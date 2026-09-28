import { AppError } from "./AppError.js";

export class UnauthorizedError extends AppError {
    constructor(){
        super(
            "USER_UNAUTHORIZED",
            401,
            "User unauthorized"
        )
    }
}