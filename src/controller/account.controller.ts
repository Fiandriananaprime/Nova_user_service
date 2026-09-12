import type { FastifyRequest, FastifyReply } from "fastify";
import { AccountService } from "../service/account.service.js";
import type { updateRequest } from "../dto/userDto.js";

export class AccountController {
    constructor (private readonly AccountService:AccountService){}

    async findAccountById(request:FastifyRequest<{Params: {id: string}}>,reply:FastifyReply){
        try {
            const account = await this.AccountService.findCurrentAccount(request.params.id);

            return reply.status(200).send({data:account});
        }
        catch (error) {
            if (error instanceof Error && error.message==="USER_NOT_FOUND"){
                return reply.status(409).send({
                    error:{
                        code:"USER_ALREADY_EXISTS",
                        message: "User already exists"
                    }
                })
            }
            return reply.status(500).send({
                error: {
                    code:"INTERNAL_SERVER_ERROR",
                    message: "Internal server error"
                }
            })
        }
        
    }

    async updateById(request:FastifyRequest<{
        Params:{id:string},
        Body:updateRequest
    }>,reply:FastifyReply){
        try {
            const account = await this.AccountService.updateById(request.params.id,request.body);
            return reply.status(200).send({data:account});
        }
        catch (error) {
            if (error instanceof Error && error.message === "USER_NOT_FOUND") {
                return reply.status(404).send({
                    error: {
                        code: "USER_NOT_FOUND",
                        message: "User not found"
                    }
                })
            }
            if (error instanceof Error && error.message==="USER_ALREADY_EXISTS"){
                return reply.status(409).send({
                    error:{
                        code:"USER_ALREADY_EXISTS",
                        message: "User already exists"
                    }
                })
            }
            request.log.error(error, "Failed to update account")
            return reply.status(500).send({
                error:{
                    code:"INTERNAL_SERVER_ERROR",
                    message: "Internal server error"
                }
            })
        }
        
    }
}
