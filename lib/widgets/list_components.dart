import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../utils/color_utils.dart';
import '../utils/typography_utils.dart';
import '../utils/spacing_utils.dart';
import '../utils/accessibility_utils.dart';

/// Modern list components with consistent styling and better interactions
class ModernListComponents {
  static const Duration _animationDuration = Duration(milliseconds: 200);

  /// Modern list tile with consistent styling and better states
  static Widget buildModernListTile({
    required String title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    bool isSelected = false,
    bool isEnabled = true,
    EdgeInsetsGeometry? contentPadding,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AccessibilityUtils.buildSemanticButton(
      label: semanticLabel ?? title,
      hint: subtitle ?? 'List item',
      onPressed: isEnabled ? (onTap ?? () {}) : () {},
      enabled: isEnabled,
      child: AnimatedContainer(
        duration: _animationDuration,
        decoration: BoxDecoration(
          color: isSelected 
              ? ColorUtils.primaryBlue.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12.0)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onTap : null,
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12.0)),
            child: Container(
              padding: contentPadding ?? SpacingUtils.listItemContentPadding,
              child: Row(
                children: [
                  // Leading widget
                  if (leading != null) ...[
                    leading,
                    const SizedBox(width: 16),
                  ],
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TypographyUtils.titleMediumStyle.copyWith(
                            color: isEnabled 
                                ? colorScheme.onSurface 
                                : colorScheme.onSurface.withOpacity(0.38),
                            fontWeight: FontWeight.w500,
                            fontSize: AccessibilityUtils.getAccessibleFontSize(
                              context,
                              TypographyUtils.titleMediumStyle.fontSize ?? 16,
                            ),
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TypographyUtils.bodyMediumStyle.copyWith(
                              color: isEnabled 
                                  ? colorScheme.onSurfaceVariant 
                                  : colorScheme.onSurfaceVariant.withOpacity(0.38),
                              fontSize: AccessibilityUtils.getAccessibleFontSize(
                                context,
                                TypographyUtils.bodyMediumStyle.fontSize ?? 14,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Trailing widget
                  if (trailing != null) ...[
                    const SizedBox(width: 16),
                    trailing,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Icon list tile with icon and consistent styling
  static Widget buildIconListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isSelected = false,
    bool isEnabled = true,
    Color? iconColor,
    EdgeInsetsGeometry? contentPadding,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final effectiveIconColor = iconColor ?? ColorUtils.primaryBlue;

    return buildModernListTile(
      context: context,
      title: title,
      subtitle: subtitle,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: effectiveIconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: effectiveIconColor,
          size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      isSelected: isSelected,
      isEnabled: isEnabled,
      contentPadding: contentPadding,
      semanticLabel: semanticLabel,
    );
  }

  /// Avatar list tile with avatar and user information
  static Widget buildAvatarListTile({
    required String title,
    required String subtitle,
    Widget? avatar,
    String? avatarUrl,
    Widget? trailing,
    VoidCallback? onTap,
    bool isSelected = false,
    bool isEnabled = true,
    EdgeInsetsGeometry? contentPadding,
    String? semanticLabel,
    required BuildContext context,
  }) {
    return buildModernListTile(
      context: context,
      title: title,
      subtitle: subtitle,
      leading: avatar ?? CircleAvatar(
        radius: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
        backgroundColor: ColorUtils.primaryBlue.withOpacity(0.1),
        child: avatarUrl == null
            ? Icon(
                Icons.person,
                color: ColorUtils.primaryBlue,
                size: ResponsiveUtils.getResponsiveIconSize(context, 16.0),
              )
            : null,
      ),
      trailing: trailing,
      onTap: onTap,
      isSelected: isSelected,
      isEnabled: isEnabled,
      contentPadding: contentPadding,
      semanticLabel: semanticLabel,
    );
  }

  /// Switch list tile with modern styling
  static Widget buildSwitchListTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isEnabled = true,
    EdgeInsetsGeometry? contentPadding,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AccessibilityUtils.buildSemanticButton(
      label: semanticLabel ?? title,
      hint: subtitle ?? 'Toggle switch',
      onPressed: isEnabled ? () => onChanged(!value) : () {},
      enabled: isEnabled,
      child: AnimatedContainer(
        duration: _animationDuration,
        decoration: BoxDecoration(
          color: value 
              ? ColorUtils.primaryBlue.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12.0)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? () => onChanged(!value) : null,
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12.0)),
            child: Container(
              padding: contentPadding ?? SpacingUtils.listItemContentPadding,
              child: Row(
                children: [
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TypographyUtils.titleMediumStyle.copyWith(
                            color: isEnabled 
                                ? colorScheme.onSurface 
                                : colorScheme.onSurface.withOpacity(0.38),
                            fontWeight: FontWeight.w500,
                            fontSize: AccessibilityUtils.getAccessibleFontSize(
                              context,
                              TypographyUtils.titleMediumStyle.fontSize ?? 16,
                            ),
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TypographyUtils.bodyMediumStyle.copyWith(
                              color: isEnabled 
                                  ? colorScheme.onSurfaceVariant 
                                  : colorScheme.onSurfaceVariant.withOpacity(0.38),
                              fontSize: AccessibilityUtils.getAccessibleFontSize(
                                context,
                                TypographyUtils.bodyMediumStyle.fontSize ?? 14,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Switch
                  const SizedBox(width: 16),
                  Switch(
                    value: value,
                    onChanged: isEnabled ? onChanged : null,
                    activeColor: ColorUtils.primaryBlue,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Checkbox list tile with modern styling
  static Widget buildCheckboxListTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
    bool isEnabled = true,
    EdgeInsetsGeometry? contentPadding,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AccessibilityUtils.buildSemanticButton(
      label: semanticLabel ?? title,
      hint: subtitle ?? 'Checkbox item',
      onPressed: isEnabled ? () => onChanged(!value) : () {},
      enabled: isEnabled,
      child: AnimatedContainer(
        duration: _animationDuration,
        decoration: BoxDecoration(
          color: value 
              ? ColorUtils.primaryBlue.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12.0)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? () => onChanged(!value) : null,
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12.0)),
            child: Container(
              padding: contentPadding ?? SpacingUtils.listItemContentPadding,
              child: Row(
                children: [
                  // Checkbox
                  Checkbox(
                    value: value,
                    onChanged: isEnabled ? onChanged : null,
                    activeColor: ColorUtils.primaryBlue,
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TypographyUtils.titleMediumStyle.copyWith(
                            color: isEnabled 
                                ? colorScheme.onSurface 
                                : colorScheme.onSurface.withOpacity(0.38),
                            fontWeight: FontWeight.w500,
                            fontSize: AccessibilityUtils.getAccessibleFontSize(
                              context,
                              TypographyUtils.titleMediumStyle.fontSize ?? 16,
                            ),
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TypographyUtils.bodyMediumStyle.copyWith(
                              color: isEnabled 
                                  ? colorScheme.onSurfaceVariant 
                                  : colorScheme.onSurfaceVariant.withOpacity(0.38),
                              fontSize: AccessibilityUtils.getAccessibleFontSize(
                                context,
                                TypographyUtils.bodyMediumStyle.fontSize ?? 14,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Radio list tile with modern styling
  static Widget buildRadioListTile<T>({
    required String title,
    String? subtitle,
    required T value,
    required T groupValue,
    required ValueChanged<T?> onChanged,
    bool isEnabled = true,
    EdgeInsetsGeometry? contentPadding,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = value == groupValue;

    return AccessibilityUtils.buildSemanticButton(
      label: semanticLabel ?? title,
      hint: subtitle ?? 'Radio option',
      onPressed: isEnabled ? () => onChanged(value) : () {},
      enabled: isEnabled,
      child: AnimatedContainer(
        duration: _animationDuration,
        decoration: BoxDecoration(
          color: isSelected 
              ? ColorUtils.primaryBlue.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12.0)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? () => onChanged(value) : null,
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12.0)),
            child: Container(
              padding: contentPadding ?? SpacingUtils.listItemContentPadding,
              child: Row(
                children: [
                  // Radio
                  Radio<T>(
                    value: value,
                    groupValue: groupValue,
                    onChanged: isEnabled ? onChanged : null,
                    activeColor: ColorUtils.primaryBlue,
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TypographyUtils.titleMediumStyle.copyWith(
                            color: isEnabled 
                                ? colorScheme.onSurface 
                                : colorScheme.onSurface.withOpacity(0.38),
                            fontWeight: FontWeight.w500,
                            fontSize: AccessibilityUtils.getAccessibleFontSize(
                              context,
                              TypographyUtils.titleMediumStyle.fontSize ?? 16,
                            ),
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TypographyUtils.bodyMediumStyle.copyWith(
                              color: isEnabled 
                                  ? colorScheme.onSurfaceVariant 
                                  : colorScheme.onSurfaceVariant.withOpacity(0.38),
                              fontSize: AccessibilityUtils.getAccessibleFontSize(
                                context,
                                TypographyUtils.bodyMediumStyle.fontSize ?? 14,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Modern list with consistent dividers and spacing
  static Widget buildModernList({
    required List<Widget> children,
    EdgeInsetsGeometry? padding,
    bool showDividers = true,
    Color? dividerColor,
    double? dividerHeight,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveDividerColor = dividerColor ?? colorScheme.outline.withOpacity(0.2);
    final effectiveDividerHeight = dividerHeight ?? 1.0;

    List<Widget> listChildren = [];
    
    for (int i = 0; i < children.length; i++) {
      listChildren.add(children[i]);
      
      if (showDividers && i < children.length - 1) {
        listChildren.add(
          Container(
            height: effectiveDividerHeight,
            color: effectiveDividerColor,
            margin: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
            ),
          ),
        );
      }
    }

    return AccessibilityUtils.buildSemanticCard(
      label: semanticLabel ?? 'List',
      child: Container(
        padding: padding ?? SpacingUtils.listPadding,
        child: Column(
          children: listChildren,
        ),
      ),
    );
  }

  /// Sectioned list with headers and consistent styling
  static Widget buildSectionedList({
    required List<ListSection> sections,
    EdgeInsetsGeometry? padding,
    bool showDividers = true,
    Color? dividerColor,
    double? dividerHeight,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveDividerColor = dividerColor ?? colorScheme.outline.withOpacity(0.2);
    final effectiveDividerHeight = dividerHeight ?? 1.0;

    List<Widget> allChildren = [];
    
    for (int sectionIndex = 0; sectionIndex < sections.length; sectionIndex++) {
      final section = sections[sectionIndex];
      
      // Section header
      if (section.title != null) {
        allChildren.add(
          Padding(
            padding: EdgeInsets.only(
              top: sectionIndex > 0 ? ResponsiveUtils.getResponsiveSpacing(context, 24.0) : 0,
              bottom: ResponsiveUtils.getResponsiveSpacing(context, 8.0),
              left: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
              right: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
            ),
            child: Text(
              section.title!,
              style: TypographyUtils.labelLargeStyle.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: AccessibilityUtils.getAccessibleFontSize(
                  context,
                  TypographyUtils.labelLargeStyle.fontSize ?? 14,
                ),
              ),
            ),
          ),
        );
      }
      
      // Section items
      for (int itemIndex = 0; itemIndex < section.children.length; itemIndex++) {
        allChildren.add(section.children[itemIndex]);
        
        if (showDividers && itemIndex < section.children.length - 1) {
          allChildren.add(
            Container(
              height: effectiveDividerHeight,
              color: effectiveDividerColor,
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
              ),
            ),
          );
        }
      }
    }

    return AccessibilityUtils.buildSemanticCard(
      label: semanticLabel ?? 'Sectioned list',
      child: Container(
        padding: padding ?? SpacingUtils.listPadding,
        child: Column(
          children: allChildren,
        ),
      ),
    );
  }

  /// Expandable list section with header and collapsible content
  static Widget buildExpandableListSection({
    required String title,
    required List<Widget> children,
    bool isExpanded = false,
    required ValueChanged<bool> onExpansionChanged,
    Widget? leading,
    Widget? trailing,
    EdgeInsetsGeometry? padding,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AccessibilityUtils.buildSemanticCard(
      label: semanticLabel ?? 'Expandable section: $title',
      child: Container(
        padding: padding ?? SpacingUtils.listPadding,
        child: Column(
          children: [
            // Header
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onExpansionChanged(!isExpanded),
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12.0)),
                child: Container(
                  padding: SpacingUtils.listItemContentPadding,
                  child: Row(
                    children: [
                      if (leading != null) ...[
                        leading,
                        const SizedBox(width: 16),
                      ],
                      Expanded(
                        child: Text(
                          title,
                          style: TypographyUtils.titleMediumStyle.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: AccessibilityUtils.getAccessibleFontSize(
                              context,
                              TypographyUtils.titleMediumStyle.fontSize ?? 16,
                            ),
                          ),
                        ),
                      ),
                      if (trailing != null) ...[
                        trailing,
                        const SizedBox(width: 8),
                      ],
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: _animationDuration,
                        child: Icon(
                          Icons.expand_more,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: children,
              ),
              crossFadeState: isExpanded 
                  ? CrossFadeState.showSecond 
                  : CrossFadeState.showFirst,
              duration: _animationDuration,
            ),
          ],
        ),
      ),
    );
  }
}

/// Data class for list sections
class ListSection {
  final String? title;
  final List<Widget> children;

  const ListSection({
    this.title,
    required this.children,
  });
}
