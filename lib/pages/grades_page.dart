import 'package:flutter/material.dart';
import '../widgets/student_drawer.dart';
import '../services/auth_service.dart';
import '../services/subject_mapping_service.dart';

// ---------------- GRADES PAGE ----------------
class GradesPage extends StatefulWidget {
  final int initialSemester; 

  const GradesPage({
    super.key,
    this.initialSemester = 1, // Default to Sem 1
  });

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  final AuthService _authService = AuthService();
  final SubjectMappingService _subjectMapping = SubjectMappingService();
  late int _selectedSemester;
  bool _isLoading = true;
  int _currentSemester = 1;

  @override
  void initState() {
    super.initState();
    _selectedSemester = widget.initialSemester;
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _subjectMapping.initializeMapping();
    await _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = _authService.getCurrentUser();
      if (userData != null) {
        setState(() {
          _currentSemester = userData['current_semester'] ?? 1;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Grades")),
        drawer: MainDrawer(context: context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Grades"),
      ),
      drawer: MainDrawer(context: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Semester Dropdown Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest, 
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedSemester,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down_rounded, color: colorScheme.primary, size: 30),
                  dropdownColor: colorScheme.surfaceContainerHighest,
                  style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
                  items: List.generate(_currentSemester - 1, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text("Semester ${index + 1}"),
                    );
                  }),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedSemester = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Grades content for the selected semester
            Expanded(
              child: SemGradesTab(semester: _selectedSemester, subjectMapping: _subjectMapping),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- CONTENT DISPLAY for Grades ----------------
class SemGradesTab extends StatelessWidget {
  final int semester;
  final SubjectMappingService subjectMapping;

  const SemGradesTab({super.key, required this.semester, required this.subjectMapping});

  // Convert numeric grade (1-10) to letter grade
  String _convertNumericToLetterGrade(int numericGrade) {
    if (numericGrade >= 9) return 'A+';
    if (numericGrade >= 8) return 'A';
    if (numericGrade >= 7) return 'B+';
    if (numericGrade >= 6) return 'B';
    if (numericGrade >= 5) return 'C+';
    if (numericGrade >= 4) return 'C';
    if (numericGrade >= 3) return 'D';
    if (numericGrade >= 2) return 'E';
    return 'F';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    // Get grades from Firebase data
    final AuthService authService = AuthService();
    final userData = authService.getCurrentUser();
    final semesterKey = 'sem$semester';
    final gradesData = userData?['grades']?[semesterKey] ?? {};
    
    if (gradesData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.grade_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              "No grades available for Semester $semester.",
              style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    // Convert grades data to list format
    final List<Map<String, dynamic>> grades = [];
    gradesData.forEach((courseCode, grade) {
      // Convert numeric grade to letter grade
      String letterGrade = _convertNumericToLetterGrade(grade as int);
      String subjectName = subjectMapping.getSubjectName(courseCode);
      
      grades.add({
        "courseCode": courseCode,
        "courseName": subjectName,
        "grade": letterGrade,
        "credits": 3, // Default credits, can be updated from courses data
      });
    });

    return ListView(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: colorScheme.surfaceContainerLow, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Icon(Icons.school_outlined, color: colorScheme.primary, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      "Grades - Semester $semester",
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface, 
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ...grades.map((g) => ListTile(
                title: Text(
                  g['courseName'].toString(), 
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Code: ${g['courseCode']}", 
                      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)
                    ),
                    Text(
                      "Credits: ${g['credits']}", 
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)
                    ),
                  ],
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    g['grade'].toString(),
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              )),
              const SizedBox(height: 8), 
            ],
          ),
        ),
      ],
    );
  }
}
