import 'dart:io';
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
import '../data/approval_data.dart';
import '../services/auth_service.dart';

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

  // Helper method to get appropriate image provider
  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else if (imagePath.startsWith('/') || imagePath.startsWith('C:')) {
      return FileImage(File(imagePath));
    } else {
      return NetworkImage(imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade700, Colors.green.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Builder(
                    builder: (context) {
                      final userData = AuthService().getCurrentUser();
                      final profilePhoto = userData?['profile_photo'];
                      
                      return CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage: profilePhoto != null && profilePhoto.toString().isNotEmpty
                            ? _getImageProvider(profilePhoto.toString())
                            : null,
                        child: profilePhoto == null || profilePhoto.toString().isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.indigo,
                              )
                            : null,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Builder(
                    builder: (context) {
                      final userData = AuthService().getCurrentUser();
                      final userName = userData?['name'] ?? 'Faculty';
                      
                      return Column(
                        children: [
                          const Text(
                            "Smart Student Hub",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Welcome, $userName!",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      );
                    },
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
                  // Removed Edit Profile from drawer as per new design
                  _buildDrawerItem(
                    icon: Icons.search,
                    title: "Student Search",
                    onTap: _studentSearch,
                  ),
                  _buildApprovalWithBadge(
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

  Widget _buildApprovalWithBadge({
    required String title,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: approvalStats,
      builder: (context, _) {
        final int pending = approvalStats.pendingCount;
        return ListTile(
          leading: const Icon(Icons.check_circle, color: Colors.indigo),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (pending > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$pending',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        );
      },
    );
  }
}
