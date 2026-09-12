import type { FastifyRequest, FastifyReply } from "fastify";
import { AccountService } from "../service/account.service.js";
import type { updateRequest } from "../dto/userDto.js";
import type { privacyDto } from "../dto/settingDto.js";

export class AccountController {
    constructor (private readonly AccountService:AccountService){}

    async findAccountById(request:FastifyRequest<{Params: {id: string}}>,reply:FastifyReply){
        try {
            const account = await this.AccountService.findCurrentAccount(request.params.id);

            return reply.status(200).send({data:account});
        }
        catch  {
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
            request.log.error(error, "Failed to update account")
            return reply.status(500).send({
                error:{
                    code:"INTERNAL_SERVER_ERROR",
                    message: "Internal server error"
                }
            })
        }
        
    }

    async updatePrivacyById(request:FastifyRequest<{
        Params:{id:string},
        Body:privacyDto
    }>,reply:FastifyReply){
        try {
            const account = await this.AccountService.updatePrivacy(request.params.id,request.body);
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
