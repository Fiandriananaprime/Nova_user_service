import type {FastifyReply, FastifyRequest} from "fastify";

import { UserService } from "../service/user.service.js";
import type { CreateUserDTO } from "../dto/userDto.js";

export class UserController {
    constructor ( private readonly UserService: UserService){}

    async createUser(request:FastifyRequest<{ Body: CreateUserDTO}>,reply:FastifyReply){
        try {
            const user = await this.UserService.createUser(request.body);

            return reply.status(200).send({
                data:user
            })
        }
        catch (error) {
            if (error instanceof Error && error.message==="USER_ALREADY_EXISTS"){
                return reply.status(409).send({
                    error:{
                        code:"USER_ALREADY_EXISTS",
                        message: "User already exists"
                    }
                })
            }
            return reply.status(500).send({
                error:{
                    code:"INTERNAL_SERVER_ERROR",
                    message: "Internal server error"
                }
            })
        }
    }
}