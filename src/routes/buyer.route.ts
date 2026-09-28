import type { FastifyInstance } from "fastify";
import type { BuyerController } from "../controller/buyer.controller.js";

export const buyerRoutes = async (
    app: FastifyInstance,
    buyerController: BuyerController,
    options: { prefix: string },
) => {
    app.register((router) => {
        router.get("/profile", buyerController.getBuyerProfile.bind(buyerController));
    }, options);
}