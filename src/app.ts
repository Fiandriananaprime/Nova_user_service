import Fastify from "fastify"
import { routes } from "./route.js"
import { AppError } from "./errorHandler/AppError.js";

export const app = Fastify();

routes(app)

app.setErrorHandler((error, request, reply) => {
  request.log.error(error);

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