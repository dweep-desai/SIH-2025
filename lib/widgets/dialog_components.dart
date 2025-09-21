import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../utils/color_utils.dart';
import '../utils/typography_utils.dart';
import '../utils/spacing_utils.dart';
import '../utils/accessibility_utils.dart';
import 'button_components.dart';

/// Modern dialog components with consistent styling and better animations
class ModernDialogComponents {
  static const Duration _animationDuration = Duration(milliseconds: 300);

  /// Show a modern alert dialog
  static Future<T?> showModernAlertDialog<T>({
    required BuildContext context,
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
    IconData? icon,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveIconColor = iconColor ?? (isDestructive ? colorScheme.error : ColorUtils.primaryBlue);

    return showDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20.0)),
        ),
        child: Container(
          padding: SpacingUtils.dialogPaddingAll,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: effectiveIconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: effectiveIconColor,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 32.0),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Title
              Text(
                title,
                style: TypographyUtils.headlineSmallStyle.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: AccessibilityUtils.getAccessibleFontSize(
                    context,
                    TypographyUtils.headlineSmallStyle.fontSize ?? 24,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Content
              Text(
                content,
                style: TypographyUtils.bodyLargeStyle.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: AccessibilityUtils.getAccessibleFontSize(
                    context,
                    TypographyUtils.bodyLargeStyle.fontSize ?? 16,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Actions
              Row(
                children: [
                  if (cancelText != null) ...[
                    Expanded(
                      child: ModernButtonComponents.buildSecondaryButton(
                        context: context,
                        text: cancelText,
                        onPressed: () {
                          Navigator.of(context).pop();
                          onCancel?.call();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: isDestructive
                        ? ModernButtonComponents.buildDestructiveButton(
                            context: context,
                            text: confirmText ?? 'Confirm',
                            onPressed: () {
                              Navigator.of(context).pop();
                              onConfirm?.call();
                            },
                          )
                        : ModernButtonComponents.buildPrimaryButton(
                            context: context,
                            text: confirmText ?? 'Confirm',
                            onPressed: () {
                              Navigator.of(context).pop();
                              onConfirm?.call();
                            },
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

  /// Show a modern confirmation dialog
  static Future<bool?> showModernConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    bool isDestructive = false,
    IconData? icon,
    Color? iconColor,
  }) {
    return showModernAlertDialog<bool>(
      context: context,
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
      isDestructive: isDestructive,
      icon: icon,
      iconColor: iconColor,
      onConfirm: () => Navigator.of(context).pop(true),
      onCancel: () => Navigator.of(context).pop(false),
    );
  }

  /// Show a modern info dialog
  static Future<void> showModernInfoDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? buttonText,
    IconData? icon,
    Color? iconColor,
  }) {
    return showModernAlertDialog<void>(
      context: context,
      title: title,
      content: content,
      confirmText: buttonText ?? 'OK',
      icon: icon ?? Icons.info_outline,
      iconColor: iconColor ?? ColorUtils.primaryBlue,
      onConfirm: () => Navigator.of(context).pop(),
    );
  }

  /// Show a modern error dialog
  static Future<void> showModernErrorDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? buttonText,
  }) {
    return showModernAlertDialog<void>(
      context: context,
      title: title,
      content: content,
      confirmText: buttonText ?? 'OK',
      icon: Icons.error_outline,
      iconColor: Theme.of(context).colorScheme.error,
      onConfirm: () => Navigator.of(context).pop(),
    );
  }

  /// Show a modern success dialog
  static Future<void> showModernSuccessDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? buttonText,
  }) {
    return showModernAlertDialog<void>(
      context: context,
      title: title,
      content: content,
      confirmText: buttonText ?? 'OK',
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
      onConfirm: () => Navigator.of(context).pop(),
    );
  }

  /// Show a modern loading dialog
  static Future<void> showModernLoadingDialog({
    required BuildContext context,
    required String message,
    bool barrierDismissible = false,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20.0)),
        ),
        child: Container(
          padding: SpacingUtils.dialogPaddingAll,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(ColorUtils.primaryBlue),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: TypographyUtils.bodyLargeStyle.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AccessibilityUtils.getAccessibleFontSize(
                    context,
                    TypographyUtils.bodyLargeStyle.fontSize ?? 16,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show a modern bottom sheet
  static Future<T?> showModernBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool isScrollControlled = true,
    double? maxHeight,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final effectiveMaxHeight = maxHeight ?? screenHeight * 0.9;

    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
                padding: const EdgeInsets.all(16),
                child: Text(
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
              ),
            ],
            // Content
            Flexible(
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  /// Show a modern action sheet
  static Future<T?> showModernActionSheet<T>({
    required BuildContext context,
    required List<ActionSheetItem<T>> actions,
    String? title,
    String? cancelText,
  }) {
    return showModernBottomSheet<T>(
      context: context,
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Actions
          ...actions.map((action) => _buildActionSheetItem(
            context: context,
            item: action,
            onTap: () => Navigator.of(context).pop(action.value),
          )),
          // Cancel button
          if (cancelText != null) ...[
            const Divider(height: 1),
            _buildActionSheetItem(
              context: context,
              item: ActionSheetItem<T>(
                title: cancelText,
                icon: Icons.close,
                isDestructive: false,
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ],
      ),
    );
  }

  /// Build action sheet item
  static Widget _buildActionSheetItem<T>({
    required BuildContext context,
    required ActionSheetItem<T> item,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = item.isDestructive 
        ? colorScheme.error 
        : colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  color: textColor,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Text(
                  item.title,
                  style: TypographyUtils.bodyLargeStyle.copyWith(
                    color: textColor,
                    fontWeight: item.isDestructive ? FontWeight.w500 : FontWeight.normal,
                    fontSize: AccessibilityUtils.getAccessibleFontSize(
                      context,
                      TypographyUtils.bodyLargeStyle.fontSize ?? 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show a modern date picker dialog
  static Future<DateTime?> showModernDatePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? title,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) => Theme(
        data: theme.copyWith(
          colorScheme: colorScheme.copyWith(
            primary: ColorUtils.primaryBlue,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
  }

  /// Show a modern time picker dialog
  static Future<TimeOfDay?> showModernTimePicker({
    required BuildContext context,
    TimeOfDay? initialTime,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: theme.copyWith(
          colorScheme: colorScheme.copyWith(
            primary: ColorUtils.primaryBlue,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
  }

  /// Show a modern full screen dialog
  static Future<T?> showModernFullScreenDialog<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool isDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      barrierLabel: '',
      transitionDuration: _animationDuration,
      pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
        appBar: title != null
            ? AppBar(
                title: Text(title),
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            : null,
        body: child,
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
    );
  }

  /// Show a modern snackbar
  static void showModernSnackBar({
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
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TypographyUtils.bodyMediumStyle.copyWith(
                  color: textColor,
                  fontSize: AccessibilityUtils.getAccessibleFontSize(
                    context,
                    TypographyUtils.bodyMediumStyle.fontSize ?? 14,
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
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12.0)),
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
}

/// Data class for action sheet items
class ActionSheetItem<T> {
  final String title;
  final IconData? icon;
  final bool isDestructive;
  final T? value;

  const ActionSheetItem({
    required this.title,
    this.icon,
    this.isDestructive = false,
    this.value,
  });
}

/// Enum for snackbar types
enum SnackBarType {
  info,
  success,
  warning,
  error,
}
