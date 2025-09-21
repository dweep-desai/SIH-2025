import 'package:flutter/material.dart';

/// Responsive breakpoints for different screen sizes
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1600;
}

/// Responsive utility class for handling different screen sizes
class ResponsiveUtils {
  /// Get the current screen type based on width
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < ResponsiveBreakpoints.mobile) {
      return ScreenType.mobile;
    } else if (width < ResponsiveBreakpoints.tablet) {
      return ScreenType.tablet;
    } else if (width < ResponsiveBreakpoints.desktop) {
      return ScreenType.desktop;
    } else {
      return ScreenType.largeDesktop;
    }
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return getScreenType(context) == ScreenType.mobile;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    return getScreenType(context) == ScreenType.tablet;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return getScreenType(context) == ScreenType.desktop;
  }

  /// Check if current screen is large desktop
  static bool isLargeDesktop(BuildContext context) {
    return getScreenType(context) == ScreenType.largeDesktop;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenType = getScreenType(context);
    
    switch (screenType) {
      case ScreenType.mobile:
        return const EdgeInsets.all(16);
      case ScreenType.tablet:
        return const EdgeInsets.all(24);
      case ScreenType.desktop:
        return const EdgeInsets.all(32);
      case ScreenType.largeDesktop:
        return const EdgeInsets.all(40);
    }
  }

  /// Get responsive margin based on screen size
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    final screenType = getScreenType(context);
    
    switch (screenType) {
      case ScreenType.mobile:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case ScreenType.tablet:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case ScreenType.desktop:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ScreenType.largeDesktop:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
    }
  }

  /// Get responsive font size based on screen size
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenType = getScreenType(context);
    
    switch (screenType) {
      case ScreenType.mobile:
        return baseFontSize;
      case ScreenType.tablet:
        return baseFontSize * 1.1;
      case ScreenType.desktop:
        return baseFontSize * 1.2;
      case ScreenType.largeDesktop:
        return baseFontSize * 1.3;
    }
  }

  /// Get responsive icon size based on screen size
  static double getResponsiveIconSize(BuildContext context, double baseIconSize) {
    final screenType = getScreenType(context);
    
    switch (screenType) {
      case ScreenType.mobile:
        return baseIconSize;
      case ScreenType.tablet:
        return baseIconSize * 1.1;
      case ScreenType.desktop:
        return baseIconSize * 1.2;
      case ScreenType.largeDesktop:
        return baseIconSize * 1.3;
    }
  }

  /// Get responsive grid columns based on screen size
  static int getResponsiveGridColumns(BuildContext context) {
    final screenType = getScreenType(context);
    
    switch (screenType) {
      case ScreenType.mobile:
        return 1;
      case ScreenType.tablet:
        return 2;
      case ScreenType.desktop:
        return 3;
      case ScreenType.largeDesktop:
        return 4;
    }
  }

  /// Get responsive card width based on screen size
  static double getResponsiveCardWidth(BuildContext context) {
    final screenType = getScreenType(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    switch (screenType) {
      case ScreenType.mobile:
        return screenWidth - 32; // Full width minus padding
      case ScreenType.tablet:
        return (screenWidth - 64) / 2; // Half width minus padding
      case ScreenType.desktop:
        return (screenWidth - 96) / 3; // Third width minus padding
      case ScreenType.largeDesktop:
        return (screenWidth - 128) / 4; // Quarter width minus padding
    }
  }

  /// Get responsive spacing based on screen size
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenType = getScreenType(context);
    
    switch (screenType) {
      case ScreenType.mobile:
        return baseSpacing;
      case ScreenType.tablet:
        return baseSpacing * 1.2;
      case ScreenType.desktop:
        return baseSpacing * 1.5;
      case ScreenType.largeDesktop:
        return baseSpacing * 1.8;
    }
  }

  /// Get responsive elevation based on screen size
  static double getResponsiveElevation(BuildContext context, double baseElevation) {
    final screenType = getScreenType(context);
    
    switch (screenType) {
      case ScreenType.mobile:
        return baseElevation;
      case ScreenType.tablet:
        return baseElevation * 1.2;
      case ScreenType.desktop:
        return baseElevation * 1.5;
      case ScreenType.largeDesktop:
        return baseElevation * 1.8;
    }
  }

  /// Get responsive border radius based on screen size
  static double getResponsiveBorderRadius(BuildContext context, double baseRadius) {
    final screenType = getScreenType(context);
    
    switch (screenType) {
      case ScreenType.mobile:
        return baseRadius;
      case ScreenType.tablet:
        return baseRadius * 1.1;
      case ScreenType.desktop:
        return baseRadius * 1.2;
      case ScreenType.largeDesktop:
        return baseRadius * 1.3;
    }
  }

  /// Get responsive max width for content
  static double getResponsiveMaxWidth(BuildContext context) {
    final screenType = getScreenType(context);
    
    switch (screenType) {
      case ScreenType.mobile:
        return double.infinity;
      case ScreenType.tablet:
        return 800;
      case ScreenType.desktop:
        return 1200;
      case ScreenType.largeDesktop:
        return 1600;
    }
  }

  /// Get responsive aspect ratio for cards
  static double getResponsiveAspectRatio(BuildContext context) {
    final screenType = getScreenType(context);
    
    switch (screenType) {
      case ScreenType.mobile:
        return 1.2; // Taller cards on mobile
      case ScreenType.tablet:
        return 1.1;
      case ScreenType.desktop:
        return 1.0; // Square cards on desktop
      case ScreenType.largeDesktop:
        return 0.9; // Wider cards on large desktop
    }
  }
}

