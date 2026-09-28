import { UserNotFoundError } from "../errorHandler/UserError.js";
import type { BuyerRepository } from "../repository/buyer.repository.js";

export class BuyerService {
    constructor( 
        private readonly buyerRepository: BuyerRepository
    ){}

    async getBuyerProfile(userId: string) {
        const buyerProfile = await this.buyerRepository.getBuyerProfile(userId);

        if (!buyerProfile)  throw new UserNotFoundError()
        return buyerProfile;
    }
}