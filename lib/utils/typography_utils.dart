import 'package:flutter/material.dart';

class TypographyUtils {
  // Font families
  static const String primaryFontFamily = 'Roboto';
  static const String secondaryFontFamily = 'Inter';
  static const String monospaceFontFamily = 'JetBrains Mono';

  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // Font sizes (Material 3 scale)
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall = 24.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 16.0;
  static const double titleSmall = 14.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
  static const double labelLarge = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall = 11.0;

  // Line heights
  static const double displayLargeHeight = 64.0;
  static const double displayMediumHeight = 52.0;
  static const double displaySmallHeight = 44.0;
  static const double headlineLargeHeight = 40.0;
  static const double headlineMediumHeight = 36.0;
  static const double headlineSmallHeight = 32.0;
  static const double titleLargeHeight = 28.0;
  static const double titleMediumHeight = 24.0;
  static const double titleSmallHeight = 20.0;
  static const double bodyLargeHeight = 24.0;
  static const double bodyMediumHeight = 20.0;
  static const double bodySmallHeight = 16.0;
  static const double labelLargeHeight = 20.0;
  static const double labelMediumHeight = 16.0;
  static const double labelSmallHeight = 16.0;

  // Letter spacing
  static const double displayLargeSpacing = -0.25;
  static const double displayMediumSpacing = 0.0;
  static const double displaySmallSpacing = 0.0;
  static const double headlineLargeSpacing = 0.0;
  static const double headlineMediumSpacing = 0.0;
  static const double headlineSmallSpacing = 0.0;
  static const double titleLargeSpacing = 0.0;
  static const double titleMediumSpacing = 0.15;
  static const double titleSmallSpacing = 0.1;
  static const double bodyLargeSpacing = 0.5;
  static const double bodyMediumSpacing = 0.25;
  static const double bodySmallSpacing = 0.4;
  static const double labelLargeSpacing = 0.1;
  static const double labelMediumSpacing = 0.5;
  static const double labelSmallSpacing = 0.5;

