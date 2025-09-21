import re

# Read the file
with open('lib/services/auth_service.dart', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# Keep only the faculty assignment print statement
cleaned_lines = []
for line in lines:
    if 'RANDOMLY ASSIGNED FACULTY' in line and 'print(' in line:
        cleaned_lines.append(line)
    elif 'print(' not in line:
        cleaned_lines.append(line)

# Write the cleaned content back
with open('lib/services/auth_service.dart', 'w', encoding='utf-8') as f:
    f.write(''.join(cleaned_lines))

print("All debug prints removed except faculty assignment")
