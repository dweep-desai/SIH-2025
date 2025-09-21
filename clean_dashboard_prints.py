import re

# Read the file
with open('lib/pages/dashboard_page.dart', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# Remove all print statements
cleaned_lines = []
for line in lines:
    if 'print(' not in line:
        cleaned_lines.append(line)

# Write the cleaned content back
with open('lib/pages/dashboard_page.dart', 'w', encoding='utf-8') as f:
    f.write(''.join(cleaned_lines))

print("All debug prints removed from dashboard_page.dart")
