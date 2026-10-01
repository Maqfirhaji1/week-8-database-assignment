Capstone Walkthrough Presentation
Slide 1 — Project
Multi-Tenant SaaS Order Management System

A secure PostgreSQL-based order management platform with Redis caching.

Slide 2 — Problem

The system needs to support multiple independent tenants.

Each tenant manages:

Users

Customers

Products

Orders

Order items

The primary security requirement is preventing cross-tenant data access.

Slide 3 — Architecture

The system uses PostgreSQL as the durable source of truth and Redis as a supporting cache.

PostgreSQL provides transactions, relationships, RLS, auditing, indexes, and reporting.

Redis provides fast temporary access to frequently requested product information.

Slide 4 — Data Model

The main entities are:

Tenants

Users

Customers

Products

Orders

Order Items

Audit Log

Tenant-owned records contain tenant_id.

Foreign keys preserve relational integrity.

Slide 5 — Migrations

The schema is version controlled with Flyway:

V1 — Core tables
V2 — Indexes
V3 — Audit and triggers
V4 — Row-Level Security
V5 — Demo data


This allows the database to be recreated consistently from version-controlled SQL.

Slide 6 — Multi-Tenancy

The design uses shared PostgreSQL tables.

Tenant isolation is enforced using Row-Level Security.

The application establishes the tenant context for the current transaction, and RLS policies restrict rows to that tenant.

Slide 7 — NoSQL

Redis is used for product caching.

Example key:

tenant:{tenant_id}:product:{product_id}


Redis improves repeated read performance while PostgreSQL remains the source of truth.

Slide 8 — Optimization

Performance is measured using:

EXPLAIN (ANALYZE, BUFFERS)


Tenant-specific order queries use:

CREATE INDEX idx_orders_tenant_created
ON orders (tenant_id, created_at DESC);


JSONB product searches use a GIN index.

The final report contains the actual before-and-after measurements.

Slide 9 — Security

Security controls include:

Least-privilege roles

Row-Level Security

Tenant isolation

Password hashes

Audit logging

Parameterized queries

No application superuser

Slide 10 — Backup and Recovery

Backups use PostgreSQL custom format:

pg_dump -Fc -f backups/capstone_$(date +%F).dump capstone


The backup is inspected using pg_restore --list and restored into a separate test database.

Slide 11 — Testing

The project is tested for:

Migration success

Tenant isolation

Audit logging

Index usage

JSONB queries

Backup creation

Backup restoration

Redis fallback behavior

Slide 12 — Conclusion

The project demonstrates a complete database lifecycle from requirements and design through implementation, security, optimization, backup, recovery, and documentation.

The architecture keeps PostgreSQL responsible for durable transactional data while Redis provides a focused caching capability.