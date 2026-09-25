import { RDSDataClient } from '@aws-sdk/client-rds-data';
import { drizzle } from 'drizzle-orm/aws-data-api/pg';
import * as schema from './schema';

export interface DbConfig {
	clusterArn: string;
	secretArn: string;
	database: string;
}

/**
 * A drizzle client that talks to aurora through the rds data api (plain https), so the lambda doesn't need to sit in the vpc
 * or look after database connections. The same client is used by the migrate and seed scripts from a laptop
 */
export function createDb({ clusterArn, secretArn, database }: DbConfig) {
	return drizzle(new RDSDataClient({}), { database, secretArn, resourceArn: clusterArn, schema });
}

export type Db = ReturnType<typeof createDb>;

/** Reads the connection details from the environment, which is how the lambda and the scripts both get them */
export function dbConfigFromEnv(env: NodeJS.ProcessEnv = process.env): DbConfig {
	const clusterArn = env.DB_CLUSTER_ARN;
	const secretArn = env.DB_SECRET_ARN;
	const database = env.DB_NAME;
	if (!clusterArn || !secretArn || !database) {
		throw new Error('DB_CLUSTER_ARN, DB_SECRET_ARN and DB_NAME all need to be set :(');
	}
	return { clusterArn, secretArn, database };
}
