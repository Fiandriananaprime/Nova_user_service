export const createUserSchema = {
  type: "object",
  required: ["firstName", "lastName", "email", "phone"],
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
      nullable: true,
    },
    phone: {
      type: "string",
      minLength: 1,
      maxLength: 30,
      nullable: true,
    },
  },
  oneOf: [
    { properties: { email: { type: "string", format: "email" } } },
    { properties: { phone: { type: "string", minLength: 1, maxLength: 30 } } },
  ],
  additionalProperties: false,
} as const;

export const createAddress = {
  type: "object",
  properties: {
    label: { type: "string", minLength: 1, maxLength: 100 },
    recipientName: { type: "string", minLength: 1, maxLength: 200 },
    phone: { type: "string", minLength: 1, maxLength: 30 },
    street: { type: "string", minLength: 1 },
    district: { type: "string", minLength: 1, maxLength: 150 },
    city: { type: "string", minLength: 1, maxLength: 150 },
    region: { type: "string", minLength: 1, maxLength: 150 },
    postalCode: { type: "string", minLength: 1, maxLength: 20 },
    latitude: { type: "number", minimum: -90, maximum: 90 },
    longitude: { type: "number", minimum: -180, maximum: 180 },
    instructions: { type: "string" },
    isDefault: { type: "boolean", default: false }
  },
  required: ["label", "recipientName", "phone", "street", "district", "city", "region", "postalCode", "instructions"],
  additionalProperties: false
} as const;

export const updateAddress = {
  type: "object",
  properties: {
    label: { type: "string", minLength: 1, maxLength: 100 },
    recipientName: { type: "string", minLength: 1, maxLength: 200 },
    phone: { type: "string", minLength: 1, maxLength: 30 },
    street: { type: "string", minLength: 1 },
    district: { type: "string", minLength: 1, maxLength: 150 },
    city: { type: "string", minLength: 1, maxLength: 150 },
    region: { type: "string", minLength: 1, maxLength: 150 },
    postalCode: { type: "string", minLength: 1, maxLength: 20 },
    latitude: { type: "number", minimum: -90, maximum: 90 },
    longitude: { type: "number", minimum: -180, maximum: 180 },
    instructions: { type: "string" },
    isDefault: { type: "boolean" }
  },
  additionalProperties: false
} as const;