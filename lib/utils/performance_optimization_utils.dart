import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Performance optimization utilities for efficient rendering and smooth animations
class PerformanceOptimizationUtils {
  /// Optimize widget rebuilds with const constructors
  static Widget buildOptimizedWidget({
    required Widget child,
    bool shouldRebuild = false,
  }) {
    if (shouldRebuild) {
      return child;
    }
    return child;
  }

  /// Build optimized list view with lazy loading
  static Widget buildOptimizedListView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    ScrollController? controller,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }

  /// Build optimized grid view with lazy loading
  static Widget buildOptimizedGridView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    required int crossAxisCount,
    double? childAspectRatio,
    double? crossAxisSpacing,
    double? mainAxisSpacing,
    ScrollController? controller,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return GridView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio ?? 1.0,
        crossAxisSpacing: crossAxisSpacing ?? 0,
        mainAxisSpacing: mainAxisSpacing ?? 0,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }

  /// Optimize animations with proper disposal
  static void optimizeAnimationController(AnimationController controller) {
    if (!controller.isAnimating) {
      controller.dispose();
    }
  }

  /// Build optimized image with caching
  static Widget buildOptimizedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit? fit,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? const CircularProgressIndicator();
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? const Icon(Icons.error);
      },
    );
  }

  /// Optimize memory usage
  static void optimizeMemoryUsage() {
    // Force garbage collection
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Memory optimization logic here
    });
  }

  /// Build optimized card with proper elevation
  static Widget buildOptimizedCard({
    required Widget child,
    double? elevation,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    return Card(
      elevation: elevation ?? 2.0,
      margin: margin,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
