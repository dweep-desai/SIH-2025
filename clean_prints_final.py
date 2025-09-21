import re

# Read the file
with open('lib/services/auth_service.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Find and preserve the faculty assignment print statement
faculty_assignment_pattern = r"print\('🎯 🎲 RANDOMLY ASSIGNED FACULTY: \$facultyName \(\$assignedFacultyId\)'\);"
faculty_assignment_match = re.search(faculty_assignment_pattern, content)

if faculty_assignment_match:
    print("Found faculty assignment print statement")
    # Replace it with a placeholder first
    content = content.replace(faculty_assignment_match.group(0), "FACULTY_ASSIGNMENT_PRINT_PLACEHOLDER")
else:
    print("Faculty assignment print statement not found")

# Remove ALL print statements (including the ones that were missed)
content = re.sub(r"print\([^)]*\);\s*", "", content)

# Restore the faculty assignment print statement
if faculty_assignment_match:
    content = content.replace("FACULTY_ASSIGNMENT_PRINT_PLACEHOLDER", faculty_assignment_match.group(0))

# Clean up multiple empty lines
content = re.sub(r'\n\s*\n\s*\n', '\n\n', content)

# Write the cleaned content back
with open('lib/services/auth_service.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print("All debug prints removed from auth_service.dart except faculty assignment")
