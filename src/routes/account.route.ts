import type { FastifyInstance } from "fastify";
import { AccountController } from "../controller/account.controller.js";
import { accountPrivacy, updateProfile } from "../schema/account.schema.js";


export const accountRoutes =  (
    app: FastifyInstance,
    accountController: AccountController,
    options: { prefix: string },
) => {
    app.register((router) => {
        router.get("/account/profile", accountController.findCurrentAccount.bind(accountController));
        router.patch("/account/profile",{schema:{body:updateProfile}}, accountController.updateCurrentAccount.bind(accountController));
        router.get("/account/privacy", accountController.getPrivacy.bind(accountController))
        router.put("/account/privacy",{schema:{body:accountPrivacy}}, accountController.updatePrivacy.bind(accountController))
        router.get("/account/consents",accountController.findAccountConsent.bind(accountController))
        router.patch("/account/consents",accountController.updateConsent.bind(accountController))
    }, options);
}