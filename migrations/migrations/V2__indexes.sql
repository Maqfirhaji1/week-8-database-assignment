CREATE INDEX idx_users_tenant
ON users (tenant_id);

CREATE INDEX idx_customers_tenant
ON customers (tenant_id);

CREATE INDEX idx_products_tenant
ON products (tenant_id);

CREATE INDEX idx_products_tenant_sku
ON products (tenant_id, sku);

CREATE INDEX idx_products_attributes
ON products USING GIN (attributes);

CREATE INDEX idx_orders_tenant_created
ON orders (tenant_id, created_at DESC);

CREATE INDEX idx_orders_tenant_status
ON orders (tenant_id, status);

CREATE INDEX idx_orders_customer
ON orders (tenant_id, customer_id, created_at DESC);

CREATE INDEX idx_order_items_order
ON order_items (tenant_id, order_id);

CREATE INDEX idx_order_items_product
ON order_items (tenant_id, product_id);

ANALYZE users;
ANALYZE customers;
ANALYZE products;
ANALYZE orders;
ANALYZE order_items;