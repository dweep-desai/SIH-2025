import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../utils/color_utils.dart';
import '../utils/typography_utils.dart';
import '../utils/spacing_utils.dart';
import '../utils/accessibility_utils.dart';
import 'button_components.dart';

/// Modern search components with consistent styling and better user experience
class ModernSearchComponents {

  /// Modern search bar with consistent styling
  static Widget buildModernSearchBar({
    required TextEditingController controller,
    required String hintText,
    VoidCallback? onSearch,
    VoidCallback? onClear,
    ValueChanged<String>? onChanged,
    bool enabled = true,
    bool autofocus = false,
    EdgeInsetsGeometry? padding,
    String? semanticLabel,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: padding ?? SpacingUtils.listPadding,
      child: TextField(
        controller: controller,
        onSubmitted: onSearch != null ? (_) => onSearch() : null,
        onChanged: onChanged,
        enabled: enabled,
        autofocus: autofocus,
        style: TypographyUtils.bodyLargeStyle.copyWith(
          color: enabled ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.38),
          fontSize: AccessibilityUtils.getAccessibleFontSize(
            context,
            TypographyUtils.bodyLargeStyle.fontSize ?? 16,
          ),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TypographyUtils.bodyLargeStyle.copyWith(
            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
            fontSize: AccessibilityUtils.getAccessibleFontSize(
              context,
              TypographyUtils.bodyLargeStyle.fontSize ?? 16,
            ),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: enabled ? colorScheme.onSurfaceVariant : colorScheme.onSurfaceVariant.withOpacity(0.38),
            size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: colorScheme.onSurfaceVariant,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                  ),
                  onPressed: () {
                    controller.clear();
                    onClear?.call();
                  },
                )
              : null,
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
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0)),
            borderSide: BorderSide(
              color: ColorUtils.primaryBlue,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16.0)),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
            vertical: ResponsiveUtils.getResponsiveSpacing(context, 12.0),
          ),
        ),
      ),
    );
  }

  /// Search bar with filter button
  static Widget buildSearchBarWithFilter({
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onFilterTap,
    VoidCallback? onSearch,
    VoidCallback? onClear,
    ValueChanged<String>? onChanged,
    bool enabled = true,
    bool autofocus = false,
    EdgeInsetsGeometry? padding,
    String? semanticLabel,
    required BuildContext context,
  }) {
    return Container(
      padding: padding ?? SpacingUtils.listPadding,
      child: Row(
        children: [
          Expanded(
            child: buildModernSearchBar(
              context: context,
              controller: controller,
              hintText: hintText,
              onSearch: onSearch,
              onClear: onClear,
              onChanged: onChanged,
              enabled: enabled,
              autofocus: autofocus,
              semanticLabel: semanticLabel,
            ),
          ),
          const SizedBox(width: 12),
          ModernButtonComponents.buildIconButton(
            context: context,
            icon: Icons.filter_list,
            onPressed: onFilterTap,
            tooltip: 'Filter',
          ),
        ],
      ),
    );
  }

  /// Search results list with modern styling
  static Widget buildSearchResultsList({
    required List<SearchResultItem> results,
    required ValueChanged<SearchResultItem> onItemTap,
    bool isLoading = false,
    String? emptyMessage,
    String? errorMessage,
    VoidCallback? onRetry,
    EdgeInsetsGeometry? padding,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isLoading) {
      return Container(
        padding: padding ?? SpacingUtils.listPadding,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ColorUtils.primaryBlue),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Container(
        padding: padding ?? SpacingUtils.listPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: colorScheme.error,
              size: ResponsiveUtils.getResponsiveIconSize(context, 48.0),
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: TypographyUtils.bodyLargeStyle.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: AccessibilityUtils.getAccessibleFontSize(
                  context,
                  TypographyUtils.bodyLargeStyle.fontSize ?? 16,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ModernButtonComponents.buildPrimaryButton(
                context: context,
                text: 'Retry',
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      );
    }

    if (results.isEmpty) {
      return Container(
        padding: padding ?? SpacingUtils.listPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              color: colorScheme.onSurfaceVariant.withOpacity(0.6),
              size: ResponsiveUtils.getResponsiveIconSize(context, 48.0),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage ?? 'No results found',
              style: TypographyUtils.bodyLargeStyle.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: AccessibilityUtils.getAccessibleFontSize(
                  context,
                  TypographyUtils.bodyLargeStyle.fontSize ?? 16,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: padding ?? SpacingUtils.listPadding,
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final item = results[index];
          return _buildSearchResultItem(
            context: context,
            item: item,
            onTap: () => onItemTap(item),
          );
        },
      ),
    );
  }

  /// Build individual search result item
  static Widget _buildSearchResultItem({
    required BuildContext context,
    required SearchResultItem item,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12.0)),
        child: Container(
          padding: SpacingUtils.listItemContentPadding,
          child: Row(
            children: [
              // Leading widget (icon or avatar)
              if (item.leading != null) ...[
                item.leading!,
                const SizedBox(width: 16),
              ] else if (item.icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorUtils.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item.icon!,
                    color: ColorUtils.primaryBlue,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TypographyUtils.titleMediumStyle.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                        fontSize: AccessibilityUtils.getAccessibleFontSize(
                          context,
                          TypographyUtils.titleMediumStyle.fontSize ?? 16,
                        ),
                      ),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle!,
                        style: TypographyUtils.bodyMediumStyle.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: AccessibilityUtils.getAccessibleFontSize(
                            context,
                            TypographyUtils.bodyMediumStyle.fontSize ?? 14,
                          ),
                        ),
                      ),
                    ],
                    if (item.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.description!,
                        style: TypographyUtils.bodySmallStyle.copyWith(
                          color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                          fontSize: AccessibilityUtils.getAccessibleFontSize(
                            context,
                            TypographyUtils.bodySmallStyle.fontSize ?? 12,
                          ),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Trailing widget
              if (item.trailing != null) ...[
                const SizedBox(width: 16),
                item.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Search filters panel
  static Widget buildSearchFilters({
    required List<SearchFilter> filters,
    required Map<String, dynamic> selectedFilters,
    required ValueChanged<Map<String, dynamic>> onFiltersChanged,
    VoidCallback? onClearAll,
    VoidCallback? onApply,
    EdgeInsetsGeometry? padding,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: padding ?? SpacingUtils.listPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Filters',
                style: TypographyUtils.titleLargeStyle.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: AccessibilityUtils.getAccessibleFontSize(
                    context,
                    TypographyUtils.titleLargeStyle.fontSize ?? 22,
                  ),
                ),
              ),
              const Spacer(),
              if (onClearAll != null)
                ModernButtonComponents.buildTextButton(
                  context: context,
                  text: 'Clear All',
                  onPressed: onClearAll,
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Filters
          ...filters.map((filter) => _buildFilterWidget(
            context: context,
            filter: filter,
            selectedValue: selectedFilters[filter.key],
            onChanged: (value) {
              final newFilters = Map<String, dynamic>.from(selectedFilters);
              if (value == null) {
                newFilters.remove(filter.key);
              } else {
                newFilters[filter.key] = value;
              }
              onFiltersChanged(newFilters);
            },
          )),
          // Apply button
          if (onApply != null) ...[
            const SizedBox(height: 24),
            ModernButtonComponents.buildPrimaryButton(
              context: context,
              text: 'Apply Filters',
              onPressed: onApply,
              isFullWidth: true,
            ),
          ],
        ],
      ),
    );
  }

  /// Build individual filter widget
  static Widget _buildFilterWidget({
    required BuildContext context,
    required SearchFilter filter,
    required dynamic selectedValue,
    required ValueChanged<dynamic> onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            filter.label,
            style: TypographyUtils.titleMediumStyle.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                TypographyUtils.titleMediumStyle.fontSize ?? 16,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildFilterInput(
            context: context,
            filter: filter,
            selectedValue: selectedValue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  /// Build filter input based on filter type
  static Widget _buildFilterInput({
    required BuildContext context,
    required SearchFilter filter,
    required dynamic selectedValue,
    required ValueChanged<dynamic> onChanged,
  }) {
    switch (filter.type) {
      case SearchFilterType.dropdown:
        return DropdownButtonFormField<dynamic>(
          value: selectedValue,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12.0)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: filter.options?.map((option) => DropdownMenuItem(
            value: option.value,
            child: Text(option.label),
          )).toList(),
        );
      case SearchFilterType.checkbox:
        return Column(
          children: filter.options?.map((option) => CheckboxListTile(
            title: Text(option.label),
            value: selectedValue?.contains(option.value) ?? false,
            onChanged: (checked) {
              final currentValues = List<dynamic>.from(selectedValue ?? []);
              if (checked == true) {
                currentValues.add(option.value);
              } else {
                currentValues.remove(option.value);
              }
              onChanged(currentValues.isEmpty ? null : currentValues);
            },
            contentPadding: EdgeInsets.zero,
          )).toList() ?? [],
        );
      case SearchFilterType.range:
        return RangeSlider(
          values: selectedValue ?? RangeValues(filter.minValue ?? 0, filter.maxValue ?? 100),
          min: filter.minValue ?? 0,
          max: filter.maxValue ?? 100,
          divisions: filter.divisions,
          onChanged: (values) => onChanged(values),
        );
      case SearchFilterType.date:
        return InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedValue ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              onChanged(date);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12.0)),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 8),
                Text(
                  selectedValue != null 
                      ? '${selectedValue.day}/${selectedValue.month}/${selectedValue.year}'
                      : 'Select date',
                ),
              ],
            ),
          ),
        );
    }
  }

  /// Search suggestions dropdown
  static Widget buildSearchSuggestions({
    required List<String> suggestions,
    required ValueChanged<String> onSuggestionTap,
    EdgeInsetsGeometry? padding,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: padding ?? SpacingUtils.listPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suggestions',
            style: TypographyUtils.labelLargeStyle.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                TypographyUtils.labelLargeStyle.fontSize ?? 14,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...suggestions.map((suggestion) => Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSuggestionTap(suggestion),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 8.0)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.history,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: TypographyUtils.bodyMediumStyle.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: AccessibilityUtils.getAccessibleFontSize(
                            context,
                            TypographyUtils.bodyMediumStyle.fontSize ?? 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

/// Data class for search result items
class SearchResultItem {
  final String title;
  final String? subtitle;
  final String? description;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final dynamic data;

  const SearchResultItem({
    required this.title,
    this.subtitle,
    this.description,
    this.icon,
    this.leading,
    this.trailing,
    this.data,
  });
}

/// Data class for search filters
class SearchFilter {
  final String key;
  final String label;
  final SearchFilterType type;
  final List<FilterOption>? options;
  final double? minValue;
  final double? maxValue;
  final int? divisions;

  const SearchFilter({
    required this.key,
    required this.label,
    required this.type,
    this.options,
    this.minValue,
    this.maxValue,
    this.divisions,
  });
}

/// Data class for filter options
class FilterOption {
  final dynamic value;
  final String label;

  const FilterOption({
    required this.value,
    required this.label,
  });
}

/// Enum for search filter types
enum SearchFilterType {
  dropdown,
  checkbox,
  range,
  date,
}
