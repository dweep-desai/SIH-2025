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
      // Force refresh user data from Firebase to get latest updates
      print('🔄 Loading faculty user data...');
      final userData = await _authService.forceRefreshUserData();
      if (userData != null) {
        print('✅ Faculty user data loaded: ${userData['name']}');
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
        
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
      String facultyId = _userData!['id'];
      print('🔍 Loading approval analytics directly from Firebase for faculty: $facultyId');
      
      // Get Firebase Database reference
      final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();
      
      // Get approval analytics directly from Firebase
      DataSnapshot analyticsSnapshot = await databaseRef.child('faculty').child(facultyId).child('approval_analytics').get();
      
      print('🔍 Raw approval analytics from Firebase: ${analyticsSnapshot.value}');
      print('🔍 Approval analytics exists: ${analyticsSnapshot.exists}');
      
      if (analyticsSnapshot.exists && analyticsSnapshot.value != null) {
        _approvalAnalytics = Map<String, dynamic>.from(analyticsSnapshot.value as Map<dynamic, dynamic>);
        print('🔍 Loaded approval analytics from Firebase: $_approvalAnalytics');
      } else {
        print('🔍 No approval analytics found in Firebase, using defaults');
        _approvalAnalytics = {
          'total_approved': 0,
          'total_rejected': 0,
          'approval_rate': 0.0,
          'avg_points_awarded': 0.0,
        };
      }
    } catch (e) {
      print('❌ Error loading approval analytics from Firebase: $e');
      _approvalAnalytics = {
        'total_approved': 0,
        'total_rejected': 0,
        'approval_rate': 0.0,
        'avg_points_awarded': 0.0,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final texts = theme.textTheme;
    // Faculty theme: green
    final Color facultyPrimary = Colors.green.shade700;

    if (_isLoading) {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Analytics'),
        backgroundColor: facultyPrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadApprovalAnalyticsFromFirebase,
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
