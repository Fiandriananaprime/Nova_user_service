import { prisma } from "../database/prisma.js";
import type { CreateUserDTO, updateRequest } from "../dto/userDto.js";

export class UserRepository {

    async findById(id:string){
        return prisma.user.findUnique({
            where:{id}
        })
    }
    async findByEmail(email: string){
        return prisma.user.findUnique({
            where:{email}
        })
    }

    async createUser(data:CreateUserDTO){
        const { firstName, lastName, email } = data;

        return prisma.user.create({
            data: {
                firstName,
                lastName,
                email,
            },
        })
    }

    async updateById(id:string,data:updateRequest){
        return prisma.user.update({
            where:{ id },
            data
        })
    }
}