import 'package:flutter/material.dart';
import '../widgets/student_drawer.dart';
import '../services/auth_service.dart';

// ---------------- SEMESTER INFO PAGE ----------------
class SemesterInfoPage extends StatefulWidget {
  final int startTabIndex;

  const SemesterInfoPage({super.key, this.startTabIndex = 0});

  @override
  State<SemesterInfoPage> createState() => _SemesterInfoPageState();
}

class _SemesterInfoPageState extends State<SemesterInfoPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = _authService.getCurrentUser();
      if (userData != null) {
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Semester Info")),
        drawer: MainDrawer(context: context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: 2,
      initialIndex: widget.startTabIndex,
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
        body: TabBarView(
          children: [
            CoursesTab(userData: _userData),
            AttendanceTab(userData: _userData),
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
  final Map<String, dynamic>? userData;
  
  const CoursesTab({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    // Get current semester courses from Firebase data
    final currentSemester = userData?['current_semester'] ?? 1;
    final semesterKey = 'sem$currentSemester';
    final courses = userData?['courses']?[semesterKey] ?? [];
    
    if (courses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.book_outlined,
                size: 64,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'No courses found for Semester $currentSemester',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final courseString = courses[index] as String;
        final parts = courseString.split(' - ');
        final courseCode = parts.isNotEmpty ? parts[0] : courseString;
        final courseName = parts.length > 1 ? parts[1] : courseString;
        
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(courseName),
            subtitle: Text("Course Code: $courseCode"),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Ongoing',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.green.shade700,
                ),
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
  final Map<String, dynamic>? userData;
  
  const AttendanceTab({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    // Get attendance data from Firebase
    final attendance = userData?['attendance'] ?? 0;
    final currentSemester = userData?['current_semester'] ?? 1;
    final semesterKey = 'sem$currentSemester';
    final courses = userData?['courses']?[semesterKey] ?? [];
    
    if (courses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 64,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'No attendance data available',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final courseString = courses[index] as String;
        final parts = courseString.split(' - ');
        final courseName = parts.length > 1 ? parts[1] : courseString;
        
        // Calculate attendance for this course (simplified - using overall attendance)
        final double percentage = attendance / 100.0;
        final int present = (attendance * 0.8).round(); // Simulate course-specific attendance
        final int total = 100;

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(courseName),
            subtitle: Text("Attendance: $present/$total"),
            trailing: Text(
              "${percentage.toStringAsFixed(1)}%",
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
