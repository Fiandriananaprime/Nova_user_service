CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- =========================================================
-- USERS
-- =========================================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,

    email TEXT NOT NULL UNIQUE,
    phone TEXT UNIQUE,

    role TEXT NOT NULL DEFAULT 'buyer',
    status TEXT NOT NULL DEFAULT 'active',

    admin_role TEXT,

    avatar_url TEXT,

    email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    phone_verified BOOLEAN NOT NULL DEFAULT FALSE,

    last_login_at TIMESTAMP,
    last_login_ip INET,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT users_role_check
        CHECK (role IN ('buyer', 'seller', 'admin', 'moderator', 'delivery_agent')),

    CONSTRAINT users_status_check
        CHECK (status IN ('active', 'suspended', 'banned', 'inactive'))
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_status ON users(status);


-- =========================================================
-- USER ADDRESSES
-- /buyer/addresses
-- =========================================================

CREATE TABLE user_addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID NOT NULL,

    label TEXT NOT NULL,
    recipient_name TEXT NOT NULL,
    phone TEXT NOT NULL,

    street TEXT NOT NULL,
    district TEXT,
    city TEXT NOT NULL,
    region TEXT,
    postal_code TEXT,

    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,

    instructions TEXT,

    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_user_addresses_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_user_addresses_user_id
    ON user_addresses(user_id);

CREATE INDEX idx_user_addresses_default
    ON user_addresses(user_id, is_default);


-- =========================================================
-- BUYER PREFERENCES
-- /buyer/preferences
-- =========================================================

CREATE TABLE buyer_preferences (
    user_id UUID PRIMARY KEY,

    theme TEXT NOT NULL DEFAULT 'system',
    lang TEXT NOT NULL DEFAULT 'fr',

    preferred_delivery_method TEXT,

    personalized_recommendations BOOLEAN NOT NULL DEFAULT TRUE,
    show_recently_viewed BOOLEAN NOT NULL DEFAULT TRUE,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_buyer_preferences_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);


-- =========================================================
-- BUYER NOTIFICATION PREFERENCES
-- /buyer/notifications/preferences
-- =========================================================

CREATE TABLE buyer_notification_preferences (
    user_id UUID PRIMARY KEY,

    order_created BOOLEAN NOT NULL DEFAULT TRUE,
    order_delivered BOOLEAN NOT NULL DEFAULT TRUE,
    order_pending BOOLEAN NOT NULL DEFAULT TRUE,
    order_cancelled BOOLEAN NOT NULL DEFAULT TRUE,

    payment BOOLEAN NOT NULL DEFAULT TRUE,
    promotions BOOLEAN NOT NULL DEFAULT TRUE,
    price_drops BOOLEAN NOT NULL DEFAULT TRUE,
    back_in_stock BOOLEAN NOT NULL DEFAULT TRUE,
    new_products BOOLEAN NOT NULL DEFAULT TRUE,

    followed_stores BOOLEAN NOT NULL DEFAULT TRUE,
    reviews BOOLEAN NOT NULL DEFAULT TRUE,
    recommendations BOOLEAN NOT NULL DEFAULT TRUE,

    email BOOLEAN NOT NULL DEFAULT TRUE,
    push BOOLEAN NOT NULL DEFAULT TRUE,
    sms BOOLEAN NOT NULL DEFAULT FALSE,

    frequency TEXT NOT NULL DEFAULT 'instant',

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_buyer_notification_preferences_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT buyer_notification_frequency_check
        CHECK (frequency IN ('instant', 'daily', 'weekly'))
);


-- =========================================================
-- SELLER SETTINGS
-- /seller/settings
-- =========================================================

CREATE TABLE seller_settings (
    user_id UUID PRIMARY KEY,

    theme TEXT NOT NULL DEFAULT 'system',
    lang TEXT NOT NULL DEFAULT 'fr',

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_seller_settings_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);


-- =========================================================
-- SELLER NOTIFICATION PREFERENCES
-- /seller/notifications/preferences
-- =========================================================

CREATE TABLE seller_notification_preferences (
    user_id UUID PRIMARY KEY,

    new_order BOOLEAN NOT NULL DEFAULT TRUE,
    order_cancelled BOOLEAN NOT NULL DEFAULT TRUE,

    low_stock BOOLEAN NOT NULL DEFAULT TRUE,
    product_approved BOOLEAN NOT NULL DEFAULT TRUE,
    product_rejected BOOLEAN NOT NULL DEFAULT TRUE,

    new_review BOOLEAN NOT NULL DEFAULT TRUE,
    payout BOOLEAN NOT NULL DEFAULT TRUE,

    seller_announcements BOOLEAN NOT NULL DEFAULT TRUE,

    email BOOLEAN NOT NULL DEFAULT TRUE,
    push BOOLEAN NOT NULL DEFAULT TRUE,
    sms BOOLEAN NOT NULL DEFAULT FALSE,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_seller_notification_preferences_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);


