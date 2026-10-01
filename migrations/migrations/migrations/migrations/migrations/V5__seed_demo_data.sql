INSERT INTO tenants (id, name)
VALUES
(
    '00000000-0000-0000-0000-000000000001',
    'Acme Store'
),
(
    '00000000-0000-0000-0000-000000000002',
    'Beta Store'
);

INSERT INTO users (
    tenant_id,
    full_name,
    email,
    password_hash,
    role
)
VALUES
(
    '00000000-0000-0000-0000-000000000001',
    'Amina Hassan',
    'amina@acme.example',
    '$2b$12$DEMO_HASH_REPLACE_IN_APPLICATION',
    'admin'
),
(
    '00000000-0000-0000-0000-000000000002',
    'Brian Otieno',
    'brian@beta.example',
    '$2b$12$DEMO_HASH_REPLACE_IN_APPLICATION',
    'admin'
);

INSERT INTO customers (
    id,
    tenant_id,
    full_name,
    email,
    phone
)
VALUES
(
    '10000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000001',
    'John Kamau',
    'john@example.com',
    '+254700000001'
),
(
    '10000000-0000-0000-0000-000000000002',
    '00000000-0000-0000-0000-000000000002',
    'Mary Wanjiku',
    'mary@example.com',
    '+254700000002'
);

INSERT INTO products (
    id,
    tenant_id,
    name,
    sku,
    price,
    stock_quantity,
    attributes
)
VALUES
(
    '20000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000001',
    'Laptop Pro',
    'ACME-LAP-001',
    125000.00,
    25,
    '{"category":"electronics","brand":"Acme","ram":"16GB"}'
),
(
    '20000000-0000-0000-0000-000000000002',
    '00000000-0000-0000-0000-000000000002',
    'Running Shoes',
    'BETA-SHOE-001',
    8500.00,
    100,
    '{"category":"clothing","brand":"Beta","size":"42","color":"black"}'
);

INSERT INTO orders (
    id,
    tenant_id,
    customer_id,
    status,
    total_amount
)
VALUES
(
    '30000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000001',
    '10000000-0000-0000-0000-000000000001',
    'paid',
    125000.00
);

INSERT INTO order_items (
    tenant_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    subtotal
)
VALUES
(
    '00000000-0000-0000-0000-000000000001',
    '30000000-0000-0000-0000-000000000001',
    '20000000-0000-0000-0000-000000000001',
    1,
    125000.00,
    125000.00
);