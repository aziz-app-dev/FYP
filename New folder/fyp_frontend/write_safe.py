import sys
import os

def write_file(path, content):
    with open(path, 'w', encoding='utf-8', newline='') as f:
        f.write(content)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python write_safe.py <path> <content_file>")
        sys.exit(1)
    
    path = sys.argv[1]
    content_file = sys.argv[2]
    
    with open(content_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    write_file(path, content)
    print(f"Successfully wrote to {path}")
