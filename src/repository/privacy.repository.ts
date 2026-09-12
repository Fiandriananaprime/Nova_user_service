import { prisma } from "../database/prisma.js";
import { Prisma } from "../generated/prisma/index.js";
import type { privacyDto } from "../dto/settingDto.js";

export class PrivacyRepository {
    async create(
        tx: Prisma.TransactionClient,
        userId: string,
    ) {
        return tx.privacySettings.create({
            data: {
            userId,
            },
        });
    }
    async updatePrivacy(userId: string, data: privacyDto) {
        return prisma.privacySettings.upsert({
            where: { userId },

            create: {
            userId,
            ...data,
            },

            update: {
            ...data,
            },
        });
    }
}