import 'package:flutter/material.dart';
import 'responsive_utils.dart';
import 'color_utils.dart';
import 'typography_utils.dart';
import 'accessibility_utils.dart';

/// Mobile optimization utilities for touch-friendly interactions and better mobile UX
class MobileOptimizationUtils {
  /// Minimum touch target size as per Material Design guidelines
  static const double minTouchTargetSize = 48.0;
  
  /// Recommended touch target size for better accessibility
  static const double recommendedTouchTargetSize = 56.0;
  
  /// Maximum touch target size to avoid accidental touches
  static const double maxTouchTargetSize = 64.0;

  /// Get optimized touch target size for mobile
  static double getMobileTouchTargetSize(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
      return recommendedTouchTargetSize;
    }
    return minTouchTargetSize;
  }

  /// Get optimized padding for mobile screens
  static EdgeInsets getMobilePadding(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
      return EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 16.0));
    }
    return EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 8.0));
  }

  /// Get optimized margin for mobile screens
  static EdgeInsets getMobileMargin(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
      return EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 8.0));
    }
    return EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 4.0));
  }

  /// Get optimized font size for mobile readability
  static double getMobileFontSize(BuildContext context, double baseFontSize) {
    if (ResponsiveUtils.isMobile(context)) {
      // Increase font size slightly for better mobile readability
      return baseFontSize * 1.1;
    }
    return baseFontSize;
  }

  /// Get optimized icon size for mobile touch targets
  static double getMobileIconSize(BuildContext context, double baseIconSize) {
    if (ResponsiveUtils.isMobile(context)) {
      // Ensure icons are large enough for touch interaction
      return baseIconSize.clamp(24.0, 32.0);
    }
    return baseIconSize;
  }

  /// Get optimized border radius for mobile
  static double getMobileBorderRadius(BuildContext context, double baseRadius) {
    if (ResponsiveUtils.isMobile(context)) {
      // Slightly larger border radius for modern mobile feel
      return baseRadius * 1.2;
    }
    return baseRadius;
  }

  /// Get optimized elevation for mobile
  static double getMobileElevation(BuildContext context, double baseElevation) {
    if (ResponsiveUtils.isMobile(context)) {
      // Higher elevation for better depth perception on mobile
      return baseElevation * 1.5;
    }
    return baseElevation;
  }

  /// Build mobile-optimized button with proper touch target
  static Widget buildMobileOptimizedButton({
    required Widget child,
    required VoidCallback? onPressed,
    EdgeInsetsGeometry? padding,
    double? minHeight,
    double? minWidth,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final effectiveMinHeight = minHeight ?? getMobileTouchTargetSize(context);
    final effectiveMinWidth = minWidth ?? getMobileTouchTargetSize(context);
    final effectivePadding = padding ?? getMobilePadding(context);

    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(getMobileBorderRadius(context, 12.0)),
          child: Container(
            constraints: BoxConstraints(
              minHeight: effectiveMinHeight,
              minWidth: effectiveMinWidth,
            ),
            padding: effectivePadding,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  /// Build mobile-optimized list tile with proper touch target
  static Widget buildMobileOptimizedListTile({
    required Widget child,
    required VoidCallback? onTap,
    EdgeInsetsGeometry? contentPadding,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final effectivePadding = contentPadding ?? EdgeInsets.symmetric(
      horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
      vertical: ResponsiveUtils.getResponsiveSpacing(context, 12.0),
    );

    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(getMobileBorderRadius(context, 12.0)),
          child: Container(
            constraints: BoxConstraints(
              minHeight: getMobileTouchTargetSize(context),
            ),
            padding: effectivePadding,
            child: child,
          ),
        ),
      ),
    );
  }

  /// Build mobile-optimized card with proper touch feedback
  static Widget buildMobileOptimizedCard({
    required Widget child,
    required VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    double? elevation,
    BorderRadius? borderRadius,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveElevation = elevation ?? getMobileElevation(context, 2.0);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(getMobileBorderRadius(context, 16.0));

    Widget cardContent = Container(
      margin: margin ?? getMobileMargin(context),
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
        child: Container(
          padding: padding ?? getMobilePadding(context),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      cardContent = Semantics(
        button: true,
        label: semanticLabel,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: effectiveBorderRadius,
            child: cardContent,
          ),
        ),
      );
    }

    return cardContent;
  }

  /// Build mobile-optimized text field with proper touch target
  static Widget buildMobileOptimizedTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    int? maxLines = 1,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    void Function(String)? onChanged,
    bool enabled = true,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Semantics(
      textField: true,
      label: semanticLabel ?? labelText,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
        enabled: enabled,
        style: textTheme.bodyLarge?.copyWith(
          color: enabled ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.6),
          fontSize: AccessibilityUtils.getAccessibleFontSize(
            context,
            getMobileFontSize(context, 16.0),
          ),
        ),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: enabled 
              ? colorScheme.surfaceContainerHighest
              : colorScheme.surfaceContainerHighest.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(getMobileBorderRadius(context, 16.0)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(getMobileBorderRadius(context, 16.0)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(getMobileBorderRadius(context, 16.0)),
            borderSide: BorderSide(
              color: ColorUtils.primaryBlue,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(getMobileBorderRadius(context, 16.0)),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
            vertical: ResponsiveUtils.getResponsiveSpacing(context, 16.0), // Increased for mobile
          ),
          labelStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: AccessibilityUtils.getAccessibleFontSize(
              context,
              getMobileFontSize(context, 14.0),
            ),
          ),
          hintStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
            fontSize: AccessibilityUtils.getAccessibleFontSize(
              context,
              getMobileFontSize(context, 14.0),
            ),
          ),
        ),
      ),
    );
  }

  /// Build mobile-optimized bottom navigation bar
  static Widget buildMobileOptimizedBottomNavigationBar({
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
          height: getMobileTouchTargetSize(context) + 16, // Extra padding for mobile
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
                getMobileFontSize(context, 12.0),
              ),
            ),
            unselectedLabelStyle: TypographyUtils.labelSmallStyle.copyWith(
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                getMobileFontSize(context, 12.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build mobile-optimized app bar
  static Widget buildMobileOptimizedAppBar({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    double? elevation,
    Color? backgroundColor,
    Color? foregroundColor,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveElevation = elevation ?? getMobileElevation(context, 4.0);

    return AppBar(
      title: Text(
        title,
        style: TypographyUtils.titleLargeStyle.copyWith(
          color: foregroundColor ?? colorScheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: AccessibilityUtils.getAccessibleFontSize(
            context,
            getMobileFontSize(context, 22.0),
          ),
        ),
      ),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: effectiveElevation,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      centerTitle: false,
      titleSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
    );
  }

  /// Build mobile-optimized drawer
  static Widget buildMobileOptimizedDrawer({
    required Widget child,
    double? width,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final effectiveWidth = width ?? (MediaQuery.of(context).size.width * 0.8);

    return Drawer(
      width: effectiveWidth,
      backgroundColor: theme.colorScheme.surface,
      child: SafeArea(
        child: child,
      ),
    );
  }

  /// Build mobile-optimized floating action button
  static Widget buildMobileOptimizedFloatingActionButton({
    required VoidCallback? onPressed,
    required Widget child,
    String? tooltip,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    required BuildContext context,
  }) {
    final effectiveElevation = elevation ?? getMobileElevation(context, 6.0);

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? ColorUtils.primaryBlue,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: effectiveElevation,
      child: child,
    );
  }

  /// Build mobile-optimized snackbar
  static void showMobileOptimizedSnackBar({
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
            Icon(icon, color: textColor, size: getMobileIconSize(context, 20.0)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TypographyUtils.bodyMediumStyle.copyWith(
                  color: textColor,
                  fontSize: AccessibilityUtils.getAccessibleFontSize(
                    context,
                    getMobileFontSize(context, 14.0),
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
          borderRadius: BorderRadius.circular(getMobileBorderRadius(context, 12.0)),
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

  /// Check if device is in mobile mode
  static bool isMobileMode(BuildContext context) {
    return ResponsiveUtils.isMobile(context);
  }

  /// Get mobile-optimized grid columns
  static int getMobileGridColumns(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
      return 1; // Single column for mobile
    } else if (ResponsiveUtils.isTablet(context)) {
      return 2; // Two columns for tablet
    } else {
      return 3; // Three columns for desktop
    }
  }

  /// Get mobile-optimized aspect ratio
  static double getMobileAspectRatio(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
      return 1.2; // Slightly taller for mobile
    } else if (ResponsiveUtils.isTablet(context)) {
      return 1.0; // Square for tablet
    } else {
      return 0.8; // Wider for desktop
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
