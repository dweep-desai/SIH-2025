import 'package:flutter/material.dart';
import '../widgets/student_drawer.dart';
import '../widgets/enhanced_app_bar.dart';
import '../widgets/loading_components.dart';
import '../widgets/error_components.dart';
import '../services/auth_service.dart';
import '../utils/responsive_utils.dart';
import '../utils/animation_utils.dart';
import '../utils/color_utils.dart';
import '../utils/image_utils.dart';
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
  bool _hasError = false;
  String _errorMessage = '';
  Map<String, dynamic>? _userData;
  double _gpa = 0.0;
  List<Map<String, dynamic>> _topAchievements = [];

  // Method to refresh data from external calls
  void refreshData() {
    _loadUserData();
  }


  // Method to force refresh data
  Future<void> _forceRefresh() async {
    await _loadUserData();
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
    _loadUserData();
  }


  Future<void> _loadUserData() async {
    try {
      // Force refresh user data directly from Firebase to get latest updates
      final userData = await _authService.forceRefreshUserData();
      if (userData != null) {
        // Safely cast the grades data
        Map<String, dynamic> grades = {};
        if (userData['grades'] != null) {
          try {
            grades = Map<String, dynamic>.from(userData['grades'] as Map<dynamic, dynamic>);
          } catch (e) {
            grades = {};
          }
        }
        
        // Safely cast the student_record data
        Map<String, dynamic> studentRecord = {};
        if (userData['student_record'] != null) {
          try {
            studentRecord = Map<String, dynamic>.from(userData['student_record'] as Map<dynamic, dynamic>);
          } catch (e) {
            studentRecord = {};
          }
        }
        
        // Fetch domains from student branch if user is a student
        if (userData['category'] == 'student') {
          final domains = await _authService.fetchDomainsFromStudentBranch(userData['id']);
          userData['domain1'] = domains['domain1'];
          userData['domain2'] = domains['domain2'];
        }
        
        setState(() {
          _userData = userData;
          _gpa = _authService.calculateGPA(grades);
          _topAchievements = _getTopAchievements(studentRecord);
          _isLoading = false;
        });
        
        // Debug profile photo loading
        if (userData['profile_photo'] != null && userData['profile_photo'].toString().isNotEmpty) {
          print('Dashboard: Profile photo found - ${userData['profile_photo'].toString().substring(0, 50)}...');
          print('Dashboard: Profile photo type - ${userData['profile_photo'].toString().startsWith('data:') ? 'Base64 Data URL' : userData['profile_photo'].toString().startsWith('http') ? 'Network URL' : 'Base64 String'}');
        } else {
          print('Dashboard: No profile photo found');
        }
        
        // Enhanced domain logging
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
    final Color studentPrimary = ColorUtils.primaryBlue;

    if (_isLoading) {
      return Scaffold(
        appBar: EnhancedAppBar(
          title: "Dashboard",
          backgroundColor: studentPrimary,
          foregroundColor: Colors.white,
          enableGradient: true,
          gradientColors: [
            studentPrimary,
            studentPrimary.withOpacity(0.8),
          ],
        ),
        drawer: MainDrawer(context: context),
        body: LoadingComponents.buildModernLoadingIndicator(
          message: "Loading your dashboard...",
          context: context,
        ),
      );
    }

    if (_hasError) {
      return Scaffold(
        appBar: EnhancedAppBar(
          title: "Dashboard",
          backgroundColor: studentPrimary,
          foregroundColor: Colors.white,
          enableGradient: true,
          gradientColors: [
            studentPrimary,
            studentPrimary.withOpacity(0.8),
          ],
        ),
        drawer: MainDrawer(context: context),
        body: Center(
          child: Padding(
            padding: ResponsiveUtils.getResponsivePadding(context),
            child: ErrorComponents.buildErrorState(
              title: 'Failed to Load Dashboard',
              message: _errorMessage.isNotEmpty 
                  ? _errorMessage 
                  : 'Unable to load your dashboard data. Please check your connection and try again.',
              icon: Icons.dashboard_outlined,
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

    return Scaffold(
      appBar: EnhancedAppBar(
        title: "Dashboard",
        subtitle: "Welcome back!",
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
    );
  }

  // ---------------- Widgets ----------------
  Widget personalCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return AnimationUtils.buildAnimatedCard(
      duration: AnimationUtils.normalDuration,
      curve: AnimationUtils.normalCurve,
      elevation: ResponsiveUtils.getResponsiveElevation(context, 4),
      child: Container(
        margin: ResponsiveUtils.getResponsiveMargin(context),
        child: Card(
        elevation: ResponsiveUtils.getResponsiveElevation(context, 4),
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                colorScheme.surfaceContainerHighest,
              ],
            ),
          ),
      child: Padding(
            padding: ResponsiveUtils.getResponsivePadding(context),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                    // Profile Avatar with enhanced styling
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: ResponsiveUtils.getResponsiveIconSize(context, 50),
                  backgroundColor: colorScheme.primaryContainer,
                  backgroundImage: _userData?['profile_photo'] != null && _userData!['profile_photo'].isNotEmpty
                      ? _getImageProvider(_userData!['profile_photo'])
                      : null,
                  child: _userData?['profile_photo'] == null || _userData!['profile_photo'].isEmpty
                            ? Icon(
                                Icons.person_rounded, 
                                size: ResponsiveUtils.getResponsiveIconSize(context, 50), 
                                color: colorScheme.onPrimaryContainer
                              )
                      : null,
                ),
                    ),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                    
                    // Name with gradient text
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                  _userData?['name'] ?? "Loading...",
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
                    
                    // Student ID with chip-like styling
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.getResponsiveSpacing(context, 12),
                        vertical: ResponsiveUtils.getResponsiveSpacing(context, 4),
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
                      ),
                      child: Text(
                        "ID: ${_userData?['student_id'] ?? 'Loading...'}",
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                    
                    // Divider with gradient
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            colorScheme.outline.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                    
                    // Details with enhanced styling
                Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        _buildModernDetailRow(context, Icons.school_rounded, "Branch", _userData?['branch'] ?? 'Loading...', colorScheme, textTheme),
                        _buildModernDetailRow(context, Icons.account_balance_rounded, "Institute", _userData?['institute'] ?? 'Loading...', colorScheme, textTheme),
                        _buildModernDetailRow(context, Icons.person_outline_rounded, "Faculty Advisor", _userData?['faculty_advisor'] ?? 'Loading...', colorScheme, textTheme),
                        _buildModernDetailRow(context, Icons.work_outline_rounded, "Domain 1", _getDomainDisplay(_userData?['domain1']), colorScheme, textTheme),
                        _buildModernDetailRow(context, Icons.work_outline_rounded, "Domain 2", _getDomainDisplay(_userData?['domain2']), colorScheme, textTheme),
                  ],
                ),
              ],
            ),
                
                // Enhanced Edit Button
            Positioned(
              top: 0,
              right: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StudentEditProfilePage()),
                    );
                    if (result == true) {
                      refreshData();
                    }
                  },
                  child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
                          vertical: ResponsiveUtils.getResponsiveSpacing(context, 8),
                        ),
                    decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [colorScheme.primary, colorScheme.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                            Icon(
                              Icons.edit_rounded, 
                              size: ResponsiveUtils.getResponsiveIconSize(context, 16), 
                              color: colorScheme.onPrimary
                            ),
                            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 4)),
                            Text(
                              "Edit", 
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.onPrimary, 
                                fontWeight: FontWeight.w600
                              )
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
            ),
          ),
        ),
      ),
      ),
    );
  }


  Widget _buildModernDetailRow(BuildContext context, IconData icon, String label, String value, ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ResponsiveUtils.getResponsiveSpacing(context, 4)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getResponsiveSpacing(context, 12),
        vertical: ResponsiveUtils.getResponsiveSpacing(context, 8),
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 8)),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 8)),
            ),
            child: Icon(
              icon, 
              size: ResponsiveUtils.getResponsiveIconSize(context, 16), 
              color: colorScheme.primary
            ),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 2)),
                Text(
                  value,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
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
  ImageProvider? _getImageProvider(String? imagePath) {
    return ImageUtils.getImageProvider(imagePath);
  }

  Widget gpaCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return AnimationUtils.buildAnimatedCard(
      duration: AnimationUtils.normalDuration,
      curve: AnimationUtils.normalCurve,
      elevation: ResponsiveUtils.getResponsiveElevation(context, 4),
      child: Container(
        margin: ResponsiveUtils.getResponsiveMargin(context),
        child: Card(
        elevation: ResponsiveUtils.getResponsiveElevation(context, 4),
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                colorScheme.primaryContainer.withOpacity(0.1),
              ],
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SemesterInfoPage()),
          );
        },
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
        child: Padding(
                padding: ResponsiveUtils.getResponsivePadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with icon and semester info
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 8)),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [colorScheme.primary, colorScheme.secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
                          ),
                          child: Icon(
                            Icons.school_rounded,
                            color: colorScheme.onPrimary,
                            size: ResponsiveUtils.getResponsiveIconSize(context, 20),
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                                "Academic Performance",
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                "Semester ${_userData?['current_semester'] ?? 'Loading...'}",
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: colorScheme.primary,
                          size: ResponsiveUtils.getResponsiveIconSize(context, 16),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                    
                    // GPA Display with enhanced styling
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current GPA",
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
                            Text(
                              "${_gpa.toStringAsFixed(2)}",
                              style: textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                            Text(
                              "out of 10.0",
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 16)),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.trending_up_rounded,
                color: colorScheme.primary,
                                size: ResponsiveUtils.getResponsiveIconSize(context, 24),
                              ),
                              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
                              Text(
                                "View Details",
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                    
                    // Enhanced Progress Bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Progress",
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${(_gpa / 10 * 100).toStringAsFixed(0)}%",
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                        Container(
                          height: ResponsiveUtils.getResponsiveSpacing(context, 8),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 4)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 4)),
                            child: LinearProgressIndicator(
                              value: _gpa / 10,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _gpa >= 8.0 
                                    ? Colors.green
                                    : _gpa >= 6.0 
                                        ? Colors.orange
                                        : colorScheme.error
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
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
    final bool isGoodAttendance = attendancePercentage >= 0.75;

    return AnimationUtils.buildAnimatedCard(
      duration: AnimationUtils.normalDuration,
      curve: AnimationUtils.normalCurve,
      elevation: ResponsiveUtils.getResponsiveElevation(context, 4),
      child: Container(
        margin: ResponsiveUtils.getResponsiveMargin(context),
        child: Card(
        elevation: ResponsiveUtils.getResponsiveElevation(context, 4),
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                isGoodAttendance 
                    ? Colors.green.withOpacity(0.1)
                    : colorScheme.errorContainer.withOpacity(0.1),
              ],
            ),
          ),
          child: Material(
            color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SemesterInfoPage(startTabIndex: 1),
            ),
          );
        },
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
        child: Padding(
                padding: ResponsiveUtils.getResponsivePadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with status indicator
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 8)),
                          decoration: BoxDecoration(
                            color: isGoodAttendance 
                                ? Colors.green.withOpacity(0.2)
                                : colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
                          ),
                          child: Icon(
                            isGoodAttendance 
                                ? Icons.check_circle_rounded
                                : Icons.warning_rounded,
                            color: isGoodAttendance 
                                ? Colors.green
                                : colorScheme.error,
                            size: ResponsiveUtils.getResponsiveIconSize(context, 20),
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Attendance Overview",
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                isGoodAttendance ? "Excellent attendance!" : "Needs improvement",
                                style: textTheme.bodySmall?.copyWith(
                                  color: isGoodAttendance 
                                      ? Colors.green
                                      : colorScheme.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: colorScheme.primary,
                          size: ResponsiveUtils.getResponsiveIconSize(context, 16),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                    
                    // Attendance percentage with visual emphasis
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current Attendance",
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
                            Text(
                              "${(attendancePercentage * 100).toStringAsFixed(0)}%",
                              style: textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isGoodAttendance 
                                    ? Colors.green
                                    : colorScheme.error,
                              ),
                            ),
                            Text(
                              "out of 100%",
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 16)),
                          decoration: BoxDecoration(
                            color: isGoodAttendance 
                                ? Colors.green.withOpacity(0.2)
                                : colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                color: isGoodAttendance 
                                    ? Colors.green
                                    : colorScheme.error,
                                size: ResponsiveUtils.getResponsiveIconSize(context, 24),
                              ),
                              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
                              Text(
                                "View Details",
                                style: textTheme.labelSmall?.copyWith(
                                  color: isGoodAttendance 
                                      ? Colors.green
                                      : colorScheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                    
                    // Enhanced Progress Bar with status colors
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Progress",
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${(attendancePercentage * 100).toStringAsFixed(0)}%",
                              style: textTheme.labelMedium?.copyWith(
                                color: isGoodAttendance 
                                    ? Colors.green
                                    : colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                        Container(
                          height: ResponsiveUtils.getResponsiveSpacing(context, 8),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 4)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 4)),
                            child: LinearProgressIndicator(
                value: attendancePercentage,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isGoodAttendance 
                                    ? Colors.green
                                    : colorScheme.error
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                        // Status message
                        Text(
                          isGoodAttendance 
                              ? "Keep up the great work! 🎉"
                              : "Consider improving your attendance 📚",
                          style: textTheme.bodySmall?.copyWith(
                              color: isGoodAttendance 
                                  ? Colors.green
                                  : colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
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

    return AnimationUtils.buildAnimatedCard(
      duration: AnimationUtils.normalDuration,
      curve: AnimationUtils.normalCurve,
      elevation: ResponsiveUtils.getResponsiveElevation(context, 4),
      child: Container(
      margin: ResponsiveUtils.getResponsiveMargin(context),
      child: Card(
        elevation: ResponsiveUtils.getResponsiveElevation(context, 4),
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                colorScheme.tertiaryContainer.withOpacity(0.1),
              ],
            ),
          ),
          child: Material(
            color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AchievementsPage()),
          );
        },
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
        child: Padding(
                padding: ResponsiveUtils.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                    // Header with icon and title
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 8)),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [colorScheme.tertiary, colorScheme.primary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
                          ),
                          child: Icon(
                            Icons.workspace_premium_rounded,
                            color: colorScheme.onPrimary,
                            size: ResponsiveUtils.getResponsiveIconSize(context, 20),
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Student Record",
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                "Your achievements & accomplishments",
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: colorScheme.primary,
                          size: ResponsiveUtils.getResponsiveIconSize(context, 16),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                    
                    // Achievements list with enhanced styling
                    if (_topAchievements.isNotEmpty) ...[
                      ..._topAchievements.asMap().entries.map((entry) {
                        final index = entry.key;
                        final achievement = entry.value;
                        return Container(
                          margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.getResponsiveSpacing(context, 12),
                            vertical: ResponsiveUtils.getResponsiveSpacing(context, 8),
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
                            border: Border.all(
                              color: colorScheme.outline.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                child: Row(
                  children: [
                              // Achievement number badge
                              Container(
                                width: ResponsiveUtils.getResponsiveSpacing(context, 24),
                                height: ResponsiveUtils.getResponsiveSpacing(context, 24),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [colorScheme.primary, colorScheme.secondary],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                              // Achievement details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      achievement['title'] ?? 'Achievement',
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 2)),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: ResponsiveUtils.getResponsiveSpacing(context, 6),
                                            vertical: ResponsiveUtils.getResponsiveSpacing(context, 2),
                                          ),
                                          decoration: BoxDecoration(
                                            color: colorScheme.primaryContainer,
                                            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 8)),
                                          ),
                                          child: Text(
                                            achievement['category'] ?? 'General',
                                            style: textTheme.labelSmall?.copyWith(
                                              color: colorScheme.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                                        Icon(
                                          Icons.star_rounded,
                                          color: Colors.orange,
                                          size: ResponsiveUtils.getResponsiveIconSize(context, 14),
                                        ),
                                        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 2)),
                                        Text(
                                          '${achievement['points'] ?? 0} pts',
                                          style: textTheme.labelSmall?.copyWith(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: ResponsiveUtils.getResponsiveIconSize(context, 14),
                                color: colorScheme.onSurfaceVariant,
                ),
            ],
          ),
                        );
                      }),
                    ] else ...[
                      // Empty state with enhanced styling
                      Container(
                        padding: ResponsiveUtils.getResponsivePadding(context),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.emoji_events_outlined,
                              size: ResponsiveUtils.getResponsiveIconSize(context, 48),
                              color: colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                            Text(
                              "No achievements yet",
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
                            Text(
                              "Start building your student record!",
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget quickButtons(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return AnimationUtils.buildAnimatedCard(
      duration: AnimationUtils.normalDuration,
      curve: AnimationUtils.normalCurve,
      elevation: ResponsiveUtils.getResponsiveElevation(context, 4),
      child: Container(
      margin: ResponsiveUtils.getResponsiveMargin(context),
      child: Row(
      children: [
        Expanded(
            child: _buildModernQuickButton(
              context: context,
              icon: Icons.download_rounded,
              label: "Download Profile",
            onPressed: () { /* TODO: Implement Download Profile */ },
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
        Expanded(
            child: _buildModernQuickButton(
              context: context,
              icon: Icons.analytics_rounded,
              label: "View Analytics",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StudentAnalyticsPage()),
              );
            },
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildModernQuickButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: ResponsiveUtils.getResponsiveElevation(context, 8),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
              vertical: ResponsiveUtils.getResponsiveSpacing(context, 16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: colorScheme.onPrimary,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 24),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                Text(
                  label,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
