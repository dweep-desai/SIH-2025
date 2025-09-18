import 'package:flutter/material.dart';
import '../widgets/student_drawer.dart';
import '../services/student_service.dart';

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
  int currentSemester = 1; // will be overridden from DB

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
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: StudentService.instance.getCurrentStudentStream(),
        builder: (context, snapshot) {
          final student = snapshot.data;
          final int dbCurrentSem = (student != null && student['currentSemester'] is int)
              ? student['currentSemester'] as int
              : currentSemester;
          final int maxSelectable = (dbCurrentSem - 1).clamp(0, 20);
          if (maxSelectable > 0 && _selectedSemester > maxSelectable) {
            // Ensure selected is within allowed range
            _selectedSemester = maxSelectable;
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest, 
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: maxSelectable == 0 ? null : _selectedSemester,
                      hint: const Text('No past semesters'),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down_rounded, color: colorScheme.primary, size: 30),
                      dropdownColor: colorScheme.surfaceContainerHighest,
                      style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
                      items: List.generate(maxSelectable, (index) {
                        return DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text("Semester ${index + 1}"),
                        );
                      }),
                      onChanged: maxSelectable == 0
                          ? null
                          : (int? newValue) {
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
                Expanded(
                  child: maxSelectable == 0
                      ? Center(
                          child: Text(
                            'No grades available yet.',
                            style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        )
                      : SemGradesTab(semester: _selectedSemester),
                ),
              ],
            ),
          );
        },
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

    return StreamBuilder<Map<String, dynamic>?>(
      stream: StudentService.instance.getCurrentStudentStream(),
      builder: (context, snapshot) {
        final student = snapshot.data;
        final String? studentId = student?["studentId"] as String?;
        if (studentId == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return FutureBuilder<Map<String, String>>(
          future: StudentService.instance.getGradesForSemester(studentId, semester),
          builder: (context, snap) {
            final grades = snap.data ?? const {};
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
                      ...grades.entries.map((entry) => ListTile(
                        title: Text(entry.key, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            entry.value,
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
          },
        );
      },
    );
  }
}
