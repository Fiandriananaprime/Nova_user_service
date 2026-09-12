import Fastify from "fastify"
import { UserRoutes } from "./routes/user.route.js"

export const buildApp = () => {
    const app = Fastify({
        logger:true
    })

    app.register(UserRoutes, {prefix: "/api"})

    return app
}