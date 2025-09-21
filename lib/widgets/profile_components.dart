import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../utils/color_utils.dart';
import '../utils/typography_utils.dart';
import '../utils/spacing_utils.dart';
import '../utils/accessibility_utils.dart';
import 'button_components.dart';

/// Modern profile components with consistent styling and better visual hierarchy
class ModernProfileComponents {

  /// Modern profile header with avatar and basic information
  static Widget buildProfileHeader({
    required String name,
    required String subtitle,
    Widget? avatar,
    String? avatarUrl,
    List<Widget>? actions,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AccessibilityUtils.buildSemanticCard(
      label: semanticLabel ?? 'Profile header: $name',
      child: Container(
        padding: padding ?? SpacingUtils.cardPaddingAll,
        margin: margin ?? SpacingUtils.cardMarginAll,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorUtils.primaryBlue.withOpacity(0.1),
              ColorUtils.primaryBlue.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20.0)),
        ),
        child: Column(
          children: [
            // Avatar and basic info
            Row(
              children: [
                _buildProfileAvatar(
                  context: context,
                  avatar: avatar,
                  avatarUrl: avatarUrl,
                  name: name,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TypographyUtils.headlineSmallStyle.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: AccessibilityUtils.getAccessibleFontSize(
                            context,
                            TypographyUtils.headlineSmallStyle.fontSize ?? 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TypographyUtils.bodyLargeStyle.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: AccessibilityUtils.getAccessibleFontSize(
                            context,
                            TypographyUtils.bodyLargeStyle.fontSize ?? 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Actions
            if (actions != null) ...[
              const SizedBox(height: 16),
              Row(
                children: actions
                    .map((action) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: action,
                          ),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Profile avatar with modern styling
  static Widget _buildProfileAvatar({
    required BuildContext context,
    Widget? avatar,
    String? avatarUrl,
    required String name,
  }) {
    final size = ResponsiveUtils.getResponsiveIconSize(context, 80.0);

    if (avatar != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ColorUtils.primaryBlue.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: avatar,
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            ColorUtils.primaryBlue,
            ColorUtils.primaryBlue.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorUtils.primaryBlue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: avatarUrl != null
          ? ClipOval(
              child: Image.network(
                avatarUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(context, name, size),
              ),
            )
          : _buildDefaultAvatar(context, name, size),
    );
  }

  /// Default avatar with initials
  static Widget _buildDefaultAvatar(BuildContext context, String name, double size) {
    final initials = name
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .take(2)
        .join('');

    return Center(
      child: Text(
        initials,
        style: TypographyUtils.headlineMediumStyle.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.4,
        ),
      ),
    );
  }

  /// Profile information section
  static Widget buildProfileInfoSection({
    required String title,
    required List<ProfileInfoItem> items,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AccessibilityUtils.buildSemanticCard(
      label: semanticLabel ?? 'Profile information: $title',
      child: Container(
        padding: padding ?? SpacingUtils.cardPaddingAll,
        margin: margin ?? SpacingUtils.cardMarginAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TypographyUtils.titleLargeStyle.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: AccessibilityUtils.getAccessibleFontSize(
                  context,
                  TypographyUtils.titleLargeStyle.fontSize ?? 22,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...items.map((item) => _buildProfileInfoItem(
              context: context,
              item: item,
            )),
          ],
        ),
      ),
    );
  }

  /// Build individual profile info item
  static Widget _buildProfileInfoItem({
    required BuildContext context,
    required ProfileInfoItem item,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorUtils.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              item.icon,
              color: ColorUtils.primaryBlue,
              size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: TypographyUtils.bodyMediumStyle.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: AccessibilityUtils.getAccessibleFontSize(
                      context,
                      TypographyUtils.bodyMediumStyle.fontSize ?? 14,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                if (item.value is Widget)
                  item.value as Widget
                else
                  Text(
                    item.value.toString(),
                    style: TypographyUtils.bodyLargeStyle.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                      fontSize: AccessibilityUtils.getAccessibleFontSize(
                        context,
                        TypographyUtils.bodyLargeStyle.fontSize ?? 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Action
          if (item.onTap != null)
            IconButton(
              icon: Icon(
                Icons.edit,
                color: ColorUtils.primaryBlue,
                size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
              ),
              onPressed: item.onTap,
            ),
        ],
      ),
    );
  }

  /// Profile stats section
  static Widget buildProfileStatsSection({
    required List<ProfileStatItem> stats,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    String? semanticLabel,
    required BuildContext context,
  }) {
    return AccessibilityUtils.buildSemanticCard(
      label: semanticLabel ?? 'Profile statistics',
      child: Container(
        padding: padding ?? SpacingUtils.cardPaddingAll,
        margin: margin ?? SpacingUtils.cardMarginAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: TypographyUtils.titleLargeStyle.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: AccessibilityUtils.getAccessibleFontSize(
                  context,
                  TypographyUtils.titleLargeStyle.fontSize ?? 22,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildStatsGrid(context: context, stats: stats),
          ],
        ),
      ),
    );
  }

  /// Build stats grid
  static Widget _buildStatsGrid({
    required BuildContext context,
    required List<ProfileStatItem> stats,
  }) {
    final crossAxisCount = ResponsiveUtils.isMobile(context) ? 2 : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.2,
        crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
        mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => _buildStatCard(
        context: context,
        stat: stats[index],
      ),
    );
  }

  /// Build individual stat card
  static Widget _buildStatCard({
    required BuildContext context,
    required ProfileStatItem stat,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: stat.color?.withOpacity(0.1) ?? ColorUtils.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0)),
        border: Border.all(
          color: stat.color?.withOpacity(0.2) ?? ColorUtils.primaryBlue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            stat.icon,
            color: stat.color ?? ColorUtils.primaryBlue,
            size: ResponsiveUtils.getResponsiveIconSize(context, 32.0),
          ),
          const SizedBox(height: 8),
          Text(
            stat.value,
            style: TypographyUtils.headlineSmallStyle.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                TypographyUtils.headlineSmallStyle.fontSize ?? 24,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.label,
            style: TypographyUtils.bodySmallStyle.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                TypographyUtils.bodySmallStyle.fontSize ?? 12,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Profile achievements section
  static Widget buildProfileAchievementsSection({
    required List<ProfileAchievementItem> achievements,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AccessibilityUtils.buildSemanticCard(
      label: semanticLabel ?? 'Profile achievements',
      child: Container(
        padding: padding ?? SpacingUtils.cardPaddingAll,
        margin: margin ?? SpacingUtils.cardMarginAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Achievements',
              style: TypographyUtils.titleLargeStyle.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: AccessibilityUtils.getAccessibleFontSize(
                  context,
                  TypographyUtils.titleLargeStyle.fontSize ?? 22,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...achievements.map((achievement) => _buildAchievementItem(
              context: context,
              achievement: achievement,
            )),
          ],
        ),
      ),
    );
  }

  /// Build individual achievement item
  static Widget _buildAchievementItem({
    required BuildContext context,
    required ProfileAchievementItem achievement,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: achievement.isUnlocked 
            ? Colors.green.withOpacity(0.1)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12.0)),
        border: Border.all(
          color: achievement.isUnlocked 
              ? Colors.green.withOpacity(0.3)
              : colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: achievement.isUnlocked 
                  ? Colors.green.withOpacity(0.2)
                  : colorScheme.onSurface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              achievement.icon,
              color: achievement.isUnlocked 
                  ? Colors.green
                  : colorScheme.onSurface.withOpacity(0.5),
              size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TypographyUtils.titleMediumStyle.copyWith(
                    color: achievement.isUnlocked 
                        ? colorScheme.onSurface
                        : colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                    fontSize: AccessibilityUtils.getAccessibleFontSize(
                      context,
                      TypographyUtils.titleMediumStyle.fontSize ?? 16,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: TypographyUtils.bodyMediumStyle.copyWith(
                    color: achievement.isUnlocked 
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurfaceVariant.withOpacity(0.6),
                    fontSize: AccessibilityUtils.getAccessibleFontSize(
                      context,
                      TypographyUtils.bodyMediumStyle.fontSize ?? 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Status
          if (achievement.isUnlocked)
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
            ),
        ],
      ),
    );
  }

  /// Profile edit form
  static Widget buildProfileEditForm({
    required GlobalKey<FormState> formKey,
    required List<ProfileFormField> fields,
    required VoidCallback onSave,
    VoidCallback? onCancel,
    bool isLoading = false,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AccessibilityUtils.buildSemanticCard(
      label: semanticLabel ?? 'Profile edit form',
      child: Container(
        padding: padding ?? SpacingUtils.cardPaddingAll,
        margin: margin ?? SpacingUtils.cardMarginAll,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Profile',
                style: TypographyUtils.titleLargeStyle.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: AccessibilityUtils.getAccessibleFontSize(
                    context,
                    TypographyUtils.titleLargeStyle.fontSize ?? 22,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ...fields.map((field) => _buildFormField(
                context: context,
                field: field,
              )),
              const SizedBox(height: 24),
              // Actions
              Row(
                children: [
                  if (onCancel != null) ...[
                    Expanded(
                      child: ModernButtonComponents.buildSecondaryButton(
                        context: context,
                        text: 'Cancel',
                        onPressed: onCancel,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ModernButtonComponents.buildPrimaryButton(
                      context: context,
                      text: 'Save',
                      onPressed: isLoading ? null : onSave,
                      isLoading: isLoading,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build form field
  static Widget _buildFormField({
    required BuildContext context,
    required ProfileFormField field,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: TypographyUtils.labelLargeStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                TypographyUtils.labelLargeStyle.fontSize ?? 14,
              ),
            ),
          ),
          const SizedBox(height: 8),
          field.builder(context),
        ],
      ),
    );
  }
}

/// Data class for profile info items
class ProfileInfoItem {
  final String label;
  final dynamic value;
  final IconData icon;
  final VoidCallback? onTap;

  const ProfileInfoItem({
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
  });
}

/// Data class for profile stat items
class ProfileStatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const ProfileStatItem({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });
}

/// Data class for profile achievement items
class ProfileAchievementItem {
  final String title;
  final String description;
  final IconData icon;
  final bool isUnlocked;

  const ProfileAchievementItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
  });
}

/// Data class for profile form fields
class ProfileFormField {
  final String label;
  final Widget Function(BuildContext) builder;

  const ProfileFormField({
    required this.label,
    required this.builder,
  });
}
