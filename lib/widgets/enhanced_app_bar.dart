import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class EnhancedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final String? subtitle;
  final Widget? titleWidget;
  final bool enableGradient;
  final List<Color>? gradientColors;
  final bool enableShadow;
  final double? shadowBlurRadius;
  final Color? shadowColor;

  const EnhancedAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle = true,
    this.bottom,
    this.onBackPressed,
    this.showBackButton = true,
    this.subtitle,
    this.titleWidget,
    this.enableGradient = false,
    this.gradientColors,
    this.enableShadow = true,
    this.shadowBlurRadius,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
    final effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
    final effectiveElevation = elevation ?? ResponsiveUtils.getResponsiveElevation(context, 2);

    Widget appBarContent = AppBar(
      title: titleWidget ?? _buildTitle(context, textTheme, effectiveForegroundColor),
      leading: _buildLeading(context, colorScheme, effectiveForegroundColor),
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: enableShadow ? effectiveElevation : 0,
      centerTitle: centerTitle,
      bottom: bottom,
      surfaceTintColor: Colors.transparent,
      shadowColor: shadowColor ?? colorScheme.shadow.withOpacity(0.1),
      scrolledUnderElevation: enableShadow ? effectiveElevation : 0,
    );

    if (enableGradient) {
      final colors = gradientColors ?? [
        effectiveBackgroundColor,
        effectiveBackgroundColor.withOpacity(0.8),
      ];

      appBarContent = Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: enableShadow ? [
            BoxShadow(
              color: shadowColor ?? colorScheme.shadow.withOpacity(0.1),
              blurRadius: shadowBlurRadius ?? 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: appBarContent,
      );
    }

    return appBarContent;
  }

  Widget _buildTitle(BuildContext context, TextTheme textTheme, Color foregroundColor) {
    if (subtitle != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle!,
            style: textTheme.bodySmall?.copyWith(
              color: foregroundColor.withOpacity(0.7),
            ),
          ),
        ],
      );
    }

    return Text(
      title,
      style: textTheme.titleLarge?.copyWith(
        color: foregroundColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context, ColorScheme colorScheme, Color foregroundColor) {
    if (leading != null) return leading;
    
    if (!showBackButton) return null;

    // Check if there's a drawer in the Scaffold
    final scaffold = context.findAncestorWidgetOfExactType<Scaffold>();
    final hasDrawer = scaffold?.drawer != null;
    
    if (hasDrawer) {
      // Show hamburger menu for drawer
      return Builder(
        builder: (context) => IconButton(
          icon: Icon(
            Icons.menu,
            color: foregroundColor,
            size: ResponsiveUtils.getResponsiveIconSize(context, 24),
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: 'Menu',
        ),
      );
    } else {
      // Show back button for navigation
      return IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: foregroundColor,
          size: ResponsiveUtils.getResponsiveIconSize(context, 20),
        ),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: 'Back',
      );
    }
  }

  @override
  Size get preferredSize {
    final baseHeight = kToolbarHeight;
    final subtitleHeight = subtitle != null ? 20.0 : 0.0;
    return Size.fromHeight(baseHeight + subtitleHeight);
  }
}

class AnimatedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final String? subtitle;
  final Widget? titleWidget;
  final bool enableGradient;
  final List<Color>? gradientColors;
  final bool enableShadow;
  final double? shadowBlurRadius;
  final Color? shadowColor;
  final Duration animationDuration;

  const AnimatedAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle = true,
    this.bottom,
    this.onBackPressed,
    this.showBackButton = true,
    this.subtitle,
    this.titleWidget,
    this.enableGradient = false,
    this.gradientColors,
    this.enableShadow = true,
    this.shadowBlurRadius,
    this.shadowColor,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedAppBar> createState() => _AnimatedAppBarState();

  @override
  Size get preferredSize {
    final baseHeight = kToolbarHeight;
    final subtitleHeight = subtitle != null ? 20.0 : 0.0;
    return Size.fromHeight(baseHeight + subtitleHeight);
  }
}

class _AnimatedAppBarState extends State<AnimatedAppBar> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _slideController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: EnhancedAppBar(
          title: widget.title,
          actions: widget.actions,
          leading: widget.leading,
          automaticallyImplyLeading: widget.automaticallyImplyLeading,
          backgroundColor: widget.backgroundColor,
          foregroundColor: widget.foregroundColor,
          elevation: widget.elevation,
          centerTitle: widget.centerTitle,
          bottom: widget.bottom,
          onBackPressed: widget.onBackPressed,
          showBackButton: widget.showBackButton,
          subtitle: widget.subtitle,
          titleWidget: widget.titleWidget,
          enableGradient: widget.enableGradient,
          gradientColors: widget.gradientColors,
          enableShadow: widget.enableShadow,
          shadowBlurRadius: widget.shadowBlurRadius,
          shadowColor: widget.shadowColor,
        ),
      ),
    );
  }
}

class FloatingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? subtitle;
  final Widget? titleWidget;
  final bool enableGradient;
  final List<Color>? gradientColors;
  final EdgeInsets margin;
  final double borderRadius;

  const FloatingAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.subtitle,
    this.titleWidget,
    this.enableGradient = false,
    this.gradientColors,
    this.margin = const EdgeInsets.all(16.0),
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
    final effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: enableGradient ? null : effectiveBackgroundColor,
        gradient: enableGradient ? LinearGradient(
          colors: gradientColors ?? [
            effectiveBackgroundColor,
            effectiveBackgroundColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ) : null,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        title: titleWidget ?? _buildTitle(textTheme, effectiveForegroundColor),
        leading: leading,
        actions: actions,
        backgroundColor: Colors.transparent,
        foregroundColor: effectiveForegroundColor,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
    );
  }

  Widget _buildTitle(TextTheme textTheme, Color foregroundColor) {
    if (subtitle != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle!,
            style: textTheme.bodySmall?.copyWith(
              color: foregroundColor.withOpacity(0.7),
            ),
          ),
        ],
      );
    }

    return Text(
      title,
      style: textTheme.titleLarge?.copyWith(
        color: foregroundColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Size get preferredSize {
    final baseHeight = kToolbarHeight;
    final subtitleHeight = subtitle != null ? 20.0 : 0.0;
    return Size.fromHeight(baseHeight + subtitleHeight + margin.vertical);
  }
}
