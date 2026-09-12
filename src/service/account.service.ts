import type { privacyDto } from "../dto/settingDto.js";
import type { updateRequest } from "../dto/userDto.js";
import { UserNotFoundError } from "../errorHandler/UserError.js";
import type { PrivacyRepository } from "../repository/privacy.repository.js";
import { UserRepository } from "../repository/user.repository.js";

export class AccountService {
    constructor (
        private readonly UserRepository: UserRepository,
        private readonly PrivacyRepository: PrivacyRepository
    ){}

    async findCurrentAccount(id:string){
        const user = await this.UserRepository.findById(id);
        return user
    }

    async updateById(id:string,data:updateRequest){
        const existingUser = await this.UserRepository.findById(id);

        if(!existingUser) throw new UserNotFoundError();

        const user = await this.UserRepository.updateById(id,data)

        return user;
    }

    async updatePrivacy(id:string,data:privacyDto){
        const existingUser = await this.UserRepository.findById(id);

        if(!existingUser) throw new UserNotFoundError;

        const user = await this.PrivacyRepository.updatePrivacy(id,data)

        return user;
    }
}