import 'package:flutter/material.dart';
import '../widgets/student_drawer.dart'; // Will be created

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
              Tab(icon: Icon(Icons.grade), text: "Grades"), // Assuming GradesTab will be here or imported
            ],
          ),
        ),
        drawer: MainDrawer(context: context),
        body: const TabBarView(
          children: [
            CoursesTab(),
            AttendanceTab(),
            GradesTab(), // Placeholder for now, might need its own file or be defined here
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
    final courses = [
      {"name": "Data Structures", "grade": "A", "credits": 4},
      {"name": "Operating Systems", "grade": "B+", "credits": 3},
      {"name": "Database Systems", "grade": "A-", "credits": 3},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(course["name"].toString()),
            subtitle: Text("Credits: ${course["credits"]}"),
            trailing: Text(
              course["grade"].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ),
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
    final List<Map<String, dynamic>> attendance = [
      {"course": "Data Structures", "present": 42, "total": 50},
      {"course": "Operating Systems", "present": 35, "total": 45},
      {"course": "Database Systems", "present": 40, "total": 50},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: attendance.length,
      itemBuilder: (context, index) {
        final course = attendance[index];
        final int present = course["present"] as int;
        final int total = course["total"] as int;
        final double percentage = present / total;

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(course["course"].toString()),
            subtitle: Text("Attendance: $present/$total"),
            trailing: Text(
              "${(percentage * 100).toStringAsFixed(1)}%",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: percentage >= 0.75 ? Colors.green : Colors.red,
              ),
            ),
          ),
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
