import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../utils/color_utils.dart';
import '../utils/typography_utils.dart';
import '../utils/spacing_utils.dart';
import '../utils/accessibility_utils.dart';
import 'card_components.dart';
import 'modern_chart_components.dart';

/// Modern analytics components with consistent styling and better data visualization
class ModernAnalyticsComponents {

  /// Analytics dashboard with modern layout
  static Widget buildAnalyticsDashboard({
    required List<AnalyticsWidget> widgets,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    String? semanticLabel,
    required BuildContext context,
  }) {
    return AccessibilityUtils.buildSemanticCard(
      label: semanticLabel ?? 'Analytics dashboard',
      child: Container(
        padding: padding ?? SpacingUtils.screenPaddingAll,
        margin: margin ?? SpacingUtils.cardMarginAll,
        child: Column(
          children: [
            // Header
            _buildDashboardHeader(context: context),
            const SizedBox(height: 24),
            // Widgets grid
            _buildWidgetsGrid(context: context, widgets: widgets),
          ],
        ),
      ),
    );
  }

  /// Build dashboard header
  static Widget _buildDashboardHeader({required BuildContext context}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analytics Dashboard',
                style: TypographyUtils.headlineMediumStyle.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: AccessibilityUtils.getAccessibleFontSize(
                    context,
                    TypographyUtils.headlineMediumStyle.fontSize ?? 28,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Track your performance and insights',
                style: TypographyUtils.bodyLargeStyle.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: AccessibilityUtils.getAccessibleFontSize(
                    context,
                    TypographyUtils.bodyLargeStyle.fontSize ?? 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Refresh button
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: ColorUtils.primaryBlue,
            size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
          ),
          onPressed: () {
            // Handle refresh
          },
        ),
      ],
    );
  }

  /// Build widgets grid
  static Widget _buildWidgetsGrid({
    required BuildContext context,
    required List<AnalyticsWidget> widgets,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = ResponsiveUtils.isMobile(context) ? 1 : ResponsiveUtils.isTablet(context) ? 2 : 3;
        final childAspectRatio = ResponsiveUtils.isMobile(context) ? 1.5 : 1.2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
            mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
          ),
          itemCount: widgets.length,
          itemBuilder: (context, index) => _buildAnalyticsWidget(
            context: context,
            widget: widgets[index],
          ),
        );
      },
    );
  }

  /// Build individual analytics widget
  static Widget _buildAnalyticsWidget({
    required BuildContext context,
    required AnalyticsWidget widget,
  }) {
    switch (widget.type) {
      case AnalyticsWidgetType.metric:
        return _buildMetricWidget(context: context, widget: widget);
      case AnalyticsWidgetType.chart:
        return _buildChartWidget(context: context, widget: widget);
      case AnalyticsWidgetType.table:
        return _buildTableWidget(context: context, widget: widget);
      case AnalyticsWidgetType.progress:
        return _buildProgressWidget(context: context, widget: widget);
      case AnalyticsWidgetType.gauge:
        return _buildGaugeWidget(context: context, widget: widget);
    }
  }

  /// Build metric widget
  static Widget _buildMetricWidget({
    required BuildContext context,
    required AnalyticsWidget widget,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final metric = widget.data as AnalyticsMetric;

    return ModernCardComponents.buildModernCard(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: metric.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  metric.icon,
                  color: metric.color,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  metric.title,
                  style: TypographyUtils.titleMediumStyle.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    fontSize: AccessibilityUtils.getAccessibleFontSize(
                      context,
                      TypographyUtils.titleMediumStyle.fontSize ?? 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Value
          Text(
            metric.value,
            style: TypographyUtils.headlineLargeStyle.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                TypographyUtils.headlineLargeStyle.fontSize ?? 32,
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Subtitle
          Text(
            metric.subtitle,
            style: TypographyUtils.bodyMediumStyle.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                TypographyUtils.bodyMediumStyle.fontSize ?? 14,
              ),
            ),
          ),
          // Trend
          if (metric.trend != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  metric.trend!.isPositive ? Icons.trending_up : Icons.trending_down,
                  color: metric.trend!.isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  metric.trend!.value,
                  style: TypographyUtils.bodySmallStyle.copyWith(
                    color: metric.trend!.isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: AccessibilityUtils.getAccessibleFontSize(
                      context,
                      TypographyUtils.bodySmallStyle.fontSize ?? 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Build chart widget
  static Widget _buildChartWidget({
    required BuildContext context,
    required AnalyticsWidget widget,
  }) {
    final chart = widget.data as AnalyticsChart;

    return ModernCardComponents.buildModernCard(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            chart.title,
            style: TypographyUtils.titleLargeStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                TypographyUtils.titleLargeStyle.fontSize ?? 22,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Chart
          Expanded(
            child: _buildChart(context: context, chart: chart),
          ),
        ],
      ),
    );
  }

  /// Build chart based on type
  static Widget _buildChart({
    required BuildContext context,
    required AnalyticsChart chart,
  }) {
    switch (chart.type) {
      case AnalyticsChartType.line:
        return ModernChartComponents.buildModernLineChart(
          context: context,
          data: chart.data['data'] ?? [],
          title: chart.title,
          xAxisLabel: chart.data['xAxisLabel'] ?? 'X',
          yAxisLabel: chart.data['yAxisLabel'] ?? 'Y',
        );
      case AnalyticsChartType.bar:
        return ModernChartComponents.buildModernBarChart(
          context: context,
          data: chart.data['data'] ?? [],
          title: chart.title,
          xAxisLabel: chart.data['xAxisLabel'] ?? 'X',
          yAxisLabel: chart.data['yAxisLabel'] ?? 'Y',
        );
      case AnalyticsChartType.pie:
        return ModernChartComponents.buildModernPieChart(
          context: context,
          data: chart.data['data'] ?? [],
          title: chart.title,
        );
      case AnalyticsChartType.gauge:
        return ModernChartComponents.buildModernGaugeChart(
          context: context,
          value: chart.data['value'] ?? 0.0,
          maxValue: chart.data['max'] ?? 100.0,
          title: chart.title,
        );
    }
  }

  /// Build table widget
  static Widget _buildTableWidget({
    required BuildContext context,
    required AnalyticsWidget widget,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final table = widget.data as AnalyticsTable;

    return ModernCardComponents.buildModernCard(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            table.title,
            style: TypographyUtils.titleLargeStyle.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                TypographyUtils.titleLargeStyle.fontSize ?? 22,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Table
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: table.columns.map((column) => DataColumn(
                  label: Text(
                    column,
                    style: TypographyUtils.labelLargeStyle.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: AccessibilityUtils.getAccessibleFontSize(
                        context,
                        TypographyUtils.labelLargeStyle.fontSize ?? 14,
                      ),
                    ),
                  ),
                )).toList(),
                rows: table.rows.map((row) => DataRow(
                  cells: row.map((cell) => DataCell(
                    Text(
                      cell,
                      style: TypographyUtils.bodyMediumStyle.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: AccessibilityUtils.getAccessibleFontSize(
                          context,
                          TypographyUtils.bodyMediumStyle.fontSize ?? 14,
                        ),
                      ),
                    ),
                  )).toList(),
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build progress widget
  static Widget _buildProgressWidget({
    required BuildContext context,
    required AnalyticsWidget widget,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = widget.data as AnalyticsProgress;

    return ModernCardComponents.buildModernCard(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            progress.title,
            style: TypographyUtils.titleLargeStyle.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                TypographyUtils.titleLargeStyle.fontSize ?? 22,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Progress items
          ...progress.items.map((item) => _buildProgressItem(
            context: context,
            item: item,
          )),
        ],
      ),
    );
  }

  /// Build progress item
  static Widget _buildProgressItem({
    required BuildContext context,
    required AnalyticsProgressItem item,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.label,
                style: TypographyUtils.titleMediumStyle.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: AccessibilityUtils.getAccessibleFontSize(
                    context,
                    TypographyUtils.titleMediumStyle.fontSize ?? 16,
                  ),
                ),
              ),
              Text(
                '${(item.value * 100).toInt()}%',
                style: TypographyUtils.bodyLargeStyle.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: AccessibilityUtils.getAccessibleFontSize(
                    context,
                    TypographyUtils.bodyLargeStyle.fontSize ?? 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: item.value,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(item.color),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  /// Build gauge widget
  static Widget _buildGaugeWidget({
    required BuildContext context,
    required AnalyticsWidget widget,
  }) {
    final gauge = widget.data as AnalyticsGauge;

    return ModernCardComponents.buildModernCard(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            gauge.title,
            style: TypographyUtils.titleLargeStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                TypographyUtils.titleLargeStyle.fontSize ?? 22,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Gauge
          Expanded(
            child: ModernChartComponents.buildModernGaugeChart(
              context: context,
              value: gauge.value,
              maxValue: gauge.max,
              title: gauge.title,
            ),
          ),
        ],
      ),
    );
  }

  /// Analytics summary card
  static Widget buildAnalyticsSummary({
    required List<AnalyticsMetric> metrics,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    String? semanticLabel,
    required BuildContext context,
  }) {
    return AccessibilityUtils.buildSemanticCard(
      label: semanticLabel ?? 'Analytics summary',
      child: Container(
        padding: padding ?? SpacingUtils.cardPaddingAll,
        margin: margin ?? SpacingUtils.cardMarginAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: TypographyUtils.titleLargeStyle.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: AccessibilityUtils.getAccessibleFontSize(
                  context,
                  TypographyUtils.titleLargeStyle.fontSize ?? 22,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: metrics.map((metric) => Expanded(
                child: _buildSummaryMetric(
                  context: context,
                  metric: metric,
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Build summary metric
  static Widget _buildSummaryMetric({
    required BuildContext context,
    required AnalyticsMetric metric,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: metric.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12.0)),
        border: Border.all(
          color: metric.color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            metric.icon,
            color: metric.color,
            size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
          ),
          const SizedBox(height: 8),
          Text(
            metric.value,
            style: TypographyUtils.titleLargeStyle.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                TypographyUtils.titleLargeStyle.fontSize ?? 22,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.title,
            style: TypographyUtils.bodySmallStyle.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: AccessibilityUtils.getAccessibleFontSize(
                context,
                TypographyUtils.bodySmallStyle.fontSize ?? 12,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Data classes for analytics components

class AnalyticsWidget {
  final AnalyticsWidgetType type;
  final dynamic data;

  const AnalyticsWidget({
    required this.type,
    required this.data,
  });
}

enum AnalyticsWidgetType {
  metric,
  chart,
  table,
  progress,
  gauge,
}

class AnalyticsMetric {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final AnalyticsTrend? trend;

  const AnalyticsMetric({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.trend,
  });
}

class AnalyticsTrend {
  final String value;
  final bool isPositive;

  const AnalyticsTrend({
    required this.value,
    required this.isPositive,
  });
}

class AnalyticsChart {
  final String title;
  final AnalyticsChartType type;
  final Map<String, dynamic> data;

  const AnalyticsChart({
    required this.title,
    required this.type,
    required this.data,
  });
}

enum AnalyticsChartType {
  line,
  bar,
  pie,
  gauge,
}

class AnalyticsTable {
  final String title;
  final List<String> columns;
  final List<List<String>> rows;

  const AnalyticsTable({
    required this.title,
    required this.columns,
    required this.rows,
  });
}

class AnalyticsProgress {
  final String title;
  final List<AnalyticsProgressItem> items;

  const AnalyticsProgress({
    required this.title,
    required this.items,
  });
}

class AnalyticsProgressItem {
  final String label;
  final double value;
  final Color color;

  const AnalyticsProgressItem({
    required this.label,
    required this.value,
    required this.color,
  });
}

class AnalyticsGauge {
  final String title;
  final double value;
  final double max;

  const AnalyticsGauge({
    required this.title,
    required this.value,
    required this.max,
  });
}
