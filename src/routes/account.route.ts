import type { FastifyInstance } from "fastify";
import { AccountService } from "../service/account.service.js";
import { UserRepository } from "../repository/user.repository.js";
import { AccountController } from "../controller/account.controller.js";


export const accountRoutes =  (app:FastifyInstance) => {
    const userRepository = new UserRepository();
    const accountServices = new AccountService(userRepository);
    const accountController = new AccountController(accountServices);

    app.get("/account/:id",accountController.findAccountById.bind(accountController))
}