--
-- PostgreSQL database dump
--

\restrict pRUdfnDbx21HPWziFV2v1fRb4tVDq0VqC8N6yRmhdX206RCTCvOZhSZwCO5YdOl

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: admin_role; Type: TYPE; Schema: public; Owner: novaadmin
--

CREATE TYPE public.admin_role AS ENUM (
    'super_admin',
    'admin',
    'moderator',
    'delivery'
);


ALTER TYPE public.admin_role OWNER TO novaadmin;

--
-- Name: delivery_method; Type: TYPE; Schema: public; Owner: novaadmin
--

CREATE TYPE public.delivery_method AS ENUM (
    'standard',
    'express',
    'pickup'
);


ALTER TYPE public.delivery_method OWNER TO novaadmin;

--
-- Name: language; Type: TYPE; Schema: public; Owner: novaadmin
--

CREATE TYPE public.language AS ENUM (
    'mg',
    'fr',
    'en'
);


ALTER TYPE public.language OWNER TO novaadmin;

--
-- Name: profile_visibility; Type: TYPE; Schema: public; Owner: novaadmin
--

CREATE TYPE public.profile_visibility AS ENUM (
    'private',
    'public'
);


ALTER TYPE public.profile_visibility OWNER TO novaadmin;

--
-- Name: theme; Type: TYPE; Schema: public; Owner: novaadmin
--

CREATE TYPE public.theme AS ENUM (
    'light',
    'dark',
    'system'
);


ALTER TYPE public.theme OWNER TO novaadmin;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: novaadmin
--

CREATE TYPE public.user_role AS ENUM (
    'buyer',
    'seller',
    'admin'
);


ALTER TYPE public.user_role OWNER TO novaadmin;

--
-- Name: user_status; Type: TYPE; Schema: public; Owner: novaadmin
--

CREATE TYPE public.user_status AS ENUM (
    'active',
    'suspended'
);


ALTER TYPE public.user_status OWNER TO novaadmin;

--
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: novaadmin
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_updated_at() OWNER TO novaadmin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_notification_preferences; Type: TABLE; Schema: public; Owner: novaadmin
--

