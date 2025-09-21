import 'package:flutter/material.dart';
import 'responsive_utils.dart';
import 'color_utils.dart';
import 'typography_utils.dart';
import 'accessibility_utils.dart';

/// Desktop optimization utilities for larger screens and better desktop UX
class DesktopOptimizationUtils {
  /// Optimal touch target size for desktop devices
  static const double desktopTouchTargetSize = 40.0;
  
  /// Optimal spacing for desktop layouts
  static const double desktopSpacing = 32.0;
  
  /// Optimal border radius for desktop components
  static const double desktopBorderRadius = 12.0;
  
  /// Optimal elevation for desktop components
  static const double desktopElevation = 4.0;
  
  /// Maximum content width for desktop
  static const double maxContentWidth = 1200.0;
  
  /// Sidebar width for desktop
  static const double sidebarWidth = 280.0;

  /// Get optimized touch target size for desktop
  static double getDesktopTouchTargetSize(BuildContext context) {
    if (ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isLargeDesktop(context)) {
      return desktopTouchTargetSize;
    }
    return ResponsiveUtils.isTablet(context) ? 52.0 : 48.0;
  }

  /// Get optimized padding for desktop screens
  static EdgeInsets getDesktopPadding(BuildContext context) {
    if (ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isLargeDesktop(context)) {
      return EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, desktopSpacing));
    }
    return EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 24.0));
  }

  /// Get optimized margin for desktop screens
  static EdgeInsets getDesktopMargin(BuildContext context) {
    if (ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isLargeDesktop(context)) {
      return EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 16.0));
    }
    return EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 12.0));
  }

  /// Get optimized font size for desktop readability
  static double getDesktopFontSize(BuildContext context, double baseFontSize) {
    if (ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isLargeDesktop(context)) {
      // Standard font size for desktop
      return baseFontSize;
    }
    return baseFontSize * 1.05;
  }

  /// Get optimized icon size for desktop
  static double getDesktopIconSize(BuildContext context, double baseIconSize) {
    if (ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isLargeDesktop(context)) {
      // Standard icon size for desktop
      return baseIconSize.clamp(20.0, 28.0);
    }
    return baseIconSize;
  }

  /// Get optimized border radius for desktop
  static double getDesktopBorderRadius(BuildContext context, double baseRadius) {
    if (ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isLargeDesktop(context)) {
      return desktopBorderRadius;
    }
    return baseRadius;
  }

  /// Get optimized elevation for desktop
  static double getDesktopElevation(BuildContext context, double baseElevation) {
    if (ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isLargeDesktop(context)) {
      return desktopElevation;
    }
    return baseElevation;
  }

  /// Build desktop-optimized layout with sidebar
  static Widget buildDesktopLayout({
    required Widget sidebar,
    required Widget content,
    double? sidebarWidth,
    bool isSidebarCollapsed = false,
    required BuildContext context,
  }) {
    final effectiveSidebarWidth = sidebarWidth ?? DesktopOptimizationUtils.sidebarWidth;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        // Sidebar
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isSidebarCollapsed ? 80 : effectiveSidebarWidth,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              right: BorderSide(
                color: colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: sidebar,
        ),
        // Content
        Expanded(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: maxContentWidth,
            ),
            child: content,
          ),
        ),
      ],
    );
  }

  /// Build desktop-optimized grid layout
  static Widget buildDesktopGridLayout({
    required List<Widget> children,
    int? crossAxisCount,
    double? childAspectRatio,
    double? crossAxisSpacing,
    double? mainAxisSpacing,
    EdgeInsetsGeometry? padding,
    required BuildContext context,
  }) {
    final effectiveCrossAxisCount = crossAxisCount ?? getDesktopGridColumns(context);
    final effectiveChildAspectRatio = childAspectRatio ?? getDesktopAspectRatio(context);
    final effectiveCrossAxisSpacing = crossAxisSpacing ?? ResponsiveUtils.getResponsiveSpacing(context, 24.0);
    final effectiveMainAxisSpacing = mainAxisSpacing ?? ResponsiveUtils.getResponsiveSpacing(context, 24.0);

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxContentWidth,
        ),
        padding: padding ?? getDesktopPadding(context),
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
      ),
    );
  }

  /// Build desktop-optimized navigation rail
  static Widget buildDesktopNavigationRail({
    required int selectedIndex,
    required ValueChanged<int> onDestinationSelected,
    required List<NavigationRailDestination> destinations,
    Widget? leading,
    Widget? trailing,
    double? elevation,
    Color? backgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    bool isExtended = true,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveElevation = elevation ?? getDesktopElevation(context, 4.0);

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
      extended: isExtended,
    );
  }

  /// Build desktop-optimized app bar
  static Widget buildDesktopAppBar({
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
    final effectiveElevation = elevation ?? getDesktopElevation(context, 4.0);

    return AppBar(
      title: Text(
        title,
        style: TypographyUtils.titleLargeStyle.copyWith(
          color: foregroundColor ?? colorScheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: AccessibilityUtils.getAccessibleFontSize(
            context,
            getDesktopFontSize(context, 22.0),
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
      titleSpacing: ResponsiveUtils.getResponsiveSpacing(context, 32.0),
    );
  }

  /// Build desktop-optimized dialog
  static Widget buildDesktopDialog({
    required Widget child,
    double? maxWidth,
    double? maxHeight,
    EdgeInsetsGeometry? padding,
    required BuildContext context,
  }) {
    final screenSize = MediaQuery.of(context).size;
    
    final effectiveMaxWidth = maxWidth ?? (screenSize.width * 0.4);
    final effectiveMaxHeight = maxHeight ?? (screenSize.height * 0.6);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(getDesktopBorderRadius(context, 20.0)),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: effectiveMaxWidth,
          maxHeight: effectiveMaxHeight,
        ),
        padding: padding ?? getDesktopPadding(context),
        child: child,
      ),
    );
  }

  /// Build desktop-optimized bottom sheet
  static Widget buildDesktopBottomSheet({
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
    final effectiveMaxHeight = maxHeight ?? (screenHeight * 0.5);

    return Container(
      constraints: BoxConstraints(
        maxWidth: maxContentWidth,
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
              padding: getDesktopPadding(context),
              child: Text(
                title,
                style: TypographyUtils.titleLargeStyle.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: AccessibilityUtils.getAccessibleFontSize(
                    context,
                    getDesktopFontSize(context, 22.0),
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

  /// Build desktop-optimized snackbar
  static void showDesktopSnackBar({
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
            Icon(icon, color: textColor, size: getDesktopIconSize(context, 24.0)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: TypographyUtils.bodyMediumStyle.copyWith(
                  color: textColor,
                  fontSize: AccessibilityUtils.getAccessibleFontSize(
                    context,
                    getDesktopFontSize(context, 14.0),
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
          borderRadius: BorderRadius.circular(getDesktopBorderRadius(context, 12.0)),
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

  /// Build desktop-optimized floating action button
  static Widget buildDesktopFloatingActionButton({
    required VoidCallback? onPressed,
    required Widget child,
    String? tooltip,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    required BuildContext context,
  }) {
    final effectiveElevation = elevation ?? getDesktopElevation(context, 6.0);

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? ColorUtils.primaryBlue,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: effectiveElevation,
      child: child,
    );
  }

  /// Build desktop-optimized data table
  static Widget buildDesktopDataTable({
    required List<DataColumn> columns,
    required List<DataRow> rows,
    bool sortAscending = true,
    int? sortColumnIndex,
    ValueSetter<bool?>? onSelectAll,
    EdgeInsetsGeometry? padding,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(
        maxWidth: maxContentWidth,
      ),
      padding: padding ?? getDesktopPadding(context),
      child: Card(
        elevation: getDesktopElevation(context, 2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getDesktopBorderRadius(context, 12.0)),
        ),
        child: DataTable(
          columns: columns,
          rows: rows,
          sortAscending: sortAscending,
          sortColumnIndex: sortColumnIndex,
          onSelectAll: onSelectAll,
          headingRowColor: MaterialStateProperty.all(
            colorScheme.surfaceContainerHighest,
          ),
          dataRowColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return ColorUtils.primaryBlue.withOpacity(0.1);
            }
            return null;
          }),
        ),
      ),
    );
  }

  /// Build desktop-optimized toolbar
  static Widget buildDesktopToolbar({
    required List<Widget> actions,
    String? title,
    Widget? leading,
    EdgeInsetsGeometry? padding,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(
        maxWidth: maxContentWidth,
      ),
      padding: padding ?? getDesktopPadding(context),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading,
            const SizedBox(width: 16),
          ],
          if (title != null) ...[
            Expanded(
              child: Text(
                title,
                style: TypographyUtils.titleLargeStyle.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: AccessibilityUtils.getAccessibleFontSize(
                    context,
                    getDesktopFontSize(context, 22.0),
                  ),
                ),
              ),
            ),
          ] else
            const Spacer(),
          ...actions,
        ],
      ),
    );
  }

  /// Check if device is in desktop mode
  static bool isDesktopMode(BuildContext context) {
    return ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isLargeDesktop(context);
  }

  /// Get desktop-optimized grid columns
  static int getDesktopGridColumns(BuildContext context) {
    if (ResponsiveUtils.isLargeDesktop(context)) {
      return 4; // Four columns for large desktop
    } else if (ResponsiveUtils.isDesktop(context)) {
      return 3; // Three columns for desktop
    } else if (ResponsiveUtils.isTablet(context)) {
      return 2; // Two columns for tablet
    } else {
      return 1; // Single column for mobile
    }
  }

  /// Get desktop-optimized aspect ratio
  static double getDesktopAspectRatio(BuildContext context) {
    if (ResponsiveUtils.isLargeDesktop(context)) {
      return 0.7; // Wider for large desktop
    } else if (ResponsiveUtils.isDesktop(context)) {
      return 0.8; // Wider for desktop
    } else if (ResponsiveUtils.isTablet(context)) {
      return 1.0; // Square for tablet
    } else {
      return 1.2; // Slightly taller for mobile
    }
  }

  /// Get desktop-optimized max width for content
  static double getDesktopMaxWidth(BuildContext context) {
    if (ResponsiveUtils.isLargeDesktop(context)) {
      return 1400.0; // Larger max width for large desktop
    } else if (ResponsiveUtils.isDesktop(context)) {
      return maxContentWidth; // Standard max width for desktop
    } else if (ResponsiveUtils.isTablet(context)) {
      return 800.0; // Optimal max width for tablet
    } else {
      return double.infinity; // Full width for mobile
    }
  }

  /// Build desktop-optimized responsive layout
  static Widget buildDesktopResponsiveLayout({
    required Widget mobileLayout,
    required Widget tabletLayout,
    required Widget desktopLayout,
    Widget? largeDesktopLayout,
    required BuildContext context,
  }) {
    if (ResponsiveUtils.isMobile(context)) {
      return mobileLayout;
    } else if (ResponsiveUtils.isTablet(context)) {
      return tabletLayout;
    } else if (ResponsiveUtils.isLargeDesktop(context)) {
      return largeDesktopLayout ?? desktopLayout;
    } else {
      return desktopLayout;
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
