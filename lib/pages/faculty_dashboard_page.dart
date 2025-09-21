import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/faculty_drawer.dart';
import '../widgets/approval_donut_chart.dart';
import '../widgets/enhanced_app_bar.dart';
import '../widgets/loading_components.dart';
import '../widgets/error_components.dart';
import 'faculty_edit_profile_page.dart';
import 'faculty_notifications_page.dart';
import '../services/auth_service.dart';
import '../utils/safe_snackbar_utils.dart';
import '../utils/responsive_utils.dart';
import '../utils/animation_utils.dart';
import '../utils/color_utils.dart';

// ---------------- FACULTY DASHBOARD PAGE ----------------
class FacultyDashboardPage extends StatefulWidget {
  const FacultyDashboardPage({super.key});

  @override
  State<FacultyDashboardPage> createState() => _FacultyDashboardPageState();
}

class _FacultyDashboardPageState extends State<FacultyDashboardPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _papersAndPublications = [];
  List<Map<String, dynamic>> _projects = [];
  List<Map<String, dynamic>> _approvalRequests = [];
  List<Map<String, dynamic>> _approvalHistory = [];
  Map<String, dynamic> _approvalAnalytics = {};
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Force refresh user data from Firebase to get latest updates
      final userData = await _authService.forceRefreshUserData();
      if (userData != null) {
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
        
        // Load faculty-specific data
        await _loadFacultyData();
        await _loadNotificationCount();
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadFacultyData() async {
    if (_userData == null) return;
    
    try {
      // Load papers and publications (max 10)
      if (_userData!['faculty_record'] != null && 
          _userData!['faculty_record']['papers_and_publications'] != null) {
        List<dynamic> papers = _userData!['faculty_record']['papers_and_publications'] as List<dynamic>;
        _papersAndPublications = papers.take(10).map((paper) => 
          Map<String, dynamic>.from(paper as Map<dynamic, dynamic>)).toList();
      }
      
      // Load projects (max 10)
      if (_userData!['faculty_record'] != null && 
          _userData!['faculty_record']['projects'] != null) {
        List<dynamic> projects = _userData!['faculty_record']['projects'] as List<dynamic>;
        _projects = projects.take(10).map((project) => 
          Map<String, dynamic>.from(project as Map<dynamic, dynamic>)).toList();
      }
      
      // Load approval requests directly from Firebase
      await _loadApprovalRequestsFromFirebase();
      
      // Load approval history directly from Firebase
      await _loadApprovalHistoryFromFirebase();
      
      // Load approval analytics directly from Firebase
      await _loadApprovalAnalyticsFromFirebase();
      
      setState(() {});
    } catch (e) {
    }
  }

  // Method to refresh data from external calls
  void refreshData() {
    _loadUserData();
  }

  // Method to refresh only approval requests
  Future<void> _refreshApprovalRequests() async {
    await _loadApprovalRequestsFromFirebase();
    await _loadNotificationCount(); // Also refresh notification count
    setState(() {});
    
    // Approval requests refreshed silently
  }

  // Method to refresh only approval history
  Future<void> _refreshApprovalHistory() async {
    await _loadApprovalHistoryFromFirebase();
    setState(() {});
    
    // Approval history refreshed silently
  }

  // Method to refresh only approval analytics
  Future<void> _refreshApprovalAnalytics() async {
    await _loadApprovalAnalyticsFromFirebase();
    setState(() {});
    
    // Approval analytics refreshed silently
  }

  // Method to load approval history directly from Firebase
  Future<void> _loadApprovalHistoryFromFirebase() async {
    try {
      String facultyId = _userData!['id'];
      
      // Get Firebase Database reference
      final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();
      
      // Get approval history directly from Firebase
      DataSnapshot historySnapshot = await databaseRef.child('faculty').child(facultyId).child('approval_history').get();
      
      
      if (historySnapshot.exists && historySnapshot.value != null) {
        if (historySnapshot.value is Map) {
          Map<dynamic, dynamic> historyMap = historySnapshot.value as Map<dynamic, dynamic>;
          _approvalHistory = historyMap.entries.map((entry) {
            Map<String, dynamic> item = Map<String, dynamic>.from(entry.value as Map<dynamic, dynamic>);
            item['request_id'] = entry.key; // Add the request ID
            return item;
          }).toList();
        } else {
          _approvalHistory = [];
        }
      } else {
        _approvalHistory = [];
      }
    } catch (e) {
      _approvalHistory = [];
    }
  }

  // Method to load approval analytics directly from Firebase
  Future<void> _loadApprovalAnalyticsFromFirebase() async {
    try {
      String facultyId = _userData!['id'];
      
      // Get Firebase Database reference
      final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();
      
      // Get approval analytics directly from Firebase
      DataSnapshot analyticsSnapshot = await databaseRef.child('faculty').child(facultyId).child('approval_analytics').get();
      
      
      if (analyticsSnapshot.exists && analyticsSnapshot.value != null) {
        _approvalAnalytics = Map<String, dynamic>.from(analyticsSnapshot.value as Map<dynamic, dynamic>);
      } else {
        _approvalAnalytics = {
          'total_approved': 0,
          'total_rejected': 0,
          'approval_rate': 0.0,
          'avg_points_awarded': 0.0,
        };
      }
    } catch (e) {
      _approvalAnalytics = {
        'total_approved': 0,
        'total_rejected': 0,
        'approval_rate': 0.0,
        'avg_points_awarded': 0.0,
      };
    }
  }

  // Method to load notification count from approval requests
  Future<void> _loadNotificationCount() async {
    try {
      if (_userData == null) return;
      
      final facultyId = _userData!['faculty_id'] ?? _userData!['id'];

      final snapshot = await FirebaseDatabase.instance.ref()
          .child('faculty')
          .child(facultyId)
          .child('approval_section')
          .get();
      
      if (snapshot.exists) {
        final approvalData = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        setState(() {
          _notificationCount = approvalData.length;
        });
      } else {
        setState(() {
          _notificationCount = 0;
        });
      }
    } catch (e) {
      setState(() {
        _notificationCount = 0;
      });
    }
  }

  // Method to open notifications page
  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FacultyNotificationsPage()),
    ).then((_) {
      // Refresh notification count when returning from notifications page
      _loadNotificationCount();
    });
  }

  // Method to load approval requests directly from Firebase
  Future<void> _loadApprovalRequestsFromFirebase() async {
    try {
      String facultyId = _userData!['id'];
      
      // Get Firebase Database reference
      final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();
      
      // Get approval section directly from Firebase
      DataSnapshot approvalSnapshot = await databaseRef.child('faculty').child(facultyId).child('approval_section').get();
      
      
      if (approvalSnapshot.exists && approvalSnapshot.value != null) {
        if (approvalSnapshot.value is Map) {
          Map<dynamic, dynamic> approvalMap = approvalSnapshot.value as Map<dynamic, dynamic>;
          _approvalRequests = approvalMap.entries.map((entry) {
            Map<String, dynamic> request = Map<String, dynamic>.from(entry.value as Map<dynamic, dynamic>);
            request['request_id'] = entry.key; // Add the request ID
            return request;
          }).toList();
          
          // Log each request for debugging
          for (var request in _approvalRequests) {
          }
        } else {
          _approvalRequests = [];
        }
      } else {
        _approvalRequests = [];
      }
    } catch (e) {
      _approvalRequests = [];
    }
  }

  // Debug method to check approval section
  Future<void> _debugApprovalSection() async {
    if (_userData == null) {
      return;
    }

    try {
      String facultyId = _userData!['id'];
      String facultyName = _userData!['name'];
      String department = _userData!['department'];
      
      
      // Check approval section directly from Firebase
      final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();
      
      DataSnapshot approvalSnapshot = await databaseRef.child('faculty').child(facultyId).child('approval_section').get();
      
      if (approvalSnapshot.exists && approvalSnapshot.value != null) {
        if (approvalSnapshot.value is Map) {
          Map<dynamic, dynamic> approvalMap = approvalSnapshot.value as Map<dynamic, dynamic>;
          if (approvalMap.isNotEmpty) {
            approvalMap.forEach((key, value) {
            });
          } else {
          }
        } else {
        }
      } else {
      }
      
      // Also refresh the UI data
      await _loadApprovalRequestsFromFirebase();
      setState(() {});
      
      // Debug info printed to console silently
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    // Faculty theme: green gradient
    final Color facultyPrimary = Colors.green.shade600;

    if (_isLoading) {
      return Scaffold(
        appBar: EnhancedAppBar(
          title: "Faculty Dashboard",
          backgroundColor: facultyPrimary,
          foregroundColor: Colors.white,
          enableGradient: true,
          gradientColors: [
            facultyPrimary,
            facultyPrimary.withOpacity(0.8),
          ],
        ),
        drawer: MainDrawer(context: context, isFaculty: true),
        body: LoadingComponents.buildModernLoadingIndicator(
          message: "Loading faculty dashboard...",
          context: context,
        ),
      );
    }

    return Scaffold(
      appBar: EnhancedAppBar(
        title: "Faculty Dashboard",
        subtitle: "Welcome back!",
        backgroundColor: facultyPrimary,
        foregroundColor: Colors.white,
        enableGradient: true,
        gradientColors: [
          facultyPrimary,
          facultyPrimary.withOpacity(0.8),
        ],
        actions: [
          // Notification bell with badge
          Stack(
            children: [
              IconButton(
                onPressed: _openNotifications,
                icon: const Icon(Icons.notifications),
                tooltip: 'Notifications',
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: refreshData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Page',
          ),
        ],
      ),
      drawer: MainDrawer(context: context, isFaculty: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: ResponsiveUtils.getResponsivePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimationUtils.buildAnimatedCard(
                  child: personalCard(context),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                AnimationUtils.buildAnimatedCard(
                  child: researchPapersCard(context),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                AnimationUtils.buildAnimatedCard(
                  child: projectsCard(context),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                AnimationUtils.buildAnimatedCard(
                  child: approvalRequestsCard(context),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                AnimationUtils.buildAnimatedCard(
                  child: approvalHistoryCard(context),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                AnimationUtils.buildAnimatedCard(
                  child: approvalAnalyticsCard(context),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------- Widgets ----------------
  Widget personalCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final facultyPrimary = Colors.green.shade600;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade50,
            Colors.green.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
        border: Border.all(
          color: facultyPrimary.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: facultyPrimary.withOpacity(0.2),
            blurRadius: ResponsiveUtils.getResponsiveElevation(context, 8),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: facultyPrimary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: ResponsiveUtils.getResponsiveIconSize(context, 40),
                    backgroundColor: Colors.white,
                    backgroundImage: _userData?['profile_photo'] != null && _userData!['profile_photo'].toString().isNotEmpty
                        ? _getImageProvider(_userData!['profile_photo'])
                        : null,
                    child: _userData?['profile_photo'] == null || _userData!['profile_photo'].toString().isEmpty
                        ? Icon(
                            Icons.person_rounded, 
                            size: ResponsiveUtils.getResponsiveIconSize(context, 40), 
                            color: facultyPrimary,
                          )
                        : null,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
               Text(
                 _userData?['name'] ?? "Loading...",
                 style: textTheme.titleLarge?.copyWith(
                   color: Colors.grey.shade800,
                   fontWeight: FontWeight.bold,
                 ),
               ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.getResponsiveSpacing(context, 12),
                    vertical: ResponsiveUtils.getResponsiveSpacing(context, 4),
                  ),
                  decoration: BoxDecoration(
                    color: facultyPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
                  ),
                 child: Text(
                   "Faculty ID: ${_userData?['faculty_id'] ?? 'Loading...'}",
                   style: textTheme.bodyMedium?.copyWith(
                     color: Colors.grey.shade700,
                     fontWeight: FontWeight.w600,
                   ),
                 ),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                Divider(color: facultyPrimary.withOpacity(0.3)),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(context, Icons.work, "Designation: ${_userData?['designation'] ?? 'Loading...'}", facultyPrimary),
                    _buildDetailRow(context, Icons.business, "Department: ${_userData?['department'] ?? 'Loading...'}", facultyPrimary),
                    _buildDetailRow(context, Icons.school, "Educational Qualifications: ${_userData?['educational_qualifications'] ?? 'Loading...'}", facultyPrimary),
                    _buildDetailRow(context, Icons.email, "Email: ${_userData?['email'] ?? 'Loading...'}", facultyPrimary),
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
                      MaterialPageRoute(builder: (_) => const FacultyEditProfilePage()),
                    );
                    
                    // If profile was updated, refresh the dashboard data
                    if (result == true) {
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

  Widget _buildDetailRow(BuildContext context, IconData icon, String text, Color? color) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = color ?? Colors.green.shade600;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.getResponsiveSpacing(context, 4)),
      child: Row(
        children: [
          Icon(
            icon,
            size: ResponsiveUtils.getResponsiveIconSize(context, 18),
            color: effectiveColor,
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8)),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
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

  Widget researchPapersCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(Icons.article, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text("Papers and Publications", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        children: _papersAndPublications.isNotEmpty
            ? _papersAndPublications.map((paper) => ListTile(
                dense: true,
                title: Text(paper['title'] ?? 'Untitled', style: textTheme.bodyMedium),
                subtitle: Text(paper['description'] ?? '', style: textTheme.bodySmall),
                trailing: IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () => _showPaperDetails(context, paper),
                ),
              )).toList()
            : [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: Text("No papers and publications to display", style: textTheme.bodyMedium)),
                ),
              ],
      ),
    );
  }

  void _showPaperDetails(BuildContext context, Map<String, dynamic> paper) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(paper['title'] ?? 'Untitled'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (paper['description'] != null) ...[
              const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(paper['description']),
              const SizedBox(height: 8),
            ],
            if (paper['link'] != null) ...[
              const Text('Link:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(paper['link']),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget projectsCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(Icons.engineering, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text("Projects", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        children: _projects.isNotEmpty
            ? _projects.map((project) => ListTile(
                dense: true,
                title: Text(project['title'] ?? 'Untitled', style: textTheme.bodyMedium),
                subtitle: Text(project['description'] ?? '', style: textTheme.bodySmall),
                trailing: IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () => _showProjectDetails(context, project),
                ),
              )).toList()
            : [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: Text("No projects to display", style: textTheme.bodyMedium)),
                ),
              ],
      ),
    );
  }

  void _showProjectDetails(BuildContext context, Map<String, dynamic> project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(project['title'] ?? 'Untitled'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project['description'] != null) ...[
              const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(project['description']),
              const SizedBox(height: 8),
            ],
            if (project['link'] != null) ...[
              const Text('Link:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(project['link']),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget approvalRequestsCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(Icons.approval, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text("Approval Requests", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        children: _approvalRequests.isNotEmpty
            ? _approvalRequests.map((request) => ListTile(
                dense: true,
                title: Text("${request['student_name'] ?? 'Unknown'} - ${request['project_name'] ?? 'Untitled'}", 
                    style: textTheme.bodyMedium),
                subtitle: Text("Category: ${request['category'] ?? 'Unknown'}", style: textTheme.bodySmall),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () => _showRequestDetails(context, request),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () => _handleApproval(request, true),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => _handleApproval(request, false),
                    ),
                  ],
                ),
              )).toList()
            : [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: Text("No approval requests to display", style: textTheme.bodyMedium)),
                ),
              ],
      ),
    );
  }

  Widget approvalHistoryCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(Icons.history, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text("Approval History", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        children: _approvalHistory.isNotEmpty
            ? _approvalHistory.map((item) => ListTile(
                dense: true,
                title: Text("${item['student_name'] ?? 'Unknown'} - ${item['project_name'] ?? 'Untitled'}", 
                    style: textTheme.bodyMedium),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Status: ${item['status'] ?? 'Unknown'}", style: textTheme.bodySmall),
                    if (item['status'] == 'rejected' && item['reason'] != null)
                      Text("Reason: ${item['reason']}", style: textTheme.bodySmall?.copyWith(color: Colors.red)),
                    if (item['status'] == 'accepted' && item['points_awarded'] != null)
                      Text("Points: ${item['points_awarded']}", style: textTheme.bodySmall?.copyWith(color: Colors.green)),
                  ],
                ),
                trailing: Icon(
                  item['status'] == 'accepted' ? Icons.check_circle : Icons.cancel,
                  color: item['status'] == 'accepted' ? Colors.green : Colors.red,
                ),
              )).toList()
            : [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: Text("No approval history to display", style: textTheme.bodyMedium)),
                ),
              ],
      ),
    );
  }

  void _showRequestDetails(BuildContext context, Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${request['student_name'] ?? 'Unknown'} - ${request['project_name'] ?? 'Untitled'}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (request['title'] != null) ...[
              const Text('Title:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(request['title']),
              const SizedBox(height: 8),
            ],
            if (request['description'] != null) ...[
              const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(request['description']),
              const SizedBox(height: 8),
            ],
            if (request['link'] != null) ...[
              const Text('Link:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(request['link']),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleApproval(Map<String, dynamic> request, bool approved) async {
    try {
      if (approved) {
        // Show dialog for points input
        await _showApprovalDialog(request, true);
      } else {
        // Show dialog for rejection reason
        await _showRejectionDialog(request);
      }
    } catch (e) {
      SafeSnackBarUtils.showError(
        context,
        message: 'Error handling approval: $e',
      );
    }
  }

  Future<void> _showApprovalDialog(Map<String, dynamic> request, bool approved) async {
    final TextEditingController pointsController = TextEditingController();
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Approve Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Student: ${request['student_name']}'),
            Text('Project: ${request['project_name']}'),
            const SizedBox(height: 16),
            TextField(
              controller: pointsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Points to Award',
                hintText: 'Enter points (1-50)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              int points = int.tryParse(pointsController.text) ?? 0;
              if (points < 1 || points > 50) {
                SafeSnackBarUtils.showWarning(
                  context,
                  message: 'Please enter points between 1 and 50',
                );
                return;
              }
              
              Navigator.pop(context);
              await _processApproval(request, true, points, '');
            },
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  Future<void> _showRejectionDialog(Map<String, dynamic> request) async {
    final TextEditingController reasonController = TextEditingController();
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reject Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Student: ${request['student_name']}'),
            Text('Project: ${request['project_name']}'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for Rejection',
                hintText: 'Enter reason for rejection',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (reasonController.text.trim().isEmpty) {
                SafeSnackBarUtils.showWarning(
                  context,
                  message: 'Please enter a reason for rejection',
                );
                return;
              }
              
              Navigator.pop(context);
              await _processApproval(request, false, 0, reasonController.text.trim());
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  Future<void> _processApproval(Map<String, dynamic> request, bool approved, int points, String reason) async {
    try {
      String requestId = request['request_id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
      
      await _authService.handleApprovalRequest(requestId, approved, points, reason);
      
      // Refresh data
      await _loadUserData();
      
      if (approved) {
        SafeSnackBarUtils.showSuccess(
          context,
          message: 'Request approved successfully',
        );
      } else {
        SafeSnackBarUtils.showWarning(
          context,
          message: 'Request rejected',
        );
      }
    } catch (e) {
      SafeSnackBarUtils.showError(
        context,
        message: 'Error processing approval: $e',
      );
    }
  }

  Widget approvalAnalyticsCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    final totalApproved = _approvalAnalytics['total_approved'] ?? 0;
    final totalRejected = _approvalAnalytics['total_rejected'] ?? 0;
    final approvalRate = _approvalAnalytics['approval_rate'] ?? 0.0;
    final avgPoints = _approvalAnalytics['avg_points_awarded'] ?? 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics_outlined, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text("Approval Analytics", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _metricTile(context, 'Total Approved', '$totalApproved', Icons.check_circle, Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _metricTile(context, 'Total Rejected', '$totalRejected', Icons.cancel, Colors.red)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _metricTile(context, 'Approval Rate', '${(approvalRate * 100).toStringAsFixed(1)}%', Icons.percent, colorScheme.primary)),
                const SizedBox(width: 12),
                Expanded(child: _metricTile(context, 'Avg. Points Awarded', avgPoints.toStringAsFixed(1), Icons.star_rate, colorScheme.tertiary)),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ApprovalDonutChart(
                    approved: totalApproved,
                    rejected: totalRejected,
                    pending: 0,
                    includePending: false,
                    showLegend: true,
                    thicknessMultiplier: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricTile(BuildContext context, String title, String value, IconData icon, Color color) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: colors.outline.withOpacity(0.2))),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 100),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(title, style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant), maxLines: 2, softWrap: true)),
                ],
              ),
              const SizedBox(height: 8),
              Text(value, style: textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.bold)),
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
            icon: const Icon(Icons.download, size: 20),
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
            onPressed: () { /* TODO: Implement View Analytics */ },
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
