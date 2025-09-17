import 'package:flutter/material.dart';
import '../widgets/faculty_drawer.dart';
import '../data/approval_data.dart';
import '../widgets/approval_donut_chart.dart';

class FacultyApprovalAnalyticsPage extends StatelessWidget {
  const FacultyApprovalAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final texts = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Analytics'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      drawer: MainDrawer(context: context, isFaculty: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Metrics (no pending)
            AnimatedBuilder(
              animation: approvalStats,
              builder: (context, _) {
                final totalApproved = approvalStats.approvedCount;
                final totalRejected = approvalStats.rejectedCount;
                final approvalRate = approvalStats.approvalRatePercent;
                final avgPoints = computeAveragePointsAwarded();
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildAnalyticsCard(
                            context,
                            'Total Approved',
                            '$totalApproved',
                            Icons.check_circle_outline,
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildAnalyticsCard(
                            context,
                            'Total Rejected',
                            '$totalRejected',
                            Icons.cancel_outlined,
                            Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildAnalyticsCard(
                            context,
                            'Approval Rate',
                            approvalRate.toStringAsFixed(1),
                            Icons.percent,
                            colors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildAnalyticsCard(
                            context,
                            'Avg. Points Awarded',
                            avgPoints.toStringAsFixed(1),
                            Icons.star_rate,
                            colors.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),

            // Standalone Donut Chart (centered, not inside any card)
            AnimatedBuilder(
              animation: approvalStats,
              builder: (context, _) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ApprovalDonutChart(
                        approved: approvalStats.approvedCount,
                        rejected: approvalStats.rejectedCount,
                        pending: 0,
                        includePending: false,
                        showLegend: true,
                        thicknessMultiplier: 1.5,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            
            // Charts Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bar_chart, color: colors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Approval Trends',
                          style: texts.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.analytics_outlined,
                            size: 64,
                            color: colors.outline.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No analytics data available',
                            style: texts.titleMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Charts and trends will appear here once approval data is available',
                            style: texts.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Category Breakdown removed as requested
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final texts = theme.textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 110),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: texts.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: texts.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
