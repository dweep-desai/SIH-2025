import 'package:flutter/material.dart';

/// Utility class for safely showing SnackBars with proper context checks
class SafeSnackBarUtils {
  /// Safely shows a SnackBar with proper context validation
  static void showSafeSnackBar(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    // Check if the widget is still mounted and has a valid context
    if (!context.mounted) return;
    
    try {
      // Check if ScaffoldMessenger is available
      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
      if (scaffoldMessenger == null) return;
      
      // Clear any existing SnackBars to prevent stacking
      scaffoldMessenger.clearSnackBars();
      
      // Show the new SnackBar
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          duration: duration,
          action: action,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } catch (e) {
      // Silently handle any errors to prevent console spam
      debugPrint('SafeSnackBar error: $e');
    }
  }
  
  /// Shows a success SnackBar
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    showSafeSnackBar(
      context,
      message: message,
      backgroundColor: Colors.green,
      duration: duration,
    );
  }
  
  /// Shows an error SnackBar
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    showSafeSnackBar(
      context,
      message: message,
      backgroundColor: Colors.red,
      duration: duration,
    );
  }
  
  /// Shows a warning SnackBar
  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    showSafeSnackBar(
      context,
      message: message,
      backgroundColor: Colors.orange,
      duration: duration,
    );
  }
  
  /// Shows an info SnackBar
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    showSafeSnackBar(
      context,
      message: message,
      backgroundColor: Colors.blue,
      duration: duration,
    );
  }
}
