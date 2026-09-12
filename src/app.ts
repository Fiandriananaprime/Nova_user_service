import Fastify from "fastify"
import { routes } from "./route.js"

export const app = Fastify();

routes(app)