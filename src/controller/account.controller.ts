import type { FastifyRequest, FastifyReply } from "fastify";
import { AccountService } from "../service/account.service.js";


export class AccountController {
    constructor (private readonly AccountService:AccountService){}

    async findAccountById(request:FastifyRequest<{Params: {id: string}}>,reply:FastifyReply){
        try {
            const account = await this.AccountService.findCurrentAccount(request.params.id);
            
            if (!account){
                return reply.status(404).send({
                    error: {
                        code: "USER_NOT_FOUND",
                        message: "User not found"
                    }
                })    
            }
            return reply.status(200).send({data:account});
        }
        catch {
            return reply.status(500).send({
                error: {
                    code:"INTERNAL_SERVER_ERROR",
                    message: "Internal server error"
                }
            })
        }
        
    }
}
