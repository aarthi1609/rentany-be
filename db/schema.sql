-- RentAny MVP PostgreSQL schema
-- Simple first version for AWS hosting with product images/videos stored in S3.

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS citext;

CREATE TYPE product_status AS ENUM (
  'active',
  'paused',
  'removed'
);

CREATE TYPE rental_status AS ENUM (
  'requested',
  'accepted',
  'rejected',
  'cancelled',
  'in_progress',
  'returned',
  'completed'
);

CREATE TYPE notification_status AS ENUM (
  'pending',
  'sent',
  'failed'
);

CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email citext NOT NULL UNIQUE,
  phone text,
  google_id text UNIQUE,
  profile_image_s3_key text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  category_id uuid NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
  title text NOT NULL,
  description text,
  model text,
  image_s3_key text,
  price_per_day numeric(10, 2) NOT NULL CHECK (price_per_day > 0),
  address text,
  city text,
  state text,
  latitude numeric(9, 6),
  longitude numeric(9, 6),
  status product_status NOT NULL DEFAULT 'active',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE rentals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
  owner_id uuid NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  renter_id uuid NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  start_date date NOT NULL,
  end_date date NOT NULL,
  total_price numeric(10, 2) NOT NULL CHECK (total_price >= 0),
  status rental_status NOT NULL DEFAULT 'requested',
  owner_phone_share_consent boolean NOT NULL DEFAULT false,
  renter_phone_share_consent boolean NOT NULL DEFAULT false,
  pickup_video_s3_key text,
  return_video_s3_key text,
  owner_agreement_accepted boolean NOT NULL DEFAULT false,
  renter_agreement_accepted boolean NOT NULL DEFAULT false,
  started_at timestamptz,
  returned_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CHECK (end_date >= start_date),
  CHECK (owner_id <> renter_id)
);

CREATE TABLE rental_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  rental_id uuid NOT NULL REFERENCES rentals(id) ON DELETE CASCADE,
  sender_id uuid REFERENCES users(id) ON DELETE SET NULL,
  message text NOT NULL,
  is_system_message boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  rental_id uuid REFERENCES rentals(id) ON DELETE CASCADE,
  type text NOT NULL,
  email citext NOT NULL,
  status notification_status NOT NULL DEFAULT 'pending',
  error_message text,
  created_at timestamptz NOT NULL DEFAULT now(),
  sent_at timestamptz
);

CREATE INDEX idx_products_owner_id ON products (owner_id);
CREATE INDEX idx_products_category_id ON products (category_id);
CREATE INDEX idx_products_status ON products (status);
CREATE INDEX idx_products_location ON products (latitude, longitude);
CREATE INDEX idx_rentals_product_id ON rentals (product_id);
CREATE INDEX idx_rentals_owner_id ON rentals (owner_id);
CREATE INDEX idx_rentals_renter_id ON rentals (renter_id);
CREATE INDEX idx_rentals_status ON rentals (status);
CREATE INDEX idx_rental_messages_rental_id ON rental_messages (rental_id, created_at);
CREATE INDEX idx_notifications_user_id ON notifications (user_id);
CREATE INDEX idx_notifications_status ON notifications (status);

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_set_updated_at
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER products_set_updated_at
BEFORE UPDATE ON products
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER rentals_set_updated_at
BEFORE UPDATE ON rentals
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

INSERT INTO categories (name, slug)
VALUES ('Electronics', 'electronics')
ON CONFLICT (slug) DO NOTHING;
