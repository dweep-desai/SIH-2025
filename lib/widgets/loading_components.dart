import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class LoadingComponents {
  static Widget buildModernLoadingIndicator({
    String? message,
    Color? color,
    double? size,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    final effectiveColor = color ?? colorScheme.primary;
    final effectiveSize = size ?? ResponsiveUtils.getResponsiveIconSize(context, 40);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: effectiveSize,
            height: effectiveSize,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
            ),
          ),
          if (message != null) ...[
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  static Widget buildSkeletonCard({
    double? height,
    EdgeInsets? margin,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: margin ?? ResponsiveUtils.getResponsiveMargin(context),
      height: height ?? ResponsiveUtils.getResponsiveSpacing(context, 120),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
      ),
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSkeletonLine(
              width: ResponsiveUtils.getResponsiveSpacing(context, 200),
              height: ResponsiveUtils.getResponsiveSpacing(context, 20),
              context: context,
              colorScheme: colorScheme,
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            _buildSkeletonLine(
              width: ResponsiveUtils.getResponsiveSpacing(context, 150),
              height: ResponsiveUtils.getResponsiveSpacing(context, 16),
              context: context,
              colorScheme: colorScheme,
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
            _buildSkeletonLine(
              width: ResponsiveUtils.getResponsiveSpacing(context, 100),
              height: ResponsiveUtils.getResponsiveSpacing(context, 16),
              context: context,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildSkeletonList({
    int itemCount = 3,
    required BuildContext context,
  }) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: EdgeInsets.only(
            bottom: ResponsiveUtils.getResponsiveSpacing(context, 16),
          ),
          child: buildSkeletonListItem(context),
        ),
      ),
    );
  }

  static Widget buildSkeletonListItem(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: ResponsiveUtils.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
      ),
      child: Row(
        children: [
          _buildSkeletonCircle(
            size: ResponsiveUtils.getResponsiveIconSize(context, 40),
            context: context,
            colorScheme: colorScheme,
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSkeletonLine(
                  width: ResponsiveUtils.getResponsiveSpacing(context, 120),
                  height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                  context: context,
                  colorScheme: colorScheme,
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                _buildSkeletonLine(
                  width: ResponsiveUtils.getResponsiveSpacing(context, 80),
                  height: ResponsiveUtils.getResponsiveSpacing(context, 14),
                  context: context,
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildSkeletonChart({
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: ResponsiveUtils.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSkeletonLine(
            width: ResponsiveUtils.getResponsiveSpacing(context, 200),
            height: ResponsiveUtils.getResponsiveSpacing(context, 20),
            context: context,
            colorScheme: colorScheme,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
          Container(
            height: ResponsiveUtils.getResponsiveSpacing(context, 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                5,
                (index) => _buildSkeletonBar(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 40 + (index * 20)),
                  context: context,
                  colorScheme: colorScheme,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildShimmerEffect({
    required Widget child,
    required BuildContext context,
  }) {
    return Shimmer(
      child: child,
    );
  }

  static Widget buildPulseLoading({
    String? message,
    Color? color,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    final effectiveColor = color ?? colorScheme.primary;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PulseAnimation(
            color: effectiveColor,
            child: Container(
              width: ResponsiveUtils.getResponsiveIconSize(context, 60),
              height: ResponsiveUtils.getResponsiveIconSize(context, 60),
              decoration: BoxDecoration(
                color: effectiveColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          if (message != null) ...[
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  static Widget buildDotsLoading({
    String? message,
    Color? color,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    final effectiveColor = color ?? colorScheme.primary;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _DotsAnimation(
            color: effectiveColor,
            context: context,
          ),
          if (message != null) ...[
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  static Widget _buildSkeletonLine({
    required double width,
    required double height,
    required BuildContext context,
    required ColorScheme colorScheme,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.6),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 4)),
      ),
    );
  }

  static Widget _buildSkeletonCircle({
    required double size,
    required BuildContext context,
    required ColorScheme colorScheme,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
    );
  }

  static Widget _buildSkeletonBar({
    required double height,
    required BuildContext context,
    required ColorScheme colorScheme,
  }) {
    return Container(
      width: ResponsiveUtils.getResponsiveSpacing(context, 20),
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.6),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 4)),
      ),
    );
  }
}

class Shimmer extends StatefulWidget {
  final Widget child;

  const Shimmer({
    super.key,
    required this.child,
  });

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.4),
                Colors.transparent,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class _PulseAnimation extends StatefulWidget {
  final Widget child;
  final Color color;

  const _PulseAnimation({
    required this.child,
    required this.color,
  });

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

class _DotsAnimation extends StatefulWidget {
  final Color color;
  final BuildContext context;

  const _DotsAnimation({
    required this.color,
    required this.context,
  });

  @override
  State<_DotsAnimation> createState() => _DotsAnimationState();
}

class _DotsAnimationState extends State<_DotsAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );
    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Stagger the animations
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getResponsiveSpacing(widget.context, 4),
              ),
              width: ResponsiveUtils.getResponsiveSpacing(widget.context, 8),
              height: ResponsiveUtils.getResponsiveSpacing(widget.context, 8),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.3 + (_animations[index].value * 0.7)),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}
