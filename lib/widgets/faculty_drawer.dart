import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/semester_info_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/faculty_dashboard_page.dart';
import '../pages/grades_page.dart';
import '../pages/achievements_page.dart';
import '../pages/faculty_student_search_page.dart';
import '../pages/faculty_approval_page.dart';
import '../pages/faculty_approval_history_page.dart';
import '../pages/faculty_approval_analytics_page.dart';
import '../pages/faculty_edit_profile_page.dart';

// ---------------- GLOBAL DRAWER ----------------
class MainDrawer extends StatelessWidget {
  final BuildContext context;
  final bool isFaculty;

  const MainDrawer({super.key, required this.context, this.isFaculty = false});

  void _signOut() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _semInfo() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SemesterInfoPage()), 
    );
  }

  void _dashboard() {
    if (isFaculty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FacultyDashboardPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    }
  }

  void _studentSearch() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const FacultyStudentSearchPage()),
    );
  }

  void _approvalSection() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const FacultyApprovalPage()),
    );
  }

  void _grades() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const GradesPage()),
    );
  }
  
  void _achievements() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AchievementsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.indigoAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
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
                    "Welcome, Faculty!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
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
                if (!isFaculty) ...[
                  _buildDrawerItem(
                    icon: Icons.info,
                    title: "Semester Info",
                    onTap: _semInfo,
                  ),
                  _buildDrawerItem(
                    icon: Icons.grade,
                    title: "Grades",
                    onTap: _grades,
                  ),
                  _buildDrawerItem(
                    icon: Icons.workspace_premium,
                    title: "Achievements",
                    onTap: _achievements,
                  ),
                  _buildDrawerItem(
                    icon: Icons.search,
                    title: "Search Faculty",
                    onTap: () {},
                  ),
                ],
                if (isFaculty) ...[
                  _buildDrawerItem(
                    icon: Icons.edit,
                    title: "Edit Profile",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const FacultyEditProfilePage()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.search,
                    title: "Student Search",
                    onTap: _studentSearch,
                  ),
                  _buildDrawerItem(
                    icon: Icons.check_circle,
                    title: "Approval Section",
                    onTap: _approvalSection,
                  ),
                  _buildDrawerItem(
                    icon: Icons.history,
                    title: "Approval History",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const FacultyApprovalHistoryPage()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.analytics_outlined,
                    title: "Approval Analytics",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const FacultyApprovalAnalyticsPage()),
                      );
                    },
                  ),
                ],
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
