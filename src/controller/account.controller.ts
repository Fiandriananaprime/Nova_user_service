import type { FastifyRequest, FastifyReply } from "fastify";
import { AccountService } from "../service/account.service.js";
import type { updateRequest } from "../dto/userDto.js";
import type { privacyDto, consentDto } from "../dto/settingDto.js";

export class AccountController {
    constructor (private readonly AccountService:AccountService){}

    async findAccountById(request:FastifyRequest<{Params: {id: string}}>,reply:FastifyReply){
            const account = await this.AccountService.findCurrentAccount(request.params.id);
            return reply.status(200).send({data:account});        
    }

    async updateById(request:FastifyRequest<{ Params:{id:string}, Body:updateRequest }>,reply:FastifyReply){
            const account = await this.AccountService.updateById(request.params.id,request.body);
            return reply.status(200).send({data:account});
    }

    async updatePrivacyById(request:FastifyRequest<{Params:{id:string}, Body:privacyDto}>,reply:FastifyReply){
            const account = await this.AccountService.updatePrivacy(request.params.id,request.body);
            return reply.status(200).send({data:account});
    }
    
    //Consent
    async findAccountConsentById(request:FastifyRequest<{Params:{id:string}}>, reply: FastifyReply) {
                const privacy = await this.AccountService.findAccountConsentById(request.params.id);

        return reply.status(200).send({data:privacy});
    }


    async updateConsentById(request:FastifyRequest<{Params:{id:string},Body:consentDto}>, reply:FastifyReply){
        const consent = await this.AccountService.updateConsent(request.params.id,request.body);

        return reply.status(200).send({data:consent})
    }
}
