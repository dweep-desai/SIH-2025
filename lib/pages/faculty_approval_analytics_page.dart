import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/faculty_drawer.dart';
import '../widgets/enhanced_app_bar.dart';
import '../widgets/modern_chart_components.dart';
import '../widgets/form_components.dart';
import '../widgets/loading_components.dart';
import '../widgets/error_components.dart';
import '../utils/responsive_utils.dart';
import '../services/auth_service.dart';

class FacultyApprovalAnalyticsPage extends StatefulWidget {
  const FacultyApprovalAnalyticsPage({super.key});

  @override
  State<FacultyApprovalAnalyticsPage> createState() => _FacultyApprovalAnalyticsPageState();
}

class _FacultyApprovalAnalyticsPageState extends State<FacultyApprovalAnalyticsPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
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
      final userData = await _authService.forceRefreshUserData();
      if (userData != null) {
        
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
        
        // Load approval analytics directly from Firebase
        await _loadApprovalAnalyticsFromFirebase();
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
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
      
      
      // Get approval_analytics directly from Firebase
      DataSnapshot analyticsSnapshot = await databaseRef.child('faculty').child(facultyId).child('approval_analytics').get();
      
      
      if (analyticsSnapshot.exists && analyticsSnapshot.value != null) {
        _approvalAnalytics = Map<String, dynamic>.from(analyticsSnapshot.value as Map<dynamic, dynamic>);
        
        
        // Log each analytics field for debugging
        _approvalAnalytics.forEach((key, value) {
          print('Analytics $key: $value (${value.runtimeType})');
        });
      } else {
        
        _approvalAnalytics = {
          'total_approved': 0,
          'total_rejected': 0,
          'approval_rate': 0.0,
          'avg_points_awarded': 0.0,
        };
      }
      
      
      // Update the UI with the loaded data
      setState(() {});
      
    } catch (e) {
      
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
    
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    // Faculty theme: green
    // final Color facultyPrimary = Colors.green.shade700;

    if (_isLoading) {
      return Scaffold(
        appBar: EnhancedAppBar(
          title: 'Approval Analytics',
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          enableGradient: true,
          gradientColors: [
            const Color(0xFF4A90E2).withOpacity(0.8), // Blue
            const Color(0xFF7ED321).withOpacity(0.6), // Green
          ],
          elevation: 0,
        ),
        drawer: MainDrawer(context: context, isFaculty: true),
        body: LoadingComponents.buildPulseLoading(
          message: 'Loading Analytics Data',
          context: context,
        ),
      );
    }

    if (_hasError) {
      return Scaffold(
        appBar: EnhancedAppBar(
          title: 'Approval Analytics',
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          enableGradient: true,
          gradientColors: [
            const Color(0xFF4A90E2).withOpacity(0.8), // Blue
            const Color(0xFF7ED321).withOpacity(0.6), // Green
          ],
          elevation: 0,
        ),
        drawer: MainDrawer(context: context, isFaculty: true),
        body: Center(
          child: Padding(
            padding: ResponsiveUtils.getResponsivePadding(context),
            child: ErrorComponents.buildErrorState(
              title: 'Failed to Load Analytics',
              message: _errorMessage.isNotEmpty 
                  ? _errorMessage 
                  : 'Unable to load your approval analytics. Please check your connection and try again.',
              icon: Icons.analytics_outlined,
              onRetry: () {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                  _errorMessage = '';
                });
                _loadUserData();
              },
              context: context,
              retryText: 'Retry',
            ),
          ),
        ),
      );
    }

    final totalApproved = (_approvalAnalytics['total_approved'] ?? 0).toInt();
    final totalRejected = (_approvalAnalytics['total_rejected'] ?? 0).toInt();
    final approvalRate = (_approvalAnalytics['approval_rate'] ?? 0.0).toDouble();
    final avgPoints = (_approvalAnalytics['avg_points_awarded'] ?? 0.0).toDouble();
    
    print('Processed values - totalApproved: $totalApproved (${totalApproved.runtimeType}), totalRejected: $totalRejected (${totalRejected.runtimeType})');

    return Scaffold(
      appBar: EnhancedAppBar(
        title: 'Approval Analytics',
        subtitle: 'Track your approval performance',
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        enableGradient: true,
        gradientColors: [
          const Color(0xFF4A90E2).withOpacity(0.8), // Blue
          const Color(0xFF7ED321).withOpacity(0.6), // Green
        ],
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _loadApprovalAnalyticsFromFirebase();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Approval Analytics',
          ),
        ],
      ),
      drawer: MainDrawer(context: context, isFaculty: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4A90E2).withOpacity(0.1), // Light blue
              const Color(0xFF7ED321).withOpacity(0.1), // Light green
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: ResponsiveUtils.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Overview Metrics
              _buildMetricsGrid(context, totalApproved, totalRejected, approvalRate, avgPoints, colors),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24.0)),
              // Modern Donut Chart
              _buildModernDonutChart(context, totalApproved, totalRejected, colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(BuildContext context, int totalApproved, int totalRejected, double approvalRate, double avgPoints, ColorScheme colors) {
    return Column(
      children: [
        // First row: Total Approved and Total Rejected
        Row(
          children: [
            Expanded(
              child: _buildModernMetricTile(
                context: context,
                title: 'Total Approved',
                value: '$totalApproved',
                icon: Icons.check_circle,
                color: Colors.green,
                colors: colors,
              ),
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12.0)),
            Expanded(
              child: _buildModernMetricTile(
                context: context,
                title: 'Total Rejected',
                value: '$totalRejected',
                icon: Icons.cancel,
                color: Colors.red,
                colors: colors,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12.0)),
        // Second row: Approval Rate and Avg Points Awarded
        Row(
          children: [
            Expanded(
              child: _buildModernMetricTile(
                context: context,
                title: 'Approval Rate',
                value: '${(approvalRate * 100).toStringAsFixed(1)}%',
                icon: Icons.percent,
                color: colors.primary,
                colors: colors,
              ),
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12.0)),
            Expanded(
              child: _buildModernMetricTile(
                context: context,
                title: 'Avg Points Awarded',
                value: avgPoints.toStringAsFixed(1),
                icon: Icons.star_rate,
                color: colors.tertiary,
                colors: colors,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModernDonutChart(BuildContext context, int totalApproved, int totalRejected, ColorScheme colors) {
    final chartData = [
      {
        'value': totalApproved.toDouble(),
        'label': 'Approved',
        'percentage': totalApproved + totalRejected > 0 ? (totalApproved.toDouble() / (totalApproved + totalRejected).toDouble()) * 100.0 : 0.0,
      },
      {
        'value': totalRejected.toDouble(),
        'label': 'Rejected',
        'percentage': totalApproved + totalRejected > 0 ? (totalRejected.toDouble() / (totalApproved + totalRejected).toDouble()) * 100.0 : 0.0,
      },
    ];

    return ModernChartComponents.buildModernPieChart(
      data: chartData,
      title: "Approval Distribution",
      subtitle: "Breakdown of your approval decisions",
      icon: Icons.pie_chart_outline,
      context: context,
      colors: [Colors.green.shade600, Colors.red.shade600],
      centerSpaceRadius: 60.0,
      showLegend: true,
      showPercentage: true,
    );
  }

  Widget _buildModernMetricTile({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required ColorScheme colors,
  }) {
    final textTheme = Theme.of(context).textTheme;
    
    return ModernFormComponents.buildModernCard(
      context: context,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: ResponsiveUtils.getResponsiveSpacing(context, 120.0).toDouble(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8.0)),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  softWrap: true,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8.0)),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
        ),
      ),
    );
  }
}
