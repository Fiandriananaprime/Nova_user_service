import type { CreateUserDTO } from "../dto/userDto.js";
import { UserRepository } from "../repository/user.repository.js";

export class UserService {
    constructor ( private readonly UserRepository: UserRepository) {}

    async createUser(data:CreateUserDTO){
        const existingUser = await this.UserRepository.findByEmail(data.email);

        if(existingUser){
            throw new Error("USER_ALREADY_EXISTS");
        }

        const user = await this.UserRepository.createUser(data);

        return {
            id:user.id,
            firstName:user.firstName,
            lastName:user.lastName,
            email:user.email,            
            role:user.role,
            status:user.status
        }
    }
}