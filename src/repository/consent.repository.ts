import { prisma } from "../database/prisma.js";
import type { Prisma } from "../generated/prisma/index.js";

export class ConsentRepository {

    async create (
        tx: Prisma.TransactionClient,
        userId:string
    ){
        return tx.consentSettings.create({
            data:{userId}
        })
    }

    async findByUserId(userId: string){
        return prisma.consentSettings.findUnique({where:{userId}})
    }
}