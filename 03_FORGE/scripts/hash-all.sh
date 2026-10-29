#!/bin/bash
echo "========================================="
echo "     ALPHA0AZ1OMEGA - MASTER HASH        "
echo "========================================="
TIMESTAMP=$(date -u +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="AO_CORE_PROOF_${TIMESTAMP}.tar.gz"
echo "[+] Archiving all files (excluding .git and sandbox)..."
tar --exclude='.git' --exclude='03_FORGE/sandbox' --exclude='.DS_Store' -czf "/tmp/${ARCHIVE_NAME}" .
echo "[+] Calculating SHA-256 Master Hash..."
HASH=$(shasum -a 256 "/tmp/${ARCHIVE_NAME}" | cut -d ' ' -f 1)
echo "---------------------------------------------------"
echo "PROOF OF AUTHORSHIP (For INPI / eIDAS deposition)"
echo "File: ${ARCHIVE_NAME}"
echo "Date (UTC): $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
echo "Author: Zacharie SYLLA (alpha0az1omega)"
echo "Master Hash: ${HASH}"
echo "---------------------------------------------------"
echo "[+] Archive saved in /tmp/${ARCHIVE_NAME}"
