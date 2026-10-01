PLP Database Capstone — Multi-Tenant SaaS Order Management System
Project Overview

This project implements a multi-tenant SaaS order management system using PostgreSQL as the primary transactional database and Redis as a supporting cache.

The system manages tenants, users, customers, products, orders, and order items. PostgreSQL provides relational integrity, transactions, indexing, Row-Level Security, auditing, backup, and recovery capabilities.

Architecture
                 ┌──────────────────────┐
                 │     Application      │
                 └──────────┬───────────┘
                            │
               ┌────────────┴────────────┐
               │                         │
               ▼                         ▼
       ┌────────────────┐       ┌────────────────┐
       │   PostgreSQL   │       │     Redis      │
       │                │       │                │
       │ Transactions   │       │ Product Cache  │
       │ RLS            │       │ Fast Reads     │
       │ Audit Logs     │       │ TTL            │
       │ Reporting      │       │                │
       └────────────────┘       └────────────────┘


PostgreSQL remains the source of truth. Redis is used only for temporary caching.

Main Features

Multi-tenant database architecture

PostgreSQL Row-Level Security

Versioned Flyway migrations

Tenant-aware indexes

JSONB product attributes

GIN JSONB index

Trigger-based audit logging

Redis cache design

Least-privilege database roles

Backup and restore procedure

Query optimization using EXPLAIN ANALYZE

Database Entities

The primary entities are:

Tenants

Users

Customers

Products

Orders

Order Items

Audit Log

Tenant-owned tables contain a tenant_id column.

Migration Strategy

Schema changes are version controlled using Flyway.

V1__core_tables.sql
V2__indexes.sql
V3__audit_and_triggers.sql
V4__row_level_security.sql
V5__seed_demo_data.sql


A development database can be rebuilt using:

flyway clean migrate


flyway clean must never be used against production.

Multi-Tenancy

The application uses shared PostgreSQL tables with a tenant_id.

Tenant isolation is enforced with Row-Level Security rather than relying only on application filtering.

The application establishes the tenant context for a transaction before accessing tenant-owned data.

JSONB

Products have common typed fields such as name, SKU, price, and stock quantity.

Variable product attributes are stored in JSONB.

Example:

{
  "category": "electronics",
  "brand": "Acme",
  "ram": "16GB"
}


This allows different product types to store different attributes without creating hundreds of nullable columns.

Redis

Redis is used as a cache for frequently accessed product information.

Example key:

tenant:{tenant_id}:product:{product_id}


If Redis is unavailable, the application can fall back to PostgreSQL.

Performance

Indexes are designed around actual access patterns.

For example:

CREATE INDEX idx_orders_tenant_created
ON orders (tenant_id, created_at DESC);


This supports recent-order queries for a particular tenant.

The optimization directory contains actual EXPLAIN ANALYZE evidence.

Security

The project includes:

Least-privilege database roles

Row-Level Security

Tenant isolation

Password hash storage

Audit logging

Parameterized-query requirement

No application superuser

Restricted database privileges

No production credentials or secrets are stored in this repository.

Backup

The project includes a PostgreSQL backup script using the custom dump format:

pg_dump -Fc -f backups/capstone_$(date +%F).dump capstone


The backup can be inspected using:

pg_restore --list backups/capstone_YYYY-MM-DD.dump


A separate test database should be used to verify restoration.

Repository Structure
plp-database-capstone/
├── README.md
├── requirements.md
├── er_diagram.dbml
├── presentation.md
├── migrations/
│   ├── V1__core_tables.sql
│   ├── V2__indexes.sql
│   ├── V3__audit_and_triggers.sql
│   ├── V4__row_level_security.sql
│   └── V5__seed_demo_data.sql
├── nosql/
│   └── redis_design.md
├── optimization/
│   └── query_optimization.md
├── security/
│   └── security_artifacts.sql
└── backups/
    └── backup_restore.sh

Conclusion

The project demonstrates a complete database lifecycle from requirements and schema design through migrations, security, NoSQL integration, optimization, auditing, and backup/recovery.