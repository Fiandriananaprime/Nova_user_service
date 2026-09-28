
import { prisma } from "../database/prisma.js";
import type { CreateUserDTO } from "../dto/userDto.js";
import { UserAlreadyExists, UserNotFoundError } from "../errorHandler/UserError.js";

import { UserRepository } from "../repository/user.repository.js";
import type { ConsentRepository } from "../repository/consent.repository.js";
import type { PrivacyRepository } from "../repository/privacy.repository.js";
import type { CreateAddress, userAddress } from "../type/user.js";

export class UserService {
    constructor ( 
        private readonly UserRepository: UserRepository,
        private readonly PrivacyRepository: PrivacyRepository,
        private readonly ConsentRepository: ConsentRepository
    ) {}

    async createUser(data:CreateUserDTO){
        const existingUser = await this.UserRepository.findByEmail(data.email);

        if(existingUser){
            throw new UserAlreadyExists;
        }

        return prisma.$transaction(async (tx) =>{
            const user = await this.UserRepository.createUser(tx,data);

            await this.PrivacyRepository.create(tx,user.id);
            await this.ConsentRepository.create(tx,user.id);

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

    async findAddressesByUserId(userId: string){
        const user = this.UserRepository.findById(userId);
        if(!user) throw new UserNotFoundError();

        const addresses = this.UserRepository.getAddresses(userId);
        return addresses
    }

    async addUserAddress(userId: string,address: CreateAddress): Promise<userAddress>{
        const userExist = await this.UserRepository.findById(userId)
        if(!userExist) throw new UserNotFoundError()
        
        const createdAddress = this.UserRepository.addUserAddress(userId,address);
        
        return createdAddress
    }
}