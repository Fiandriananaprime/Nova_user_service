import type { FastifyInstance } from "fastify";
import { UserController } from "../controller/user.controller.js";

export const internalRoutes = async (
    app: FastifyInstance,
    userController: UserController,
    options: { prefix: string },
) => {
    app.register((router) => {
        router.post("/users", userController.createUser.bind(userController));
    }, options);
}