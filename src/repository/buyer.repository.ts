import { prisma } from "../database/prisma.js";
import type { BuyerPreferences, BuyerProfile } from "../type/buyer.js";

export class BuyerRepository {
    

    async getBuyerProfile(id: string): Promise<BuyerProfile | null>{
        const user = await prisma.user.findUnique({where:{id}})
        const preference = await prisma.buyerPreferences.findUnique({where: {userId:id}})
        const notificationPreference = await prisma.buyerNotificationPreferences.findUnique({where:{userId:id}})
        const favoriteCategories = await prisma.buyerFavoriteCategory.findMany({where:{userId:id}})
        if(!user) return null

        return {
            id: user.id,
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            role: user.role,
            status: user.status,
            theme: preference?.theme ?? "light",
            lang: preference?.language?? "fr",
            preferredDeliveryMethod: preference?.preferredDeliveryMethod ?? "standard",
            personalizedRecommendations: preference?.personalizedRecommendations ?? true,
            showRecentlyViewed: preference?.showRecentlyViewed ?? true,
            favoriteCategories:favoriteCategories.map(
                (favorite) => favorite.categoryId
            ),
            ...(notificationPreference
                ? { notifications: {
                    orderCreated: notificationPreference.orderCreated,
                    orderDelivered: notificationPreference.orderDelivered,
                    orderPending: notificationPreference.orderPending,
                    orderCancelled: notificationPreference.orderCancelled,
                    payment: notificationPreference.payment,
                    promotions: notificationPreference.promotions,
                    priceDrops: notificationPreference.priceDrops,
                    backInStock: notificationPreference.backInStock,
                    newProducts: notificationPreference.newProducts,
                    followedStores: notificationPreference.followedStores,
                    reviews: notificationPreference.reviews,
                    recommendations: notificationPreference.recommendations,
                    email: notificationPreference.email,
                    push: notificationPreference.push,
                    sms: notificationPreference.sms,
                    frequency: notificationPreference.frequency,
                } }
                : {}),
        }
    }

    async updatePreferences( userId: string, body: BuyerPreferences): Promise<BuyerPreferences> {
      return prisma.$transaction(async (tx) => {
        const { notifications, favoriteCategories, ...preferences } = body;

        if (Object.keys(preferences).length > 0) {
         await tx.buyerPreferences.update({
            where: { userId },
            data: preferences,
         });
        }

         if (notifications) {
          await tx.buyerNotificationPreferences.update({
            where: { userId },
            data: notifications,
          });
        }

         if (favoriteCategories) {
          await tx.buyerFavoriteCategory.deleteMany({
              where: { userId },
          });

          await tx.buyerFavoriteCategory.createMany({
              data: favoriteCategories.map((categoryId) => ({
              userId,
              categoryId,
            })),
          });
         }

          const updated = await tx.buyerPreferences.findUnique({
            where: { userId },
          });

          const notificationPreferences = await tx.buyerNotificationPreferences.findUnique({
                where: { userId },
            });

            const favorites = await tx.buyerFavoriteCategory.findMany({
              where: { userId },
            });

          return {
            ...updated,
            ...notificationPreferences,
            favoriteCategories: favorites.map((f) => f.categoryId),
          };
      });
    }

    async getBuyerPreferences(userId: string): Promise<BuyerPreferences>{
        const preferences = await prisma.buyerPreferences.findUnique({where: {userId}})
        const notificationPreferences = await prisma.buyerNotificationPreferences.findUnique({where:{userId}})
        const favoriteCategories = await prisma.buyerFavoriteCategory.findMany({where:{userId}})
        return {
            ...preferences,
            ...notificationPreferences,
            favoriteCategories:favoriteCategories.map(
                (favorite) => favorite.categoryId
            ),
        }
    }
}