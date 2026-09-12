import Fastify from "fastify"
import { routes } from "./route.js"
import { AppError } from "./errorHandler/AppError.js";

export const app = Fastify();

routes(app)

app.setErrorHandler((error, request, reply) => {
  request.log.error(error);

   if (
    typeof error === "object" &&
    error !== null &&
    "validation" in error
  ) {
    return reply.status(400).send({
      error: {
        code: "VALIDATION_ERROR",
        message: "Request validation failed.",
        details: error.validation,
      },
    });
  }
  
  if (error instanceof AppError) {
    return reply.status(error.statusCode).send({
      error: {
        code: error.code,
        message: error.message,
      },
    });
  }

  return reply.status(500).send({
    error: {
      code: "INTERNAL_SERVER_ERROR",
      message: "Internal server error",
    },
  });
});