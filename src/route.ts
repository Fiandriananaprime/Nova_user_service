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
import { buyerRoutes } from "./routes/buyer.route.js";
import { BuyerRepository } from "./repository/buyer.repository.js";
import { BuyerService } from "./service/buyer.service.js";
import { BuyerController } from "./controller/buyer.controller.js";

export const routes = (app: FastifyInstance) => {

    // Dependencies
    const userRepository = new UserRepository();
    const privacyRepository = new PrivacyRepository();
    const consentRepository = new ConsentRepository();
    const buyerRepository = new BuyerRepository();

    // Services
    const accountService = new AccountService(userRepository,privacyRepository,consentRepository);
    const userService = new UserService(userRepository, privacyRepository,consentRepository);
    const buyerService = new BuyerService(buyerRepository);

    // Controllers
    const accountController = new AccountController(accountService);
    const userController = new UserController(userService);
    const buyerController = new BuyerController(buyerService); 

    // Routes
    accountRoutes(app, accountController, { prefix: "/api" });
    internalRoutes(app, userController, { prefix: "/internal" });
    buyerRoutes(app, buyerController,userController, { prefix: "/api/buyer" });
};