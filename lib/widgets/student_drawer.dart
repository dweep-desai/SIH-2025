import 'dart:io';
import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/semester_info_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/grades_page.dart';
import '../pages/achievements_page.dart';
import '../pages/faculty_search_page.dart';
import '../pages/request_approval_page.dart';
import '../pages/approval_status_page.dart';
import '../services/auth_service.dart';

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

  void _searchFaculty() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const FacultySearchPage()),
    );
  }

  void _requestApproval() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RequestApprovalPage()),
    );
  }

  void _approvalStatus() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ApprovalStatusPage()),
    );
  }

  // Helper method to get appropriate image provider
  ImageProvider _getImageProvider(String imagePath) {
    print('🖼️ ==========================================');
    print('🖼️ STUDENT DRAWER _getImageProvider DEBUG');
    print('🖼️ ==========================================');
    print('🖼️ Input imagePath: "$imagePath"');
    print('🖼️ imagePath length: ${imagePath.length}');
    print('🖼️ startsWith http: ${imagePath.startsWith('http')}');
    print('🖼️ startsWith /: ${imagePath.startsWith('/')}');
    print('🖼️ startsWith C:: ${imagePath.startsWith('C:')}');
    
    ImageProvider provider;
    if (imagePath.startsWith('http')) {
      provider = NetworkImage(imagePath);
      print('🖼️ Using NetworkImage for HTTP URL');
    } else if (imagePath.startsWith('/') || imagePath.startsWith('C:')) {
      provider = FileImage(File(imagePath));
      print('🖼️ Using FileImage for local path');
    } else {
      provider = NetworkImage(imagePath);
      print('🖼️ Using NetworkImage as fallback');
    }
    
    print('🖼️ Provider type: ${provider.runtimeType}');
    print('🖼️ ==========================================');
    return provider;
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
                colors: [Colors.blue.shade800, Colors.blue.shade600],
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
                      
                      // Debug profile photo in drawer
                      print('🖼️ ==========================================');
                      print('🖼️ STUDENT DRAWER PROFILE PHOTO DEBUG');
                      print('🖼️ ==========================================');
                      print('🖼️ User Data: ${userData?['id']}');
                      print('🖼️ Profile Photo Raw: $profilePhoto');
                      print('🖼️ Profile Photo Type: ${profilePhoto.runtimeType}');
                      print('🖼️ Profile Photo isNull: ${profilePhoto == null}');
                      print('🖼️ Profile Photo isEmpty: ${profilePhoto.toString().isEmpty}');
                      print('🖼️ Profile Photo isNotEmpty: ${profilePhoto.toString().isNotEmpty}');
                      if (profilePhoto != null && profilePhoto.toString().isNotEmpty) {
                        print('🖼️ Profile Photo Value: "$profilePhoto"');
                        print('🖼️ Profile Photo Length: ${profilePhoto.toString().length}');
                      }
                      print('🖼️ ==========================================');
                      
                      return CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage: profilePhoto != null && profilePhoto.isNotEmpty
                            ? _getImageProvider(profilePhoto)
                            : null,
                        child: profilePhoto == null || profilePhoto.isEmpty
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
                      final name = userData?['name'] ?? 'Student Name';
                      return Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  Builder(
                    builder: (context) {
                      final userData = AuthService().getCurrentUser();
                      final email = userData?['email'] ?? 'student@university.edu';
                      return Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
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
                  title: "Student Record",
                  onTap: _achievements,
                ),
                // Removed Edit Profile from drawer as per new design
                _buildDrawerItem(
                  icon: Icons.search,
                  title: "Search Faculty",
                  onTap: _searchFaculty,
                ),
                _buildDrawerItem(
                  icon: Icons.assignment_turned_in,
                  title: "Request Approval",
                  onTap: _requestApproval,
                ),
                _buildDrawerItem(
                  icon: Icons.history,
                  title: "Approval Status",
                  onTap: _approvalStatus,
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
