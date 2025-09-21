import 'package:flutter/material.dart';

class ColorUtils {
  // Primary color variations
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color primaryBlueLight = Color(0xFF42A5F5);
  static const Color primaryBlueDark = Color(0xFF1565C0);
  
  static const Color primaryGreen = Color(0xFF388E3C);
  static const Color primaryGreenLight = Color(0xFF66BB6A);
  static const Color primaryGreenDark = Color(0xFF2E7D32);
  
  static const Color primaryOrange = Color(0xFFF57C00);
  static const Color primaryOrangeLight = Color(0xFFFFB74D);
  static const Color primaryOrangeDark = Color(0xFFE65100);
  
  static const Color primaryPurple = Color(0xFF7B1FA2);
  static const Color primaryPurpleLight = Color(0xFFBA68C8);
  static const Color primaryPurpleDark = Color(0xFF6A1B9A);

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);
  static const Color successContainer = Color(0xFFE8F5E8);
  
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);
  static const Color warningContainer = Color(0xFFFFF3E0);
  
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color errorDark = Color(0xFFD32F2F);
  static const Color errorContainer = Color(0xFFFFEBEE);
  
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);
  static const Color infoContainer = Color(0xFFE3F2FD);

  // Neutral colors
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);

  // Surface colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color surfaceContainer = Color(0xFFF0F0F0);
  static const Color surfaceContainerHigh = Color(0xFFE8E8E8);
  static const Color surfaceContainerHighest = Color(0xFFE0E0E0);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryBlueLight],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, successLight],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warning, warningLight],
  );

  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [error, errorLight],
  );

  static const LinearGradient infoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [info, infoLight],
  );

  // Theme-specific color schemes
  static ColorScheme getLightColorScheme() {
    return const ColorScheme.light(
      primary: primaryBlue,
      onPrimary: textOnPrimary,
      primaryContainer: Color(0xFFE3F2FD),
      onPrimaryContainer: primaryBlueDark,
      secondary: primaryGreen,
      onSecondary: textOnPrimary,
      secondaryContainer: Color(0xFFE8F5E8),
      onSecondaryContainer: primaryGreenDark,
      tertiary: primaryPurple,
      onTertiary: textOnPrimary,
      tertiaryContainer: Color(0xFFF3E5F5),
      onTertiaryContainer: primaryPurpleDark,
      error: error,
      onError: textOnPrimary,
      errorContainer: errorContainer,
      onErrorContainer: errorDark,
      surface: surface,
      onSurface: textPrimary,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: textSecondary,
      outline: neutral400,
      outlineVariant: neutral300,
      shadow: neutral900,
      scrim: neutral900,
      inverseSurface: neutral800,
      onInverseSurface: neutral100,
      inversePrimary: primaryBlueLight,
    );
  }

  static ColorScheme getDarkColorScheme() {
    return const ColorScheme.dark(
      primary: primaryBlueLight,
      onPrimary: primaryBlueDark,
      primaryContainer: primaryBlueDark,
      onPrimaryContainer: primaryBlueLight,
      secondary: primaryGreenLight,
      onSecondary: primaryGreenDark,
      secondaryContainer: primaryGreenDark,
      onSecondaryContainer: primaryGreenLight,
      tertiary: primaryPurpleLight,
      onTertiary: primaryPurpleDark,
      tertiaryContainer: primaryPurpleDark,
      onTertiaryContainer: primaryPurpleLight,
      error: errorLight,
      onError: errorDark,
      errorContainer: errorDark,
      onErrorContainer: errorLight,
      surface: neutral900,
      onSurface: neutral100,
      surfaceVariant: neutral800,
      onSurfaceVariant: neutral300,
      outline: neutral600,
      outlineVariant: neutral700,
      shadow: neutral900,
      scrim: neutral900,
      inverseSurface: neutral100,
      onInverseSurface: neutral800,
      inversePrimary: primaryBlue,
    );
  }

  // Status-based colors
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
      case 'approved':
        return success;
      case 'warning':
      case 'pending':
      case 'in_progress':
        return warning;
      case 'error':
      case 'failed':
      case 'rejected':
        return error;
      case 'info':
      case 'draft':
      case 'new':
        return info;
      default:
        return neutral500;
    }
  }

  static Color getStatusContainerColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
      case 'approved':
        return successContainer;
      case 'warning':
      case 'pending':
      case 'in_progress':
        return warningContainer;
      case 'error':
      case 'failed':
      case 'rejected':
        return errorContainer;
      case 'info':
      case 'draft':
      case 'new':
        return infoContainer;
      default:
        return neutral100;
    }
  }

  // Priority-based colors
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'urgent':
        return error;
      case 'medium':
      case 'normal':
        return warning;
      case 'low':
        return success;
      default:
        return neutral500;
    }
  }

  // Grade-based colors
  static Color getGradeColor(double grade) {
    if (grade >= 90) return success;
    if (grade >= 80) return successLight;
    if (grade >= 70) return warning;
    if (grade >= 60) return warningLight;
    return error;
  }

  // Attendance-based colors
  static Color getAttendanceColor(double percentage) {
    if (percentage >= 90) return success;
    if (percentage >= 80) return successLight;
    if (percentage >= 70) return warning;
    if (percentage >= 60) return warningLight;
    return error;
  }

  // Performance-based colors
  static Color getPerformanceColor(double score) {
    if (score >= 0.9) return success;
    if (score >= 0.8) return successLight;
    if (score >= 0.7) return warning;
    if (score >= 0.6) return warningLight;
    return error;
  }

  // Category-based colors
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'academic':
      case 'education':
        return primaryBlue;
      case 'project':
      case 'development':
        return primaryGreen;
      case 'research':
      case 'innovation':
        return primaryPurple;
      case 'achievement':
      case 'award':
        return primaryOrange;
      case 'social':
      case 'community':
        return info;
      default:
        return neutral500;
    }
  }

  // Color utilities
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  static Color lighten(Color color, double amount) {
    return Color.lerp(color, Colors.white, amount) ?? color;
  }

  static Color darken(Color color, double amount) {
    return Color.lerp(color, Colors.black, amount) ?? color;
  }

  static Color blend(Color color1, Color color2, double ratio) {
    return Color.lerp(color1, color2, ratio) ?? color1;
  }

  // Contrast utilities
  static Color getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  static bool hasGoodContrast(Color foreground, Color background) {
    final contrastRatio = getContrastRatio(foreground, background);
    return contrastRatio >= 4.5; // WCAG AA standard
  }

  static double getContrastRatio(Color color1, Color color2) {
    final luminance1 = color1.computeLuminance();
    final luminance2 = color2.computeLuminance();
    
    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;
    
    return (lighter + 0.05) / (darker + 0.05);
  }

  // Accessibility utilities
  static Color getAccessibleColor(Color baseColor, Color backgroundColor) {
    if (hasGoodContrast(baseColor, backgroundColor)) {
      return baseColor;
    }
    return getContrastColor(backgroundColor);
  }

  // Theme-aware color selection
  static Color getThemeAwareColor(BuildContext context, {
    required Color lightColor,
    required Color darkColor,
  }) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light ? lightColor : darkColor;
  }

  // Material 3 color tokens
  static const Map<String, Color> material3Tokens = {
    'primary': primaryBlue,
    'onPrimary': textOnPrimary,
    'primaryContainer': Color(0xFFE3F2FD),
    'onPrimaryContainer': primaryBlueDark,
    'secondary': primaryGreen,
    'onSecondary': textOnPrimary,
    'secondaryContainer': Color(0xFFE8F5E8),
    'onSecondaryContainer': primaryGreenDark,
    'tertiary': primaryPurple,
    'onTertiary': textOnPrimary,
    'tertiaryContainer': Color(0xFFF3E5F5),
    'onTertiaryContainer': primaryPurpleDark,
    'error': error,
    'onError': textOnPrimary,
    'errorContainer': errorContainer,
    'onErrorContainer': errorDark,
    'surface': surface,
    'onSurface': textPrimary,
    'surfaceVariant': surfaceVariant,
    'onSurfaceVariant': textSecondary,
    'outline': neutral400,
    'outlineVariant': neutral300,
    'shadow': neutral900,
    'scrim': neutral900,
  };

  // Color palette for charts and data visualization
  static const List<Color> chartColors = [
    primaryBlue,
    primaryGreen,
    primaryOrange,
    primaryPurple,
    info,
    success,
    warning,
    error,
    Color(0xFF9C27B0), // Purple
    Color(0xFF00BCD4), // Cyan
    Color(0xFF4CAF50), // Green
    Color(0xFFFFC107), // Amber
  ];

  // Color palette for categories
  static const Map<String, Color> categoryColors = {
    'academic': primaryBlue,
    'project': primaryGreen,
    'research': primaryPurple,
    'achievement': primaryOrange,
    'social': info,
    'technical': Color(0xFF9C27B0),
    'creative': Color(0xFF00BCD4),
    'sports': Color(0xFF4CAF50),
    'volunteer': Color(0xFFFFC107),
    'leadership': Color(0xFFE91E63),
  };

  // Color palette for status indicators
  static const Map<String, Color> statusColors = {
    'active': success,
    'inactive': neutral500,
    'pending': warning,
    'completed': success,
    'cancelled': error,
    'draft': info,
    'published': success,
    'archived': neutral600,
  };

  // Color palette for priority levels
  static const Map<String, Color> priorityColors = {
    'low': success,
    'medium': warning,
    'high': error,
    'urgent': Color(0xFFD32F2F),
    'critical': Color(0xFFB71C1C),
  };

  // Color palette for user roles
  static const Map<String, Color> roleColors = {
    'student': primaryBlue,
    'faculty': primaryGreen,
    'admin': primaryPurple,
    'moderator': primaryOrange,
    'guest': neutral500,
  };

  // Color palette for departments
  static const Map<String, Color> departmentColors = {
    'computer_science': primaryBlue,
    'engineering': primaryGreen,
    'mathematics': primaryPurple,
    'physics': primaryOrange,
    'chemistry': info,
    'biology': success,
    'business': warning,
    'arts': Color(0xFF9C27B0),
    'literature': Color(0xFF00BCD4),
    'history': Color(0xFF795548),
  };
}
