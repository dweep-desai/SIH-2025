import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/admin_dashboard_page.dart';
import '../pages/admin_institute_analytics_page.dart';
import '../pages/admin_department_analytics_page.dart';
import '../pages/admin_faculty_search_page.dart';
import '../pages/admin_student_search_page.dart';

// ---------------- ADMIN DRAWER ----------------
class AdminDrawer extends StatelessWidget {
  final BuildContext context;

  const AdminDrawer({super.key, required this.context});

  void _signOut() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _dashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
    );
  }

  void _instituteAnalytics() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminInstituteAnalyticsPage()),
    );
  }

  void _departmentAnalytics() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminDepartmentAnalyticsPage()),
    );
  }

  void _facultySearch() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminFacultySearchPage()),
    );
  }

  void _studentSearch() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminStudentSearchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade700, Colors.orange.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Text(
                "Smart Student Hub - Admin",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: _dashboard,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text("Institute Analytics"),
            onTap: _instituteAnalytics,
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text("Departmentwise Analytics"),
            onTap: _departmentAnalytics,
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text("Faculty Search"),
            onTap: _facultySearch,
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text("Student Search"),
            onTap: _studentSearch,
          ),
          ListTile(
            leading: const Icon(Icons.lock_open),
            title: const Text("Sign Out"),
            onTap: _signOut,
          ),
        ],
      ),
    );
  }
}
