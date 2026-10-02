import type { FastifyRequest, FastifyReply } from "fastify";
import { AccountService } from "../service/account.service.js";
import type { updateRequest } from "../dto/userDto.js";
import type { privacyDto, consentDto } from "../dto/settingDto.js";
import { UnauthorizedError } from "../errorHandler/CredentialError.js";

export class AccountController {
    constructor (private readonly AccountService:AccountService){}

    async findCurrentAccount(request:FastifyRequest,reply:FastifyReply){
            if (!request.userId) throw new UnauthorizedError();
            const account = await this.AccountService.findCurrentAccount(request.userId);
            return reply.status(200).send({data:account});
    }

    async updateCurrentAccount(request:FastifyRequest<{ Body:updateRequest }>,reply:FastifyReply){
            if (!request.userId) throw new UnauthorizedError();
            const account = await this.AccountService.updateById(request.userId,request.body);
            return reply.status(200).send({data:account});
    }

    async getPrivacy(request:FastifyRequest,reply:FastifyReply){
            if (!request.userId) throw new UnauthorizedError();
            const privacy = await this.AccountService.findPrivacy(request.userId);
            return reply.status(200).send({data:privacy});
    }

    async updatePrivacy(request:FastifyRequest<{Body:privacyDto}>,reply:FastifyReply){
            if (!request.userId) throw new UnauthorizedError();
            const account = await this.AccountService.updatePrivacy(request.userId,request.body);
            return reply.status(200).send({data:account});
    }
    
    async findAccountConsent(request:FastifyRequest, reply:FastifyReply) {
                if (!request.userId) throw new UnauthorizedError();
                const consent = await this.AccountService.findAccountConsentById(request.userId);

        return reply.status(200).send({data:consent});
    }


    async updateConsent(request:FastifyRequest<{Body:consentDto}>, reply:FastifyReply){
        if (!request.userId) throw new UnauthorizedError();
        const consent = await this.AccountService.updateConsent(request.userId,request.body);

        return reply.status(200).send({data:consent})
    }
}
