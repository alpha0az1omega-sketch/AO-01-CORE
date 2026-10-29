#!/usr/bin/env python3
import json
import urllib.request
import asyncio
import sys
import os
from datetime import datetime, timezone
from http.server import BaseHTTPRequestHandler, HTTPServer

try:
    from mcp import ClientSession, StdioServerParameters
    from mcp.client.stdio import stdio_client
    MCP_AVAILABLE = True
except ImportError:
    MCP_AVAILABLE = False

try:
    from pypdf import PdfReader
    PDF_AVAILABLE = True
except ImportError:
    PDF_AVAILABLE = False

class AlphaBrain(BaseHTTPRequestHandler):
    def do_POST(self):
        try:
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data.decode('utf-8'))
            user_message = data.get('message', '')

            # Valeurs par défaut
            memory_context = "Memory not loaded."
            univers_context = "Univers not loaded."
            time_context = f"UTC: {datetime.now(timezone.utc).isoformat()} | Local: {datetime.now().astimezone().strftime('%Y-%m-%d %H:%M:%S %Z')}"
            pdf_context = self.read_pdf_context()

            if MCP_AVAILABLE:
                loop = asyncio.new_event_loop()
                asyncio.set_event_loop(loop)
                try:
                    mem, uni, tim = loop.run_until_complete(self.fetch_mcp_context())
                    memory_context = mem
                    univers_context = uni
                    time_context = tim
                except Exception as e:
                    print(f"[MCP Warning] Fallback to local context. Error: {e}")
                finally:
                    loop.close()

            system_prompt = f"""YOUR PRIME DIRECTIVES (The Univers):
{univers_context}

YOUR MEMORY (Latest Seal):
{memory_context}

CURRENT REAL-TIME:
{time_context}

PDF CONTEXT (From the vault):
{pdf_context}

RULES:
1. Answer in English, precise and technical.
2. If asked for time, use CURRENT REAL-TIME.
3. If asked about the PDF, use PDF CONTEXT.
4. Address the user as "Creator" or "Zacharie".
5. Keep answers under 30 words.
"""

            ollama_url = "http://localhost:11434/api/generate"
            payload = {
                "model": "llama3.2:3b",
                "system": system_prompt,
                "prompt": user_message,
                "stream": False
            }

            req = urllib.request.Request(ollama_url, data=json.dumps(payload).encode('utf-8'), headers={'Content-Type': 'application/json'})
            with urllib.request.urlopen(req) as response:
                result = json.loads(response.read().decode('utf-8'))
                ai_response = result.get('response', 'Error generating response.')

                self.send_response(200)
                self.send_header('Content-Type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(json.dumps({"reply": ai_response}).encode('utf-8'))
                
        except Exception as e:
            # Filet de sécurité absolu : si ça plante, on renvoie l'erreur au chat au lieu de crasher
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps({"reply": f"Brain Error: {str(e)}"}).encode('utf-8'))

    def read_pdf_context(self):
        if not PDF_AVAILABLE:
            return "pypdf library not installed."
        pdf_dir = "AO-SECURE-VAULT"
        if os.path.exists(pdf_dir):
            for file in os.listdir(pdf_dir):
                if file.lower().endswith('.pdf'):
                    try:
                        reader = PdfReader(os.path.join(pdf_dir, file))
                        if len(reader.pages) > 0:
                            text = reader.pages[0].extract_text()
                            if text:
                                return f"Contenu du PDF '{file}' :\n" + text[:1000]
                    except Exception as e:
                        return f"Error reading PDF: {str(e)}"
        return "No PDF found."

    async def fetch_mcp_context(self):
        server_params = StdioServerParameters(
            command=sys.executable,
            args=["03_FORGE/mcp/alpha_mcp_server.py"],
            env=None
        )
        async with stdio_client(server_params) as (read, write):
            async with ClientSession(read, write) as session:
                await session.initialize()
                seal_res = await session.read_resource("alpha://seal/latest")
                reg_res = await session.read_resource("alpha://registry")
                time_res = await session.read_resource("alpha://time")
                return (seal_res.contents[0].text, reg_res.contents[0].text, time_res.contents[0].text)

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

if __name__ == '__main__':
    print("=========================================")
    print("   ALPHA SOVEREIGN AGENT - BULLETPROOF   ")
    print("=========================================")
    print("Listening on http://localhost:8001")
    server = HTTPServer(('localhost', 8001), AlphaBrain)
    server.serve_forever()
