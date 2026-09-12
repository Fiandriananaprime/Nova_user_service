import "dotenv/config";

import { app } from "./app.js";

const PORT = Number(process.env["PORT"]) || 3001;

const start = async () => {
    try {
        await app.listen({
            port: PORT,
            host: "0.0.0.0",
        });
    } catch (error) {
        app.log.error(error);
        process.exit(1);
    }

    console.log("Server Listening on port :" + PORT)
};

process.on("unhandledRejection", (error) => {
    app.log.error(error);
    process.exit(1);
});

process.on("uncaughtException", (error) => {
    app.log.error(error);
    process.exit(1);
});

start();