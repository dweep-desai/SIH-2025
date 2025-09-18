import 'package:flutter/material.dart';
import '../widgets/student_drawer.dart'; // Will be created
import '../services/student_service.dart';

// ---------------- SEMESTER INFO PAGE ----------------
class SemesterInfoPage extends StatelessWidget {
  final int startTabIndex;

  const SemesterInfoPage({super.key, this.startTabIndex = 0});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: startTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Semester Info"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.book), text: "Courses"),
              Tab(icon: Icon(Icons.check_circle), text: "Attendance"),
            ],
          ),
        ),
        drawer: MainDrawer(context: context),
        body: const TabBarView(
          children: [
            CoursesTab(),
            AttendanceTab(),
          ],
        ),
      ),
    );
  }
}

// ---------------- SEMESTER OVERVIEW TAB ----------------
class SemesterOverviewTab extends StatelessWidget {
  const SemesterOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    double progress = 90 / 120; // Example credits

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Semester: 5",
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text("GPA: 8.3",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 16),
                  Text("Credits Completed: 90 / 120"),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- COURSES TAB ----------------
class CoursesTab extends StatelessWidget {
  const CoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: StudentService.instance.getCurrentStudentStream(),
      builder: (context, snapshot) {
        final student = snapshot.data;
        final String? studentId = student?["studentId"] as String?;
        final int currentSem = (student != null && student["currentSemester"] is int)
            ? student["currentSemester"] as int
            : 1;
        if (studentId == null) {
          return const Center(child: CircularProgressIndicator());
        }
        // Prefer inline student snapshot when available to avoid an extra roundtrip
        final dynamic inlineCoursesMap = student?['courses'];
        if (inlineCoursesMap is Map) {
          final String semKey = currentSem.toString();
          final dynamic inlineCourses = inlineCoursesMap[semKey];
          if (inlineCourses is List && inlineCourses.isNotEmpty) {
            final List<dynamic> courses = inlineCourses;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                final String name = course is String ? course : course.toString();
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(name),
                    trailing: const Text('-', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                  ),
                );
              },
            );
          }
        }
        // Fallback to service resolver (nearest previous or grades-derived)
        return FutureBuilder<List<dynamic>>(
          future: StudentService.instance.getCoursesForSemester(studentId, currentSem),
          builder: (context, snap) {
            final courses = snap.data ?? const [];
            if (courses.isEmpty) {
              return const Center(child: Text('No courses found for current semester.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                String name;
                dynamic gradeVal;
                dynamic creditsVal;
                if (course is Map && course['name'] != null) {
                  name = course['name'].toString();
                  gradeVal = course['grade'];
                  creditsVal = course['credits'];
                } else {
                  name = course.toString();
                }
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(name),
                    subtitle: Text('Credits: ${creditsVal ?? '-'}'),
                    trailing: Text(
                      (gradeVal ?? '-').toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

// ---------------- ATTENDANCE TAB ----------------
class AttendanceTab extends StatelessWidget {
  const AttendanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: StudentService.instance.getCurrentStudentStream(),
      builder: (context, snapshot) {
        final student = snapshot.data;
        final String? studentId = student?["studentId"] as String?;
        if (studentId == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return FutureBuilder<double>(
          future: StudentService.instance.getAttendancePercent(studentId),
          builder: (context, snap) {
            final double pct = (snap.data ?? 0.0).clamp(0.0, 1.0);
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: const Text('Overall Attendance'),
                    subtitle: const Text('All courses combined'),
                    trailing: Text(
                      '${(pct * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: pct >= 0.75 ? Colors.green : Colors.red,
                      ),
                    ),
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

// --------------- GRADES TAB (from SemesterInfo) -------------------
//This is the GradesTab that was part of SemesterInfoPage in main.dart
class GradesTab extends StatelessWidget {
  const GradesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> grades = [
      {"course": "Data Structures", "grade": "A", "credits": 4},
      {"course": "Operating Systems", "grade": "B+", "credits": 3},
      {"course": "Database Systems", "grade": "A-", "credits": 3},
      {"course": "Software Engineering", "grade": "A", "credits": 3},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ListTile(
                leading: Icon(Icons.grade, color: Colors.indigo),
                title: Text("Grades"),
              ),
              const Divider(height: 1),
              ...grades.map((g) => ListTile(
                title: Text(g['course'].toString()),
                trailing: Text(
                  g['grade'].toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}
