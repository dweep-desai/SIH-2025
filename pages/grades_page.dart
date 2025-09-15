import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart'; // Will be created

// ---------------- GRADES PAGE ----------------
class GradesPage extends StatelessWidget {
  final int startTabIndex;
  final int currentSemester; 

  const GradesPage({
    super.key,
    this.startTabIndex = 0,
    this.currentSemester = 4, // Default or example value, adjust as needed
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: currentSemester,
      initialIndex: startTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Grades"),
          bottom: TabBar(
            isScrollable: true, 
            tabs: List.generate(
              currentSemester,
                  (index) => Tab(text: "Sem ${index + 1}"),
            ),
          ),
        ),
        drawer: MainDrawer(context: context),
        body: TabBarView(
          children: List.generate(
            currentSemester,
                (index) => SemGradesTab(semester: index + 1),
          ),
        ),
      ),
    );
  }
}

// ---------------- TAB CONTENT for GradesPage----------------
class SemGradesTab extends StatelessWidget {
  final int semester;

  const SemGradesTab({super.key, required this.semester});

  @override
  Widget build(BuildContext context) {
    // Mock grades - replace with real semester-specific data later
    final List<Map<String, dynamic>> grades = [
      {"course": "Sub 1", "grade": "A", "credits": 4},
      {"course": "Sub 2", "grade": "B+", "credits": 3},
      {"course": "Sub 3", "grade": "A-", "credits": 3},
      {"course": "Sub 4", "grade": "A", "credits": 3},
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
              ListTile(
                leading: const Icon(Icons.grade, color: Colors.indigo),
                title: Text("Grades - Semester $semester"),
              ),
              const Divider(height: 1),
              ...grades.map((g) => ListTile(
                title: Text(g['course'].toString()),
                trailing: Text(
                  g['grade'].toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}
