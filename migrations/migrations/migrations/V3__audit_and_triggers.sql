CREATE TABLE audit_log (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tenant_id UUID,
    table_name TEXT NOT NULL,
    operation TEXT NOT NULL,
    old_row JSONB,
    new_row JSONB,
    changed_by TEXT NOT NULL DEFAULT current_user,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_audit_tenant_time
ON audit_log (tenant_id, changed_at DESC);

CREATE OR REPLACE FUNCTION write_audit_log()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    audit_tenant_id UUID;
BEGIN
    IF TG_OP = 'DELETE' THEN
        audit_tenant_id := OLD.tenant_id;
    ELSE
        audit_tenant_id := NEW.tenant_id;
    END IF;

    INSERT INTO audit_log (
        tenant_id,
        table_name,
        operation,
        old_row,
        new_row,
        changed_by
    )
    VALUES (
        audit_tenant_id,
        TG_TABLE_NAME,
        TG_OP,
        CASE
            WHEN TG_OP IN ('UPDATE', 'DELETE')
            THEN to_jsonb(OLD)
        END,
        CASE
            WHEN TG_OP IN ('INSERT', 'UPDATE')
            THEN to_jsonb(NEW)
        END,
        current_user
    );

    RETURN COALESCE(NEW, OLD);
END;
$$;

CREATE TRIGGER trg_customers_audit
AFTER INSERT OR UPDATE OR DELETE
ON customers
FOR EACH ROW
EXECUTE FUNCTION write_audit_log();

CREATE TRIGGER trg_products_audit
AFTER INSERT OR UPDATE OR DELETE
ON products
FOR EACH ROW
EXECUTE FUNCTION write_audit_log();

CREATE TRIGGER trg_orders_audit
AFTER INSERT OR UPDATE OR DELETE
ON orders
FOR EACH ROW
EXECUTE FUNCTION write_audit_log();