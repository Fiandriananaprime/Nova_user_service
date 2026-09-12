
import { prisma } from "../database/prisma.js";
import type { CreateUserDTO } from "../dto/userDto.js";
import { UserAlreadyExists } from "../errorHandler/UserError.js";
import type { PrivacyRepository } from "../repository/privacy.repository.js";
import { UserRepository } from "../repository/user.repository.js";

export class UserService {
    constructor ( 
        private readonly UserRepository: UserRepository,
        private readonly PrivacyRepository: PrivacyRepository
    ) {}

    async createUser(data:CreateUserDTO){
        const existingUser = await this.UserRepository.findByEmail(data.email);

        if(existingUser){
            throw new UserAlreadyExists;
        }

        return prisma.$transaction(async (tx) =>{
            const user = await this.UserRepository.createUser(tx,data);

            await this.PrivacyRepository.create(tx,user.id);

            return {
                id : user.id,
                firstName: user.firstName,
                lastName: user.lastName,
                email: user.email,
                role: user.role,
                status: user.status
            }
        })
    }
}