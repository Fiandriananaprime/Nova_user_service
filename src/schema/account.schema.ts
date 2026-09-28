export const accountPrivacy = {
    type: "object",
    properties:{
        profileVisibility: {type: "string"},
        dataSharing: {type: "boolean"}
    },
    additionalProperties:false
} as const 

export const consentSetting = {
    type: "object",
    properties:{
        marketings: {type: "boolean"},
        analytics: {type: "boolean"},
        personnalization: {type: "boolean"}
    },
    additionalProperties: false
} as const

export const updateProfile = {
    type: "object",
    properties:{
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
        avatarUrl: {
            type: "string",
            minLength: 1,
            maxLength: 100,
        }
    },
    additionalProperties: false
}as const