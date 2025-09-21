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
import '../utils/responsive_utils.dart';
import '../utils/navigation_utils.dart';

// ---------------- GLOBAL DRAWER ----------------
class MainDrawer extends StatelessWidget {
  final BuildContext context;

  const MainDrawer({super.key, required this.context});

  void _signOut() {
    NavigationUtils.pushReplacementWithFade(
      context,
      const LoginPage(),
    );
  }

  void _semInfo() {
    NavigationUtils.pushReplacementWithSlide(
      context,
      const SemesterInfoPage(),
    );
  }

  void _dashboard() {
    NavigationUtils.pushReplacementWithSlide(
      context,
      const DashboardPage(),
    );
  }

  void _grades() {
    NavigationUtils.pushReplacementWithSlide(
      context,
      const GradesPage(),
    );
  }

  void _achievements() {
    NavigationUtils.pushReplacementWithSlide(
      context,
      const AchievementsPage(),
    );
  }

  void _searchFaculty() {
    NavigationUtils.pushWithSlide(
      context,
      const FacultySearchPage(),
    );
  }

  void _requestApproval() {
    NavigationUtils.pushReplacementWithSlide(
      context,
      const RequestApprovalPage(),
    );
  }

  void _approvalStatus() {
    NavigationUtils.pushReplacementWithSlide(
      context,
      const ApprovalStatusPage(),
    );
  }

  // Helper method to get appropriate image provider
  ImageProvider _getImageProvider(String imagePath) {
    
    ImageProvider provider;
    if (imagePath.startsWith('http')) {
      provider = NetworkImage(imagePath);
    } else if (imagePath.startsWith('/') || imagePath.startsWith('C:')) {
      provider = FileImage(File(imagePath));
    } else {
      provider = NetworkImage(imagePath);
    }
    
    return provider;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary,
              colorScheme.secondary,
              colorScheme.tertiary,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Enhanced Header Section
            Container(
              constraints: BoxConstraints(
                minHeight: ResponsiveUtils.getResponsiveSpacing(context, 180),
                maxHeight: ResponsiveUtils.getResponsiveSpacing(context, 220),
              ),
              padding: ResponsiveUtils.getResponsivePadding(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Profile Avatar with enhanced styling
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Builder(
                      builder: (context) {
                        final userData = AuthService().getCurrentUser();
                        final profilePhoto = userData?['profile_photo'];
                        
                        return CircleAvatar(
                          radius: ResponsiveUtils.getResponsiveIconSize(context, 50),
                          backgroundColor: Colors.white,
                          backgroundImage: profilePhoto != null && profilePhoto.isNotEmpty
                              ? _getImageProvider(profilePhoto)
                              : null,
                          child: profilePhoto == null || profilePhoto.isEmpty
                              ? Icon(
                                  Icons.person_rounded,
                                  size: ResponsiveUtils.getResponsiveIconSize(context, 50),
                                  color: colorScheme.primary,
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                  
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                  
                  // Name with gradient text
                  Builder(
                    builder: (context) {
                      final userData = AuthService().getCurrentUser();
                      final name = userData?['name'] ?? 'Student Name';
                      return ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.white, Colors.white.withOpacity(0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          name,
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                  
                  // Email with chip-like styling
                  Builder(
                    builder: (context) {
                      final userData = AuthService().getCurrentUser();
                      final email = userData?['email'] ?? 'student@university.edu';
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.getResponsiveSpacing(context, 8),
                          vertical: ResponsiveUtils.getResponsiveSpacing(context, 2),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
                        ),
                        child: Text(
                          email,
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Enhanced Menu Items
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 24)),
                    topRight: Radius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 24)),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                    
                    _buildModernDrawerItem(
                      context: context,
                      icon: Icons.dashboard_rounded,
                      title: "Dashboard",
                      subtitle: "Overview & quick access",
                      onTap: _dashboard,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    
                    _buildModernDrawerItem(
                      context: context,
                      icon: Icons.info_rounded,
                      title: "Semester Info",
                      subtitle: "Academic details",
                      onTap: _semInfo,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    
                    _buildModernDrawerItem(
                      context: context,
                      icon: Icons.grade_rounded,
                      title: "Grades",
                      subtitle: "Academic performance",
                      onTap: _grades,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    
                    _buildModernDrawerItem(
                      context: context,
                      icon: Icons.workspace_premium_rounded,
                      title: "Student Record",
                      subtitle: "Achievements & projects",
                      onTap: _achievements,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    
                    _buildModernDrawerItem(
                      context: context,
                      icon: Icons.search_rounded,
                      title: "Search Faculty",
                      subtitle: "Find faculty members",
                      onTap: _searchFaculty,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    
                    _buildModernDrawerItem(
                      context: context,
                      icon: Icons.assignment_turned_in_rounded,
                      title: "Request Approval",
                      subtitle: "Submit for review",
                      onTap: _requestApproval,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    
                    _buildModernDrawerItem(
                      context: context,
                      icon: Icons.history_rounded,
                      title: "Approval Status",
                      subtitle: "Track your requests",
                      onTap: _approvalStatus,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                    
                    // Divider with gradient
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16)),
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
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                    
                    _buildModernDrawerItem(
                      context: context,
                      icon: Icons.logout_rounded,
                      title: "Sign Out",
                      subtitle: "Logout from account",
                      onTap: _signOut,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                      isDestructive: true,
                    ),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildModernDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    bool isDestructive = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getResponsiveSpacing(context, 12),
        vertical: ResponsiveUtils.getResponsiveSpacing(context, 4),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
        color: isDestructive 
            ? colorScheme.errorContainer.withOpacity(0.1)
            : colorScheme.surfaceContainerHighest.withOpacity(0.3),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
              vertical: ResponsiveUtils.getResponsiveSpacing(context, 12),
            ),
            child: Row(
              children: [
                // Icon container
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 8)),
                  decoration: BoxDecoration(
                    color: isDestructive 
                        ? colorScheme.errorContainer
                        : colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive 
                        ? colorScheme.error
                        : colorScheme.primary,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 20),
                  ),
                ),
                
                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleSmall?.copyWith(
                          color: isDestructive 
                              ? colorScheme.error
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 2)),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: isDestructive 
                              ? colorScheme.error.withOpacity(0.7)
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDestructive 
                      ? colorScheme.error
                      : colorScheme.onSurfaceVariant,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
