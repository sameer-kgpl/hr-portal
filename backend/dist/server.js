import app from './app.js';
import { env } from './config/env.js';
import { healthcheckDb } from './config/db.js';
async function start() {
    try {
        await healthcheckDb();
        app.listen(env.port, () => {
            // eslint-disable-next-line no-console
            console.log(`API listening on port ${env.port}`);
        });
    }
    catch (err) {
        // eslint-disable-next-line no-console
        console.error('Failed to start server:', err);
        process.exit(1);
    }
}
start();
//# sourceMappingURL=server.js.map