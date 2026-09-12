CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- =========================================================
-- ENUMS
-- =========================================================

CREATE TYPE user_role AS ENUM (
    'buyer',
    'seller',
    'admin'
);

CREATE TYPE user_status AS ENUM (
    'active',
    'suspended'
);

CREATE TYPE admin_role AS ENUM (
    'super_admin',
    'admin',
    'moderator',
    'delivery'
);

CREATE TYPE theme AS ENUM (
    'light',
    'dark',
    'system'
);

CREATE TYPE language AS ENUM (
    'mg',
    'fr',
    'en'
);

CREATE TYPE profile_visibility AS ENUM (
    'private',
    'public'
);

CREATE TYPE delivery_method AS ENUM (
    'standard',
    'express',
    'pickup'
);

-- =========================================================
-- USERS
-- =========================================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,

    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(30) UNIQUE,

    role user_role NOT NULL DEFAULT 'buyer',
    status user_status NOT NULL DEFAULT 'active',

    admin_role admin_role,

    avatar_url TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT users_admin_role_check
        CHECK (
            role = 'admin'
            OR admin_role IS NULL
        )
);

CREATE INDEX idx_users_role
    ON users(role);

CREATE INDEX idx_users_status
    ON users(status);

-- =========================================================
-- USER ADDRESSES
-- =========================================================

CREATE TABLE user_addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID NOT NULL,

    label VARCHAR(100) NOT NULL,
    recipient_name VARCHAR(200) NOT NULL,
    phone VARCHAR(30) NOT NULL,

    street TEXT NOT NULL,
    district VARCHAR(150),
    city VARCHAR(150) NOT NULL,
    region VARCHAR(150),

    postal_code VARCHAR(20),

    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,

    instructions TEXT,

    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_user_addresses_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_user_addresses_user_id
    ON user_addresses(user_id);

CREATE INDEX idx_user_addresses_user_default
    ON user_addresses(user_id, is_default);

-- Un seul address par défaut par utilisateur
CREATE UNIQUE INDEX idx_user_addresses_one_default
    ON user_addresses(user_id)
    WHERE is_default = TRUE;

-- =========================================================
-- BUYER PREFERENCES
-- =========================================================

CREATE TABLE buyer_preferences (
    user_id UUID PRIMARY KEY,

    theme theme NOT NULL DEFAULT 'system',
    language language NOT NULL DEFAULT 'fr',

    preferred_delivery_method delivery_method
        NOT NULL DEFAULT 'standard',

    personalized_recommendations BOOLEAN
        NOT NULL DEFAULT TRUE,

    show_recently_viewed BOOLEAN
        NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_buyer_preferences_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

-- =========================================================
-- BUYER FAVORITE CATEGORIES
-- =========================================================

CREATE TABLE buyer_favorite_categories (
    user_id UUID NOT NULL,
    category_id UUID NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    PRIMARY KEY (user_id, category_id),

    CONSTRAINT fk_buyer_favorite_categories_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE

    -- category_id intentionally has no FK:
    -- Category belongs to Product/Catalog Service.
);

CREATE INDEX idx_buyer_favorite_categories_category
    ON buyer_favorite_categories(category_id);

-- =========================================================
-- BUYER NOTIFICATION PREFERENCES
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
    new_products BOOLEAN NOT NULL DEFAULT FALSE,
    followed_stores BOOLEAN NOT NULL DEFAULT FALSE,
    reviews BOOLEAN NOT NULL DEFAULT TRUE,
    recommendations BOOLEAN NOT NULL DEFAULT TRUE,

    email BOOLEAN NOT NULL DEFAULT FALSE,
    push BOOLEAN NOT NULL DEFAULT TRUE,
    sms BOOLEAN NOT NULL DEFAULT FALSE,

    frequency VARCHAR(20) NOT NULL DEFAULT 'monthly',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_buyer_notification_preferences_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT buyer_notification_frequency_check
        CHECK (
            frequency IN ('monthly', 'daily', 'weekly')
        )
);

-- =========================================================
-- SELLER SETTINGS
-- =========================================================

CREATE TABLE seller_settings (
    user_id UUID PRIMARY KEY,

    theme theme NOT NULL DEFAULT 'system',
    language language NOT NULL DEFAULT 'fr',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_seller_settings_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

-- =========================================================
-- SELLER NOTIFICATION PREFERENCES
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

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_seller_notification_preferences_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

-- =========================================================
-- ADMIN SETTINGS
-- =========================================================

CREATE TABLE admin_settings (
    user_id UUID PRIMARY KEY,

    theme theme NOT NULL DEFAULT 'system',
    language language NOT NULL DEFAULT 'fr',

    email_notifications BOOLEAN NOT NULL DEFAULT TRUE,
    push_notifications BOOLEAN NOT NULL DEFAULT TRUE,
    security_alerts BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_admin_settings_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

-- =========================================================
-- ADMIN NOTIFICATION PREFERENCES
-- =========================================================

CREATE TABLE admin_notification_preferences (
    user_id UUID PRIMARY KEY,

    seller_applications BOOLEAN NOT NULL DEFAULT TRUE,
    product_moderation BOOLEAN NOT NULL DEFAULT TRUE,
    payment_failures BOOLEAN NOT NULL DEFAULT TRUE,
    fraud_alerts BOOLEAN NOT NULL DEFAULT TRUE,
    system_alerts BOOLEAN NOT NULL DEFAULT TRUE,
    user_reports BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_admin_notification_preferences_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

-- =========================================================
-- PRIVACY SETTINGS
-- =========================================================

CREATE TABLE privacy_settings (
    user_id UUID PRIMARY KEY,

    profile_visibility profile_visibility
        NOT NULL DEFAULT 'private',

    activity_personalization BOOLEAN
        NOT NULL DEFAULT TRUE,

    analytics_consent BOOLEAN
        NOT NULL DEFAULT FALSE,

    marketing_consent BOOLEAN
        NOT NULL DEFAULT FALSE,

    data_sharing BOOLEAN
        NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_privacy_settings_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

-- =========================================================
-- CONSENT SETTINGS
-- =========================================================

CREATE TABLE consent_settings (
    user_id UUID PRIMARY KEY,

    marketing BOOLEAN NOT NULL DEFAULT FALSE,
    analytics BOOLEAN NOT NULL DEFAULT FALSE,
    personalization BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_consent_settings_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

-- =========================================================
-- FAVORITE PRODUCTS
-- =========================================================

CREATE TABLE favorite_products (
    user_id UUID NOT NULL,
    product_id UUID NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    PRIMARY KEY (user_id, product_id),

    CONSTRAINT fk_favorite_products_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE

    -- product_id has no FK:
    -- Product belongs to Product Service.
);

CREATE INDEX idx_favorite_products_product
    ON favorite_products(product_id);

CREATE INDEX idx_favorite_products_user
    ON favorite_products(user_id);

-- =========================================================
-- FOLLOWED STORES
-- =========================================================

CREATE TABLE followed_stores (
    user_id UUID NOT NULL,
    store_id UUID NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    PRIMARY KEY (user_id, store_id),

    CONSTRAINT fk_followed_stores_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE

    -- store_id has no FK:
    -- Store belongs to Store Service.
);

CREATE INDEX idx_followed_stores_store
    ON followed_stores(store_id);

CREATE INDEX idx_followed_stores_user
    ON followed_stores(user_id);

-- =========================================================
-- UPDATED_AT TRIGGER
-- =========================================================

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

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