CREATE TABLE public.admin_notification_preferences (
    user_id uuid NOT NULL,
    seller_applications boolean DEFAULT true NOT NULL,
    product_moderation boolean DEFAULT true NOT NULL,
    payment_failures boolean DEFAULT true NOT NULL,
    fraud_alerts boolean DEFAULT true NOT NULL,
    system_alerts boolean DEFAULT true NOT NULL,
    user_reports boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.admin_notification_preferences OWNER TO novaadmin;

--
-- Name: admin_settings; Type: TABLE; Schema: public; Owner: novaadmin
--

CREATE TABLE public.admin_settings (
    user_id uuid NOT NULL,
    theme public.theme DEFAULT 'system'::public.theme NOT NULL,
    language public.language DEFAULT 'fr'::public.language NOT NULL,
    email_notifications boolean DEFAULT true NOT NULL,
    push_notifications boolean DEFAULT true NOT NULL,
    security_alerts boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.admin_settings OWNER TO novaadmin;

--
-- Name: buyer_favorite_categories; Type: TABLE; Schema: public; Owner: novaadmin
--

CREATE TABLE public.buyer_favorite_categories (
    user_id uuid NOT NULL,
    category_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.buyer_favorite_categories OWNER TO novaadmin;

--
-- Name: buyer_notification_preferences; Type: TABLE; Schema: public; Owner: novaadmin
--

CREATE TABLE public.buyer_notification_preferences (
    user_id uuid NOT NULL,
    order_created boolean DEFAULT true NOT NULL,
    order_delivered boolean DEFAULT true NOT NULL,
    order_pending boolean DEFAULT true NOT NULL,
    order_cancelled boolean DEFAULT true NOT NULL,
    payment boolean DEFAULT true NOT NULL,
    promotions boolean DEFAULT true NOT NULL,
    price_drops boolean DEFAULT true NOT NULL,
    back_in_stock boolean DEFAULT true NOT NULL,
    new_products boolean DEFAULT false NOT NULL,
    followed_stores boolean DEFAULT false NOT NULL,
    reviews boolean DEFAULT true NOT NULL,
    recommendations boolean DEFAULT true NOT NULL,
    email boolean DEFAULT false NOT NULL,
    push boolean DEFAULT true NOT NULL,
    sms boolean DEFAULT false NOT NULL,
    frequency character varying(20) DEFAULT 'monthly'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT buyer_notification_frequency_check CHECK (((frequency)::text = ANY ((ARRAY['monthly'::character varying, 'daily'::character varying, 'weekly'::character varying])::text[])))
);


ALTER TABLE public.buyer_notification_preferences OWNER TO novaadmin;

--
-- Name: buyer_preferences; Type: TABLE; Schema: public; Owner: novaadmin
--

CREATE TABLE public.buyer_preferences (
    user_id uuid NOT NULL,
    theme public.theme DEFAULT 'system'::public.theme NOT NULL,
    language public.language DEFAULT 'fr'::public.language NOT NULL,
    preferred_delivery_method public.delivery_method DEFAULT 'standard'::public.delivery_method NOT NULL,
    personalized_recommendations boolean DEFAULT true NOT NULL,
    show_recently_viewed boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.buyer_preferences OWNER TO novaadmin;

--
-- Name: consent_settings; Type: TABLE; Schema: public; Owner: novaadmin
--

CREATE TABLE public.consent_settings (
    user_id uuid NOT NULL,
    marketing boolean DEFAULT false NOT NULL,
    analytics boolean DEFAULT false NOT NULL,
    personalization boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.consent_settings OWNER TO novaadmin;

--
-- Name: favorite_products; Type: TABLE; Schema: public; Owner: novaadmin
--

CREATE TABLE public.favorite_products (
    user_id uuid NOT NULL,
    product_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.favorite_products OWNER TO novaadmin;

--
-- Name: followed_stores; Type: TABLE; Schema: public; Owner: novaadmin
--

CREATE TABLE public.followed_stores (
    user_id uuid NOT NULL,
    store_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.followed_stores OWNER TO novaadmin;

--
-- Name: privacy_settings; Type: TABLE; Schema: public; Owner: novaadmin
--

CREATE TABLE public.privacy_settings (
    user_id uuid NOT NULL,
    profile_visibility public.profile_visibility DEFAULT 'private'::public.profile_visibility NOT NULL,
    activity_personalization boolean DEFAULT true NOT NULL,
    analytics_consent boolean DEFAULT false NOT NULL,
    marketing_consent boolean DEFAULT false NOT NULL,
    data_sharing boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.privacy_settings OWNER TO novaadmin;

--
-- Name: seller_notification_preferences; Type: TABLE; Schema: public; Owner: novaadmin
--

CREATE TABLE public.seller_notification_preferences (
    user_id uuid NOT NULL,
    new_order boolean DEFAULT true NOT NULL,
    order_cancelled boolean DEFAULT true NOT NULL,
    low_stock boolean DEFAULT true NOT NULL,
    product_approved boolean DEFAULT true NOT NULL,
    product_rejected boolean DEFAULT true NOT NULL,
    new_review boolean DEFAULT true NOT NULL,
    payout boolean DEFAULT true NOT NULL,
    seller_announcements boolean DEFAULT true NOT NULL,
    email boolean DEFAULT true NOT NULL,
    push boolean DEFAULT true NOT NULL,
    sms boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.seller_notification_preferences OWNER TO novaadmin;

--
-- Name: seller_settings; Type: TABLE; Schema: public; Owner: novaadmin
--

CREATE TABLE public.seller_settings (
    user_id uuid NOT NULL,
    theme public.theme DEFAULT 'system'::public.theme NOT NULL,
    language public.language DEFAULT 'fr'::public.language NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.seller_settings OWNER TO novaadmin;

--
-- Name: user_addresses; Type: TABLE; Schema: public; Owner: novaadmin
--

CREATE TABLE public.user_addresses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    label character varying(100) NOT NULL,
    recipient_name character varying(200) NOT NULL,
    phone character varying(30) NOT NULL,
    street text NOT NULL,
    district character varying(150),
    city character varying(150) NOT NULL,
    region character varying(150),
    postal_code character varying(20),
    latitude double precision,
    longitude double precision,
    instructions text,
    is_default boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_addresses OWNER TO novaadmin;

--
-- Name: users; Type: TABLE; Schema: public; Owner: novaadmin
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(30),
    role public.user_role DEFAULT 'buyer'::public.user_role NOT NULL,
    status public.user_status DEFAULT 'active'::public.user_status NOT NULL,
    admin_role public.admin_role,
    avatar_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT users_admin_role_check CHECK (((role = 'admin'::public.user_role) OR (admin_role IS NULL)))
);


ALTER TABLE public.users OWNER TO novaadmin;

--
-- Data for Name: admin_notification_preferences; Type: TABLE DATA; Schema: public; Owner: novaadmin
--

COPY public.admin_notification_preferences (user_id, seller_applications, product_moderation, payment_failures, fraud_alerts, system_alerts, user_reports, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: admin_settings; Type: TABLE DATA; Schema: public; Owner: novaadmin
--

COPY public.admin_settings (user_id, theme, language, email_notifications, push_notifications, security_alerts, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: buyer_favorite_categories; Type: TABLE DATA; Schema: public; Owner: novaadmin
--

COPY public.buyer_favorite_categories (user_id, category_id, created_at) FROM stdin;
\.


--
-- Data for Name: buyer_notification_preferences; Type: TABLE DATA; Schema: public; Owner: novaadmin
--

COPY public.buyer_notification_preferences (user_id, order_created, order_delivered, order_pending, order_cancelled, payment, promotions, price_drops, back_in_stock, new_products, followed_stores, reviews, recommendations, email, push, sms, frequency, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: buyer_preferences; Type: TABLE DATA; Schema: public; Owner: novaadmin
--

COPY public.buyer_preferences (user_id, theme, language, preferred_delivery_method, personalized_recommendations, show_recently_viewed, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: consent_settings; Type: TABLE DATA; Schema: public; Owner: novaadmin
--

COPY public.consent_settings (user_id, marketing, analytics, personalization, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: favorite_products; Type: TABLE DATA; Schema: public; Owner: novaadmin
--

COPY public.favorite_products (user_id, product_id, created_at) FROM stdin;
\.


--
-- Data for Name: followed_stores; Type: TABLE DATA; Schema: public; Owner: novaadmin
--

COPY public.followed_stores (user_id, store_id, created_at) FROM stdin;
\.


--
-- Data for Name: privacy_settings; Type: TABLE DATA; Schema: public; Owner: novaadmin
--

COPY public.privacy_settings (user_id, profile_visibility, activity_personalization, analytics_consent, marketing_consent, data_sharing, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: seller_notification_preferences; Type: TABLE DATA; Schema: public; Owner: novaadmin
--

COPY public.seller_notification_preferences (user_id, new_order, order_cancelled, low_stock, product_approved, product_rejected, new_review, payout, seller_announcements, email, push, sms, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: seller_settings; Type: TABLE DATA; Schema: public; Owner: novaadmin
--

COPY public.seller_settings (user_id, theme, language, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_addresses; Type: TABLE DATA; Schema: public; Owner: novaadmin
--

COPY public.user_addresses (id, user_id, label, recipient_name, phone, street, district, city, region, postal_code, latitude, longitude, instructions, is_default, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: novaadmin
--

COPY public.users (id, first_name, last_name, email, phone, role, status, admin_role, avatar_url, created_at, updated_at) FROM stdin;
\.


--
-- Name: admin_notification_preferences admin_notification_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.admin_notification_preferences
    ADD CONSTRAINT admin_notification_preferences_pkey PRIMARY KEY (user_id);


--
-- Name: admin_settings admin_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.admin_settings
    ADD CONSTRAINT admin_settings_pkey PRIMARY KEY (user_id);


--
-- Name: buyer_favorite_categories buyer_favorite_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.buyer_favorite_categories
    ADD CONSTRAINT buyer_favorite_categories_pkey PRIMARY KEY (user_id, category_id);


--
-- Name: buyer_notification_preferences buyer_notification_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.buyer_notification_preferences
    ADD CONSTRAINT buyer_notification_preferences_pkey PRIMARY KEY (user_id);


--
-- Name: buyer_preferences buyer_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.buyer_preferences
    ADD CONSTRAINT buyer_preferences_pkey PRIMARY KEY (user_id);


--
-- Name: consent_settings consent_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.consent_settings
    ADD CONSTRAINT consent_settings_pkey PRIMARY KEY (user_id);


--
-- Name: favorite_products favorite_products_pkey; Type: CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.favorite_products
    ADD CONSTRAINT favorite_products_pkey PRIMARY KEY (user_id, product_id);


--
-- Name: followed_stores followed_stores_pkey; Type: CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.followed_stores
    ADD CONSTRAINT followed_stores_pkey PRIMARY KEY (user_id, store_id);


--
-- Name: privacy_settings privacy_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.privacy_settings
    ADD CONSTRAINT privacy_settings_pkey PRIMARY KEY (user_id);


--
-- Name: seller_notification_preferences seller_notification_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.seller_notification_preferences
    ADD CONSTRAINT seller_notification_preferences_pkey PRIMARY KEY (user_id);


--
-- Name: seller_settings seller_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.seller_settings
    ADD CONSTRAINT seller_settings_pkey PRIMARY KEY (user_id);


--
-- Name: user_addresses user_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_buyer_favorite_categories_category; Type: INDEX; Schema: public; Owner: novaadmin
--

CREATE INDEX idx_buyer_favorite_categories_category ON public.buyer_favorite_categories USING btree (category_id);


--
-- Name: idx_favorite_products_product; Type: INDEX; Schema: public; Owner: novaadmin
--

CREATE INDEX idx_favorite_products_product ON public.favorite_products USING btree (product_id);


--
-- Name: idx_favorite_products_user; Type: INDEX; Schema: public; Owner: novaadmin
--

CREATE INDEX idx_favorite_products_user ON public.favorite_products USING btree (user_id);


--
-- Name: idx_followed_stores_store; Type: INDEX; Schema: public; Owner: novaadmin
--

CREATE INDEX idx_followed_stores_store ON public.followed_stores USING btree (store_id);


--
-- Name: idx_followed_stores_user; Type: INDEX; Schema: public; Owner: novaadmin
--

CREATE INDEX idx_followed_stores_user ON public.followed_stores USING btree (user_id);


--
-- Name: idx_user_addresses_one_default; Type: INDEX; Schema: public; Owner: novaadmin
--

CREATE UNIQUE INDEX idx_user_addresses_one_default ON public.user_addresses USING btree (user_id) WHERE (is_default = true);


--
-- Name: idx_user_addresses_user_default; Type: INDEX; Schema: public; Owner: novaadmin
--

CREATE INDEX idx_user_addresses_user_default ON public.user_addresses USING btree (user_id, is_default);


--
-- Name: idx_user_addresses_user_id; Type: INDEX; Schema: public; Owner: novaadmin
--

CREATE INDEX idx_user_addresses_user_id ON public.user_addresses USING btree (user_id);


--
-- Name: idx_users_role; Type: INDEX; Schema: public; Owner: novaadmin
--

CREATE INDEX idx_users_role ON public.users USING btree (role);


--
-- Name: idx_users_status; Type: INDEX; Schema: public; Owner: novaadmin
--

CREATE INDEX idx_users_status ON public.users USING btree (status);


--
-- Name: admin_notification_preferences trg_admin_notification_preferences_updated_at; Type: TRIGGER; Schema: public; Owner: novaadmin
--

CREATE TRIGGER trg_admin_notification_preferences_updated_at BEFORE UPDATE ON public.admin_notification_preferences FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: admin_settings trg_admin_settings_updated_at; Type: TRIGGER; Schema: public; Owner: novaadmin
--

CREATE TRIGGER trg_admin_settings_updated_at BEFORE UPDATE ON public.admin_settings FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: buyer_notification_preferences trg_buyer_notification_preferences_updated_at; Type: TRIGGER; Schema: public; Owner: novaadmin
--

CREATE TRIGGER trg_buyer_notification_preferences_updated_at BEFORE UPDATE ON public.buyer_notification_preferences FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: buyer_preferences trg_buyer_preferences_updated_at; Type: TRIGGER; Schema: public; Owner: novaadmin
--

CREATE TRIGGER trg_buyer_preferences_updated_at BEFORE UPDATE ON public.buyer_preferences FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: consent_settings trg_consent_settings_updated_at; Type: TRIGGER; Schema: public; Owner: novaadmin
--

CREATE TRIGGER trg_consent_settings_updated_at BEFORE UPDATE ON public.consent_settings FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: privacy_settings trg_privacy_settings_updated_at; Type: TRIGGER; Schema: public; Owner: novaadmin
--

CREATE TRIGGER trg_privacy_settings_updated_at BEFORE UPDATE ON public.privacy_settings FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: seller_notification_preferences trg_seller_notification_preferences_updated_at; Type: TRIGGER; Schema: public; Owner: novaadmin
--

CREATE TRIGGER trg_seller_notification_preferences_updated_at BEFORE UPDATE ON public.seller_notification_preferences FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: seller_settings trg_seller_settings_updated_at; Type: TRIGGER; Schema: public; Owner: novaadmin
--

CREATE TRIGGER trg_seller_settings_updated_at BEFORE UPDATE ON public.seller_settings FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: user_addresses trg_user_addresses_updated_at; Type: TRIGGER; Schema: public; Owner: novaadmin
--

CREATE TRIGGER trg_user_addresses_updated_at BEFORE UPDATE ON public.user_addresses FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: users trg_users_updated_at; Type: TRIGGER; Schema: public; Owner: novaadmin
--

CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: admin_notification_preferences fk_admin_notification_preferences_user; Type: FK CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.admin_notification_preferences
    ADD CONSTRAINT fk_admin_notification_preferences_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: admin_settings fk_admin_settings_user; Type: FK CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.admin_settings
    ADD CONSTRAINT fk_admin_settings_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: buyer_favorite_categories fk_buyer_favorite_categories_user; Type: FK CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.buyer_favorite_categories
    ADD CONSTRAINT fk_buyer_favorite_categories_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: buyer_notification_preferences fk_buyer_notification_preferences_user; Type: FK CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.buyer_notification_preferences
    ADD CONSTRAINT fk_buyer_notification_preferences_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: buyer_preferences fk_buyer_preferences_user; Type: FK CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.buyer_preferences
    ADD CONSTRAINT fk_buyer_preferences_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: consent_settings fk_consent_settings_user; Type: FK CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.consent_settings
    ADD CONSTRAINT fk_consent_settings_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: favorite_products fk_favorite_products_user; Type: FK CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.favorite_products
    ADD CONSTRAINT fk_favorite_products_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: followed_stores fk_followed_stores_user; Type: FK CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.followed_stores
    ADD CONSTRAINT fk_followed_stores_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: privacy_settings fk_privacy_settings_user; Type: FK CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.privacy_settings
    ADD CONSTRAINT fk_privacy_settings_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: seller_notification_preferences fk_seller_notification_preferences_user; Type: FK CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.seller_notification_preferences
    ADD CONSTRAINT fk_seller_notification_preferences_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: seller_settings fk_seller_settings_user; Type: FK CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.seller_settings
    ADD CONSTRAINT fk_seller_settings_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_addresses fk_user_addresses_user; Type: FK CONSTRAINT; Schema: public; Owner: novaadmin
--

ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT fk_user_addresses_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict pRUdfnDbx21HPWziFV2v1fRb4tVDq0VqC8N6yRmhdX206RCTCvOZhSZwCO5YdOl

