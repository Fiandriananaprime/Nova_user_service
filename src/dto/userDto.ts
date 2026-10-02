export interface CreateUserDTO {
    firstName: string;
    lastName: string;
    email: string | null;
    phone: string | null;
}
export type { User, ProfileUpdateRequest as updateRequest } from "@Fiandriananaprime/nova_api_type";