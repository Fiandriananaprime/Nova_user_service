import type { FastifyInstance } from "fastify";
import { UserController } from "../controller/user.controller.js";
import { createUserSchema } from "../schema/user.schema.js";

export const internalRoutes = async (
    app: FastifyInstance,
    userController: UserController,
    options: { prefix: string },
) => {
    app.register((router) => {
        router.post("/users",{schema:{body:createUserSchema}}, userController.createUser.bind(userController));
        router.delete("/users/:id", userController.deleteUser.bind(userController));
        router.get("/addresses",userController.findUserAddresses.bind(userController),)
    }, options);
}