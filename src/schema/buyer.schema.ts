export const updateBuyerPreferences = {
  type: "object",
  properties: {
    theme: { type: "string", enum: ["light", "dark", "system"] },
    lang: { type: "string", enum: ["fr", "en", "mg"] },
    favoriteCategories: {
      type: "array",
      items: { type: "string", format: "uuid" }
    },
    preferredDeliveryMethod: {
      type: "string",
      enum: ["standard", "express", "pickup"]
    },
    personalizedRecommendations: { type: "boolean" },
    showRecentlyViewed: { type: "boolean" },
    notifications: {
      type: "object",
      properties: {
        orderCreated: { type: "boolean" },
        orderDelivered: { type: "boolean" },
        orderPending: { type: "boolean" },
        orderCancelled: { type: "boolean" },
        payment: { type: "boolean" },
        promotions: { type: "boolean" },
        priceDrops: { type: "boolean" },
        backInStock: { type: "boolean" },
        newProducts: { type: "boolean" },
        followedStores: { type: "boolean" },
        reviews: { type: "boolean" },
        recommendations: { type: "boolean" },
        email: { type: "boolean" },
        push: { type: "boolean" },
        sms: { type: "boolean" },
        frequency: { type: "string", enum: ["monthly", "daily", "weekly"] }
      },
      additionalProperties: false
    }
  },
  additionalProperties: false
} as const;