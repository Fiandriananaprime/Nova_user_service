import type { FastifyInstance } from "fastify";
import { AccountController } from "../controller/account.controller.js";


export const accountRoutes =  (
    app: FastifyInstance,
    accountController: AccountController,
    options: { prefix: string },
) => {
    app.register((router) => {
        router.get("/account/:id", accountController.findAccountById.bind(accountController));
    }, options);
}