/// Screen type enumeration
enum ScreenType {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

/// Responsive widget that adapts to different screen sizes
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final screenType = ResponsiveUtils.getScreenType(context);
    
    switch (screenType) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenType.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
  }
}

/// Responsive grid widget that adapts columns based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final double childAspectRatio;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveUtils.getResponsiveGridColumns(context);
    final responsiveSpacing = ResponsiveUtils.getResponsiveSpacing(context, spacing);
    final responsiveRunSpacing = ResponsiveUtils.getResponsiveSpacing(context, runSpacing);
    final responsiveAspectRatio = ResponsiveUtils.getResponsiveAspectRatio(context) * childAspectRatio;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: responsiveSpacing,
        mainAxisSpacing: responsiveRunSpacing,
        childAspectRatio: responsiveAspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Responsive container that adapts padding and margin
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? maxWidth;
  final BoxDecoration? decoration;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.maxWidth,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding = padding ?? ResponsiveUtils.getResponsivePadding(context);
    final responsiveMargin = margin ?? ResponsiveUtils.getResponsiveMargin(context);
    final responsiveMaxWidth = maxWidth ?? ResponsiveUtils.getResponsiveMaxWidth(context);
    
    return Container(
      padding: responsivePadding,
      margin: responsiveMargin,
      constraints: BoxConstraints(
        maxWidth: responsiveMaxWidth,
      ),
      decoration: decoration,
      child: child,
    );
  }
}

/// Responsive text widget that adapts font size
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final baseFontSize = style?.fontSize ?? 14.0;
    final responsiveFontSize = ResponsiveUtils.getResponsiveFontSize(context, baseFontSize);
    
    return Text(
      text,
      style: style?.copyWith(fontSize: responsiveFontSize) ?? 
             TextStyle(fontSize: responsiveFontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Responsive icon widget that adapts icon size
class ResponsiveIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? size;

  const ResponsiveIcon(
    this.icon, {
    super.key,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final baseIconSize = size ?? 24.0;
    final responsiveIconSize = ResponsiveUtils.getResponsiveIconSize(context, baseIconSize);
    
    return Icon(
      icon,
      size: responsiveIconSize,
      color: color,
    );
  }
}
