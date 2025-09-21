import re

# Read the file
with open('lib/pages/student_edit_profile_page.dart', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# Remove all print statements
cleaned_lines = []
for line in lines:
    if 'print(' not in line:
        cleaned_lines.append(line)

# Write the cleaned content back
with open('lib/pages/student_edit_profile_page.dart', 'w', encoding='utf-8') as f:
    f.write(''.join(cleaned_lines))

print("All debug prints removed from student_edit_profile_page.dart")
