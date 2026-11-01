import ollama
import subprocess
import os
import re

IDENTITY_SEAL = """
You are Alpha, the sovereign agent of the AO-01-CORE project.
You are an expert Python developer.
You reply ONLY with Python code. No text, no Markdown, no asterisks (**).
"""

def call_ai(role, task):
    print(f"\n🧠 [Agent {role}] Thinking...")
    try:
        response = ollama.chat(
            model='llama3.2:3b',
            messages=[
                {'role': 'system', 'content': IDENTITY_SEAL},
                {'role': 'user', 'content': f"Role: {role}\nTask: {task}"}
            ],
            options={'temperature': 0.0} # Zero creativity, we want pure code
        )
        return response['message']['content']
    except Exception as e:
        print(f"❌ Error with Ollama: {e}")
        return None

def clean_code(raw_code):
    """Removes all Markdown artifacts that the AI adds"""
    # 1. Remove Markdown code blocks
    code = re.sub(r'```python', '', raw_code)
    code = re.sub(r'```', '', code)
    # 2. Remove formatting asterisks (**)
    code = code.replace("**", "")
    # 3. Remove lines starting with a hash (titles), except shebangs
    lines = code.split('\n')
    clean_lines = [l for l in lines if not l.strip().startswith('#') or l.strip().startswith('#!')]
    return '\n'.join(clean_lines).strip()

def execute_secure_code(python_code, filename="test_sandbox.py"):
    os.makedirs("sandbox", exist_ok=True)
    filepath = os.path.join("sandbox", filename)
    
    clean_code_str = clean_code(python_code)
    
    with open(filepath, "w") as f:
        f.write(clean_code_str)
        
    print(f"⚙️ Testing generated code in {filepath}...")
    try:
        result = subprocess.run(["python3", filepath], capture_output=True, text=True, timeout=20)
        if result.returncode == 0:
            return True, result.stdout, clean_code_str
        else:
            return False, result.stderr, clean_code_str
    except Exception as e:
        return False, str(e), clean_code_str

def export_to_github(final_code, final_filename):
    export_folder = "03_FORGE/generated_artifacts"
    os.makedirs(export_folder, exist_ok=True)
    export_path = os.path.join(export_folder, final_filename)
    with open(export_path, "w") as f:
        f.write(final_code)
    print(f"\n📦 FILE READY: '{export_path}'")
    print("👉 GO TO GITHUB (Browser) -> Upload files")

def autonomous_loop(objective, final_filename):
    print(f"🎯 OBJECTIVE LAUNCHED: {objective}")
    
    plan = call_ai("Planner", f"Technical plan for: {objective}")
    if not plan: return
    
    coder_prompt = f"""Write the Python script for: {plan}.
STRICT RULES:
1. No text before or after the code.
2. No ** or #.
3. Use import hashlib for SHA-256.
4. All strings must be in quotes."""
    
    code = call_ai("Coder", coder_prompt)
    if not code: return
    
    success, result, clean_code_str = execute_secure_code(code)
    
    if success:
        print("✅ SUCCESS: The code works perfectly!")
        print("--- OUTPUT ---")
        print(result)
        export_to_github(clean_code_str, final_filename)
    else:
        print("❌ FAILURE: The code crashed. The AI is attempting to fix it...")
        print(f"Error: {result}")
        
        corrector_prompt = f"""Failed Python code:
{clean_code_str}

Python Error:
{result}

Provide ONLY the corrected code. No text. No **. No #."""
        
        correction = call_ai("Corrector", corrector_prompt)
        if correction:
            success2, result2, clean_code_str2 = execute_secure_code(correction, "test_sandbox_corrected.py")
            if success2:
                print("✅ SUCCESS AFTER CORRECTION!")
                print(result2)
                export_to_github(clean_code_str2, final_filename)
            else:
                print("❌ The AI failed. The 3b model is too small to code.")
                print("💡 TIP: Download a coding model like 'qwen2.5-coder' with the command: ollama run qwen2.5-coder")

if __name__ == "__main__":
    print("=========================================")
    print("   META-ORCHESTRATOR AO-01-CORE (ALPHA)  ")
    print("=========================================")
    user_objective = input("\n> What should the AI do today? : ")
    filename = input("> What name for the final file (e.g., my_script.py)? : ")
    if user_objective.strip() and filename.strip():
        autonomous_loop(user_objective, filename)
