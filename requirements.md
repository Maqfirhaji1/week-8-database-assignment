Requirements Summary
Project

Multi-Tenant SaaS Order Management System

Objective

Build a secure and scalable order management database that supports multiple independent tenants while maintaining strong data isolation and transactional consistency.

Functional Requirements
Tenant Management

Store multiple organizations.

Each tenant has a unique identifier and name.

Tenant records include creation timestamps.

User Management

Users belong to a tenant.

Users have names, email addresses, password hashes, and roles.

Email addresses are unique within each tenant.

Customer Management

Tenants can create and manage customers.

Customers have names, email addresses, phone numbers, and timestamps.

Product Management

Tenants can manage products.

Products contain SKU, name, price, stock quantity, and timestamps.

Variable product attributes are stored as JSONB.

Order Management

Customers can create orders.

Orders belong to both a tenant and customer.

Orders contain status, total amount, and timestamps.

Order Items

Each order contains one or more products.

Order items record quantity, unit price, and subtotal.

Audit Logging

Critical changes to customers, products, and orders are automatically recorded.

Audit records include:

Tenant

Table

Operation

Old row

New row

Database user

Timestamp

Security Requirements

Tenant data must be isolated.

PostgreSQL Row-Level Security must be used.

Application roles must follow least privilege.

The application must not use a PostgreSQL superuser.

Passwords must be stored as hashes.

SQL statements must use parameterized queries.

Sensitive operations must be auditable.

Performance Requirements

The database must efficiently support:

Tenant-specific order history

Customer order history

Product lookup by SKU

Product JSONB attribute searches

Order status reporting

Indexes must be based on actual query patterns.

Reliability Requirements

PostgreSQL backups must be created.

Backups must be verified.

At least one backup must be restored into a separate test database.

The database should support WAL-based recovery when configured.

Technology Stack

PostgreSQL

Redis

Flyway

SQL

dbdiagram.io

Application layer using parameterized SQL

Success Criteria

The project is complete when:

The schema can be recreated using migrations.

Tenant isolation works through RLS.

Audit logging records critical changes.

Redis caching is documented.

Query optimization is demonstrated with actual EXPLAIN ANALYZE output.

Backup and restore procedures work.

Least-privilege security is configured.

The architecture and design decisions can be presented clearly.