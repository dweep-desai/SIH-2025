import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../utils/color_utils.dart';
import '../utils/typography_utils.dart';
import '../utils/spacing_utils.dart';
import '../utils/accessibility_utils.dart';

/// Modern button components with consistent styling and better states
class ModernButtonComponents {
  static const Duration _animationDuration = Duration(milliseconds: 200);

  /// Helper method to get responsive button height
  static double _getButtonHeight(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
      return 48.0;
    } else if (ResponsiveUtils.isTablet(context)) {
      return 52.0;
    } else {
      return 56.0;
    }
  }

  /// Primary action button with gradient background
  static Widget buildPrimaryButton({
    required BuildContext context,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
    EdgeInsetsGeometry? padding,
    String? semanticLabel,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = onPressed != null && !isLoading;

    return AccessibilityUtils.buildSemanticButton(
      label: semanticLabel ?? text,
      hint: 'Primary action button',
      onPressed: isEnabled ? onPressed : () {},
      enabled: isEnabled,
      child: AnimatedContainer(
        duration: _animationDuration,
        width: isFullWidth ? double.infinity : null,
        height: _getButtonHeight(context),
        decoration: BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
                  colors: [
                    ColorUtils.primaryBlue,
                    ColorUtils.primaryBlue.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isEnabled ? null : colorScheme.onSurface.withOpacity(0.12),
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getResponsiveBorderRadius(context, 12.0),
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: ColorUtils.primaryBlue.withOpacity(0.3),
                    blurRadius: ResponsiveUtils.getResponsiveElevation(context, 8),
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getResponsiveBorderRadius(context, 12.0),
            ),
            child: Container(
              padding: padding ?? SpacingUtils.buttonPaddingAll,
              child: _buildButtonContent(
                context,
                text: text,
                icon: icon,
                isLoading: isLoading,
                textColor: isEnabled ? Colors.white : colorScheme.onSurface.withOpacity(0.38),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Secondary action button with outline style
  static Widget buildSecondaryButton({
    required BuildContext context,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
    EdgeInsetsGeometry? padding,
    String? semanticLabel,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = onPressed != null && !isLoading;

    return AccessibilityUtils.buildSemanticButton(
      label: semanticLabel ?? text,
      hint: 'Secondary action button',
      onPressed: isEnabled ? onPressed : () {},
      enabled: isEnabled,
      child: AnimatedContainer(
        duration: _animationDuration,
        width: isFullWidth ? double.infinity : null,
        height: _getButtonHeight(context),
        decoration: BoxDecoration(
          border: Border.all(
            color: isEnabled ? ColorUtils.primaryBlue : colorScheme.onSurface.withOpacity(0.12),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getResponsiveBorderRadius(context, 12.0),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getResponsiveBorderRadius(context, 12.0),
            ),
            child: Container(
              padding: padding ?? SpacingUtils.buttonPaddingAll,
              child: _buildButtonContent(
                context,
                text: text,
                icon: icon,
                isLoading: isLoading,
                textColor: isEnabled ? ColorUtils.primaryBlue : colorScheme.onSurface.withOpacity(0.38),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Tertiary/text button with minimal styling
  static Widget buildTextButton({
    required BuildContext context,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    EdgeInsetsGeometry? padding,
    String? semanticLabel,
    Color? textColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = onPressed != null && !isLoading;
    final effectiveTextColor = textColor ?? (isEnabled ? ColorUtils.primaryBlue : colorScheme.onSurface.withOpacity(0.38));

    return AccessibilityUtils.buildSemanticButton(
      label: semanticLabel ?? text,
      hint: 'Text button',
      onPressed: isEnabled ? onPressed : () {},
      enabled: isEnabled,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getResponsiveBorderRadius(context, 12.0),
          ),
          child: Container(
            padding: padding ?? SpacingUtils.buttonPaddingHorizontal,
            child: _buildButtonContent(
              context,
              text: text,
              icon: icon,
              isLoading: isLoading,
              textColor: effectiveTextColor,
            ),
          ),
        ),
      ),
    );
  }

  /// Floating Action Button with modern styling
  static Widget buildFloatingActionButton({
    required BuildContext context,
    required VoidCallback? onPressed,
    required IconData icon,
    String? tooltip,
    bool isExtended = false,
    String? label,
    bool isLoading = false,
  }) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null && !isLoading;

    return AccessibilityUtils.buildSemanticButton(
      label: tooltip ?? label ?? 'Floating action button',
      hint: 'Main action button',
      onPressed: isEnabled ? onPressed : () {},
      enabled: isEnabled,
      child: AnimatedContainer(
        duration: _animationDuration,
        decoration: BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
                  colors: [
                    ColorUtils.primaryBlue,
                    ColorUtils.primaryBlue.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isEnabled ? null : theme.colorScheme.onSurface.withOpacity(0.12),
          borderRadius: BorderRadius.circular(isExtended ? 16 : 28),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: ColorUtils.primaryBlue.withOpacity(0.3),
                    blurRadius: ResponsiveUtils.getResponsiveElevation(context, 12),
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(isExtended ? 16 : 28),
            child: Container(
              padding: isExtended
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                  : const EdgeInsets.all(16),
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isEnabled ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.38),
                        ),
                      ),
                    )
                  : isExtended && label != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icon,
                              color: isEnabled ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.38),
                              size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              label,
                              style: TypographyUtils.labelLargeStyle.copyWith(
                                color: isEnabled ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.38),
                                fontSize: AccessibilityUtils.getAccessibleFontSize(context, TypographyUtils.labelLargeStyle.fontSize ?? 14),
                              ),
                            ),
                          ],
                        )
                      : Icon(
                          icon,
                          color: isEnabled ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.38),
                          size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                        ),
            ),
          ),
        ),
      ),
    );
  }

  /// Icon button with modern styling and states
  static Widget buildIconButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onPressed,
    String? tooltip,
    bool isLoading = false,
    Color? iconColor,
    Color? backgroundColor,
    double? size,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = onPressed != null && !isLoading;
    final effectiveIconColor = iconColor ?? (isEnabled ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.38));
    final buttonSize = size ?? (ResponsiveUtils.isMobile(context) ? 40.0 : ResponsiveUtils.isTablet(context) ? 44.0 : 48.0);

    return AccessibilityUtils.buildSemanticButton(
      label: tooltip ?? 'Icon button',
      hint: 'Action button',
      onPressed: isEnabled ? onPressed : () {},
      enabled: isEnabled,
      child: AnimatedContainer(
        duration: _animationDuration,
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(buttonSize / 2),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(buttonSize / 2),
            child: Container(
              child: isLoading
                  ? Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(effectiveIconColor),
                        ),
                      ),
                    )
                  : Icon(
                      icon,
                      color: effectiveIconColor,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  /// Destructive button for dangerous actions
  static Widget buildDestructiveButton({
    required BuildContext context,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
    EdgeInsetsGeometry? padding,
    String? semanticLabel,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = onPressed != null && !isLoading;

    return AccessibilityUtils.buildSemanticButton(
      label: semanticLabel ?? text,
      hint: 'Destructive action button',
      onPressed: isEnabled ? onPressed : () {},
      enabled: isEnabled,
      child: AnimatedContainer(
        duration: _animationDuration,
        width: isFullWidth ? double.infinity : null,
        height: _getButtonHeight(context),
        decoration: BoxDecoration(
          color: isEnabled ? colorScheme.error : colorScheme.onSurface.withOpacity(0.12),
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getResponsiveBorderRadius(context, 12.0),
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: colorScheme.error.withOpacity(0.3),
                    blurRadius: ResponsiveUtils.getResponsiveElevation(context, 8),
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getResponsiveBorderRadius(context, 12.0),
            ),
            child: Container(
              padding: padding ?? SpacingUtils.buttonPaddingAll,
              child: _buildButtonContent(
                context,
                text: text,
                icon: icon,
                isLoading: isLoading,
                textColor: isEnabled ? colorScheme.onError : colorScheme.onSurface.withOpacity(0.38),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Success button for positive actions
  static Widget buildSuccessButton({
    required BuildContext context,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
    EdgeInsetsGeometry? padding,
    String? semanticLabel,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = onPressed != null && !isLoading;
    const successColor = Colors.green;

    return AccessibilityUtils.buildSemanticButton(
      label: semanticLabel ?? text,
      hint: 'Success action button',
      onPressed: isEnabled ? onPressed : () {},
      enabled: isEnabled,
      child: AnimatedContainer(
        duration: _animationDuration,
        width: isFullWidth ? double.infinity : null,
        height: _getButtonHeight(context),
        decoration: BoxDecoration(
          color: isEnabled ? successColor : colorScheme.onSurface.withOpacity(0.12),
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getResponsiveBorderRadius(context, 12.0),
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: successColor.withOpacity(0.3),
                    blurRadius: ResponsiveUtils.getResponsiveElevation(context, 8),
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getResponsiveBorderRadius(context, 12.0),
            ),
            child: Container(
              padding: padding ?? SpacingUtils.buttonPaddingAll,
              child: _buildButtonContent(
                context,
                text: text,
                icon: icon,
                isLoading: isLoading,
                textColor: isEnabled ? Colors.white : colorScheme.onSurface.withOpacity(0.38),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Chip-style button for tags and filters
  static Widget buildChipButton({
    required BuildContext context,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isSelected = false,
    bool isLoading = false,
    String? semanticLabel,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = onPressed != null && !isLoading;

    return AccessibilityUtils.buildSemanticButton(
      label: semanticLabel ?? text,
      hint: isSelected ? 'Selected chip button' : 'Chip button',
      onPressed: isEnabled ? onPressed : () {},
      enabled: isEnabled,
      child: AnimatedContainer(
        duration: _animationDuration,
        decoration: BoxDecoration(
          color: isSelected
              ? (isEnabled ? ColorUtils.primaryBlue : colorScheme.onSurface.withOpacity(0.12))
              : (isEnabled ? colorScheme.surface : colorScheme.onSurface.withOpacity(0.12)),
          border: Border.all(
            color: isSelected
                ? (isEnabled ? ColorUtils.primaryBlue : colorScheme.onSurface.withOpacity(0.12))
                : (isEnabled ? colorScheme.outline : colorScheme.onSurface.withOpacity(0.12)),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: _buildButtonContent(
                context,
                text: text,
                icon: icon,
                isLoading: isLoading,
                textColor: isSelected
                    ? (isEnabled ? Colors.white : colorScheme.onSurface.withOpacity(0.38))
                    : (isEnabled ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.38)),
                isCompact: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Helper method to build button content with text and optional icon
  static Widget _buildButtonContent(
    BuildContext context, {
    required String text,
    IconData? icon,
    bool isLoading = false,
    required Color textColor,
    bool isCompact = false,
  }) {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: (isCompact ? TypographyUtils.labelMediumStyle : TypographyUtils.labelLargeStyle).copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                (isCompact ? TypographyUtils.labelMediumStyle.fontSize : TypographyUtils.labelLargeStyle.fontSize) ?? 14,
              ),
            ),
          ),
        ],
      );
    }

    final textStyle = (isCompact ? TypographyUtils.labelMediumStyle : TypographyUtils.labelLargeStyle).copyWith(
      color: textColor,
      fontWeight: FontWeight.w600,
      fontSize: AccessibilityUtils.getAccessibleFontSize(
        context,
        (isCompact ? TypographyUtils.labelMediumStyle.fontSize : TypographyUtils.labelLargeStyle.fontSize) ?? 14,
      ),
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: textColor,
            size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
          ),
          SizedBox(width: isCompact ? 4 : 8),
          Text(text, style: textStyle),
        ],
      );
    }

    return Text(text, style: textStyle);
  }

  /// Button group for related actions
  static Widget buildButtonGroup({
    required BuildContext context,
    required List<ButtonGroupItem> buttons,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
    bool isVertical = false,
  }) {
    final children = buttons
        .map((button) => Expanded(
              child: Padding(
                padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 4)),
                child: button.builder(context),
              ),
            ))
        .toList();

    return isVertical
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          )
        : Row(
            mainAxisAlignment: mainAxisAlignment,
            children: children,
          );
  }
}

/// Data class for button group items
class ButtonGroupItem {
  final Widget Function(BuildContext) builder;

  const ButtonGroupItem({required this.builder});
}
