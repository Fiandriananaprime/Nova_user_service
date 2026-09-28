import type { FastifyReply, FastifyRequest } from "fastify";
import type { BuyerService } from "../service/buyer.service.js";
import { UnauthorizedError } from "../errorHandler/CredentialError.js";

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
}