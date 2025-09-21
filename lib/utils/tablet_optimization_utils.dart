import 'package:flutter/material.dart';
import 'responsive_utils.dart';
import 'color_utils.dart';
import 'typography_utils.dart';
import 'accessibility_utils.dart';

/// Tablet optimization utilities for adaptive design and better tablet UX
class TabletOptimizationUtils {
  /// Optimal touch target size for tablet devices
  static const double tabletTouchTargetSize = 52.0;
  
  /// Optimal spacing for tablet layouts
  static const double tabletSpacing = 24.0;
  
  /// Optimal border radius for tablet components
  static const double tabletBorderRadius = 16.0;
  
  /// Optimal elevation for tablet components
  static const double tabletElevation = 6.0;

  /// Get optimized touch target size for tablet
  static double getTabletTouchTargetSize(BuildContext context) {
    if (ResponsiveUtils.isTablet(context)) {
      return tabletTouchTargetSize;
    }
    return ResponsiveUtils.isMobile(context) ? 48.0 : 40.0;
  }

  /// Get optimized padding for tablet screens
  static EdgeInsets getTabletPadding(BuildContext context) {
    if (ResponsiveUtils.isTablet(context)) {
      return EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, tabletSpacing));
    }
    return EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 16.0));
  }

  /// Get optimized margin for tablet screens
  static EdgeInsets getTabletMargin(BuildContext context) {
    if (ResponsiveUtils.isTablet(context)) {
      return EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 12.0));
    }
    return EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 8.0));
  }

  /// Get optimized font size for tablet readability
  static double getTabletFontSize(BuildContext context, double baseFontSize) {
    if (ResponsiveUtils.isTablet(context)) {
      // Slightly larger font size for tablet readability
      return baseFontSize * 1.05;
    }
    return baseFontSize;
  }

  /// Get optimized icon size for tablet
  static double getTabletIconSize(BuildContext context, double baseIconSize) {
    if (ResponsiveUtils.isTablet(context)) {
      // Optimal icon size for tablet
      return baseIconSize.clamp(28.0, 36.0);
    }
    return baseIconSize;
  }

  /// Get optimized border radius for tablet
  static double getTabletBorderRadius(BuildContext context, double baseRadius) {
    if (ResponsiveUtils.isTablet(context)) {
      return tabletBorderRadius;
    }
    return baseRadius;
  }

  /// Get optimized elevation for tablet
  static double getTabletElevation(BuildContext context, double baseElevation) {
    if (ResponsiveUtils.isTablet(context)) {
      return tabletElevation;
    }
    return baseElevation;
  }

  /// Build tablet-optimized grid layout
  static Widget buildTabletGridLayout({
    required List<Widget> children,
    int? crossAxisCount,
    double? childAspectRatio,
    double? crossAxisSpacing,
    double? mainAxisSpacing,
    EdgeInsetsGeometry? padding,
    required BuildContext context,
  }) {
    final effectiveCrossAxisCount = crossAxisCount ?? getTabletGridColumns(context);
    final effectiveChildAspectRatio = childAspectRatio ?? getTabletAspectRatio(context);
    final effectiveCrossAxisSpacing = crossAxisSpacing ?? ResponsiveUtils.getResponsiveSpacing(context, 16.0);
    final effectiveMainAxisSpacing = mainAxisSpacing ?? ResponsiveUtils.getResponsiveSpacing(context, 16.0);

    return Padding(
      padding: padding ?? getTabletPadding(context),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: effectiveCrossAxisCount,
          childAspectRatio: effectiveChildAspectRatio,
          crossAxisSpacing: effectiveCrossAxisSpacing,
          mainAxisSpacing: effectiveMainAxisSpacing,
        ),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
    );
  }

  /// Build tablet-optimized card layout
  static Widget buildTabletCardLayout({
    required List<Widget> cards,
    int? crossAxisCount,
    double? childAspectRatio,
    double? crossAxisSpacing,
    double? mainAxisSpacing,
    EdgeInsetsGeometry? padding,
    required BuildContext context,
  }) {
    return buildTabletGridLayout(
      context: context,
      children: cards,
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      padding: padding,
    );
  }

  /// Build tablet-optimized list layout
  static Widget buildTabletListLayout({
    required List<Widget> items,
    bool isHorizontal = false,
    EdgeInsetsGeometry? padding,
    required BuildContext context,
  }) {
    if (isHorizontal) {
      return Container(
        height: getTabletTouchTargetSize(context) + 32,
        padding: padding ?? getTabletPadding(context),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.only(
              right: index < items.length - 1 ? ResponsiveUtils.getResponsiveSpacing(context, 16.0) : 0,
            ),
            child: items[index],
          ),
        ),
      );
    }

    return Padding(
      padding: padding ?? getTabletPadding(context),
      child: Column(
        children: items,
      ),
    );
  }

  /// Build tablet-optimized navigation rail
  static Widget buildTabletNavigationRail({
    required int selectedIndex,
    required ValueChanged<int> onDestinationSelected,
    required List<NavigationRailDestination> destinations,
    Widget? leading,
    Widget? trailing,
    double? elevation,
    Color? backgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveElevation = elevation ?? getTabletElevation(context, 4.0);

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: destinations,
      leading: leading,
      trailing: trailing,
      elevation: effectiveElevation,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      selectedIconTheme: IconThemeData(
        color: selectedItemColor ?? ColorUtils.primaryBlue,
      ),
      unselectedIconTheme: IconThemeData(
        color: unselectedItemColor ?? colorScheme.onSurfaceVariant,
      ),
      labelType: NavigationRailLabelType.all,
      extended: ResponsiveUtils.isTablet(context) && MediaQuery.of(context).size.width > 600,
    );
  }

  /// Build tablet-optimized app bar
  static Widget buildTabletAppBar({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    double? elevation,
    Color? backgroundColor,
    Color? foregroundColor,
    bool centerTitle = false,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveElevation = elevation ?? getTabletElevation(context, 4.0);

    return AppBar(
      title: Text(
        title,
        style: TypographyUtils.titleLargeStyle.copyWith(
          color: foregroundColor ?? colorScheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: AccessibilityUtils.getAccessibleFontSize(
            context,
            getTabletFontSize(context, 22.0),
          ),
        ),
      ),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: effectiveElevation,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      centerTitle: centerTitle,
      titleSpacing: ResponsiveUtils.getResponsiveSpacing(context, 24.0),
    );
  }

  /// Build tablet-optimized drawer
  static Widget buildTabletDrawer({
    required Widget child,
    double? width,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final effectiveWidth = width ?? (MediaQuery.of(context).size.width * 0.3);

    return Drawer(
      width: effectiveWidth,
      backgroundColor: theme.colorScheme.surface,
      child: SafeArea(
        child: child,
      ),
    );
  }

  /// Build tablet-optimized bottom navigation bar
  static Widget buildTabletBottomNavigationBar({
    required int currentIndex,
    required ValueChanged<int> onTap,
    required List<BottomNavigationBarItem> items,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: getTabletTouchTargetSize(context) + 20,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            items: items,
            type: BottomNavigationBarType.fixed,
            backgroundColor: colorScheme.surface,
            selectedItemColor: ColorUtils.primaryBlue,
            unselectedItemColor: colorScheme.onSurfaceVariant,
            selectedLabelStyle: TypographyUtils.labelSmallStyle.copyWith(
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                getTabletFontSize(context, 12.0),
              ),
            ),
            unselectedLabelStyle: TypographyUtils.labelSmallStyle.copyWith(
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                getTabletFontSize(context, 12.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build tablet-optimized floating action button
  static Widget buildTabletFloatingActionButton({
    required VoidCallback? onPressed,
    required Widget child,
    String? tooltip,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    required BuildContext context,
  }) {
    final effectiveElevation = elevation ?? getTabletElevation(context, 6.0);

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? ColorUtils.primaryBlue,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: effectiveElevation,
      child: child,
    );
  }

  /// Build tablet-optimized dialog
  static Widget buildTabletDialog({
    required Widget child,
    double? maxWidth,
    double? maxHeight,
    EdgeInsetsGeometry? padding,
    required BuildContext context,
  }) {
    final screenSize = MediaQuery.of(context).size;
    
    final effectiveMaxWidth = maxWidth ?? (screenSize.width * 0.6);
    final effectiveMaxHeight = maxHeight ?? (screenSize.height * 0.8);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(getTabletBorderRadius(context, 20.0)),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: effectiveMaxWidth,
          maxHeight: effectiveMaxHeight,
        ),
        padding: padding ?? getTabletPadding(context),
        child: child,
      ),
    );
  }

  /// Build tablet-optimized bottom sheet
  static Widget buildTabletBottomSheet({
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool isScrollControlled = true,
    double? maxHeight,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final effectiveMaxHeight = maxHeight ?? (screenHeight * 0.7);

    return Container(
      constraints: BoxConstraints(
        maxHeight: effectiveMaxHeight,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          if (title != null) ...[
            Padding(
              padding: getTabletPadding(context),
              child: Text(
                title,
                style: TypographyUtils.titleLargeStyle.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: AccessibilityUtils.getAccessibleFontSize(
                    context,
                    getTabletFontSize(context, 22.0),
                  ),
                ),
              ),
            ),
          ],
          // Content
          Flexible(
            child: child,
          ),
        ],
      ),
    );
  }

  /// Build tablet-optimized snackbar
  static void showTabletSnackBar({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
    SnackBarType type = SnackBarType.info,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        icon = Icons.check_circle;
        break;
      case SnackBarType.error:
        backgroundColor = colorScheme.error;
        textColor = colorScheme.onError;
        icon = Icons.error;
        break;
      case SnackBarType.warning:
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        icon = Icons.warning;
        break;
      case SnackBarType.info:
        backgroundColor = ColorUtils.primaryBlue;
        textColor = Colors.white;
        icon = Icons.info;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: textColor, size: getTabletIconSize(context, 24.0)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TypographyUtils.bodyMediumStyle.copyWith(
                  color: textColor,
                  fontSize: AccessibilityUtils.getAccessibleFontSize(
                    context,
                    getTabletFontSize(context, 14.0),
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getTabletBorderRadius(context, 12.0)),
        ),
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: textColor,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }

  /// Check if device is in tablet mode
  static bool isTabletMode(BuildContext context) {
    return ResponsiveUtils.isTablet(context);
  }

  /// Get tablet-optimized grid columns
  static int getTabletGridColumns(BuildContext context) {
    if (ResponsiveUtils.isTablet(context)) {
      return 2; // Two columns for tablet
    } else if (ResponsiveUtils.isMobile(context)) {
      return 1; // Single column for mobile
    } else {
      return 3; // Three columns for desktop
    }
  }

  /// Get tablet-optimized aspect ratio
  static double getTabletAspectRatio(BuildContext context) {
    if (ResponsiveUtils.isTablet(context)) {
      return 1.0; // Square for tablet
    } else if (ResponsiveUtils.isMobile(context)) {
      return 1.2; // Slightly taller for mobile
    } else {
      return 0.8; // Wider for desktop
    }
  }

  /// Get tablet-optimized max width for content
  static double getTabletMaxWidth(BuildContext context) {
    if (ResponsiveUtils.isTablet(context)) {
      return 800.0; // Optimal max width for tablet
    } else if (ResponsiveUtils.isMobile(context)) {
      return double.infinity; // Full width for mobile
    } else {
      return 1200.0; // Larger max width for desktop
    }
  }

  /// Build tablet-optimized responsive layout
  static Widget buildTabletResponsiveLayout({
    required Widget mobileLayout,
    required Widget tabletLayout,
    Widget? desktopLayout,
    required BuildContext context,
  }) {
    if (ResponsiveUtils.isMobile(context)) {
      return mobileLayout;
    } else if (ResponsiveUtils.isTablet(context)) {
      return tabletLayout;
    } else {
      return desktopLayout ?? tabletLayout;
    }
  }
}

/// Enum for snackbar types
enum SnackBarType {
  info,
  success,
  warning,
  error,
}
