import type {FastifyReply, FastifyRequest} from "fastify";

import { UserService } from "../service/user.service.js";
import type { CreateUserDTO } from "../dto/userDto.js";

export class UserController {
    constructor ( private readonly UserService: UserService){}

    async createUser(request:FastifyRequest<{ Body: CreateUserDTO}>,reply:FastifyReply){
            const user = await this.UserService.createUser(request.body);

            return reply.status(201).send({
                data:user
            })
    }
}