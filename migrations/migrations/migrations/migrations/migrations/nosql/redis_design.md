Redis Integration
Purpose

Redis is used as a cache for frequently requested product information.

PostgreSQL remains the durable source of truth.

Why Redis?

Product data can be requested repeatedly by application users. Caching frequently accessed product records reduces unnecessary database reads and can reduce response latency.

Redis is appropriate because it provides fast in-memory access and supports expiration through TTL.

Key Design
tenant:{tenant_id}:product:{product_id}


Example:

tenant:00000000-0000-0000-0000-000000000001:product:20000000-0000-0000-0000-000000000001

Cache-Aside Pattern

Application checks Redis.

If data exists, return it.

If data does not exist, query PostgreSQL.

Store the result in Redis with a TTL.

Return the result to the caller.

Invalidation

When a product is updated or deleted, the corresponding Redis key should be invalidated.

Failure Handling

Redis is not the system of record.

If Redis becomes unavailable, the application falls back to PostgreSQL.

A Redis failure therefore affects cache performance rather than permanently affecting transactional data.

PostgreSQL vs Redis

PostgreSQL is responsible for:

Durable storage

Transactions

Foreign keys

Reporting

Security

Auditing

Redis is responsible for:

Temporary cached data

Fast repeated reads

TTL-based expiration

This separation keeps each technology focused on an appropriate workload.