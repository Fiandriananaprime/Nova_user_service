import { prisma } from "../database/prisma.js";
import { Prisma } from "../generated/prisma/index.js";

import type { CreateUserDTO, updateRequest } from "../dto/userDto.js";
import type { CreateAddress, UpdateAddress, userAddress } from "../type/user.js";

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

    async deleteById(id: string) {
        return prisma.user.delete({
            where: { id },
        });
    }

    async createUser(
        tx: Prisma.TransactionClient,
        data: CreateUserDTO
    ) {
        const { firstName, lastName, email } = data;

        return tx.user.create({
            data: {
                firstName,
                lastName,
                email,
            },
        });
    }

    async updateById(id:string,data:updateRequest){
        return prisma.user.update({
            where:{ id },
            data
        })
    }

    async getAddresses(userId: string): Promise<{ address: userAddress[] }> {
        const addresses = await prisma.userAddress.findMany({
          where: { userId },
        });

      return {
        address: addresses.map((address) => ({
            id: address.id,
            label: address.label,
            recipientName: address.recipientName,
            phone: address.phone,
            street: address.street,
            district: address.district,
            city: address.city,
            region: address.region,
            postalCode: address.postalCode,
            latitude: address.latitude,
            longitude: address.longitude,
            instructions: address.instructions,
            isDefault: address.isDefault,
        })),
      };
    }

    async addUserAddress(userId: string,body:CreateAddress): Promise<userAddress>{
        const address = await prisma.userAddress.create({
            data: {
                userId,
                label: body.label,
                recipientName: body.recipientName,
                phone: body.phone,
                street: body.street,
                district: body.district,
                city: body.city,
                region: body.region,
                postalCode: body.postalCode,
                latitude: body.latitude ?? null,
                longitude: body.longitude ?? null,
                instructions: body.instructions,
                isDefault: body.isDefault ?? false,
            },
            });

        return address

    }
    async updateAddress(id: string, userId: string, body: UpdateAddress):Promise<userAddress | null>{
        const [address] = await prisma.userAddress.updateManyAndReturn({
          where: { id, userId },
          data: body
        });
        if (!address) return null
            
        return address;
    }

    async deleteAddress(id:string, userId: string){
        return prisma.userAddress.deleteMany({where:{id,userId}})
    }

    async setDefaultAddress(id: string, userId: string) {
        return prisma.$transaction(async (tx) => {
            const address = await tx.userAddress.findFirst({
            where: { id, userId },
            });

            if (!address) return null

            await tx.userAddress.updateMany({
            where: { userId, id: { not: id } },
            data: { isDefault: false },
            });

            return tx.userAddress.update({
            where: { id },
            data: { isDefault: true },
            });
        });
    }
}