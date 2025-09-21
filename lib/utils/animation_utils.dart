import 'package:flutter/material.dart';

class AnimationUtils {
  // Animation durations
  static const Duration fastDuration = Duration(milliseconds: 150);
  static const Duration normalDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 500);
  static const Duration verySlowDuration = Duration(milliseconds: 800);

  // Animation curves
  static const Curve fastCurve = Curves.easeInOut;
  static const Curve normalCurve = Curves.easeInOutCubic;
  static const Curve slowCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve springCurve = Curves.elasticOut;

  // Fade animations
  static Widget buildFadeTransition({
    required Widget child,
    required Animation<double> animation,
    Duration duration = normalDuration,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  static Widget buildFadeIn({
    required Widget child,
    Duration duration = normalDuration,
    Curve curve = normalCurve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget buildFadeOut({
    required Widget child,
    Duration duration = normalDuration,
    Curve curve = normalCurve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: 1.0, end: 0.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Slide animations
  static Widget buildSlideTransition({
    required Widget child,
    required Animation<double> animation,
    Offset begin = const Offset(0.0, 1.0),
    Offset end = Offset.zero,
    Duration duration = normalDuration,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: begin,
        end: end,
      ).animate(animation),
      child: child,
    );
  }

  static Widget buildSlideInFromBottom({
    required Widget child,
    Duration duration = normalDuration,
    Curve curve = normalCurve,
  }) {
    return TweenAnimationBuilder<Offset>(
      duration: duration,
      curve: curve,
      tween: Tween(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ),
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget buildSlideInFromTop({
    required Widget child,
    Duration duration = normalDuration,
    Curve curve = normalCurve,
  }) {
    return TweenAnimationBuilder<Offset>(
      duration: duration,
      curve: curve,
      tween: Tween(
        begin: const Offset(0.0, -1.0),
        end: Offset.zero,
      ),
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget buildSlideInFromLeft({
    required Widget child,
    Duration duration = normalDuration,
    Curve curve = normalCurve,
  }) {
    return TweenAnimationBuilder<Offset>(
      duration: duration,
      curve: curve,
      tween: Tween(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ),
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget buildSlideInFromRight({
    required Widget child,
    Duration duration = normalDuration,
    Curve curve = normalCurve,
  }) {
    return TweenAnimationBuilder<Offset>(
      duration: duration,
      curve: curve,
      tween: Tween(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ),
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Scale animations
  static Widget buildScaleTransition({
    required Widget child,
    required Animation<double> animation,
    double begin = 0.0,
    double end = 1.0,
    Duration duration = normalDuration,
  }) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: begin,
        end: end,
      ).animate(animation),
      child: child,
    );
  }

  static Widget buildScaleIn({
    required Widget child,
    Duration duration = normalDuration,
    Curve curve = springCurve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget buildScaleOut({
    required Widget child,
    Duration duration = normalDuration,
    Curve curve = normalCurve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: 1.0, end: 0.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Rotation animations
  static Widget buildRotationTransition({
    required Widget child,
    required Animation<double> animation,
    double begin = 0.0,
    double end = 1.0,
    Duration duration = normalDuration,
  }) {
    return RotationTransition(
      turns: Tween<double>(
        begin: begin,
        end: end,
      ).animate(animation),
      child: child,
    );
  }

  static Widget buildRotateIn({
    required Widget child,
    Duration duration = normalDuration,
    Curve curve = normalCurve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 2 * 3.14159, // Full rotation
          child: child,
        );
      },
      child: child,
    );
  }

  // Combined animations
  static Widget buildSlideAndFadeIn({
    required Widget child,
    Duration duration = normalDuration,
    Curve curve = normalCurve,
    Offset slideOffset = const Offset(0.0, 0.3),
  }) {
    return TweenAnimationBuilder<Offset>(
      duration: duration,
      curve: curve,
      tween: Tween(
        begin: slideOffset,
        end: Offset.zero,
      ),
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: Opacity(
            opacity: 1.0 - (value.distance / slideOffset.distance),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  static Widget buildScaleAndFadeIn({
    required Widget child,
    Duration duration = normalDuration,
    Curve curve = springCurve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Staggered animations
  static Widget buildStaggeredFadeIn({
    required List<Widget> children,
    Duration duration = normalDuration,
    Duration staggerDelay = const Duration(milliseconds: 100),
    Curve curve = normalCurve,
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        
        return TweenAnimationBuilder<double>(
          duration: duration + (staggerDelay * index),
          curve: curve,
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: child,
        );
      }).toList(),
    );
  }

  // Hover animations
  static Widget buildHoverEffect({
    required Widget child,
    double hoverScale = 1.05,
    Duration duration = fastDuration,
    Curve curve = normalCurve,
  }) {
    return MouseRegion(
      child: AnimatedContainer(
        duration: duration,
        curve: curve,
        child: child,
      ),
    );
  }

  // Pulse animations
  static Widget buildPulseAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1000),
    double minScale = 0.95,
    double maxScale = 1.05,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: minScale, end: maxScale),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      onEnd: () {
        // This would need to be handled by the parent widget
        // to create a continuous pulse effect
      },
      child: child,
    );
  }

  // Shake animations
  static Widget buildShakeAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    double shakeIntensity = 10.0,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        final shake = shakeIntensity * (0.5 - (value - 0.5).abs());
        return Transform.translate(
          offset: Offset(shake, 0),
          child: child,
        );
      },
      child: child,
    );
  }

  // Bounce animations
  static Widget buildBounceIn({
    required Widget child,
    Duration duration = normalDuration,
    Curve curve = bounceCurve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Loading animations
  static Widget buildLoadingDots({
    Color color = Colors.blue,
    double size = 8.0,
    Duration duration = const Duration(milliseconds: 600),
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return TweenAnimationBuilder<double>(
          duration: duration,
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            final delay = index * 0.2;
            final animationValue = (value - delay).clamp(0.0, 1.0);
            final scale = 0.5 + (0.5 * (1 - (animationValue - 0.5).abs() * 2));
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
          child: Container(),
        );
      }),
    );
  }

  // Progress animations
  static Widget buildAnimatedProgress({
    required double progress,
    Duration duration = normalDuration,
    Curve curve = normalCurve,
    Color? color,
    Color? backgroundColor,
    double height = 4.0,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: 0.0, end: progress),
      builder: (context, value, child) {
        return LinearProgressIndicator(
          value: value,
          backgroundColor: backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.blue),
          minHeight: height,
        );
      },
    );
  }

  // Card animations
  static Widget buildAnimatedCard({
    required Widget child,
    Duration duration = normalDuration,
    Curve curve = normalCurve,
    double elevation = 4.0,
    Color? shadowColor,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: Card(
            elevation: elevation * value,
            shadowColor: shadowColor,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // List item animations
  static Widget buildAnimatedListItem({
    required Widget child,
    required int index,
    Duration duration = normalDuration,
    Duration staggerDelay = const Duration(milliseconds: 50),
    Curve curve = normalCurve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration + (staggerDelay * index),
      curve: curve,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Micro-interactions
  static Widget buildTapEffect({
    required Widget child,
    required VoidCallback onTap,
    double scale = 0.95,
    Duration duration = fastDuration,
    Curve curve = normalCurve,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        duration: duration,
        curve: curve,
        tween: Tween(begin: 1.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: child,
      ),
    );
  }

  // Page transition animations
  static Widget buildPageTransition({
    required Widget child,
    required Animation<double> animation,
    PageTransitionType type = PageTransitionType.slide,
  }) {
    switch (type) {
      case PageTransitionType.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      case PageTransitionType.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      case PageTransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(animation),
          child: child,
        );
      case PageTransitionType.rotation:
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(animation),
          child: child,
        );
    }
  }
}

enum PageTransitionType {
  slide,
  fade,
  scale,
  rotation,
}
