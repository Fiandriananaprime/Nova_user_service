import type { FastifyInstance } from "fastify";

import { UserRepository } from "./repository/user.repository.js";
import { PrivacyRepository } from "./repository/privacy.repository.js";
import { ConsentRepository } from "./repository/consent.repository.js";

import { AccountService } from "./service/account.service.js";
import { UserService } from "./service/user.service.js";

import { AccountController } from "./controller/account.controller.js";
import { UserController } from "./controller/user.controller.js";

import { accountRoutes } from "./routes/account.route.js";
import { internalRoutes } from "./routes/internal.route.js";

export const routes = (app: FastifyInstance) => {

    // Dependencies
    const userRepository = new UserRepository();
    const privacyRepository = new PrivacyRepository();
    const consentRepository = new ConsentRepository();

    // Services
    const accountService = new AccountService(userRepository,privacyRepository,consentRepository);
    const userService = new UserService(userRepository, privacyRepository,consentRepository);

    // Controllers
    const accountController = new AccountController(accountService);
    const userController = new UserController(userService);

    // Routes
    accountRoutes(app, accountController, { prefix: "/api" });
    internalRoutes(app, userController, { prefix: "/internal" });
};