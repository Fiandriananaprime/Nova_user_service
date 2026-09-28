export type Theme = "light" | "dark" | "system";

export type Lang = "fr" | "en" | "mg";

export type DeliveryMethod = "standard" | "express" | "pickup";

export type NotificationFrequency = "monthly" | "daily" | "weekly";

export interface NotificationPrefs {
  orderCreated: boolean;
  orderDelivered: boolean;
  orderPending: boolean;
  orderCancelled: boolean;
  payment: boolean;
  promotions: boolean;
  priceDrops: boolean;
  backInStock: boolean;
  newProducts: boolean;
  followedStores: boolean;
  reviews: boolean;
  recommendations: boolean;
  email: boolean;
  push: boolean;
  sms: boolean;
  frequency: NotificationFrequency;
}

export interface BuyerProfile extends BuyerPreferences {
  id: string;
  firstName: string;
  lastName: string;
  email: string;
  role: string;
  status: string;
}

export interface BuyerPreferences {
  theme?: Theme;
  lang?: Lang;
  preferredDeliveryMethod?: DeliveryMethod;
  favoriteCategories: string[];
  personalizedRecommendations?: boolean;
  showRecentlyViewed?: boolean;

  notifications?: NotificationPrefs;
}