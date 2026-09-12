export const accountPrivacy = {
    type: "object",
    properties:{
        profileVisibility: {type: "string"},
        activityPersonalization :{type: "boolean"},
        analyticsConsent: {type: "boolean"},
        marketingConsent: { type: "boolean"},
        dataSharing: {type: "boolean"}
    },
    additionalProperties:false
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