import { prisma } from "../database/prisma.js";
import type { CreateUserDTO } from "../dto/userDto.js";

export class UserRepository {
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
}