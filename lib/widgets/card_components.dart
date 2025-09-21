import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../utils/color_utils.dart';
import '../utils/typography_utils.dart';
import '../utils/spacing_utils.dart';
import '../utils/accessibility_utils.dart';

/// Modern card components with consistent styling and better layouts
class ModernCardComponents {
  static const Duration _animationDuration = Duration(milliseconds: 200);

  /// Basic modern card with consistent styling
  static Widget buildModernCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    double? elevation,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    bool isInteractive = false,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveElevation = elevation ?? ResponsiveUtils.getResponsiveElevation(context, 2.0);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0));

    Widget cardContent = Container(
      margin: margin ?? SpacingUtils.cardMarginAll,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: effectiveBorderRadius,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: effectiveElevation,
            offset: Offset(0, effectiveElevation / 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: padding ?? SpacingUtils.cardPaddingAll,
            child: child,
          ),
        ),
      ),
    );

    if (isInteractive && onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: cardContent,
        ),
      );
    }

    return AccessibilityUtils.buildSemanticCard(
      label: semanticLabel ?? 'Card',
      child: AnimatedContainer(
        duration: _animationDuration,
        child: cardContent,
      ),
    );
  }

  /// Elevated card with stronger shadow and modern styling
  static Widget buildElevatedCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    double? elevation,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    bool isInteractive = false,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveElevation = elevation ?? ResponsiveUtils.getResponsiveElevation(context, 8.0);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20.0));

    Widget cardContent = Container(
      margin: margin ?? SpacingUtils.cardMarginAll,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: effectiveBorderRadius,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.15),
            blurRadius: effectiveElevation,
            offset: Offset(0, effectiveElevation / 2),
          ),
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: effectiveElevation * 2,
            offset: Offset(0, effectiveElevation),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: padding ?? SpacingUtils.cardPaddingAll,
            child: child,
          ),
        ),
      ),
    );

    if (isInteractive && onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: cardContent,
        ),
      );
    }

    return AccessibilityUtils.buildSemanticCard(
      label: semanticLabel ?? 'Elevated card',
      child: AnimatedContainer(
        duration: _animationDuration,
        child: cardContent,
      ),
    );
  }

  /// Gradient card with beautiful gradient background
  static Widget buildGradientCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Gradient? gradient,
    double? elevation,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    bool isInteractive = false,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final effectiveElevation = elevation ?? ResponsiveUtils.getResponsiveElevation(context, 4.0);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20.0));
    final effectiveGradient = gradient ?? LinearGradient(
      colors: [
        ColorUtils.primaryBlue,
        ColorUtils.primaryBlue.withOpacity(0.8),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    Widget cardContent = Container(
      margin: margin ?? SpacingUtils.cardMarginAll,
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        borderRadius: effectiveBorderRadius,
        boxShadow: [
          BoxShadow(
            color: ColorUtils.primaryBlue.withOpacity(0.3),
            blurRadius: effectiveElevation,
            offset: Offset(0, effectiveElevation / 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: padding ?? SpacingUtils.cardPaddingAll,
            child: child,
          ),
        ),
      ),
    );

    if (isInteractive && onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: cardContent,
        ),
      );
    }

    return AccessibilityUtils.buildSemanticCard(
      label: semanticLabel ?? 'Gradient card',
      child: AnimatedContainer(
        duration: _animationDuration,
        child: cardContent,
      ),
    );
  }

  /// Outlined card with border styling
  static Widget buildOutlinedCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    bool isInteractive = false,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0));
    final effectiveBorderColor = borderColor ?? colorScheme.outline;
    final effectiveBorderWidth = borderWidth ?? 1.0;

    Widget cardContent = Container(
      margin: margin ?? SpacingUtils.cardMarginAll,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: effectiveBorderRadius,
        border: Border.all(
          color: effectiveBorderColor,
          width: effectiveBorderWidth,
        ),
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: padding ?? SpacingUtils.cardPaddingAll,
            child: child,
          ),
        ),
      ),
    );

    if (isInteractive && onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: cardContent,
        ),
      );
    }

    return AccessibilityUtils.buildSemanticCard(
      label: semanticLabel ?? 'Outlined card',
      child: AnimatedContainer(
        duration: _animationDuration,
        child: cardContent,
      ),
    );
  }

  /// Dashboard card with header and content sections
  static Widget buildDashboardCard({
    required String title,
    required Widget content,
    Widget? subtitle,
    Widget? trailing,
    IconData? leadingIcon,
    Color? iconColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    double? elevation,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    bool isInteractive = false,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveIconColor = iconColor ?? ColorUtils.primaryBlue;

    return buildModernCard(
      context: context,
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      onTap: onTap,
      isInteractive: isInteractive,
      semanticLabel: semanticLabel ?? 'Dashboard card: $title',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Row(
            children: [
              if (leadingIcon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: effectiveIconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    leadingIcon,
                    color: effectiveIconColor,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TypographyUtils.titleMediumStyle.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: AccessibilityUtils.getAccessibleFontSize(
                          context,
                          TypographyUtils.titleMediumStyle.fontSize ?? 16,
                        ),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      DefaultTextStyle(
                        style: TypographyUtils.bodySmallStyle.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: AccessibilityUtils.getAccessibleFontSize(
                            context,
                            TypographyUtils.bodySmallStyle.fontSize ?? 12,
                          ),
                        ),
                        child: subtitle,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 16),
          // Content section
          content,
        ],
      ),
    );
  }

  /// Stats card for displaying metrics and statistics
  static Widget buildStatsCard({
    required String title,
    required String value,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    Color? valueColor,
    Widget? trend,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    double? elevation,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    bool isInteractive = false,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveIconColor = iconColor ?? ColorUtils.primaryBlue;
    final effectiveValueColor = valueColor ?? colorScheme.onSurface;

    return buildModernCard(
      context: context,
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      onTap: onTap,
      isInteractive: isInteractive,
      semanticLabel: semanticLabel ?? 'Stats card: $title',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: effectiveIconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: effectiveIconColor,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TypographyUtils.bodyMediumStyle.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: AccessibilityUtils.getAccessibleFontSize(
                      context,
                      TypographyUtils.bodyMediumStyle.fontSize ?? 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Value
          Text(
            value,
            style: TypographyUtils.headlineSmallStyle.copyWith(
              color: effectiveValueColor,
              fontWeight: FontWeight.bold,
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                TypographyUtils.headlineSmallStyle.fontSize ?? 24,
              ),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TypographyUtils.bodySmallStyle.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: AccessibilityUtils.getAccessibleFontSize(
                  context,
                  TypographyUtils.bodySmallStyle.fontSize ?? 12,
                ),
              ),
            ),
          ],
          if (trend != null) ...[
            const SizedBox(height: 8),
            trend,
          ],
        ],
      ),
    );
  }

  /// Profile card for user information display
  static Widget buildProfileCard({
    required String name,
    required String subtitle,
    Widget? avatar,
    String? avatarUrl,
    List<Widget>? actions,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    double? elevation,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    bool isInteractive = false,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return buildModernCard(
      context: context,
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      onTap: onTap,
      isInteractive: isInteractive,
      semanticLabel: semanticLabel ?? 'Profile card: $name',
      child: Column(
        children: [
          // Avatar and basic info
          Row(
            children: [
              avatar ?? CircleAvatar(
                radius: ResponsiveUtils.getResponsiveIconSize(context, 30.0),
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                backgroundColor: ColorUtils.primaryBlue.withOpacity(0.1),
                child: avatarUrl == null
                    ? Icon(
                        Icons.person,
                        color: ColorUtils.primaryBlue,
                        size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TypographyUtils.titleMediumStyle.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: AccessibilityUtils.getAccessibleFontSize(
                          context,
                          TypographyUtils.titleMediumStyle.fontSize ?? 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TypographyUtils.bodyMediumStyle.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: AccessibilityUtils.getAccessibleFontSize(
                          context,
                          TypographyUtils.bodyMediumStyle.fontSize ?? 14,
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
                  .map((action) => Expanded(child: action))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// List card for displaying list items in a card format
  static Widget buildListCard({
    required List<Widget> children,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    double? elevation,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    bool isInteractive = false,
    String? semanticLabel,
    required BuildContext context,
  }) {
    return buildModernCard(
      context: context,
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      onTap: onTap,
      isInteractive: isInteractive,
      semanticLabel: semanticLabel ?? 'List card',
      child: Column(
        children: children
            .expand((child) => [
                  child,
                  if (child != children.last)
                    Divider(
                      height: 1,
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    ),
                ])
            .toList(),
      ),
    );
  }

  /// Card grid for displaying multiple cards in a responsive grid
  static Widget buildCardGrid({
    required List<Widget> cards,
    int? crossAxisCount,
    double? childAspectRatio,
    double? crossAxisSpacing,
    double? mainAxisSpacing,
    EdgeInsetsGeometry? padding,
    required BuildContext context,
  }) {
    final effectiveCrossAxisCount = crossAxisCount ?? (ResponsiveUtils.isMobile(context) ? 1 : ResponsiveUtils.isTablet(context) ? 2 : 3);
    final effectiveChildAspectRatio = childAspectRatio ?? (ResponsiveUtils.isMobile(context) ? 1.2 : 1.0);
    final effectiveCrossAxisSpacing = crossAxisSpacing ?? ResponsiveUtils.getResponsiveSpacing(context, 16.0);
    final effectiveMainAxisSpacing = mainAxisSpacing ?? ResponsiveUtils.getResponsiveSpacing(context, 16.0);

    return Padding(
      padding: padding ?? SpacingUtils.screenPaddingAll,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: effectiveCrossAxisCount,
          childAspectRatio: effectiveChildAspectRatio,
          crossAxisSpacing: effectiveCrossAxisSpacing,
          mainAxisSpacing: effectiveMainAxisSpacing,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) => cards[index],
      ),
    );
  }
}
