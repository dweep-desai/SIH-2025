import re

# Read the file
with open('lib/services/auth_service.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Find and preserve the faculty assignment print statement
faculty_assignment_pattern = r"print\('🎯 🎲 RANDOMLY ASSIGNED FACULTY: \$facultyName \(\$assignedFacultyId\)'\);"
faculty_assignment_match = re.search(faculty_assignment_pattern, content)

# Remove all print statements
content = re.sub(r"print\([^)]*\);\s*", "", content)

# Restore the faculty assignment print statement if it was found
if faculty_assignment_match:
    content = content.replace("print('🎯 🎲 RANDOMLY ASSIGNED FACULTY: $facultyName ($assignedFacultyId)');", faculty_assignment_match.group(0))

# Clean up multiple empty lines
content = re.sub(r'\n\s*\n\s*\n', '\n\n', content)

# Write the cleaned content back
with open('lib/services/auth_service.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print("Debug prints removed from auth_service.dart")
