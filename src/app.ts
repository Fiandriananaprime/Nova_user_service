import Fastify from "fastify"
import { internalRoutes } from "./routes/internal.route.js"
import { accountRoutes } from "./routes/account.route.js"

export const buildApp = () => {
    const app = Fastify({
        logger:true
    })
    
    app.register(internalRoutes, {prefix: "/internal"})
    app.register(accountRoutes, { prefix: "/api"})
    return app
}