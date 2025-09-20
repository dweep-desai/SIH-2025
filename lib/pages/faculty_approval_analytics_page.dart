import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/faculty_drawer.dart';
import '../services/auth_service.dart';
import '../widgets/approval_donut_chart.dart';

class FacultyApprovalAnalyticsPage extends StatefulWidget {
  const FacultyApprovalAnalyticsPage({super.key});

  @override
  State<FacultyApprovalAnalyticsPage> createState() => _FacultyApprovalAnalyticsPageState();
}

class _FacultyApprovalAnalyticsPageState extends State<FacultyApprovalAnalyticsPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  Map<String, dynamic> _approvalAnalytics = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      print('🔍 ==========================================');
      print('🔍 FACULTY APPROVAL ANALYTICS PAGE - LOADING USER DATA');
      print('🔍 ==========================================');
      
      // Force refresh user data from Firebase to get latest updates
      print('🔄 Loading faculty user data...');
      final userData = await _authService.forceRefreshUserData();
      if (userData != null) {
        print('✅ Faculty user data loaded: ${userData['name']}');
        print('✅ Faculty ID: ${userData['id']}');
        print('✅ Faculty Category: ${userData['category']}');
        print('✅ Faculty Department: ${userData['department']}');
        
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
        
        print('🔄 Now loading approval analytics from Firebase...');
        // Load approval analytics directly from Firebase
        await _loadApprovalAnalyticsFromFirebase();
      } else {
        print('❌ No faculty user data found');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('❌ Error loading faculty data: $e');
      setState(() => _isLoading = false);
    }
  }

  // Method to load approval analytics directly from Firebase
  Future<void> _loadApprovalAnalyticsFromFirebase() async {
    try {
      print('🔍 ==========================================');
      print('🔍 LOADING APPROVAL ANALYTICS FROM FIREBASE');
      print('🔍 ==========================================');
      
      String facultyId = _userData!['id'];
      print('🔍 Faculty ID: $facultyId');
      print('🔍 Firebase Path: /faculty/$facultyId/approval_analytics');
      
      // Get Firebase Database reference
      final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();
      
      print('🔍 Firebase Database Reference created');
      print('🔍 Database URL: https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app');
      
      // Get approval_analytics directly from Firebase
      print('🔍 Fetching data from Firebase...');
      DataSnapshot analyticsSnapshot = await databaseRef.child('faculty').child(facultyId).child('approval_analytics').get();
      
      print('🔍 ==========================================');
      print('🔍 FIREBASE RESPONSE ANALYSIS');
      print('🔍 ==========================================');
      print('🔍 Raw approval_analytics from Firebase: ${analyticsSnapshot.value}');
      print('🔍 Approval_analytics exists: ${analyticsSnapshot.exists}');
      print('🔍 Data type: ${analyticsSnapshot.value.runtimeType}');
      print('🔍 Data is null: ${analyticsSnapshot.value == null}');
      
      if (analyticsSnapshot.exists && analyticsSnapshot.value != null) {
        _approvalAnalytics = Map<String, dynamic>.from(analyticsSnapshot.value as Map<dynamic, dynamic>);
        
        print('🔍 ==========================================');
        print('🔍 PROCESSED APPROVAL ANALYTICS');
        print('🔍 ==========================================');
        print('🔍 Loaded approval_analytics from Firebase: $_approvalAnalytics');
        print('🔍 Total Approved: ${_approvalAnalytics['total_approved']}');
        print('🔍 Total Rejected: ${_approvalAnalytics['total_rejected']}');
        print('🔍 Approval Rate: ${_approvalAnalytics['approval_rate']}');
        print('🔍 Avg Points Awarded: ${_approvalAnalytics['avg_points_awarded']}');
        print('🔍 Total Points Awarded: ${_approvalAnalytics['total_points_awarded']}');
        
        // Log each analytics field for debugging
        _approvalAnalytics.forEach((key, value) {
          print('🔍 Analytics Field: $key = $value (${value.runtimeType})');
        });
      } else {
        print('🔍 No approval_analytics found in Firebase, using defaults');
        print('🔍 This could mean:');
        print('🔍   1. No approval analytics exist for this faculty');
        print('🔍   2. The path is incorrect');
        print('🔍   3. Firebase connection issue');
        
        _approvalAnalytics = {
          'total_approved': 0,
          'total_rejected': 0,
          'approval_rate': 0.0,
          'avg_points_awarded': 0.0,
        };
      }
      
      print('🔍 ==========================================');
      print('🔍 FINAL RESULT');
      print('🔍 ==========================================');
      print('🔍 _approvalAnalytics: $_approvalAnalytics');
      print('🔍 _approvalAnalytics.isEmpty: ${_approvalAnalytics.isEmpty}');
      print('🔍 ==========================================');
      
      // Update the UI with the loaded data
      setState(() {});
      
    } catch (e) {
      print('❌ ==========================================');
      print('❌ ERROR LOADING APPROVAL ANALYTICS');
      print('❌ ==========================================');
      print('❌ Error: $e');
      print('❌ Error type: ${e.runtimeType}');
      print('❌ Stack trace: ${StackTrace.current}');
      print('❌ ==========================================');
      
      _approvalAnalytics = {
        'total_approved': 0,
        'total_rejected': 0,
        'approval_rate': 0.0,
        'avg_points_awarded': 0.0,
      };
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🔍 ==========================================');
    print('🔍 FACULTY APPROVAL ANALYTICS PAGE - BUILD METHOD');
    print('🔍 ==========================================');
    print('🔍 _isLoading: $_isLoading');
    print('🔍 _userData: $_userData');
    print('🔍 _approvalAnalytics: $_approvalAnalytics');
    print('🔍 _approvalAnalytics.isEmpty: ${_approvalAnalytics.isEmpty}');
    print('🔍 ==========================================');
    
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    // Faculty theme: green
    final Color facultyPrimary = Colors.green.shade700;

    if (_isLoading) {
      print('🔍 Showing loading screen...');
      return Scaffold(
        appBar: AppBar(
          title: const Text('Approval Analytics'),
          backgroundColor: facultyPrimary,
          foregroundColor: Colors.white,
        ),
        drawer: MainDrawer(context: context, isFaculty: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final totalApproved = _approvalAnalytics['total_approved'] ?? 0;
    final totalRejected = _approvalAnalytics['total_rejected'] ?? 0;
    final approvalRate = _approvalAnalytics['approval_rate'] ?? 0.0;
    final avgPoints = _approvalAnalytics['avg_points_awarded'] ?? 0.0;

    print('🔍 Showing main content screen...');
    print('🔍 Analytics values:');
    print('🔍   - totalApproved: $totalApproved');
    print('🔍   - totalRejected: $totalRejected');
    print('🔍   - approvalRate: $approvalRate');
    print('🔍   - avgPoints: $avgPoints');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Analytics'),
        backgroundColor: facultyPrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              print('🔍 Refresh button pressed - reloading approval analytics...');
              _loadApprovalAnalyticsFromFirebase();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Approval Analytics',
          ),
        ],
      ),
      drawer: MainDrawer(context: context, isFaculty: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Metrics
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
                Expanded(child: _metricTile(context, 'Approval Rate', '${(approvalRate * 100).toStringAsFixed(1)}%', Icons.percent, colors.primary)),
                const SizedBox(width: 12),
                Expanded(child: _metricTile(context, 'Avg. Points Awarded', avgPoints.toStringAsFixed(1), Icons.star_rate, colors.tertiary)),
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
}
