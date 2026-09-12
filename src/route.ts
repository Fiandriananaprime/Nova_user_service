import type { FastifyInstance } from "fastify";

import { UserRepository } from "./repository/user.repository.js";

import { AccountService } from "./service/account.service.js";
import { UserService } from "./service/user.service.js";

import { AccountController } from "./controller/account.controller.js";
import { UserController } from "./controller/user.controller.js";

import { accountRoutes } from "./routes/account.route.js";
import { internalRoutes } from "./routes/internal.route.js";

export const routes = (app: FastifyInstance) => {

    // Dependencies
    const userRepository = new UserRepository();

    // Services
    const accountService = new AccountService(userRepository);
    const userService = new UserService(userRepository);

    // Controllers
    const accountController = new AccountController(accountService);
    const userController = new UserController(userService);

    // Routes
    accountRoutes(app, accountController, { prefix: "/api" });
    internalRoutes(app, userController, { prefix: "/internal" });
};