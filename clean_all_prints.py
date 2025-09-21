import os
import re

def clean_file_prints(file_path):
    """Clean print statements from a file, keeping only faculty assignment prints"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        
        # Keep only faculty assignment print statements
        cleaned_lines = []
        for line in lines:
            if 'RANDOMLY ASSIGNED FACULTY' in line and 'print(' in line:
                cleaned_lines.append(line)
            elif 'print(' not in line:
                cleaned_lines.append(line)
        
        # Write the cleaned content back
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(''.join(cleaned_lines))
        
        print(f"Cleaned prints from {file_path}")
        return True
    except Exception as e:
        print(f"Error cleaning {file_path}: {e}")
        return False

# Find all Dart files in the lib directory
def find_dart_files(directory):
    dart_files = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                dart_files.append(os.path.join(root, file))
    return dart_files

# Clean all Dart files
dart_files = find_dart_files('lib')
cleaned_count = 0

for file_path in dart_files:
    if clean_file_prints(file_path):
        cleaned_count += 1

print(f"Cleaned {cleaned_count} files")
