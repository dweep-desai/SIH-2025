import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../utils/accessibility_utils.dart';
import 'button_components.dart';

class ModernFormComponents {
  static Widget buildModernTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    int? maxLines = 1,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    void Function(String)? onChanged,
    bool enabled = true,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
        enabled: enabled,
        style: textTheme.bodyLarge?.copyWith(
          color: enabled ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.6),
          fontSize: AccessibilityUtils.getAccessibleFontSize(context, 16),
        ),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: enabled 
              ? colorScheme.surfaceContainerHighest
              : colorScheme.surfaceContainerHighest.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0)),
            borderSide: BorderSide(
              color: colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0)),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0)),
            borderSide: BorderSide(
              color: colorScheme.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0)),
            borderSide: BorderSide(
              color: colorScheme.error,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0)),
            borderSide: BorderSide(
              color: colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
            vertical: ResponsiveUtils.getResponsiveSpacing(context, 12.0),
          ),
          labelStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          hintStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  static Widget buildModernDropdownField<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required String labelText,
    String? hintText,
    IconData? prefixIcon,
    String? Function(T?)? validator,
    void Function(T?)? onChanged,
    bool enabled = true,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: enabled ? onChanged : null,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          filled: true,
          fillColor: enabled 
              ? colorScheme.surfaceContainerHighest
              : colorScheme.surfaceContainerHighest.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0)),
            borderSide: BorderSide(
              color: colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0)),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0)),
            borderSide: BorderSide(
              color: colorScheme.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0)),
            borderSide: BorderSide(
              color: colorScheme.error,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0)),
            borderSide: BorderSide(
              color: colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
            vertical: ResponsiveUtils.getResponsiveSpacing(context, 12.0),
          ),
          labelStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          hintStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
        ),
        dropdownColor: colorScheme.surfaceContainerHighest,
        style: textTheme.bodyLarge?.copyWith(
          color: enabled ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.6),
        ),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  static Widget buildModernButton({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    Color? backgroundColor,
    Color? foregroundColor,
    bool isLoading = false,
    bool isOutlined = false,
    double? width,
    double? height,
    required BuildContext context,
    String? semanticLabel,
  }) {
    // Use the new ModernButtonComponents based on styling preferences
    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height,
        child: ModernButtonComponents.buildSecondaryButton(
          context: context,
          text: text,
          onPressed: onPressed,
          icon: icon,
          isLoading: isLoading,
          isFullWidth: width != null,
          semanticLabel: semanticLabel,
        ),
      );
    } else {
      return SizedBox(
        width: width,
        height: height,
        child: ModernButtonComponents.buildPrimaryButton(
          context: context,
          text: text,
          onPressed: onPressed,
          icon: icon,
          isLoading: isLoading,
          isFullWidth: width != null,
          semanticLabel: semanticLabel,
        ),
      );
    }
  }


  static Widget buildModernCard({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? backgroundColor,
    double? elevation,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: margin ?? ResponsiveUtils.getResponsiveMargin(context),
      child: Card(
        elevation: elevation ?? ResponsiveUtils.getResponsiveElevation(context, 2.0),
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        color: backgroundColor ?? colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20.0)),
        ),
        child: Padding(
          padding: padding ?? ResponsiveUtils.getResponsivePadding(context),
          child: child,
        ),
      ),
    );
  }

  static Widget buildFormSection({
    required String title,
    required Widget child,
    String? subtitle,
    IconData? icon,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: colorScheme.primary,
                size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8.0)),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4.0)),
                    Text(
                      subtitle,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16.0)),
        child,
      ],
    );
  }

  static Widget buildFileUploadButton({
    required String text,
    required VoidCallback onPressed,
    String? fileName,
    IconData? icon,
    bool isLoading = false,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                ),
              )
            : Icon(icon ?? Icons.upload_file),
        label: Text(
          fileName != null ? 'Change File ($fileName)' : text,
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getResponsiveSpacing(context, 20.0),
            vertical: ResponsiveUtils.getResponsiveSpacing(context, 12.0),
          ),
        ),
      ),
    );
  }

  static Widget buildValidationMessage({
    required String message,
    bool isError = true,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(top: ResponsiveUtils.getResponsiveSpacing(context, 8.0)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getResponsiveSpacing(context, 12.0),
        vertical: ResponsiveUtils.getResponsiveSpacing(context, 8.0),
      ),
      decoration: BoxDecoration(
        color: isError 
            ? colorScheme.errorContainer
            : colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 8.0)),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError ? colorScheme.error : colorScheme.primary,
            size: ResponsiveUtils.getResponsiveIconSize(context, 16.0),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8.0)),
          Expanded(
            child: Text(
              message,
              style: textTheme.bodySmall?.copyWith(
                color: isError ? colorScheme.onErrorContainer : colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
