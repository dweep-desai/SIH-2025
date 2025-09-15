import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/semester_info_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/grades_page.dart';
import '../pages/achievements_page.dart';

// ---------------- GLOBAL DRAWER ----------------
class MainDrawer extends StatelessWidget {
  final BuildContext context;

  const MainDrawer({super.key, required this.context});

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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardPage()),
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
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Center(
              child: Text(
                "Smart Student Hub",
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
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("Semester Info"),
            onTap: _semInfo,
          ),
          ListTile(
            leading: const Icon(Icons.grade),
            title: const Text("Grades"),
            onTap: _grades,
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text("Achievements"),
            onTap: _achievements, // Added onTap for achievements
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text("Search Faculty"),
            onTap: () { /* TODO: Implement Search Faculty */ },
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
