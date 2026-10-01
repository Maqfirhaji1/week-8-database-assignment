Query Optimization Evidence
Query 1 — Recent Tenant Orders
Query
EXPLAIN (ANALYZE, BUFFERS)
SELECT id,
       customer_id,
       status,
       total_amount,
       created_at
FROM orders
WHERE tenant_id = '00000000-0000-0000-0000-000000000001'
ORDER BY created_at DESC
LIMIT 50;

Before Plan

Run the query before adding the index and paste the real output below.

PASTE ACTUAL EXPLAIN ANALYZE OUTPUT HERE

Change

The following index was created:

CREATE INDEX idx_orders_tenant_created
ON orders (tenant_id, created_at DESC);


The index starts with tenant_id because tenant filtering is part of the query. The second column supports the requested descending timestamp order.

After Plan

Run:

EXPLAIN (ANALYZE, BUFFERS)
SELECT id,
       customer_id,
       status,
       total_amount,
       created_at
FROM orders
WHERE tenant_id = '00000000-0000-0000-0000-000000000001'
ORDER BY created_at DESC
LIMIT 50;


Paste the real output below.

PASTE ACTUAL EXPLAIN ANALYZE OUTPUT HERE

Result
Execution time:
BEFORE: [REAL VALUE]
AFTER:  [REAL VALUE]

Plan change:
[DESCRIBE THE ACTUAL PLAN CHANGE]

Query 2 — JSONB Product Search
Query
EXPLAIN (ANALYZE, BUFFERS)
SELECT id,
       name,
       sku,
       price
FROM products
WHERE tenant_id = '00000000-0000-0000-0000-000000000001'
  AND attributes @> '{"category":"electronics"}';

Before Plan

Paste the actual result:

PASTE ACTUAL EXPLAIN ANALYZE OUTPUT HERE

Change

A GIN index was added:

CREATE INDEX idx_products_attributes
ON products USING GIN (attributes);


GIN is appropriate for JSONB containment queries.

After Plan

Run:

EXPLAIN (ANALYZE, BUFFERS)
SELECT id,
       name,
       sku,
       price
FROM products
WHERE tenant_id = '00000000-0000-0000-0000-000000000001'
  AND attributes @> '{"category":"electronics"}';


Paste the actual result:

PASTE ACTUAL EXPLAIN ANALYZE OUTPUT HERE

Result
Execution time:
BEFORE: [REAL VALUE]
AFTER:  [REAL VALUE]

Plan change:
[DESCRIBE THE ACTUAL PLAN CHANGE]

Statistics

Statistics should be refreshed after significant data changes:

ANALYZE orders;
ANALYZE products;
ANALYZE customers;

Important

Performance numbers must come from the actual PostgreSQL environment.

Do not invent execution times or plan changes.