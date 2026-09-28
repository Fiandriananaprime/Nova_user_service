import type { FastifyReply, FastifyRequest } from "fastify";
import  { BuyerService } from "../service/buyer.service.js";
import { UnauthorizedError } from "../errorHandler/CredentialError.js";
import type { BuyerPreferences } from "../type/buyer.js";

export class BuyerController {
    constructor(
        private readonly buyerService: BuyerService
    ){}

    async getBuyerProfile(request: FastifyRequest, reply: FastifyReply){
        const userId = request.userId;

        if(!userId) throw new UnauthorizedError()
        const buyerProfile = await this.buyerService.getBuyerProfile(userId);
        return reply.status(200).send(buyerProfile);
    }

    async getPreferences(request: FastifyRequest,reply: FastifyReply){
        const userId = request.userId
        if(!userId) throw new UnauthorizedError()
        
        const preferences = await this.buyerService.getBuyerPreferencies(userId)
        return reply.status(200).send(preferences)
    }

    async updatePreferences(request: FastifyRequest<{Body:BuyerPreferences}>, reply: FastifyReply){
        const userId = request.userId
        const body = request.body

        if(!userId) throw new UnauthorizedError()
        const preferences = await this.buyerService.updatePreferences(userId, body)
        return reply.status(200).send(preferences)
    }
}