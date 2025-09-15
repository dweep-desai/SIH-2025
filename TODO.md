# TODO: Modify Faculty Side Navigation

## Task: Remove student-related buttons from faculty side nav

### Current State:
- Faculty side nav shows both student and faculty options
- Student options: Semester Info, Grades, Achievements, Search Faculty
- Faculty options: Dashboard, Student Search, Approval Section, Sign Out

### Desired State:
- Faculty side nav should only show: Dashboard, Student Search, Approval Section, Sign Out
- Remove: Semester Info, Grades, Achievements, Search Faculty

### Steps:
1. ✅ Modify `lib/widgets/main_drawer.dart` to conditionally show student buttons only when `!isFaculty`
2. ✅ Wrap student-specific ListTiles in `if (!isFaculty) ...[]`
3. ✅ Test the changes by running the app and verifying faculty drawer

### Files to Edit:
- ✅ `lib/widgets/main_drawer.dart`

### Followup:
- ✅ Run the app to verify the faculty drawer only shows faculty-specific options
