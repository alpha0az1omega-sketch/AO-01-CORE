#!/usr/bin/env python3
import json
import logging
from pathlib import Path
from datetime import datetime, timezone
import hashlib

# LE BON IMPORT POUR MCP 2.x
from mcp.server.fastmcp import FastMCP

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(name)s - %(levelname)s - %(message)s")
logger = logging.getLogger("AlphaMCP")

PROJECT_ROOT = Path(__file__).resolve().parents[2]
FOUNDATION_DIR = PROJECT_ROOT / "01_FOUNDATION"

mcp = FastMCP("alpha-sovereign")

@mcp.resource("alpha://registry")
def get_registry() -> str:
    path = FOUNDATION_DIR / "REGISTRE.md"
    return path.read_text(encoding="utf-8") if path.exists() else "Registry not found."

@mcp.resource("alpha://seal/latest")
def get_latest_seal() -> str:
    seals = sorted(FOUNDATION_DIR.glob("S*.md"), reverse=True)
    return seals[0].read_text(encoding="utf-8") if seals else "No seal found."

@mcp.resource("alpha://time")
def get_sovereign_time() -> str:
    now_utc = datetime.now(timezone.utc)
    now_local = datetime.now().astimezone()
    return f"UTC: {now_utc.isoformat()} | Local: {now_local.strftime('%Y-%m-%d %H:%M:%S %Z')}"

@mcp.tool()
def check_seal_integrity(seal_id: str) -> str:
    json_path = FOUNDATION_DIR / f"{seal_id}.json"
    md_path = FOUNDATION_DIR / f"{seal_id}.md"
    if not json_path.exists() or not md_path.exists():
        return f"Seal {seal_id} not found."
    actual_hash = hashlib.sha256(json_path.read_bytes()).hexdigest()
    md_content = md_path.read_text(encoding="utf-8")
    if actual_hash in md_content:
        return f"✅ Seal {seal_id} integrity VERIFIED. Hash: {actual_hash}"
    return f"❌ Seal {seal_id} integrity FAILED."

if __name__ == "__main__":
    logger.info("Starting Alpha MCP Server...")
    mcp.run(transport="stdio")