  // Text styles
  static const TextStyle displayLargeStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: displayLarge,
    fontWeight: regular,
    height: displayLargeHeight / displayLarge,
    letterSpacing: displayLargeSpacing,
  );

  static const TextStyle displayMediumStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: displayMedium,
    fontWeight: regular,
    height: displayMediumHeight / displayMedium,
    letterSpacing: displayMediumSpacing,
  );

  static const TextStyle displaySmallStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: displaySmall,
    fontWeight: regular,
    height: displaySmallHeight / displaySmall,
    letterSpacing: displaySmallSpacing,
  );

  static const TextStyle headlineLargeStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: headlineLarge,
    fontWeight: regular,
    height: headlineLargeHeight / headlineLarge,
    letterSpacing: headlineLargeSpacing,
  );

  static const TextStyle headlineMediumStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: headlineMedium,
    fontWeight: regular,
    height: headlineMediumHeight / headlineMedium,
    letterSpacing: headlineMediumSpacing,
  );

  static const TextStyle headlineSmallStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: headlineSmall,
    fontWeight: regular,
    height: headlineSmallHeight / headlineSmall,
    letterSpacing: headlineSmallSpacing,
  );

  static const TextStyle titleLargeStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: titleLarge,
    fontWeight: regular,
    height: titleLargeHeight / titleLarge,
    letterSpacing: titleLargeSpacing,
  );

  static const TextStyle titleMediumStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: titleMedium,
    fontWeight: medium,
    height: titleMediumHeight / titleMedium,
    letterSpacing: titleMediumSpacing,
  );

  static const TextStyle titleSmallStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: titleSmall,
    fontWeight: medium,
    height: titleSmallHeight / titleSmall,
    letterSpacing: titleSmallSpacing,
  );

  static const TextStyle bodyLargeStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodyLarge,
    fontWeight: regular,
    height: bodyLargeHeight / bodyLarge,
    letterSpacing: bodyLargeSpacing,
  );

  static const TextStyle bodyMediumStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodyMedium,
    fontWeight: regular,
    height: bodyMediumHeight / bodyMedium,
    letterSpacing: bodyMediumSpacing,
  );

  static const TextStyle bodySmallStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodySmall,
    fontWeight: regular,
    height: bodySmallHeight / bodySmall,
    letterSpacing: bodySmallSpacing,
  );

  static const TextStyle labelLargeStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: labelLarge,
    fontWeight: medium,
    height: labelLargeHeight / labelLarge,
    letterSpacing: labelLargeSpacing,
  );

  static const TextStyle labelMediumStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: labelMedium,
    fontWeight: medium,
    height: labelMediumHeight / labelMedium,
    letterSpacing: labelMediumSpacing,
  );

  static const TextStyle labelSmallStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: labelSmall,
    fontWeight: medium,
    height: labelSmallHeight / labelSmall,
    letterSpacing: labelSmallSpacing,
  );

  // Specialized text styles
  static const TextStyle buttonTextStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: labelLarge,
    fontWeight: medium,
    height: labelLargeHeight / labelLarge,
    letterSpacing: labelLargeSpacing,
  );

  static const TextStyle captionStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodySmall,
    fontWeight: regular,
    height: bodySmallHeight / bodySmall,
    letterSpacing: bodySmallSpacing,
  );

  static const TextStyle overlineStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: labelSmall,
    fontWeight: medium,
    height: labelSmallHeight / labelSmall,
    letterSpacing: labelSmallSpacing,
  );

  static const TextStyle codeStyle = TextStyle(
    fontFamily: monospaceFontFamily,
    fontSize: bodyMedium,
    fontWeight: regular,
    height: bodyMediumHeight / bodyMedium,
    letterSpacing: 0.0,
  );

  // Custom text styles for specific use cases
  static const TextStyle cardTitleStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: titleMedium,
    fontWeight: semiBold,
    height: titleMediumHeight / titleMedium,
    letterSpacing: titleMediumSpacing,
  );

  static const TextStyle cardSubtitleStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodyMedium,
    fontWeight: regular,
    height: bodyMediumHeight / bodyMedium,
    letterSpacing: bodyMediumSpacing,
  );

  static const TextStyle listItemTitleStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodyLarge,
    fontWeight: medium,
    height: bodyLargeHeight / bodyLarge,
    letterSpacing: bodyLargeSpacing,
  );

  static const TextStyle listItemSubtitleStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodyMedium,
    fontWeight: regular,
    height: bodyMediumHeight / bodyMedium,
    letterSpacing: bodyMediumSpacing,
  );

  static const TextStyle navigationTitleStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: titleLarge,
    fontWeight: semiBold,
    height: titleLargeHeight / titleLarge,
    letterSpacing: titleLargeSpacing,
  );

  static const TextStyle navigationSubtitleStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodyMedium,
    fontWeight: regular,
    height: bodyMediumHeight / bodyMedium,
    letterSpacing: bodyMediumSpacing,
  );

  static const TextStyle formLabelStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodyMedium,
    fontWeight: medium,
    height: bodyMediumHeight / bodyMedium,
    letterSpacing: bodyMediumSpacing,
  );

  static const TextStyle formHintStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodyMedium,
    fontWeight: regular,
    height: bodyMediumHeight / bodyMedium,
    letterSpacing: bodyMediumSpacing,
  );

  static const TextStyle errorTextStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodySmall,
    fontWeight: regular,
    height: bodySmallHeight / bodySmall,
    letterSpacing: bodySmallSpacing,
  );

  static const TextStyle successTextStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodySmall,
    fontWeight: regular,
    height: bodySmallHeight / bodySmall,
    letterSpacing: bodySmallSpacing,
  );

  static const TextStyle warningTextStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodySmall,
    fontWeight: regular,
    height: bodySmallHeight / bodySmall,
    letterSpacing: bodySmallSpacing,
  );

  static const TextStyle infoTextStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodySmall,
    fontWeight: regular,
    height: bodySmallHeight / bodySmall,
    letterSpacing: bodySmallSpacing,
  );

  // Chart and data visualization text styles
  static const TextStyle chartTitleStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: titleMedium,
    fontWeight: semiBold,
    height: titleMediumHeight / titleMedium,
    letterSpacing: titleMediumSpacing,
  );

  static const TextStyle chartSubtitleStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodySmall,
    fontWeight: regular,
    height: bodySmallHeight / bodySmall,
    letterSpacing: bodySmallSpacing,
  );

  static const TextStyle chartLabelStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: labelSmall,
    fontWeight: medium,
    height: labelSmallHeight / labelSmall,
    letterSpacing: labelSmallSpacing,
  );

  static const TextStyle chartValueStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: titleSmall,
    fontWeight: semiBold,
    height: titleSmallHeight / titleSmall,
    letterSpacing: titleSmallSpacing,
  );

  // Profile and user-related text styles
  static const TextStyle profileNameStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: headlineSmall,
    fontWeight: semiBold,
    height: headlineSmallHeight / headlineSmall,
    letterSpacing: headlineSmallSpacing,
  );

  static const TextStyle profileTitleStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodyLarge,
    fontWeight: medium,
    height: bodyLargeHeight / bodyLarge,
    letterSpacing: bodyLargeSpacing,
  );

  static const TextStyle profileSubtitleStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodyMedium,
    fontWeight: regular,
    height: bodyMediumHeight / bodyMedium,
    letterSpacing: bodyMediumSpacing,
  );

  // Status and badge text styles
  static const TextStyle statusTextStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: labelSmall,
    fontWeight: semiBold,
    height: labelSmallHeight / labelSmall,
    letterSpacing: labelSmallSpacing,
  );

  static const TextStyle badgeTextStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: labelSmall,
    fontWeight: medium,
    height: labelSmallHeight / labelSmall,
    letterSpacing: labelSmallSpacing,
  );

  // Utility methods
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  static TextStyle withHeight(TextStyle style, double height) {
    return style.copyWith(height: height);
  }

  static TextStyle withSpacing(TextStyle style, double spacing) {
    return style.copyWith(letterSpacing: spacing);
  }

  static TextStyle withFamily(TextStyle style, String family) {
    return style.copyWith(fontFamily: family);
  }

  // Responsive text scaling
  static TextStyle getResponsiveTextStyle(
    BuildContext context,
    TextStyle baseStyle, {
    double? scaleFactor,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final effectiveScaleFactor = scaleFactor ?? mediaQuery.textScaleFactor;
    
    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 14.0) * effectiveScaleFactor,
    );
  }

  // Text style builders for common use cases
  static TextStyle buildHeadingStyle({
    required double fontSize,
    FontWeight fontWeight = semiBold,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  static TextStyle buildBodyStyle({
    required double fontSize,
    FontWeight fontWeight = regular,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  static TextStyle buildLabelStyle({
    required double fontSize,
    FontWeight fontWeight = medium,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  // Text style combinations
  static Map<String, TextStyle> getTextTheme() {
    return {
      'displayLarge': displayLargeStyle,
      'displayMedium': displayMediumStyle,
      'displaySmall': displaySmallStyle,
      'headlineLarge': headlineLargeStyle,
      'headlineMedium': headlineMediumStyle,
      'headlineSmall': headlineSmallStyle,
      'titleLarge': titleLargeStyle,
      'titleMedium': titleMediumStyle,
      'titleSmall': titleSmallStyle,
      'bodyLarge': bodyLargeStyle,
      'bodyMedium': bodyMediumStyle,
      'bodySmall': bodySmallStyle,
      'labelLarge': labelLargeStyle,
      'labelMedium': labelMediumStyle,
      'labelSmall': labelSmallStyle,
    };
  }

  static Map<String, TextStyle> getCustomTextTheme() {
    return {
      'buttonText': buttonTextStyle,
      'caption': captionStyle,
      'overline': overlineStyle,
      'code': codeStyle,
      'cardTitle': cardTitleStyle,
      'cardSubtitle': cardSubtitleStyle,
      'listItemTitle': listItemTitleStyle,
      'listItemSubtitle': listItemSubtitleStyle,
      'navigationTitle': navigationTitleStyle,
      'navigationSubtitle': navigationSubtitleStyle,
      'formLabel': formLabelStyle,
      'formHint': formHintStyle,
      'errorText': errorTextStyle,
      'successText': successTextStyle,
      'warningText': warningTextStyle,
      'infoText': infoTextStyle,
      'chartTitle': chartTitleStyle,
      'chartSubtitle': chartSubtitleStyle,
      'chartLabel': chartLabelStyle,
      'chartValue': chartValueStyle,
      'profileName': profileNameStyle,
      'profileTitle': profileTitleStyle,
      'profileSubtitle': profileSubtitleStyle,
      'statusText': statusTextStyle,
      'badgeText': badgeTextStyle,
    };
  }
}
