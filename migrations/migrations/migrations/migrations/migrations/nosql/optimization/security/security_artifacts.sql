-- ==========================================================
-- CAPSTONE DATABASE SECURITY ARTIFACTS
-- ==========================================================

-- Create non-superuser application roles.
CREATE ROLE app_read NOLOGIN;
CREATE ROLE app_write NOLOGIN;

-- Database connection privilege.
GRANT CONNECT ON DATABASE capstone
TO app_read, app_write;

-- Schema access.
GRANT USAGE ON SCHEMA public
TO app_read, app_write;

-- Read-only application access.
GRANT SELECT
ON ALL TABLES IN SCHEMA public
TO app_read;

-- Read/write application access.
GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA public
TO app_write;

-- Sequence access for identity/serial-backed objects.
GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA public
TO app_write;

-- Future tables.
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT
ON TABLES TO app_read;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE
ON TABLES TO app_write;

-- Future sequences.
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT USAGE, SELECT
ON SEQUENCES TO app_write;

-- Verify RLS configuration.
SELECT
    schemaname,
    tablename,
    rowsecurity,
    forcerowsecurity
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

-- Verify application privileges.
SELECT
    grantee,
    table_name,
    privilege_type
FROM information_schema.role_table_grants
WHERE grantee IN ('app_read', 'app_write')
ORDER BY grantee, table_name, privilege_type;