import { prisma } from "../database/prisma.js";
import type { BuyerProfile } from "../type/buyer.js";

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
}