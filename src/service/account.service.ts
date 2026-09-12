import { UserRepository } from "../repository/user.repository.js";

export class AccountService {
    constructor (private readonly UserRepository: UserRepository){}

    async findCurrentAccount(id:string){
        const user = await this.UserRepository.findById(id);
        return user
    }
}