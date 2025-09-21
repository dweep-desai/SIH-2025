import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class ErrorComponents {
  static Widget buildErrorState({
    required String title,
    required String message,
    required IconData icon,
    required VoidCallback onRetry,
    required BuildContext context,
    String? retryText,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final effectiveIconColor = iconColor ?? colorScheme.error;
    final effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;

    return Container(
      width: double.infinity,
      padding: ResponsiveUtils.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 20)),
            decoration: BoxDecoration(
              color: effectiveIconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: ResponsiveUtils.getResponsiveIconSize(context, 48),
              color: effectiveIconColor,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
          Text(
            message,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 32)),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: Icon(
              Icons.refresh,
              size: ResponsiveUtils.getResponsiveIconSize(context, 18),
            ),
            label: Text(
              retryText ?? 'Try Again',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: effectiveIconColor,
              foregroundColor: Colors.white,
              elevation: ResponsiveUtils.getResponsiveElevation(context, 4),
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveUtils.getResponsiveSpacing(context, 16),
                horizontal: ResponsiveUtils.getResponsiveSpacing(context, 24),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildEmptyState({
    required String title,
    required String message,
    required IconData icon,
    required VoidCallback onAction,
    required BuildContext context,
    String? actionText,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final effectiveIconColor = iconColor ?? colorScheme.primary;
    final effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;

    return Container(
      width: double.infinity,
      padding: ResponsiveUtils.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 20)),
            decoration: BoxDecoration(
              color: effectiveIconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: ResponsiveUtils.getResponsiveIconSize(context, 48),
              color: effectiveIconColor,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
          Text(
            message,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 32)),
          ElevatedButton.icon(
            onPressed: onAction,
            icon: Icon(
              Icons.add,
              size: ResponsiveUtils.getResponsiveIconSize(context, 18),
            ),
            label: Text(
              actionText ?? 'Get Started',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: effectiveIconColor,
              foregroundColor: Colors.white,
              elevation: ResponsiveUtils.getResponsiveElevation(context, 4),
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveUtils.getResponsiveSpacing(context, 16),
                horizontal: ResponsiveUtils.getResponsiveSpacing(context, 24),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildNetworkErrorState({
    required VoidCallback onRetry,
    required BuildContext context,
  }) {
    return buildErrorState(
      title: 'Connection Error',
      message: 'Please check your internet connection and try again.',
      icon: Icons.wifi_off_rounded,
      onRetry: onRetry,
      context: context,
      retryText: 'Retry',
    );
  }

  static Widget buildServerErrorState({
    required VoidCallback onRetry,
    required BuildContext context,
  }) {
    return buildErrorState(
      title: 'Server Error',
      message: 'Something went wrong on our end. Please try again later.',
      icon: Icons.error_outline_rounded,
      onRetry: onRetry,
      context: context,
      retryText: 'Retry',
    );
  }

  static Widget buildNotFoundErrorState({
    required String item,
    required VoidCallback onRetry,
    required BuildContext context,
  }) {
    return buildErrorState(
      title: '$item Not Found',
      message: 'The $item you\'re looking for doesn\'t exist or has been removed.',
      icon: Icons.search_off_rounded,
      onRetry: onRetry,
      context: context,
      retryText: 'Go Back',
    );
  }

  static Widget buildPermissionErrorState({
    required String action,
    required VoidCallback onRetry,
    required BuildContext context,
  }) {
    return buildErrorState(
      title: 'Permission Denied',
      message: 'You don\'t have permission to $action. Please contact your administrator.',
      icon: Icons.lock_outline_rounded,
      onRetry: onRetry,
      context: context,
      retryText: 'Go Back',
    );
  }

  static Widget buildValidationErrorState({
    required String message,
    required VoidCallback onRetry,
    required BuildContext context,
  }) {
    return buildErrorState(
      title: 'Validation Error',
      message: message,
      icon: Icons.warning_amber_rounded,
      onRetry: onRetry,
      context: context,
      retryText: 'Fix & Retry',
    );
  }

  static Widget buildEmptyDataState({
    required String dataType,
    required VoidCallback onAction,
    required BuildContext context,
    String? actionText,
  }) {
    return buildEmptyState(
      title: 'No $dataType Found',
      message: 'There are no $dataType available at the moment. Create your first one to get started.',
      icon: Icons.inbox_rounded,
      onAction: onAction,
      context: context,
      actionText: actionText ?? 'Create $dataType',
    );
  }

  static Widget buildEmptySearchState({
    required String searchTerm,
    required VoidCallback onClear,
    required BuildContext context,
  }) {
    return buildEmptyState(
      title: 'No Results Found',
      message: 'No results found for "$searchTerm". Try adjusting your search terms.',
      icon: Icons.search_off_rounded,
      onAction: onClear,
      context: context,
      actionText: 'Clear Search',
    );
  }

  static Widget buildMaintenanceState({
    required String message,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      width: double.infinity,
      padding: ResponsiveUtils.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 20)),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.build_rounded,
              size: ResponsiveUtils.getResponsiveIconSize(context, 48),
              color: Colors.orange,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
          Text(
            'Under Maintenance',
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
          Text(
            message,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
              vertical: ResponsiveUtils.getResponsiveSpacing(context, 8),
            ),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
            ),
            child: Text(
              'We\'ll be back soon!',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.orange.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void showErrorSnackBar({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: colorScheme.onError,
              size: ResponsiveUtils.getResponsiveIconSize(context, 20),
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onError,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.error,
        duration: duration,
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: colorScheme.onError,
                onPressed: onAction,
              )
            : null,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 8)),
        ),
        margin: ResponsiveUtils.getResponsivePadding(context),
      ),
    );
  }

  static void showSuccessSnackBar({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: ResponsiveUtils.getResponsiveIconSize(context, 20),
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        duration: duration,
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction,
              )
            : null,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 8)),
        ),
        margin: ResponsiveUtils.getResponsivePadding(context),
      ),
    );
  }

  static void showWarningSnackBar({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: ResponsiveUtils.getResponsiveIconSize(context, 20),
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange.shade600,
        duration: duration,
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction,
              )
            : null,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 8)),
        ),
        margin: ResponsiveUtils.getResponsivePadding(context),
      ),
    );
  }

  static Widget buildErrorCard({
    required String message,
    required BuildContext context,
    VoidCallback? onDismiss,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      color: colorScheme.errorContainer,
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getResponsivePadding(context).left,
        vertical: ResponsiveUtils.getResponsiveSpacing(context, 8),
      ),
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: colorScheme.onErrorContainer,
              size: ResponsiveUtils.getResponsiveIconSize(context, 20),
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            Expanded(
              child: Text(
                message,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onErrorContainer,
                ),
              ),
            ),
            if (onDismiss != null)
              IconButton(
                onPressed: onDismiss,
                icon: Icon(
                  Icons.close_rounded,
                  color: colorScheme.onErrorContainer,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
