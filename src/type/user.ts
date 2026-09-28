export type {
     Address as userAddress,
     BuyerPreferences
} from "@Fiandriananaprime/nova_api_type"

export interface CreateAddress {
  label: string;
  recipientName: string;
  phone: string;
  street: string;
  district: string;
  city: string;
  region: string;
  postalCode: string;
  latitude?: number;
  longitude?: number;
  instructions: string;
  isDefault?: boolean;
}

export interface UpdateAddress {
  label?: string;
  recipientName?: string;
  phone?: string;
  street?: string;
  district?: string;
  city?: string;
  region?: string;
  postalCode?: string;
  latitude?: number;
  longitude?: number;
  instructions?: string;
  isDefault?: boolean;
}