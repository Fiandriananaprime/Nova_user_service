import type { FastifyInstance } from "fastify";
import type { BuyerController } from "../controller/buyer.controller.js";
import type { UserController } from "../controller/user.controller.js";
import { createAddress,updateAddress } from "../schema/user.schema.js";
import { updateBuyerPreferences } from "../schema/buyer.schema.js";

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
        router.patch("/addresses/:id",{schema: {body: updateAddress}}, userController.updateUserAddress.bind(userController))
        router.delete<{Params:{id:string}}>("/addresses/:id",userController.deleteAddress.bind(userController))
        router.patch("/addresses/:id/default",userController.setAddressDefault.bind(userController))
        router.get("/preferences", buyerController.getPreferences.bind(userController))
        router.patch("/preferences",{schema:{body: updateBuyerPreferences}},buyerController.updatePreferences.bind(buyerController))
    }, options);
}