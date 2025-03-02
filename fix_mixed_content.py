import os
import re

specific_files = ["/var/www/html/ioquake3.js"]

patterns = [
    (
        r"var url = 'http://'\s*\+\s*root\s*\+\s*'/assets/'\s*\+\s*name;", 
        "var url = 'https://' + root + '/assets/' + name;"),
    (
        r"var url = 'http://'\s*\+\s*fs_cdn\s*\+\s*'/assets/manifest.json';",
        "var url = 'https://' + fs_cdn + '/assets/manifest.json';"),
    (
        r"var url = 'ws://'\s*\+\s*addr\s*\+\s*':'\s*\+\s*port;",
        "var protocol = (window.location.protocol === 'https:' ? 'wss://' : 'ws://');\nvar url = protocol + addr + ':' + port;"
    )
]

directories = ["build", "html"]

def process_js_file(file_path):
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()

        modified = False
        new_content = content

        for pattern, replacement in patterns:
            updated_content = re.sub(pattern, replacement, new_content)
            if updated_content != new_content:
                new_content = updated_content
                modified = True

        if modified:
            with open(file_path, "w", encoding="utf-8") as f:
                f.write(new_content)
            print(f"[MODIFIED] {file_path}")
        else:
            print(f"[NO CHANGES] {file_path}")
    except Exception as e:
        print(f"[ERROR] Failed to process {file_path}: {str(e)}")

def process_js_files_in_directory(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".js"):
                file_path = os.path.join(root, file)
                process_js_file(file_path)

if __name__ == "__main__":
    for file_path in specific_files:
        if os.path.exists(file_path):
            process_js_file(file_path)
        else:
            print(f"[WARNING] File not found: {file_path}")

    for directory in directories:
        if os.path.exists(directory):
            process_js_files_in_directory(directory)
        else:
            print(f"[WARNING] Directory not found: {directory}")

    print("\n[DONE] Replacement completed.")
