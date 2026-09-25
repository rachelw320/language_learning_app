import { existsSync, readFileSync } from 'node:fs';
import { dbConfigFromEnv, type DbConfig } from '../api/src/db';

const OUTPUTS_FILE = 'cdk-outputs.json';
const STACK_NAME = 'EgyptianArabic';

/** The database details, from the environment if set, otherwise from the outputs file that npm run infra:deploy writes */
export function dbConfig(): DbConfig {
	if (process.env.DB_CLUSTER_ARN) {
		return dbConfigFromEnv();
	}
	if (!existsSync(OUTPUTS_FILE)) {
		throw new Error(`Can't find ${OUTPUTS_FILE} - run npm run infra:deploy first, or set DB_CLUSTER_ARN, DB_SECRET_ARN and DB_NAME :(`);
	}
	const outputs = JSON.parse(readFileSync(OUTPUTS_FILE, 'utf8'))[STACK_NAME];
	return { clusterArn: outputs.DbClusterArn, secretArn: outputs.DbSecretArn, database: outputs.DbName };
}
