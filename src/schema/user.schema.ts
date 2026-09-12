export const createUserSchema = {
  type: "object",
  required: ["firstName", "lastName", "email"],
  properties: {
    firstName: {
      type: "string",
      minLength: 1,
      maxLength: 100,
    },
    lastName: {
      type: "string",
      minLength: 1,
      maxLength: 100,
    },
    email: {
      type: "string",
      format: "email",
    },
  },
  additionalProperties: false,
} as const;