import { UserNotFoundError } from "../errorHandler/UserError.js";
import type { BuyerRepository } from "../repository/buyer.repository.js";
import type { BuyerPreferences } from "../type/buyer.js";

export class BuyerService {
    constructor( 
        private readonly buyerRepository: BuyerRepository
    ){}

    async getBuyerProfile(userId: string) {
        const buyerProfile = await this.buyerRepository.getBuyerProfile(userId);

        if (!buyerProfile)  throw new UserNotFoundError()
        return buyerProfile;
    }

    async getBuyerPreferencies(userId: string): Promise<BuyerPreferences>{
        const preferences = await this.buyerRepository.getBuyerPreferences(userId);
        if(!preferences) throw new UserNotFoundError();

        return preferences
    }

    async updatePreferences(userId: string, body: BuyerPreferences): Promise<BuyerPreferences>{
        const preferences = await this.buyerRepository.updatePreferences(userId,body);
        if(!preferences) throw new UserNotFoundError();

        return preferences
    }
}