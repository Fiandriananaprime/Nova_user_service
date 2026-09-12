import type { FastifyInstance } from "fastify";
import { UserRepository } from "../repository/user.repository.js";
import { UserService } from "../service/user.service.js";
import { UserController } from "../controller/user.controller.js";

export const UserRoutes = async (app:FastifyInstance) =>{
    const userRepository = new UserRepository();
    const userService = new UserService(userRepository);
    const userController = new UserController(userService);

    app.post("/users",userController.createUser.bind(userController));
}