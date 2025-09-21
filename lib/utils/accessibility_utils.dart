import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class AccessibilityUtils {
  // Screen reader support
  static Widget buildSemanticButton({
    required Widget child,
    required String label,
    String? hint,
    required VoidCallback onPressed,
    bool enabled = true,
  }) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      hint: hint,
      onTap: enabled ? onPressed : null,
      child: child,
    );
  }

  static Widget buildSemanticCard({
    required Widget child,
    required String label,
    String? hint,
    VoidCallback? onTap,
  }) {
    return Semantics(
      button: onTap != null,
      label: label,
      hint: hint,
      onTap: onTap,
      child: child,
    );
  }

  static Widget buildSemanticTextField({
    required Widget child,
    required String label,
    String? hint,
    String? value,
    bool isRequired = false,
  }) {
    return Semantics(
      textField: true,
      label: label,
      hint: hint,
      value: value,
      isRequired: isRequired,
      child: child,
    );
  }

  static Widget buildSemanticImage({
    required Widget child,
    required String label,
    String? hint,
  }) {
    return Semantics(
      image: true,
      label: label,
      hint: hint,
      child: child,
    );
  }

  static Widget buildSemanticProgressIndicator({
    required Widget child,
    required String label,
    double? value,
  }) {
    return Semantics(
      label: label,
      value: value?.toString(),
      child: child,
    );
  }

  // High contrast support
  static Color getHighContrastColor(BuildContext context, Color baseColor) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    
    // Check if high contrast is enabled
    final mediaQuery = MediaQuery.of(context);
    if (mediaQuery.highContrast) {
      // Use high contrast colors
      if (brightness == Brightness.dark) {
        return baseColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
      } else {
        return baseColor.computeLuminance() > 0.5 ? Colors.white : Colors.black;
      }
    }
    
    return baseColor;
  }

  // Focus management
  static void requestFocus(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  // Screen reader announcements
  static void announceToScreenReader(BuildContext context, String message) {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  // Accessibility labels for common UI elements
  static String getButtonLabel(String text, {bool isLoading = false, bool isEnabled = true}) {
    if (isLoading) {
      return '$text (Loading)';
    }
    if (!isEnabled) {
      return '$text (Disabled)';
    }
    return text;
  }

  static String getCardLabel(String title, {String? subtitle}) {
    if (subtitle != null) {
      return '$title, $subtitle';
    }
    return title;
  }

  static String getProgressLabel(double value, double max, {String? unit}) {
    final percentage = ((value / max) * 100).round();
    if (unit != null) {
      return '$percentage% complete, $value $unit of $max $unit';
    }
    return '$percentage% complete';
  }

  static String getChartLabel(String chartType, int dataPoints, {String? dataType}) {
    if (dataType != null) {
      return '$chartType chart showing $dataPoints $dataType';
    }
    return '$chartType chart with $dataPoints data points';
  }

  static String getListLabel(String listType, int itemCount) {
    if (itemCount == 0) {
      return 'Empty $listType list';
    } else if (itemCount == 1) {
      return '$listType list with 1 item';
    } else {
      return '$listType list with $itemCount items';
    }
  }

  // Accessibility hints for common actions
  static String getActionHint(String action) {
    switch (action.toLowerCase()) {
      case 'edit':
        return 'Double tap to edit';
      case 'delete':
        return 'Double tap to delete';
      case 'view':
        return 'Double tap to view details';
      case 'navigate':
        return 'Double tap to navigate';
      case 'refresh':
        return 'Double tap to refresh';
      case 'submit':
        return 'Double tap to submit';
      case 'cancel':
        return 'Double tap to cancel';
      case 'save':
        return 'Double tap to save';
      case 'close':
        return 'Double tap to close';
      case 'back':
        return 'Double tap to go back';
      default:
        return 'Double tap to activate';
    }
  }

  // Minimum touch target size (44x44 logical pixels)
  static const double minTouchTargetSize = 44.0;

  // Check if touch target meets minimum size requirements
  static bool isTouchTargetAccessible(Size size) {
    return size.width >= minTouchTargetSize && size.height >= minTouchTargetSize;
  }

  // Ensure minimum touch target size
  static Widget ensureMinTouchTarget({
    required Widget child,
    double? minWidth,
    double? minHeight,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth ?? minTouchTargetSize,
        minHeight: minHeight ?? minTouchTargetSize,
      ),
      child: child,
    );
  }

  // Accessibility-friendly spacing
  static double getAccessibleSpacing(BuildContext context, double baseSpacing) {
    final mediaQuery = MediaQuery.of(context);
    final textScaleFactor = mediaQuery.textScaleFactor;
    
    // Increase spacing for larger text
    return baseSpacing * textScaleFactor;
  }

  // Accessibility-friendly font size
  static double getAccessibleFontSize(BuildContext context, double baseFontSize) {
    final mediaQuery = MediaQuery.of(context);
    final textScaleFactor = mediaQuery.textScaleFactor;
    
    // Ensure minimum readable font size
    final scaledSize = baseFontSize * textScaleFactor;
    return scaledSize.clamp(12.0, 24.0); // Reasonable range
  }

  // Color contrast utilities
  static double getContrastRatio(Color color1, Color color2) {
    final luminance1 = color1.computeLuminance();
    final luminance2 = color2.computeLuminance();
    
    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;
    
    return (lighter + 0.05) / (darker + 0.05);
  }

  static bool hasGoodContrast(Color foreground, Color background) {
    final contrastRatio = getContrastRatio(foreground, background);
    return contrastRatio >= 4.5; // WCAG AA standard
  }

  static Color getAccessibleTextColor(Color backgroundColor) {
    final whiteContrast = getContrastRatio(Colors.white, backgroundColor);
    final blackContrast = getContrastRatio(Colors.black, backgroundColor);
    
    return whiteContrast > blackContrast ? Colors.white : Colors.black;
  }

  // Focus indicators
  static Widget buildFocusIndicator({
    required Widget child,
    required BuildContext context,
    Color? focusColor,
    double borderWidth = 2.0,
  }) {
    return Focus(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.transparent,
            width: borderWidth,
          ),
        ),
        child: child,
      ),
      onFocusChange: (hasFocus) {
        // This would typically be handled by the parent widget
        // to show/hide the focus indicator
      },
    );
  }

  // Accessibility testing helpers
  static bool isAccessibilityEnabled(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.accessibleNavigation || 
           mediaQuery.highContrast || 
           mediaQuery.boldText;
  }

  // Screen reader friendly text formatting
  static String formatForScreenReader(String text, {bool addPunctuation = true}) {
    if (addPunctuation && !text.endsWith('.') && !text.endsWith('!') && !text.endsWith('?')) {
      return '$text.';
    }
    return text;
  }

  // Accessibility-friendly error messages
  static String getAccessibleErrorMessage(String error) {
    return 'Error: ${formatForScreenReader(error)}';
  }

  // Accessibility-friendly success messages
  static String getAccessibleSuccessMessage(String message) {
    return 'Success: ${formatForScreenReader(message)}';
  }

  // Accessibility-friendly loading messages
  static String getAccessibleLoadingMessage(String message) {
    return 'Loading: ${formatForScreenReader(message)}';
  }
}
