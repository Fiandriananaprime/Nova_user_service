import type { FastifyInstance } from "fastify";
import type { BuyerController } from "../controller/buyer.controller.js";
import type { UserController } from "../controller/user.controller.js";
import { createAddress } from "../schema/user.schema.js";

export const buyerRoutes = async (
    app: FastifyInstance,
    buyerController: BuyerController,
    userController: UserController,
    options: { prefix: string },
) => {
    app.register((router) => {
        router.get("/profile", buyerController.getBuyerProfile.bind(buyerController));
        router.get("/addresses", userController.findUserAddresses.bind(userController))
        router.post("/addresses",{schema: {body: createAddress}}, userController.addUserAddress.bind(userController))
    }, options);
}