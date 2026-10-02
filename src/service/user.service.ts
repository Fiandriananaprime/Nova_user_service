
import { prisma } from "../database/prisma.js";
import type { CreateUserDTO } from "../dto/userDto.js";
import { AddressNotFound, UserAlreadyExists, UserNotFoundError } from "../errorHandler/UserError.js";
import { AppError } from "../errorHandler/AppError.js";

import { UserRepository } from "../repository/user.repository.js";
import type { ConsentRepository } from "../repository/consent.repository.js";
import type { PrivacyRepository } from "../repository/privacy.repository.js";
import type { CreateAddress, UpdateAddress, userAddress } from "../type/user.js";

export class UserService {
    constructor ( 
        private readonly UserRepository: UserRepository,
        private readonly PrivacyRepository: PrivacyRepository,
        private readonly ConsentRepository: ConsentRepository
    ) {}

    async createUser(data:CreateUserDTO){
        const existingUser = data.email
            ? await this.UserRepository.findByEmail(data.email)
            : data.phone
                ? await this.UserRepository.findByPhone(data.phone)
                : null;

        if(existingUser){
            throw new UserAlreadyExists;
        }

        if (!data.email && !data.phone) {
            throw new AppError(
                "VALIDATION_ERROR",
                400,
                "An email address or phone number is required",
            );
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
                phone: user.phone,
                role: user.role,
                status: user.status
            }
        })
    }

    async deleteUser(id: string) {
        await this.UserRepository.deleteById(id);
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

    async updateUserAddress(id: string,userId: string, body:UpdateAddress):Promise<userAddress>{
        const address = await this.UserRepository.updateAddress(id,userId,body);
        if(!address) throw new AddressNotFound()
        return address
    }

    async deleteAddress(id:string, userId:string){
        const result = await this.UserRepository.deleteAddress(id,userId)

        if(result.count === 0) throw new AddressNotFound()
    }

    async setAddressDefault(id: string, userId: string){
         const address = await this.UserRepository.setDefaultAddress(id, userId);

        if (!address) throw new AddressNotFound()
    }
}