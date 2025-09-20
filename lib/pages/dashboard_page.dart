import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/student_drawer.dart';
import '../services/auth_service.dart';
import 'semester_info_page.dart';
import 'student_edit_profile_page.dart';
import 'achievements_page.dart';
import 'student_analytics_page.dart';

// ---------------- DASHBOARD PAGE ----------------
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  double _gpa = 0.0;
  List<Map<String, dynamic>> _topAchievements = [];

  // Method to refresh data from external calls
  void refreshData() {
    print('🔄 Dashboard refreshData called');
    _loadUserData();
  }


  // Method to force refresh data
  Future<void> _forceRefresh() async {
    print('🔄 Force refreshing dashboard data...');
    await _loadUserData();
  }


  // Method to fetch domains from student branch
  Future<void> _fetchDomainsFromStudentBranch() async {
    if (_userData != null) {
      print('🔄 Fetching domains from student branch...');
      final domains = await _authService.fetchDomainsFromStudentBranch(_userData!['id']);
      
      if (domains['domain1']!.isNotEmpty || domains['domain2']!.isNotEmpty) {
        setState(() {
          _userData!['domain1'] = domains['domain1'];
          _userData!['domain2'] = domains['domain2'];
        });
        print('✅ Domains updated from student branch');
        print('✅ Domain1: "${domains['domain1']}"');
        print('✅ Domain2: "${domains['domain2']}"');
      } else {
        print('❌ No domains found in student branch');
      }
    }
  }

  // Test method to submit an approval request
  Future<void> _testApprovalRequest() async {
    try {
      Map<String, dynamic> testRequest = {
        'title': 'Test Project - ${DateTime.now().millisecondsSinceEpoch}',
        'description': 'This is a test approval request to verify the system is working correctly.',
        'category': 'project',
        'link': 'https://example.com/test-project',
      };
      
      print('🧪 ==========================================');
      print('🧪 SUBMITTING TEST APPROVAL REQUEST');
      print('🧪 ==========================================');
      print('🧪 Student: ${_userData?['name']} (${_userData?['id']})');
      print('🧪 Department: ${_userData?['branch']}');
      print('🧪 Request: $testRequest');
      print('🧪 ==========================================');
      
      await _authService.submitApprovalRequest(testRequest);
      
      print('🧪 ==========================================');
      print('🧪 TEST REQUEST COMPLETED SUCCESSFULLY');
      print('🧪 ==========================================');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Test approval request submitted! Check console and faculty dashboard.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      print('❌ ==========================================');
      print('❌ ERROR SUBMITTING TEST REQUEST');
      print('❌ ==========================================');
      print('❌ Error: $e');
      print('❌ ==========================================');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting test request: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  // Test method to check faculty selection
  Future<void> _testFacultySelection() async {
    try {
      print('🔍 ==========================================');
      print('🔍 TESTING FACULTY SELECTION');
      print('🔍 ==========================================');
      print('🔍 Student Department: ${_userData?['branch']}');
      
      // This will trigger the faculty selection logic
      Map<String, dynamic> testRequest = {
        'title': 'Faculty Selection Test',
        'description': 'Testing faculty selection logic',
        'category': 'test',
        'link': 'https://example.com/test',
      };
      
      await _authService.submitApprovalRequest(testRequest);
      
      print('🔍 ==========================================');
      print('🔍 FACULTY SELECTION TEST COMPLETED');
      print('🔍 ==========================================');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Faculty selection test completed! Check console for details.'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      print('❌ Faculty selection test error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Faculty selection test error: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when returning from other pages
    print('🔄 Dashboard didChangeDependencies - refreshing data');
    _loadUserData();
  }


  Future<void> _loadUserData() async {
    try {
      // Force refresh user data directly from Firebase to get latest updates
      print('🔄 Dashboard _loadUserData - force refreshing from Firebase...');
      final userData = await _authService.forceRefreshUserData();
      if (userData != null) {
        // Safely cast the grades data
        Map<String, dynamic> grades = {};
        if (userData['grades'] != null) {
          try {
            grades = Map<String, dynamic>.from(userData['grades'] as Map<dynamic, dynamic>);
          } catch (e) {
            print('❌ Error casting grades: $e');
            grades = {};
          }
        }
        
        // Safely cast the student_record data
        Map<String, dynamic> studentRecord = {};
        if (userData['student_record'] != null) {
          try {
            studentRecord = Map<String, dynamic>.from(userData['student_record'] as Map<dynamic, dynamic>);
          } catch (e) {
            print('❌ Error casting student_record: $e');
            studentRecord = {};
          }
        }
        
        // Fetch domains from student branch if user is a student
        if (userData['category'] == 'student') {
          print('🔄 Fetching domains from student branch...');
          final domains = await _authService.fetchDomainsFromStudentBranch(userData['id']);
          userData['domain1'] = domains['domain1'];
          userData['domain2'] = domains['domain2'];
          print('✅ Domains fetched from student branch: ${domains}');
        }
        
        setState(() {
          _userData = userData;
          _gpa = _authService.calculateGPA(grades);
          _topAchievements = _getTopAchievements(studentRecord);
          _isLoading = false;
        });
        
        // Debug profile photo loading
        print('🖼️ ==========================================');
        print('🖼️ STUDENT DASHBOARD PROFILE PHOTO DEBUG');
        print('🖼️ ==========================================');
        print('🖼️ User ID: ${userData['id']}');
        print('🖼️ User Category: ${userData['category']}');
        print('🖼️ Profile Photo Raw: ${userData['profile_photo']}');
        print('🖼️ Profile Photo Type: ${userData['profile_photo'].runtimeType}');
        print('🖼️ Profile Photo isNull: ${userData['profile_photo'] == null}');
        print('🖼️ Profile Photo isEmpty: ${userData['profile_photo'].toString().isEmpty}');
        print('🖼️ Profile Photo isNotEmpty: ${userData['profile_photo'].toString().isNotEmpty}');
        if (userData['profile_photo'] != null && userData['profile_photo'].toString().isNotEmpty) {
          print('🖼️ Profile Photo Value: "${userData['profile_photo']}"');
          print('🖼️ Profile Photo Length: ${userData['profile_photo'].toString().length}');
          print('🖼️ Profile Photo startsWith http: ${userData['profile_photo'].toString().startsWith('http')}');
          print('🖼️ Profile Photo startsWith /: ${userData['profile_photo'].toString().startsWith('/')}');
          print('🖼️ Profile Photo startsWith C:: ${userData['profile_photo'].toString().startsWith('C:')}');
        }
        print('🖼️ ==========================================');
        
        // Enhanced domain logging
        print('✅ Dashboard loaded - GPA: $_gpa');
        print('✅ User ID: ${userData['id']}');
        print('✅ User Category: ${userData['category']}');
        print('✅ Domain1: "${userData['domain1']}" (type: ${userData['domain1'].runtimeType})');
        print('✅ Domain2: "${userData['domain2']}" (type: ${userData['domain2'].runtimeType})');
        print('✅ Domain1 isEmpty: ${userData['domain1'].toString().isEmpty}');
        print('✅ Domain2 isEmpty: ${userData['domain2'].toString().isEmpty}');
        print('✅ Domain1 isNotEmpty: ${userData['domain1'].toString().isNotEmpty}');
        print('✅ Domain2 isNotEmpty: ${userData['domain2'].toString().isNotEmpty}');
        print('✅ Domain1 == null: ${userData['domain1'] == null}');
        print('✅ Domain2 == null: ${userData['domain2'] == null}');
        print('✅ Domain1 == "": ${userData['domain1'] == ""}');
        print('✅ Domain2 == "": ${userData['domain2'] == ""}');
        print('✅ Full userData keys: ${userData.keys.toList()}');
        print('✅ Grades data: $grades');
        print('✅ Student record data: $studentRecord');
      } else {
        print('❌ Failed to get user data from Firebase');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> _getTopAchievements(Map<String, dynamic> studentRecord) {
    List<Map<String, dynamic>> achievements = [];
    
    // Get top 3 from each category
    for (String category in ['achievements', 'projects', 'workshops']) {
      if (studentRecord[category] != null) {
        try {
          List<dynamic> items = [];
          if (studentRecord[category] is List) {
            items = studentRecord[category] as List<dynamic>;
          } else if (studentRecord[category] is Map) {
            items = (studentRecord[category] as Map<dynamic, dynamic>).values.toList();
          }
          
          // Sort by points if available, otherwise take first 3
          items.sort((a, b) {
            int pointsA = 0;
            int pointsB = 0;
            
            if (a is Map) {
              pointsA = a['points'] ?? 0;
            }
            if (b is Map) {
              pointsB = b['points'] ?? 0;
            }
            
            return pointsB.compareTo(pointsA);
          });
          
          achievements.addAll(items.take(3).map((item) {
            if (item is Map) {
              return {
                'title': item['title'] ?? item['name'] ?? 'Achievement',
                'category': category,
                'points': item['points'] ?? 0,
              };
            }
            return {
              'title': 'Achievement',
              'category': category,
              'points': 0,
            };
          }));
        } catch (e) {
          print('❌ Error processing $category: $e');
        }
      }
    }
    
    // Sort all achievements by points and return top 3
    achievements.sort((a, b) => (b['points'] as int).compareTo(a['points'] as int));
    return achievements.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Student theme: blue
    final Color studentPrimary = Colors.blue.shade800;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
          backgroundColor: studentPrimary,
          foregroundColor: Colors.white,
        ),
        drawer: MainDrawer(context: context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: studentPrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _fetchDomainsFromStudentBranch,
            icon: const Icon(Icons.domain),
            tooltip: 'Fetch Domains from Student Branch',
          ),
          IconButton(
            onPressed: _forceRefresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Page',
          ),
        ],
      ),
      drawer: MainDrawer(context: context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                quickButtons(context),
                const SizedBox(height: 16),
                personalCard(context),
                const SizedBox(height: 16),
                gpaCard(context),
                const SizedBox(height: 16),
                attendanceCard(context),
                const SizedBox(height: 16),
                achievementsCard(context),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: _testFacultySelection,
                    tooltip: 'Test Faculty Selection',
                    child: const Icon(Icons.people),
                    heroTag: "test_faculty",
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    onPressed: _testApprovalRequest,
                    tooltip: 'Test Approval Request',
                    child: const Icon(Icons.send),
                    heroTag: "test_approval",
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    onPressed: _forceRefresh,
                    tooltip: 'Refresh Dashboard',
                    child: const Icon(Icons.refresh),
                    heroTag: "refresh",
                  ),
                ],
              ),
    );
  }

  // ---------------- Widgets ----------------
  Widget personalCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Card(
      elevation: 2, // Softer elevation
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: colorScheme.primaryContainer,
                  backgroundImage: _userData?['profile_photo'] != null && _userData!['profile_photo'].isNotEmpty
                      ? _getImageProvider(_userData!['profile_photo'])
                      : null,
                  child: _userData?['profile_photo'] == null || _userData!['profile_photo'].isEmpty
                      ? Icon(Icons.person, size: 40, color: colorScheme.onPrimaryContainer)
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  _userData?['name'] ?? "Loading...",
                  style: textTheme.titleLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Student ID: ${_userData?['student_id'] ?? 'Loading...'}",
                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Divider(color: colorScheme.outline.withOpacity(0.5)),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align details to the start
                  children: [
                    _buildDetailRow(context, Icons.school, "Branch: ${_userData?['branch'] ?? 'Loading...'}"),
                    _buildDetailRow(context, Icons.account_balance, "Institute: ${_userData?['institute'] ?? 'Loading...'}"),
                    _buildDetailRow(context, Icons.person_outline, "Faculty Advisor: ${_userData?['faculty_advisor'] ?? 'Loading...'}"),
                    // Display domains with proper handling of empty strings
                    _buildDetailRow(context, Icons.work_outline, "Domain 1: ${_getDomainDisplay(_userData?['domain1'])}"),
                    _buildDetailRow(context, Icons.work_outline, "Domain 2: ${_getDomainDisplay(_userData?['domain2'])}"),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StudentEditProfilePage()),
                    );
                    // If profile was updated, refresh the dashboard
                    if (result == true) {
                      print('🔄 Profile was updated, refreshing dashboard');
                      refreshData();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorScheme.primary, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, size: 18, color: colorScheme.primary),
                        const SizedBox(width: 4),
                        Text("Edit", style: textTheme.labelMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.secondary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }

  // Helper method to handle domain display
  String _getDomainDisplay(dynamic domain) {
    if (domain == null) return 'Not set';
    if (domain.toString().isEmpty) return 'Not set';
    return domain.toString();
  }

  // Helper method to get appropriate image provider
  ImageProvider _getImageProvider(String imagePath) {
    print('🖼️ ==========================================');
    print('🖼️ STUDENT DASHBOARD _getImageProvider DEBUG');
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

  Widget gpaCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell( // Make card tappable with ripple effect
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SemesterInfoPage()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current Semester: ${_userData?['current_semester'] ?? 'Loading...'}",
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("GPA: ${_gpa.toStringAsFixed(2)} / 10", style: textTheme.bodyLarge),
                  Icon(Icons.show_chart, color: colorScheme.primary)
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _gpa / 10, // Convert to 0-1 range
                backgroundColor: colorScheme.surfaceContainerHighest, // Softer background
                color: colorScheme.primary,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget attendanceCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final double attendancePercentage = (_userData?['attendance'] ?? 0) / 100.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SemesterInfoPage(startTabIndex: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Attendance Overview",
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Overall: ${(attendancePercentage * 100).toStringAsFixed(0)}%", style: textTheme.bodyLarge),
                  Icon(Icons.check_circle_outline, color: attendancePercentage >= 0.75 ? Colors.green.shade600 : colorScheme.error),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: attendancePercentage,
                backgroundColor: colorScheme.surfaceContainerHighest,
                color: attendancePercentage >= 0.75 ? Colors.green.shade600 : colorScheme.error,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Removed Recent Grades card from dashboard per requirement

  Widget achievementsCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AchievementsPage()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                     Icon(Icons.workspace_premium, color: colorScheme.primary),
                     const SizedBox(width: 8),
                     Text("Student Record", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                  ],
                ),
              ),
              const Divider(height: 16, indent: 16, endIndent: 16),
              ..._topAchievements.map((achievement) => ListTile(
                dense: true,
                title: Text(achievement['title'], style: textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text("${achievement['category']} • ${achievement['points']} points", style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                trailing: Icon(Icons.arrow_forward_ios, size: 14, color: colorScheme.onSurfaceVariant),
              )),
              if (_topAchievements.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: Text("No achievements to display", style: textTheme.bodyMedium)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget quickButtons(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () { /* TODO: Implement Download Profile */ },
            icon: const Icon(Icons.download, size: 20), // Slightly smaller icon
            label: Text("Download Profile", style: textTheme.labelLarge),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StudentAnalyticsPage()),
              );
            },
            icon: const Icon(Icons.analytics, size: 20),
            label: Text("View Analytics", style: textTheme.labelLarge),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
