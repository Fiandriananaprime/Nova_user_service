import type { FastifyInstance } from "fastify";
import { AccountController } from "../controller/account.controller.js";
import { accountPrivacy, updateProfile } from "../schema/account.schema.js";


export const accountRoutes =  (
    app: FastifyInstance,
    accountController: AccountController,
    options: { prefix: string },
) => {
    app.register((router) => {
        router.get("/account/profile/:id", accountController.findAccountById.bind(accountController));
        router.patch("/account/:id",{schema:{body:{updateProfile}}}, accountController.updateById.bind(accountController))
        router.put("/account/privacy/:id",{schema:{body:{accountPrivacy}}}, accountController.updatePrivacyById.bind(accountController))
    }, options);
}