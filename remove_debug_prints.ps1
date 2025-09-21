# PowerShell script to remove debug print statements except faculty assignment
$filePath = "lib\services\auth_service.dart"
$content = Get-Content $filePath -Raw

# Keep the faculty assignment print statement
$facultyAssignmentPattern = "print\('🎯 🎲 RANDOMLY ASSIGNED FACULTY: \$facultyName \(\$assignedFacultyId\)'\);"

# Remove all other print statements
$content = $content -replace "print\('[^']*'\);\s*", ""

# Restore the faculty assignment print statement
$content = $content -replace "print\('🎯 🎲 RANDOMLY ASSIGNED FACULTY: \$facultyName \(\$assignedFacultyId\)'\);", "print('🎯 🎲 RANDOMLY ASSIGNED FACULTY: `$facultyName (`$assignedFacultyId)');"

# Clean up empty lines
$content = $content -replace "(\r?\n){3,}", "`r`n`r`n"

Set-Content $filePath $content -NoNewline
Write-Host "Debug prints removed from auth_service.dart"
