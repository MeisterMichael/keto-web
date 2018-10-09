# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_10_08_184311) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.text "tags", default: [], array: true
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.text "tags", default: [], array: true
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "bazaar_cart_items", force: :cascade do |t|
    t.bigint "cart_id"
    t.string "item_type"
    t.bigint "item_id"
    t.integer "quantity", default: 1
    t.integer "price", default: 0
    t.integer "subtotal", default: 0
    t.hstore "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_bazaar_cart_items_on_cart_id"
    t.index ["item_type", "item_id"], name: "index_bazaar_cart_items_on_item_type_and_item_id"
  end

  create_table "bazaar_carts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "order_id"
    t.integer "status", default: 1
    t.integer "subtotal", default: 0
    t.integer "estimated_tax", default: 0
    t.integer "estimated_shipping", default: 0
    t.integer "estimated_total", default: 0
    t.string "ip"
    t.hstore "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.json "checkout_cache", default: {}
    t.index ["order_id"], name: "index_bazaar_carts_on_order_id"
    t.index ["user_id"], name: "index_bazaar_carts_on_user_id"
  end

  create_table "bazaar_collection_items", force: :cascade do |t|
    t.bigint "collection_id"
    t.string "item_type"
    t.bigint "item_id"
    t.index ["collection_id"], name: "index_bazaar_collection_items_on_collection_id"
    t.index ["item_type", "item_id"], name: "index_bazaar_collection_items_on_item_type_and_item_id"
  end

  create_table "bazaar_collections", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "avatar"
    t.integer "status", default: 0
    t.integer "collection_type", default: 1
    t.integer "availability", default: 1
    t.hstore "properties", default: {}
    t.json "query", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status", "availability"], name: "index_bazaar_collections_on_status_and_availability"
    t.index ["title", "status", "availability"], name: "index_bazaar_collections_on_title_and_status_and_availability"
  end

  create_table "bazaar_discount_items", force: :cascade do |t|
    t.bigint "discount_id"
    t.string "applies_to_type"
    t.bigint "applies_to_id"
    t.integer "order_item_type", default: 1
    t.integer "minimum_orders", default: 0
    t.integer "maximum_orders", default: 1
    t.string "currency", default: "USD"
    t.integer "discount_amount"
    t.integer "discount_type", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["applies_to_type", "applies_to_id"], name: "index_discount_items_on_applies_to"
    t.index ["discount_id"], name: "index_bazaar_discount_items_on_discount_id"
  end

  create_table "bazaar_discount_users", force: :cascade do |t|
    t.bigint "discount_id"
    t.bigint "user_id"
    t.index ["discount_id"], name: "index_bazaar_discount_users_on_discount_id"
    t.index ["user_id"], name: "index_bazaar_discount_users_on_user_id"
  end

  create_table "bazaar_discounts", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "code"
    t.integer "status", default: 0
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer "availability", default: 1
    t.integer "minimum_prod_subtotal", default: 0
    t.integer "minimum_shipping_subtotal", default: 0
    t.integer "minimum_tax_subtotal", default: 0
    t.integer "limit_per_customer"
    t.integer "limit_global"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "type"
    t.integer "cached_uses", default: 0
    t.index ["type", "id"], name: "index_bazaar_discounts_on_type_and_id"
    t.index ["user_id", "status", "code"], name: "index_bazaar_discounts_on_user_id_and_status_and_code"
    t.index ["user_id", "status", "end_at"], name: "index_bazaar_discounts_on_user_id_and_status_and_end_at"
    t.index ["user_id", "status", "start_at"], name: "index_bazaar_discounts_on_user_id_and_status_and_start_at"
    t.index ["user_id", "status", "title"], name: "index_bazaar_discounts_on_user_id_and_status_and_title"
  end

  create_table "bazaar_media", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "managed_by_id"
    t.bigint "category_id"
    t.bigint "parent_id"
    t.bigint "working_media_version_id"
    t.integer "lft"
    t.integer "rgt"
    t.string "type"
    t.string "sub_type"
    t.string "title"
    t.string "subtitle"
    t.text "avatar"
    t.string "cover_image"
    t.string "avatar_caption"
    t.string "layout"
    t.string "template"
    t.text "description"
    t.text "content"
    t.string "slug"
    t.string "redirect_url"
    t.boolean "is_commentable", default: true
    t.boolean "is_sticky", default: false
    t.boolean "show_title", default: true
    t.text "keywords", default: [], array: true
    t.string "duration"
    t.integer "cached_char_count", default: 0
    t.integer "cached_word_count", default: 0
    t.integer "status", default: 1
    t.integer "availability", default: 1
    t.datetime "publish_at"
    t.hstore "properties", default: {}
    t.string "tags", default: [], array: true
    t.integer "seq"
    t.text "meta_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_bazaar_media_on_category_id"
    t.index ["managed_by_id"], name: "index_bazaar_media_on_managed_by_id"
    t.index ["parent_id"], name: "index_bazaar_media_on_parent_id"
    t.index ["slug", "type"], name: "index_bazaar_media_on_slug_and_type"
    t.index ["slug"], name: "index_bazaar_media_on_slug", unique: true
    t.index ["status", "availability"], name: "index_bazaar_media_on_status_and_availability"
    t.index ["tags"], name: "index_bazaar_media_on_tags", using: :gin
    t.index ["user_id"], name: "index_bazaar_media_on_user_id"
    t.index ["working_media_version_id"], name: "index_bazaar_media_on_working_media_version_id"
  end

  create_table "bazaar_media_offers", force: :cascade do |t|
    t.bigint "media_id"
    t.bigint "offer_id"
    t.integer "seq"
    t.index ["media_id", "seq"], name: "index_bazaar_media_offers_on_media_id_and_seq", unique: true
    t.index ["media_id"], name: "index_bazaar_media_offers_on_media_id"
    t.index ["offer_id"], name: "index_bazaar_media_offers_on_offer_id"
  end

  create_table "bazaar_order_items", force: :cascade do |t|
    t.bigint "order_id"
    t.string "item_type"
    t.bigint "item_id"
    t.string "title"
    t.integer "quantity", default: 1
    t.integer "price", default: 0
    t.integer "subtotal", default: 0
    t.string "tax_code"
    t.integer "order_item_type", default: 1
    t.hstore "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "subscription_id"
    t.string "sku"
    t.integer "parent_id"
    t.index ["item_id", "item_type", "order_id"], name: "index_bazaar_order_items_on_item_id_and_item_type_and_order_id"
    t.index ["item_type", "item_id"], name: "index_bazaar_order_items_on_item_type_and_item_id"
    t.index ["order_id"], name: "index_bazaar_order_items_on_order_id"
    t.index ["order_item_type", "order_id"], name: "index_bazaar_order_items_on_order_item_type_and_order_id"
    t.index ["subscription_id"], name: "index_bazaar_order_items_on_subscription_id"
  end

  create_table "bazaar_orders", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "billing_address_id"
    t.bigint "shipping_address_id"
    t.string "code"
    t.string "email"
    t.string "ip"
    t.integer "status", default: 2
    t.integer "subtotal", default: 0
    t.integer "tax", default: 0
    t.integer "shipping", default: 0
    t.integer "total"
    t.string "currency", default: "USD"
    t.text "customer_notes"
    t.text "support_notes"
    t.datetime "fulfilled_at"
    t.hstore "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "payment_status", default: 0
    t.integer "fulfillment_status", default: 0
    t.integer "generated_by", default: 1
    t.integer "parent_id"
    t.string "parent_type"
    t.string "provider"
    t.string "provider_customer_profile_reference"
    t.string "provider_customer_payment_profile_reference"
    t.datetime "delivered_at"
    t.integer "discount", default: 0
    t.string "type"
    t.string "source", default: "checkout"
    t.text "source_url"
    t.string "provider_reference"
    t.index ["billing_address_id"], name: "index_bazaar_orders_on_billing_address_id"
    t.index ["code"], name: "index_bazaar_orders_on_code", unique: true
    t.index ["email", "billing_address_id", "shipping_address_id"], name: "email_addr_indx"
    t.index ["email", "status"], name: "index_bazaar_orders_on_email_and_status"
    t.index ["parent_type", "parent_id"], name: "index_bazaar_orders_on_parent_type_and_parent_id"
    t.index ["shipping_address_id"], name: "index_bazaar_orders_on_shipping_address_id"
    t.index ["source", "status", "payment_status"], name: "index_bazaar_orders_on_source_and_status_and_payment_status"
    t.index ["status"], name: "index_bazaar_orders_on_status"
    t.index ["type", "status", "payment_status"], name: "index_bazaar_orders_on_type_and_status_and_payment_status"
    t.index ["user_id", "billing_address_id", "shipping_address_id"], name: "user_id_addr_indx"
    t.index ["user_id"], name: "index_bazaar_orders_on_user_id"
  end

  create_table "bazaar_product_variants", force: :cascade do |t|
    t.bigint "product_id"
    t.string "title"
    t.string "slug"
    t.string "avatar"
    t.string "option_name", default: "size"
    t.string "option_value"
    t.text "description"
    t.integer "status", default: 1
    t.integer "seq", default: 1
    t.integer "price", default: 0
    t.integer "shipping_price", default: 0
    t.integer "inventory", default: -1
    t.hstore "properties", default: {}
    t.datetime "publish_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "availability", default: 1
    t.integer "package_shape", default: 0
    t.float "package_weight"
    t.float "package_length"
    t.float "package_width"
    t.float "package_height"
    t.index ["option_name", "option_value"], name: "index_bazaar_product_variants_on_option_name_and_option_value"
    t.index ["product_id"], name: "index_bazaar_product_variants_on_product_id"
    t.index ["seq"], name: "index_bazaar_product_variants_on_seq"
    t.index ["slug"], name: "index_bazaar_product_variants_on_slug", unique: true
  end

  create_table "bazaar_products", force: :cascade do |t|
    t.bigint "category_id"
    t.text "shopify_code"
    t.string "title"
    t.string "caption"
    t.integer "seq", default: 1
    t.string "slug"
    t.string "avatar"
    t.string "brand_model"
    t.integer "status", default: 0
    t.text "description"
    t.text "content"
    t.datetime "publish_at"
    t.integer "price", default: 0
    t.integer "suggested_price", default: 0
    t.integer "shipping_price", default: 0
    t.string "currency", default: "USD"
    t.string "tags", default: [], array: true
    t.hstore "properties", default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "brand"
    t.string "model"
    t.text "size_info"
    t.text "notes"
    t.integer "collection_id"
    t.string "tax_code", default: "00000"
    t.integer "availability", default: 1
    t.integer "package_shape", default: 0
    t.float "package_weight"
    t.float "package_length"
    t.float "package_width"
    t.float "package_height"
    t.text "cart_description"
    t.index ["category_id"], name: "index_bazaar_products_on_category_id"
    t.index ["seq"], name: "index_bazaar_products_on_seq"
    t.index ["slug"], name: "index_bazaar_products_on_slug", unique: true
    t.index ["status"], name: "index_bazaar_products_on_status"
    t.index ["tags"], name: "index_bazaar_products_on_tags", using: :gin
  end

  create_table "bazaar_shipping_carrier_services", force: :cascade do |t|
    t.bigint "shipping_option_id"
    t.string "name"
    t.string "description"
    t.string "carrier"
    t.string "service_code"
    t.string "service_name"
    t.string "service_group"
    t.string "service_description"
    t.string "delivery_category"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shipping_option_id"], name: "index_bazaar_shipping_carrier_services_on_shipping_option_id"
  end

  create_table "bazaar_shipping_options", force: :cascade do |t|
    t.string "name"
    t.string "short_description"
    t.string "description"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bazaar_subscription_plans", force: :cascade do |t|
    t.string "billing_interval_unit", default: "months"
    t.integer "billing_interval_value", default: 1
    t.string "billing_statement_descriptor"
    t.integer "trial_price", default: 0
    t.string "trial_interval_unit", default: "month"
    t.integer "trial_interval_value", default: 1
    t.integer "trial_max_intervals", default: 0
    t.string "trial_statement_descriptor"
    t.integer "subscription_plan_type", default: 1
    t.string "title"
    t.integer "seq", default: 1
    t.string "slug"
    t.string "avatar"
    t.integer "status", default: 0
    t.text "description"
    t.text "content"
    t.datetime "publish_at"
    t.integer "price", default: 0
    t.integer "shipping_price", default: 0
    t.string "currency", default: "USD"
    t.hstore "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tax_code", default: "00000"
    t.string "product_sku"
    t.string "trial_sku"
    t.integer "availability", default: 1
    t.integer "package_shape", default: 0
    t.float "package_weight"
    t.float "package_length"
    t.float "package_width"
    t.float "package_height"
    t.integer "item_id"
    t.string "item_type"
    t.text "cart_description"
    t.index ["slug"], name: "index_bazaar_subscription_plans_on_slug", unique: true
    t.index ["status"], name: "index_bazaar_subscription_plans_on_status"
  end

  create_table "bazaar_subscriptions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "subscription_plan_id"
    t.bigint "billing_address_id"
    t.bigint "shipping_address_id"
    t.integer "quantity", default: 1
    t.string "code"
    t.integer "status", default: 0
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "canceled_at"
    t.datetime "trial_start_at"
    t.datetime "trial_end_at"
    t.datetime "current_period_start_at"
    t.datetime "current_period_end_at"
    t.datetime "next_charged_at"
    t.integer "amount"
    t.integer "trial_amount"
    t.string "currency", default: "USD"
    t.string "provider"
    t.string "provider_reference"
    t.string "provider_customer_profile_reference"
    t.string "provider_customer_payment_profile_reference"
    t.datetime "payment_profile_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "discount_id"
    t.integer "billing_interval_value", default: 1
    t.string "billing_interval_unit", default: "months"
    t.integer "trial_price"
    t.integer "price"
    t.datetime "failed_at"
    t.text "failed_message"
    t.integer "failed_attempts", default: 0
    t.integer "shipping_carrier_service_id"
    t.integer "shipping"
    t.integer "tax"
    t.index ["billing_address_id"], name: "index_bazaar_subscriptions_on_billing_address_id"
    t.index ["shipping_address_id"], name: "index_bazaar_subscriptions_on_shipping_address_id"
    t.index ["subscription_plan_id"], name: "index_bazaar_subscriptions_on_subscription_plan_id"
    t.index ["user_id"], name: "index_bazaar_subscriptions_on_user_id"
  end

  create_table "bazaar_transactions", force: :cascade do |t|
    t.string "parent_obj_type"
    t.bigint "parent_obj_id"
    t.integer "transaction_type", default: 1
    t.string "provider"
    t.string "reference_code"
    t.string "customer_profile_reference"
    t.string "customer_payment_profile_reference"
    t.integer "amount", default: 0
    t.string "currency", default: "USD"
    t.integer "status", default: 1
    t.text "message"
    t.hstore "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_obj_type", "parent_obj_id"], name: "index_bazaar_transactions_on_parent_obj_type_and_parent_obj_id"
    t.index ["reference_code"], name: "index_bazaar_transactions_on_reference_code"
  end

  create_table "bazaar_wholesale_items", force: :cascade do |t|
    t.bigint "wholesale_profile_id"
    t.string "item_type"
    t.bigint "item_id"
    t.integer "min_quantity", default: 0
    t.integer "price", default: 0
    t.index ["item_type", "item_id"], name: "index_bazaar_wholesale_items_on_item_type_and_item_id"
    t.index ["wholesale_profile_id", "item_id", "item_type", "min_quantity"], name: "index_wholesale_items_on_prof_id_and_item_and_min"
    t.index ["wholesale_profile_id", "item_id", "item_type", "price"], name: "index_wholesale_items_on_prof_id_and_item_and_price"
    t.index ["wholesale_profile_id", "min_quantity"], name: "index_wholesale_items_on_profile_id_and_min_qty"
    t.index ["wholesale_profile_id", "price"], name: "index_bazaar_wholesale_items_on_wholesale_profile_id_and_price"
    t.index ["wholesale_profile_id"], name: "index_bazaar_wholesale_items_on_wholesale_profile_id"
  end

  create_table "bazaar_wholesale_profiles", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "status", default: 0
    t.boolean "default_profile", default: false
    t.hstore "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_bazaar_wholesale_profiles_on_status"
    t.index ["title", "status"], name: "index_bazaar_wholesale_profiles_on_title_and_status"
  end

  create_table "bunyan_clients", force: :cascade do |t|
    t.bigint "user_id"
    t.string "uuid"
    t.string "ip"
    t.string "user_agent"
    t.string "country"
    t.string "state"
    t.string "city"
    t.string "referrer_url"
    t.string "referrer_host"
    t.string "referrer_path"
    t.string "referrer_params"
    t.string "lander_url"
    t.string "lander_host"
    t.string "lander_path"
    t.string "lander_params"
    t.string "campaign_source"
    t.string "campaign_medium"
    t.string "campaign_term"
    t.string "campaign_content"
    t.string "campaign_name"
    t.integer "campaign_cost"
    t.string "partner_source"
    t.string "partner_id"
    t.boolean "is_bot"
    t.string "device_type"
    t.string "device_family"
    t.string "device_brand"
    t.string "device_model"
    t.string "os_name"
    t.string "os_version"
    t.string "browser_family"
    t.string "browser_version"
    t.hstore "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bunyan_clients_on_user_id"
    t.index ["uuid"], name: "index_bunyan_clients_on_uuid", unique: true
  end

  create_table "bunyan_events", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "client_id"
    t.string "target_obj_type"
    t.bigint "target_obj_id"
    t.string "name"
    t.string "category"
    t.text "content"
    t.integer "value", default: 0
    t.string "ip"
    t.string "user_agent"
    t.string "campaign_source"
    t.string "campaign_medium"
    t.string "campaign_name"
    t.string "campaign_term"
    t.string "campaign_content"
    t.integer "campaign_cost"
    t.string "partner_source"
    t.string "partner_id"
    t.string "referrer_url"
    t.string "referrer_host"
    t.string "referrer_path"
    t.string "referrer_params"
    t.string "page_url"
    t.string "page_host"
    t.string "page_path"
    t.string "page_params"
    t.string "page_name"
    t.hstore "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_bunyan_events_on_client_id"
    t.index ["name", "created_at", "page_url"], name: "index_bunyan_events_on_name_and_created_at_and_page_url"
    t.index ["target_obj_type", "target_obj_id"], name: "index_bunyan_events_on_target_obj_type_and_target_obj_id"
    t.index ["user_id"], name: "index_bunyan_events_on_user_id"
  end

  create_table "edison_experiments", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.text "description"
    t.string "sample_type", default: "5050"
    t.string "conclusion_type", default: "control"
    t.string "conversion_event"
    t.string "conversion_path"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer "max_trials", default: 10000
    t.integer "status", default: 1
    t.hstore "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "edison_trials", force: :cascade do |t|
    t.bigint "experiment_id"
    t.bigint "variant_id"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_edison_trials_on_client_id"
    t.index ["experiment_id"], name: "index_edison_trials_on_experiment_id"
    t.index ["variant_id"], name: "index_edison_trials_on_variant_id"
  end

  create_table "edison_variants", force: :cascade do |t|
    t.bigint "experiment_id"
    t.string "title"
    t.text "description"
    t.float "weight", default: 1.0
    t.text "content"
    t.integer "status", default: 1
    t.integer "cached_participant_count", default: 0
    t.integer "cached_conversion_count", default: 0
    t.integer "final_participant_count", default: 0
    t.integer "final_conversion_count", default: 0
    t.boolean "is_control"
    t.hstore "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["experiment_id"], name: "index_edison_variants_on_experiment_id"
  end

  create_table "foods", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.string "description"
    t.text "content"
    t.string "avatar"
    t.text "nutrition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_foods_on_slug", unique: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "geo_addresses", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "geo_state_id"
    t.bigint "geo_country_id"
    t.integer "status"
    t.text "hash_code"
    t.string "address_type"
    t.string "title"
    t.string "first_name"
    t.string "last_name"
    t.string "street"
    t.string "street2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "phone"
    t.float "latitude"
    t.float "longitude"
    t.boolean "validated", default: false
    t.boolean "preferred", default: false
    t.boolean "valid_to_ship", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tags", default: [], array: true
    t.index ["geo_country_id", "geo_state_id"], name: "index_geo_addresses_on_geo_country_id_and_geo_state_id"
    t.index ["geo_country_id"], name: "index_geo_addresses_on_geo_country_id"
    t.index ["geo_state_id"], name: "index_geo_addresses_on_geo_state_id"
    t.index ["hash_code"], name: "index_geo_addresses_on_hash_code"
    t.index ["tags"], name: "index_geo_addresses_on_tags", using: :gin
    t.index ["user_id"], name: "index_geo_addresses_on_user_id"
  end

  create_table "geo_countries", force: :cascade do |t|
    t.string "name"
    t.string "abbrev"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "bill_to", default: true
    t.boolean "ship_to", default: true
  end

  create_table "geo_states", force: :cascade do |t|
    t.bigint "geo_country_id"
    t.string "name"
    t.string "abbrev"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["geo_country_id"], name: "index_geo_states_on_geo_country_id"
  end

  create_table "identifiers", force: :cascade do |t|
    t.string "parent_obj_type"
    t.bigint "parent_obj_id"
    t.string "provider"
    t.string "label"
    t.string "identifier"
    t.hstore "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier", "provider", "label"], name: "index_identifiers_on_identifier_and_provider_and_label", unique: true
    t.index ["parent_obj_type", "parent_obj_id"], name: "index_identifiers_on_parent_obj_type_and_parent_obj_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.bigint "recipe_id"
    t.bigint "food_id"
    t.string "amount"
    t.string "unit"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_ingredients_on_food_id"
    t.index ["recipe_id"], name: "index_ingredients_on_recipe_id"
  end

  create_table "oauth_credentials", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "provider"
    t.string "uid"
    t.string "token"
    t.string "refresh_token"
    t.string "secret"
    t.datetime "expires_at"
    t.integer "status", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider"], name: "index_oauth_credentials_on_provider"
    t.index ["secret"], name: "index_oauth_credentials_on_secret"
    t.index ["token"], name: "index_oauth_credentials_on_token"
    t.index ["uid"], name: "index_oauth_credentials_on_uid"
    t.index ["user_id"], name: "index_oauth_credentials_on_user_id"
  end

  create_table "pulitzer_categories", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "parent_id"
    t.string "name"
    t.string "type"
    t.integer "lft"
    t.integer "rgt"
    t.text "description"
    t.string "avatar"
    t.string "cover_image"
    t.integer "status", default: 1
    t.integer "availability", default: 1
    t.integer "seq"
    t.string "slug"
    t.hstore "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lft"], name: "index_pulitzer_categories_on_lft"
    t.index ["parent_id"], name: "index_pulitzer_categories_on_parent_id"
    t.index ["rgt"], name: "index_pulitzer_categories_on_rgt"
    t.index ["slug"], name: "index_pulitzer_categories_on_slug", unique: true
    t.index ["type"], name: "index_pulitzer_categories_on_type"
    t.index ["user_id"], name: "index_pulitzer_categories_on_user_id"
  end

  create_table "pulitzer_media", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "managed_by_id"
    t.string "public_id"
    t.bigint "category_id"
    t.bigint "working_media_version_id"
    t.bigint "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.string "type"
    t.string "media_type"
    t.string "sub_type"
    t.string "title"
    t.string "subtitle"
    t.text "avatar"
    t.string "cover_image"
    t.string "avatar_caption"
    t.string "layout"
    t.string "template"
    t.text "description"
    t.text "meta_description"
    t.text "content"
    t.string "slug"
    t.string "redirect_url"
    t.boolean "is_commentable", default: true
    t.boolean "is_sticky", default: false
    t.boolean "show_title", default: true
    t.datetime "modified_at"
    t.text "keywords", default: [], array: true
    t.text "tags", default: [], array: true
    t.string "duration"
    t.integer "cached_char_count", default: 0
    t.integer "cached_word_count", default: 0
    t.integer "status", default: 1
    t.integer "availability", default: 1
    t.datetime "publish_at"
    t.hstore "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_pulitzer_media_on_category_id"
    t.index ["managed_by_id"], name: "index_pulitzer_media_on_managed_by_id"
    t.index ["parent_id"], name: "index_pulitzer_media_on_parent_id"
    t.index ["public_id"], name: "index_pulitzer_media_on_public_id"
    t.index ["slug", "type"], name: "index_pulitzer_media_on_slug_and_type"
    t.index ["slug"], name: "index_pulitzer_media_on_slug", unique: true
    t.index ["status", "availability"], name: "index_pulitzer_media_on_status_and_availability"
    t.index ["tags"], name: "index_pulitzer_media_on_tags", using: :gin
    t.index ["user_id"], name: "index_pulitzer_media_on_user_id"
    t.index ["working_media_version_id"], name: "index_pulitzer_media_on_working_media_version_id"
  end

  create_table "pulitzer_media_versions", force: :cascade do |t|
    t.bigint "media_id"
    t.bigint "user_id"
    t.integer "status", default: 1
    t.json "versioned_attributes", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["media_id", "id"], name: "index_pulitzer_media_versions_on_media_id_and_id"
    t.index ["media_id", "status", "id"], name: "index_pulitzer_media_versions_on_media_id_and_status_and_id"
    t.index ["media_id"], name: "index_pulitzer_media_versions_on_media_id"
    t.index ["user_id"], name: "index_pulitzer_media_versions_on_user_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.bigint "category_id"
    t.string "title"
    t.string "description"
    t.text "content"
    t.text "avatar"
    t.text "cover_image"
    t.string "slug"
    t.string "prep_time"
    t.string "cook_time"
    t.string "serves"
    t.string "nutrition"
    t.text "tags", default: [], array: true
    t.integer "status", default: 0
    t.datetime "publish_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_recipes_on_category_id"
    t.index ["slug"], name: "index_recipes_on_slug", unique: true
    t.index ["tags"], name: "index_recipes_on_tags", using: :gin
  end

  create_table "scuttlebutt_messages", force: :cascade do |t|
    t.bigint "recipient_id"
    t.bigint "sender_id"
    t.string "title"
    t.text "content"
    t.integer "status", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id", "status"], name: "index_scuttlebutt_messages_on_recipient_id_and_status"
    t.index ["recipient_id"], name: "index_scuttlebutt_messages_on_recipient_id"
    t.index ["sender_id"], name: "index_scuttlebutt_messages_on_sender_id"
  end

  create_table "scuttlebutt_notifications", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "actor_id"
    t.string "parent_obj_type"
    t.bigint "parent_obj_id"
    t.string "activity_obj_type"
    t.bigint "activity_obj_id"
    t.string "title"
    t.text "content"
    t.integer "status", default: 1
    t.integer "parent_id"
    t.integer "lft", null: false
    t.integer "rgt", null: false
    t.integer "seq"
    t.integer "children_count", default: 0, null: false
    t.string "action"
    t.datetime "publish_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action", "children_count", "status", "created_at"], name: "idx_notifications_action_count_status"
    t.index ["action", "children_count", "status", "parent_obj_type", "created_at", "parent_obj_id"], name: "idx_notifications_action_count_status_parent_obj"
    t.index ["activity_obj_id", "activity_obj_type", "user_id", "parent_obj_id", "parent_obj_type"], name: "idx_notifications_on_activity"
    t.index ["activity_obj_type", "activity_obj_id"], name: "idx_notifications_on_act_obj"
    t.index ["actor_id"], name: "index_scuttlebutt_notifications_on_actor_id"
    t.index ["lft"], name: "index_scuttlebutt_notifications_on_lft"
    t.index ["parent_id"], name: "index_scuttlebutt_notifications_on_parent_id"
    t.index ["parent_obj_type", "parent_obj_id"], name: "idx_notifications_on_par_obj"
    t.index ["rgt"], name: "index_scuttlebutt_notifications_on_rgt"
    t.index ["user_id", "action", "children_count", "status", "created_at"], name: "idx_notifications_user_action_count_status"
    t.index ["user_id", "action", "children_count", "status", "parent_obj_type", "created_at", "parent_obj_id"], name: "idx_notifications_user_action_count_status_parent_obj"
    t.index ["user_id", "created_at", "status"], name: "idx_notifications_on_user"
    t.index ["user_id", "parent_obj_id", "parent_obj_type"], name: "idx_notifications_on_parent"
    t.index ["user_id"], name: "index_scuttlebutt_notifications_on_user_id"
  end

  create_table "scuttlebutt_posts", force: :cascade do |t|
    t.bigint "user_id"
    t.string "parent_obj_type"
    t.bigint "parent_obj_id"
    t.bigint "reply_to_id"
    t.integer "lft"
    t.integer "rgt"
    t.string "type"
    t.string "slug"
    t.string "subject"
    t.text "content"
    t.integer "rating"
    t.boolean "sticky", default: false
    t.integer "seq"
    t.bigint "cached_vote_count", default: 0
    t.float "cached_vote_score", default: 0.0
    t.bigint "cached_upvote_count", default: 0
    t.bigint "cached_downvote_count", default: 0
    t.integer "cached_subscribe_count", default: 0
    t.integer "cached_impression_count", default: 0
    t.float "computed_score", default: 0.0
    t.integer "status", default: 1
    t.integer "availability", default: 1
    t.datetime "modified_at"
    t.hstore "properties"
    t.string "tags", default: [], array: true
    t.string "mentions", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at", "mentions"], name: "index_scuttlebutt_posts_on_created_at_and_mentions"
    t.index ["mentions"], name: "index_scuttlebutt_posts_on_mentions", using: :gin
    t.index ["parent_obj_type", "parent_obj_id"], name: "idx_posts_on_par_obj"
    t.index ["reply_to_id"], name: "index_scuttlebutt_posts_on_reply_to_id"
    t.index ["slug"], name: "index_scuttlebutt_posts_on_slug", unique: true
    t.index ["tags"], name: "index_scuttlebutt_posts_on_tags", using: :gin
    t.index ["updated_at", "mentions"], name: "index_scuttlebutt_posts_on_updated_at_and_mentions"
    t.index ["user_id", "parent_obj_id", "parent_obj_type"], name: "idx_user_posts_on_parent"
    t.index ["user_id"], name: "index_scuttlebutt_posts_on_user_id"
  end

  create_table "scuttlebutt_subscriptions", force: :cascade do |t|
    t.bigint "user_id"
    t.string "parent_obj_type"
    t.bigint "parent_obj_id"
    t.bigint "category_id"
    t.string "format", default: "site"
    t.text "notification_contexts", default: [], array: true
    t.integer "status", default: 1
    t.integer "availability", default: 1
    t.hstore "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_scuttlebutt_subscriptions_on_category_id"
    t.index ["parent_obj_type", "parent_obj_id"], name: "idx_subs_on_par_obj"
    t.index ["user_id", "parent_obj_id", "parent_obj_type"], name: "idx_subs_on_parent"
    t.index ["user_id"], name: "index_scuttlebutt_subscriptions_on_user_id"
  end

  create_table "scuttlebutt_votes", force: :cascade do |t|
    t.string "parent_obj_type"
    t.bigint "parent_obj_id"
    t.bigint "user_id"
    t.integer "val", default: 0
    t.string "vote_type"
    t.string "context", default: "vote"
    t.text "content"
    t.hstore "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_obj_id", "parent_obj_type", "context"], name: "idx_votes_on_parent_context"
    t.index ["parent_obj_type", "parent_obj_id"], name: "idx_votes_on_par_obj"
    t.index ["user_id", "context"], name: "idx_votes_on_user_context"
    t.index ["user_id", "parent_obj_id", "parent_obj_type"], name: "idx_votes_on_parent"
    t.index ["user_id"], name: "index_scuttlebutt_votes_on_user_id"
  end

  create_table "socratic_prompts", force: :cascade do |t|
    t.bigint "question_id"
    t.string "prompt_ui"
    t.text "content"
    t.integer "seq"
    t.integer "value"
    t.boolean "is_correct"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id", "seq"], name: "index_socratic_prompts_on_question_id_and_seq"
    t.index ["question_id"], name: "index_socratic_prompts_on_question_id"
  end

  create_table "socratic_questions", force: :cascade do |t|
    t.bigint "survey_id"
    t.string "title"
    t.text "content"
    t.string "question_ui", default: "text_box"
    t.integer "seq"
    t.boolean "is_required"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id", "seq"], name: "index_socratic_questions_on_survey_id_and_seq"
    t.index ["survey_id", "slug"], name: "index_socratic_questions_on_survey_id_and_slug"
    t.index ["survey_id"], name: "index_socratic_questions_on_survey_id"
  end

  create_table "socratic_responses", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "surveying_id"
    t.bigint "question_id"
    t.bigint "prompt_id"
    t.text "content"
    t.text "notes"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prompt_id"], name: "index_socratic_responses_on_prompt_id"
    t.index ["question_id"], name: "index_socratic_responses_on_question_id"
    t.index ["surveying_id"], name: "index_socratic_responses_on_surveying_id"
    t.index ["user_id", "surveying_id", "question_id", "prompt_id"], name: "responses_full_idx"
    t.index ["user_id"], name: "index_socratic_responses_on_user_id"
  end

  create_table "socratic_surveyings", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "survey_id"
    t.bigint "current_question_id"
    t.bigint "furthest_question_id"
    t.integer "score"
    t.text "notes"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["current_question_id"], name: "index_socratic_surveyings_on_current_question_id"
    t.index ["furthest_question_id"], name: "index_socratic_surveyings_on_furthest_question_id"
    t.index ["survey_id"], name: "index_socratic_surveyings_on_survey_id"
    t.index ["user_id", "survey_id"], name: "index_socratic_surveyings_on_user_id_and_survey_id"
    t.index ["user_id"], name: "index_socratic_surveyings_on_user_id"
  end

  create_table "socratic_surveys", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "survey_type"
    t.integer "status", default: 1
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_socratic_surveys_on_slug"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "slug"
    t.string "first_name"
    t.string "last_name"
    t.string "avatar"
    t.datetime "dob"
    t.string "gender"
    t.integer "status", default: 1
    t.integer "role", default: 1
    t.integer "level", default: 1
    t.string "website_url"
    t.text "bio"
    t.string "ip"
    t.string "ip_country"
    t.string "timezone", default: "Pacific Time (US & Canada)"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "password_hint"
    t.string "password_hint_response"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "authentication_token"
    t.text "tags", default: [], array: true
    t.hstore "properties", default: {}
    t.hstore "settings", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "wholesale_profile_id"
    t.integer "preferred_shipping_address_id"
    t.integer "preferred_billing_address_id"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username"
    t.index ["wholesale_profile_id", "status"], name: "index_users_on_wholesale_profile_id_and_status"
  end

end
