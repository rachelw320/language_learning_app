import * as cdk from 'aws-cdk-lib';
import * as apigwv2 from 'aws-cdk-lib/aws-apigatewayv2';
import * as integrations from 'aws-cdk-lib/aws-apigatewayv2-integrations';
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront';
import * as origins from 'aws-cdk-lib/aws-cloudfront-origins';
import * as ec2 from 'aws-cdk-lib/aws-ec2';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as nodejs from 'aws-cdk-lib/aws-lambda-nodejs';
import * as rds from 'aws-cdk-lib/aws-rds';
import * as s3 from 'aws-cdk-lib/aws-s3';
import type { Construct } from 'constructs';

export interface EgyptianArabicStackProps extends cdk.StackProps {
	// The netlify site (and localhost for development) - used for cors on the api and the audio bucket
	allowedOrigins: string[];
	adminPassword: string;
	elevenLabsApiKey: string;
	elevenLabsArabicVoiceId: string;
}

const DATABASE_NAME = 'egyptian_arabic';

/**
 * The whole backend: aurora serverless (scales to zero when nobody's studying), one lambda behind an http api,
 * and a private s3 bucket for uploaded audio served through cloudfront
 */
export class EgyptianArabicStack extends cdk.Stack {
	constructor(scope: Construct, id: string, props: EgyptianArabicStackProps) {
		super(scope, id, props);

		// Aurora has to live in a vpc, but nothing else does - the lambda reaches it over the data api. No nat gateways
		// because they're the one thing here that would cost real money every month
		const vpc = new ec2.Vpc(this, 'Vpc', {
			maxAzs: 2,
			natGateways: 0,
			subnetConfiguration: [{ name: 'database', subnetType: ec2.SubnetType.PRIVATE_ISOLATED, cidrMask: 24 }],
		});

		const database = new rds.DatabaseCluster(this, 'Database', {
			engine: rds.DatabaseClusterEngine.auroraPostgres({ version: rds.AuroraPostgresEngineVersion.VER_16_6 }),
			vpc,
			vpcSubnets: { subnetType: ec2.SubnetType.PRIVATE_ISOLATED },
			writer: rds.ClusterInstance.serverlessV2('writer'),
			// 0 means it pauses after a few idle minutes and costs nothing until the next query, which then takes ~15s to wake up.
			// The app starts on its bundled cards anyway, so the wait doesn't show
			serverlessV2MinCapacity: 0,
			serverlessV2MaxCapacity: 1,
			enableDataApi: true,
			defaultDatabaseName: DATABASE_NAME,
			credentials: rds.Credentials.fromGeneratedSecret('postgres'),
			storageEncrypted: true,
			// Deleting the stack keeps a final snapshot rather than the data just vanishing
			removalPolicy: cdk.RemovalPolicy.SNAPSHOT,
		});

		const audioBucket = new s3.Bucket(this, 'AudioBucket', {
			blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
			encryption: s3.BucketEncryption.S3_MANAGED,
			enforceSSL: true,
			// The admin screen uploads straight to the bucket with a presigned url, so it needs cors
			cors: [{ allowedMethods: [s3.HttpMethods.PUT], allowedOrigins: props.allowedOrigins, allowedHeaders: ['*'] }],
			removalPolicy: cdk.RemovalPolicy.RETAIN,
		});

		// Cloudfront is the only thing allowed to read the bucket, and it's what the audio urls on cards point at
		const audioCdn = new cloudfront.Distribution(this, 'AudioCdn', {
			defaultBehavior: {
				origin: origins.S3BucketOrigin.withOriginAccessControl(audioBucket),
				viewerProtocolPolicy: cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
				cachePolicy: cloudfront.CachePolicy.CACHING_OPTIMIZED,
			},
			comment: 'Egyptian arabic app - uploaded audio',
		});
		const audioBaseUrl = `https://${audioCdn.distributionDomainName}`;

		const api = new nodejs.NodejsFunction(this, 'Api', {
			entry: 'api/src/index.ts',
			handler: 'handler',
			runtime: lambda.Runtime.NODEJS_22_X,
			architecture: lambda.Architecture.ARM_64,
			memorySize: 512,
			timeout: cdk.Duration.seconds(30),
			bundling: { minify: true, sourceMap: true, externalModules: [] },
			environment: {
				NODE_OPTIONS: '--enable-source-maps',
				DB_CLUSTER_ARN: database.clusterArn,
				DB_SECRET_ARN: database.secret!.secretArn,
				DB_NAME: DATABASE_NAME,
				AUDIO_BUCKET: audioBucket.bucketName,
				AUDIO_BASE_URL: audioBaseUrl,
				ALLOWED_ORIGINS: props.allowedOrigins.join(','),
				ADMIN_PASSWORD: props.adminPassword,
				ELEVENLABS_API_KEY: props.elevenLabsApiKey,
				ELEVENLABS_ARABIC_VOICE_ID: props.elevenLabsArabicVoiceId,
			},
		});
		database.grantDataApiAccess(api);
		audioBucket.grantPut(api);

		const httpApi = new apigwv2.HttpApi(this, 'HttpApi', {
			corsPreflight: {
				allowOrigins: props.allowedOrigins,
				allowMethods: [apigwv2.CorsHttpMethod.GET, apigwv2.CorsHttpMethod.POST, apigwv2.CorsHttpMethod.OPTIONS],
				allowHeaders: ['content-type', 'x-admin-key'],
			},
			defaultIntegration: new integrations.HttpLambdaIntegration('ApiIntegration', api),
		});

		new cdk.CfnOutput(this, 'ApiUrl', { value: httpApi.apiEndpoint, description: 'Set this as VITE_API_URL' });
		new cdk.CfnOutput(this, 'AudioBaseUrl', { value: audioBaseUrl });
		new cdk.CfnOutput(this, 'DbClusterArn', { value: database.clusterArn });
		new cdk.CfnOutput(this, 'DbSecretArn', { value: database.secret!.secretArn });
		new cdk.CfnOutput(this, 'DbName', { value: DATABASE_NAME });
	}
}