-- =========================================================
-- ADMIN SETTINGS
-- /admin/settings
-- =========================================================

CREATE TABLE admin_settings (
    user_id UUID PRIMARY KEY,

    theme TEXT NOT NULL DEFAULT 'system',
    lang TEXT NOT NULL DEFAULT 'fr',

    email_notifications BOOLEAN NOT NULL DEFAULT TRUE,
    push_notifications BOOLEAN NOT NULL DEFAULT TRUE,
    security_alerts BOOLEAN NOT NULL DEFAULT TRUE,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_admin_settings_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);


-- =========================================================
-- ADMIN NOTIFICATION PREFERENCES
-- /admin/notifications/preferences
-- =========================================================

CREATE TABLE admin_notification_preferences (
    user_id UUID PRIMARY KEY,

    seller_applications BOOLEAN NOT NULL DEFAULT TRUE,
    product_moderation BOOLEAN NOT NULL DEFAULT TRUE,
    payment_failures BOOLEAN NOT NULL DEFAULT TRUE,
    fraud_alerts BOOLEAN NOT NULL DEFAULT TRUE,
    system_alerts BOOLEAN NOT NULL DEFAULT TRUE,
    user_reports BOOLEAN NOT NULL DEFAULT TRUE,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_admin_notification_preferences_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);


-- =========================================================
-- PRIVACY SETTINGS
-- /settings
-- /admin/security
-- =========================================================

CREATE TABLE privacy_settings (
    user_id UUID PRIMARY KEY,

    profile_visibility TEXT NOT NULL DEFAULT 'public',

    activity_personalization BOOLEAN NOT NULL DEFAULT TRUE,
    analytics_consent BOOLEAN NOT NULL DEFAULT TRUE,
    marketing_consent BOOLEAN NOT NULL DEFAULT FALSE,
    data_sharing BOOLEAN NOT NULL DEFAULT FALSE,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_privacy_settings_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT privacy_profile_visibility_check
        CHECK (
            profile_visibility IN (
                'public',
                'private',
                'friends'
            )
        )
);


-- =========================================================
-- CONSENT SETTINGS
-- /settings
-- =========================================================

CREATE TABLE consent_settings (
    user_id UUID PRIMARY KEY,

    marketing BOOLEAN NOT NULL DEFAULT FALSE,
    analytics BOOLEAN NOT NULL DEFAULT TRUE,
    personalization BOOLEAN NOT NULL DEFAULT TRUE,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_consent_settings_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);


-- =========================================================
-- FAVORITE PRODUCTS
-- /favorites/products
-- =========================================================
-- product_id appartient au product-service.
-- Pas de FK inter-service ici.

CREATE TABLE favorite_products (
    user_id UUID NOT NULL,
    product_id UUID NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (user_id, product_id),

    CONSTRAINT fk_favorite_products_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_favorite_products_product_id
    ON favorite_products(product_id);


-- =========================================================
-- FOLLOWED STORES
-- /favorites/stores
-- =========================================================
-- store_id appartient au store-service.
-- Pas de FK inter-service ici.

CREATE TABLE followed_stores (
    user_id UUID NOT NULL,
    store_id UUID NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (user_id, store_id),

    CONSTRAINT fk_followed_stores_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_followed_stores_store_id
    ON followed_stores(store_id);


-- =========================================================
-- TWO FACTOR AUTHENTICATION
-- /admin/security
-- =========================================================

CREATE TABLE two_factor_settings (
    user_id UUID PRIMARY KEY,

    enabled BOOLEAN NOT NULL DEFAULT FALSE,
    secret_encrypted TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    verified_at TIMESTAMP,

    CONSTRAINT fk_two_factor_settings_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);


CREATE TABLE two_factor_recovery_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID NOT NULL,

    code_hash TEXT NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    used_at TIMESTAMP,

    CONSTRAINT fk_two_factor_recovery_codes_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_two_factor_recovery_codes_user_id
    ON two_factor_recovery_codes(user_id);


-- =========================================================
-- TRIGGER FOR updated_at
-- =========================================================

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


CREATE TRIGGER trg_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_user_addresses_updated_at
BEFORE UPDATE ON user_addresses
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_buyer_preferences_updated_at
BEFORE UPDATE ON buyer_preferences
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_buyer_notification_preferences_updated_at
BEFORE UPDATE ON buyer_notification_preferences
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_seller_settings_updated_at
BEFORE UPDATE ON seller_settings
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_seller_notification_preferences_updated_at
BEFORE UPDATE ON seller_notification_preferences
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_admin_settings_updated_at
BEFORE UPDATE ON admin_settings
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_admin_notification_preferences_updated_at
BEFORE UPDATE ON admin_notification_preferences
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_privacy_settings_updated_at
BEFORE UPDATE ON privacy_settings
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_consent_settings_updated_at
BEFORE UPDATE ON consent_settings
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_two_factor_settings_updated_at
BEFORE UPDATE ON two_factor_settings
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();