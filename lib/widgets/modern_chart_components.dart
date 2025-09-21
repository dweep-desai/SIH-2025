import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/responsive_utils.dart';
import 'form_components.dart';

class ModernChartComponents {
  static Widget buildModernLineChart({
    required List<Map<String, dynamic>> data,
    required String title,
    required String xAxisLabel,
    required String yAxisLabel,
    required BuildContext context,
    String? subtitle,
    IconData? icon,
    Color? primaryColor,
    Color? secondaryColor,
    double? minY,
    double? maxY,
    bool showArea = true,
    bool showDots = true,
    bool showGrid = true,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    final effectivePrimaryColor = primaryColor ?? colorScheme.primary;
    final effectiveSecondaryColor = secondaryColor ?? colorScheme.secondary;

    return ModernFormComponents.buildModernCard(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChartHeader(
            title: title,
            subtitle: subtitle,
            icon: icon,
            context: context,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
          SizedBox(
            height: ResponsiveUtils.getResponsiveSpacing(context, 250),
            child: data.isEmpty
                ? _buildEmptyState(
                    message: "No data available",
                    context: context,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  )
                : LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchTooltipData: LineTouchTooltipData(
                          tooltipRoundedRadius: ResponsiveUtils.getResponsiveBorderRadius(context, 8),
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              return LineTooltipItem(
                                '${xAxisLabel}: ${barSpot.x.toInt()}\n${yAxisLabel}: ${barSpot.y.toStringAsFixed(2)}',
                                textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ) ?? const TextStyle(color: Colors.black),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      gridData: showGrid ? FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 1,
                        verticalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: colorScheme.outline.withOpacity(0.2),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: colorScheme.outline.withOpacity(0.2),
                            strokeWidth: 1,
                          );
                        },
                      ) : const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: ResponsiveUtils.getResponsiveSpacing(context, 30),
                            interval: 1,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              if (value.toInt() >= 1 && value.toInt() <= data.length && value == value.toInt().toDouble()) {
                                return Text(
                                  '${value.toInt()}',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: ResponsiveUtils.getResponsiveSpacing(context, 12),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: ResponsiveUtils.getResponsiveSpacing(context, 40),
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return Text(
                                value.toStringAsFixed(1),
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: ResponsiveUtils.getResponsiveSpacing(context, 12),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: colorScheme.outline.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      minX: 0.5,
                      maxX: data.length.toDouble() + 0.5,
                      minY: minY ?? 0,
                      maxY: maxY ?? 10,
                      lineBarsData: [
                        LineChartBarData(
                          spots: data.asMap().entries.map((entry) {
                            return FlSpot(entry.key + 1, (entry.value['value'] as num).toDouble());
                          }).toList(),
                          isCurved: true,
                          color: effectivePrimaryColor,
                          barWidth: ResponsiveUtils.getResponsiveSpacing(context, 3),
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: showDots,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: ResponsiveUtils.getResponsiveSpacing(context, 4),
                                color: effectivePrimaryColor,
                                strokeWidth: 2,
                                strokeColor: colorScheme.surface,
                              );
                            },
                          ),
                          belowBarData: showArea ? BarAreaData(
                            show: true,
                            color: effectivePrimaryColor.withOpacity(0.1),
                          ) : BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  static Widget buildModernBarChart({
    required List<Map<String, dynamic>> data,
    required String title,
    required String xAxisLabel,
    required String yAxisLabel,
    required BuildContext context,
    String? subtitle,
    IconData? icon,
    List<Color>? colors,
    double? maxY,
    bool showTooltips = true,
    bool showGrid = true,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    final effectiveColors = colors ?? [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      Colors.purple.shade600,
      Colors.orange.shade600,
    ];

    return ModernFormComponents.buildModernCard(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChartHeader(
            title: title,
            subtitle: subtitle,
            icon: icon,
            context: context,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
          SizedBox(
            height: ResponsiveUtils.getResponsiveSpacing(context, 300),
            child: data.isEmpty
                ? _buildEmptyState(
                    message: "No data available",
                    context: context,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  )
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxY ?? 100,
                      barTouchData: BarTouchData(
                        enabled: showTooltips,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipRoundedRadius: ResponsiveUtils.getResponsiveBorderRadius(context, 8),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${data[group.x]['label']}\n${yAxisLabel}: ${rod.toY.toStringAsFixed(0)}',
                              textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ) ?? const TextStyle(color: Colors.black),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              if (value.toInt() < data.length) {
                                final label = data[value.toInt()]['label'] ?? '';
                                return Padding(
                                  padding: EdgeInsets.only(top: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                                  child: Transform.rotate(
                                    angle: -0.5,
                                    child: Text(
                                      label,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        fontSize: ResponsiveUtils.getResponsiveSpacing(context, 10),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: ResponsiveUtils.getResponsiveSpacing(context, 40),
                            interval: 20,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return Text(
                                '${value.toInt()}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: ResponsiveUtils.getResponsiveSpacing(context, 12),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: data.asMap().entries.map((entry) {
                        final value = (entry.value['value'] as num).toDouble();
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: value,
                              color: effectiveColors[entry.key % effectiveColors.length],
                              width: ResponsiveUtils.getResponsiveSpacing(context, 20),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 4)),
                                topRight: Radius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 4)),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  static Widget buildModernPieChart({
    required List<Map<String, dynamic>> data,
    required String title,
    required BuildContext context,
    String? subtitle,
    IconData? icon,
    List<Color>? colors,
    double centerSpaceRadius = 60,
    bool showLegend = true,
    bool showPercentage = true,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    final effectiveColors = colors ?? [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      Colors.purple.shade600,
      Colors.orange.shade600,
    ];

    return ModernFormComponents.buildModernCard(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChartHeader(
            title: title,
            subtitle: subtitle,
            icon: icon,
            context: context,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 250),
                  child: data.isEmpty
                      ? _buildEmptyState(
                          message: "No data available",
                          context: context,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                        )
                      : PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                // Handle touch interaction if needed
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 2,
                            centerSpaceRadius: centerSpaceRadius,
                            sections: _buildPieChartSections(
                              data,
                              effectiveColors,
                              textTheme,
                              showPercentage,
                              context,
                            ),
                          ),
                        ),
                ),
              ),
              if (showLegend) ...[
                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: _buildLegendItems(
                      data,
                      effectiveColors,
                      textTheme,
                      colorScheme,
                      context,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildModernGaugeChart({
    required double value,
    required double maxValue,
    required String title,
    required BuildContext context,
    String? subtitle,
    IconData? icon,
    Color? primaryColor,
    Color? secondaryColor,
    String? unit,
    List<String>? labels,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    final effectivePrimaryColor = primaryColor ?? colorScheme.primary;
    final effectiveSecondaryColor = secondaryColor ?? colorScheme.secondary;
    final percentage = (value / maxValue).clamp(0.0, 1.0);

    return ModernFormComponents.buildModernCard(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChartHeader(
            title: title,
            subtitle: subtitle,
            icon: icon,
            context: context,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
          Center(
            child: Column(
              children: [
                Container(
                  width: ResponsiveUtils.getResponsiveSpacing(context, 120),
                  height: ResponsiveUtils.getResponsiveSpacing(context, 120),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [effectivePrimaryColor, effectiveSecondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: effectivePrimaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          value.toStringAsFixed(1),
                          style: textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (unit != null)
                          Text(
                            unit,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                Container(
                  width: ResponsiveUtils.getResponsiveSpacing(context, 200),
                  height: ResponsiveUtils.getResponsiveSpacing(context, 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 4)),
                    color: colorScheme.surfaceContainerHighest,
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 4)),
                        gradient: LinearGradient(
                          colors: [effectivePrimaryColor, effectiveSecondaryColor],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                Text(
                  '${(percentage * 100).toStringAsFixed(1)}% of ${maxValue.toStringAsFixed(1)}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildChartHeader({
    required String title,
    String? subtitle,
    IconData? icon,
    required BuildContext context,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: colorScheme.primary,
            size: ResponsiveUtils.getResponsiveIconSize(context, 24),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8)),
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
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
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
    );
  }

  static Widget _buildEmptyState({
    required String message,
    required BuildContext context,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart_outlined,
            size: ResponsiveUtils.getResponsiveIconSize(context, 48),
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
          Text(
            message,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  static List<PieChartSectionData> _buildPieChartSections(
    List<Map<String, dynamic>> data,
    List<Color> colors,
    TextTheme textTheme,
    bool showPercentage,
    BuildContext context,
  ) {
    List<PieChartSectionData> sections = [];
    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      sections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: (item['value'] as num).toDouble(),
          title: showPercentage ? '${(item['percentage'] as num).toStringAsFixed(1)}%' : '',
          radius: ResponsiveUtils.getResponsiveSpacing(context, 54),
          titleStyle: textTheme.bodySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveUtils.getResponsiveSpacing(context, 12),
          ) ?? const TextStyle(),
        ),
      );
    }
    return sections;
  }

  static List<Widget> _buildLegendItems(
    List<Map<String, dynamic>> data,
    List<Color> colors,
    TextTheme textTheme,
    ColorScheme colorScheme,
    BuildContext context,
  ) {
    List<Widget> items = [];
    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      items.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.getResponsiveSpacing(context, 4)),
          child: Row(
            children: [
              Container(
                width: ResponsiveUtils.getResponsiveSpacing(context, 12),
                height: ResponsiveUtils.getResponsiveSpacing(context, 12),
                decoration: BoxDecoration(
                  color: colors[i % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8)),
              Expanded(
                child: Text(
                  item['label']?.toString().toUpperCase() ?? '',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: ResponsiveUtils.getResponsiveSpacing(context, 12),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return items;
  }
}
