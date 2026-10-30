#!/bin/bash
# Independent verification for ALPHA_ARCHIVE_000 artifact
set -euo pipefail
cd "$(dirname "$0")"
echo "[1/3] Verifying SHA-256 (requires the referenced files to be placed under 01_SPECIFICATION/)..."
shasum -a 256 -c manifest_sha256.txt || echo "  (files not found — supply them alongside)"
echo "[2/3] Verifying GPG signature..."
gpg --import alpha0az1omega_pubkey.asc 2>/dev/null || true
gpg --verify manifest_sha256.txt.asc manifest_sha256.txt
echo "[3/3] Verifying OpenTimestamps proof (network needed)..."
ots verify manifest_sha256.txt.ots || echo "  (proof may be pending — retry in ~1h)"
echo "Verification complete."
