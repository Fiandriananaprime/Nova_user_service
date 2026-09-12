import type { updateRequest } from "../dto/userDto.js";
import { UserRepository } from "../repository/user.repository.js";

export class AccountService {
    constructor (private readonly UserRepository: UserRepository){}

    async findCurrentAccount(id:string){
        const user = await this.UserRepository.findById(id);
        return user
    }

    async updateById(id:string,data:updateRequest){
        const existingUser = await this.UserRepository.findById(id);

        if(!existingUser) throw new Error("USER_NOT_FOUND");

        const user = await this.UserRepository.updateById(id,data)

        return user;
    }
}