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
      child: Column(
        children: [
<<<<<<< HEAD
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.indigoAccent],
=======
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade700, Colors.orange.shade500],
>>>>>>> main
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
<<<<<<< HEAD
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Smart Student Hub",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Welcome, Admin!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
=======
              child: Text(
                "Smart Student Hub - Admin",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
>>>>>>> main
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 10),
                _buildDrawerItem(
                  icon: Icons.dashboard,
                  title: "Dashboard",
                  onTap: _dashboard,
                ),
                _buildDrawerItem(
                  icon: Icons.analytics,
                  title: "Institute Analytics",
                  onTap: _instituteAnalytics,
                ),
                _buildDrawerItem(
                  icon: Icons.bar_chart,
                  title: "Departmentwise Analytics",
                  onTap: _departmentAnalytics,
                ),
                _buildDrawerItem(
                  icon: Icons.search,
                  title: "Faculty Search",
                  onTap: _facultySearch,
                ),
                _buildDrawerItem(
                  icon: Icons.search,
                  title: "Student Search",
                  onTap: _studentSearch,
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.lock_open,
                  title: "Sign Out",
                  onTap: _signOut,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.indigo),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    );
  }
}
