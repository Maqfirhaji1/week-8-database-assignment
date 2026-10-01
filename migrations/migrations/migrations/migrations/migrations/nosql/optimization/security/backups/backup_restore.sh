#!/bin/bash

set -euo pipefail

DATABASE="capstone"
BACKUP_DIR="backups"
DATE="$(date +%F)"
BACKUP_FILE="${BACKUP_DIR}/capstone_${DATE}.dump"

mkdir -p "$BACKUP_DIR"

echo "Creating PostgreSQL backup..."

pg_dump \
    -Fc \
    -f "$BACKUP_FILE" \
    "$DATABASE"

echo "Backup created:"
echo "$BACKUP_FILE"

echo
echo "Verifying backup contents..."

pg_restore \
    --list \
    "$BACKUP_FILE" \
    > "${BACKUP_FILE}.contents.txt"

echo "Backup verification completed."

echo
echo "Test restore commands:"
echo
echo "createdb capstone_restore_test"
echo "pg_restore -d capstone_restore_test \"$BACKUP_FILE\""
echo "psql -d capstone_restore_test -c '\dt'"