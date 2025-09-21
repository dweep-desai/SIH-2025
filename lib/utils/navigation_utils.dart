import 'package:flutter/material.dart';

class NavigationUtils {
  // Custom page transitions
  static Route<T> createSlideRoute<T>(Widget page, {Offset? beginOffset}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: beginOffset ?? begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static Route<T> createFadeRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        var tween = Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }

  static Route<T> createScaleRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        var tween = Tween<double>(begin: 0.8, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        return ScaleTransition(
          scale: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static Route<T> createSlideUpRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  // Enhanced navigation methods
  static Future<T?> pushWithSlide<T extends Object?>(
    BuildContext context,
    Widget page, {
    Offset? beginOffset,
  }) {
    return Navigator.push<T>(
      context,
      createSlideRoute<T>(page, beginOffset: beginOffset),
    );
  }

  static Future<T?> pushWithFade<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.push<T>(
      context,
      createFadeRoute<T>(page),
    );
  }

  static Future<T?> pushWithScale<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.push<T>(
      context,
      createScaleRoute<T>(page),
    );
  }

  static Future<T?> pushWithSlideUp<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.push<T>(
      context,
      createSlideUpRoute<T>(page),
    );
  }

  static Future<T?> pushReplacementWithSlide<T extends Object?>(
    BuildContext context,
    Widget page, {
    Offset? beginOffset,
  }) {
    return Navigator.pushReplacement<T, dynamic>(
      context,
      createSlideRoute<T>(page, beginOffset: beginOffset),
    );
  }

  static Future<T?> pushReplacementWithFade<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.pushReplacement<T, dynamic>(
      context,
      createFadeRoute<T>(page),
    );
  }

  static Future<T?> pushReplacementWithScale<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.pushReplacement<T, dynamic>(
      context,
      createScaleRoute<T>(page),
    );
  }

  // Animated navigation with haptic feedback
  static Future<T?> pushWithHaptic<T extends Object?>(
    BuildContext context,
    Widget page, {
    Offset? beginOffset,
    bool enableHaptic = true,
  }) {
    if (enableHaptic) {
      // Add haptic feedback
      // HapticFeedback.lightImpact();
    }
    return pushWithSlide<T>(context, page, beginOffset: beginOffset);
  }

  // Navigation with loading state
  static Future<T?> pushWithLoading<T extends Object?>(
    BuildContext context,
    Widget page, {
    String? loadingMessage,
  }) {
    // Show loading indicator
    if (loadingMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loadingMessage),
          duration: const Duration(seconds: 1),
        ),
      );
    }
    
    return pushWithSlide<T>(context, page);
  }

  // Custom back navigation with confirmation
  static Future<bool> popWithConfirmation(
    BuildContext context, {
    String? title,
    String? message,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? 'Confirm Exit'),
        content: Text(message ?? 'Are you sure you want to go back?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    
    if (result == true) {
      Navigator.of(context).pop();
    }
    return result ?? false;
  }

  // Navigation with animation and delay
  static Future<T?> pushWithDelay<T extends Object?>(
    BuildContext context,
    Widget page, {
    Duration delay = const Duration(milliseconds: 100),
    Offset? beginOffset,
  }) async {
    await Future.delayed(delay);
    return pushWithSlide<T>(context, page, beginOffset: beginOffset);
  }

  // Batch navigation (multiple pages)
  static Future<void> pushMultiple(
    BuildContext context,
    List<Widget> pages, {
    Duration delayBetween = const Duration(milliseconds: 200),
  }) async {
    for (int i = 0; i < pages.length; i++) {
      if (i == 0) {
        await pushWithSlide(context, pages[i]);
      } else {
        await Future.delayed(delayBetween);
        await pushReplacementWithSlide(context, pages[i]);
      }
    }
  }

  // Navigation with custom transition
  static Route<T> createCustomRoute<T>(
    Widget page, {
    required Widget Function(BuildContext, Animation<double>, Animation<double>, Widget) transitionBuilder,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOutCubic,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: transitionBuilder,
      transitionDuration: duration,
    );
  }

  // Navigation with shared element transition
  static Route<T> createSharedElementRoute<T>(
    Widget page, {
    required String heroTag,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return Hero(
          tag: heroTag,
          child: child,
          transitionOnUserGestures: true,
        );
      },
      transitionDuration: duration,
    );
  }

  // Navigation with custom curve
  static Route<T> createCurvedRoute<T>(
    Widget page, {
    Curve curve = Curves.easeInOutCubic,
    Duration duration = const Duration(milliseconds: 300),
    Offset? beginOffset,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;

        var tween = Tween(begin: beginOffset ?? begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: duration,
    );
  }
}
