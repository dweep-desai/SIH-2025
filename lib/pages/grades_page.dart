import 'package:flutter/material.dart';
import '../widgets/student_drawer.dart';

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
  late int _selectedSemester;
  final int totalSemesters = 7;
  final int currentSemester = 3; // TODO: replace with real current semester

  @override
  void initState() {
    super.initState();
    _selectedSemester = widget.initialSemester;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

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
                  items: List.generate(currentSemester - 1, (index) {
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
              child: SemGradesTab(semester: _selectedSemester),
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

  const SemGradesTab({super.key, required this.semester});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    // Mock grades - replace with real semester-specific data later
    final List<Map<String, dynamic>> grades = [
      {"course": "Subject A - Sem $semester", "grade": "A", "credits": 4},
      {"course": "Subject B - Sem $semester", "grade": "B+", "credits": 3},
      {"course": "Subject C - Sem $semester", "grade": "A-", "credits": 3},
      {"course": "Subject D - Sem $semester", "grade": "A", "credits": 3},
    ];

    if (grades.isEmpty) {
      return Center(
        child: Text(
          "No grades available for Semester $semester.",
          style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

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
                title: Text(g['course'].toString(), style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
                subtitle: Text("Credits: ${g['credits']}", style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
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
