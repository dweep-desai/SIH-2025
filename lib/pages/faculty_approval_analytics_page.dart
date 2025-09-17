import 'package:flutter/material.dart';
import '../widgets/faculty_drawer.dart';

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
            // Overview Cards
            Row(
              children: [
                Expanded(
                  child: _buildAnalyticsCard(
                    context,
                    'Total Approvals',
                    '0',
                    Icons.check_circle_outline,
                    colors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAnalyticsCard(
                    context,
                    'Pending',
                    '0',
                    Icons.pending_outlined,
                    colors.tertiary,
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
                    'Approved',
                    '0',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAnalyticsCard(
                    context,
                    'Rejected',
                    '0',
                    Icons.cancel_outlined,
                    Colors.red,
                  ),
                ),
              ],
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
            
            // Category Breakdown
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
                        Icon(Icons.pie_chart_outline, color: colors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Category Breakdown',
                          style: texts.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.pie_chart_outline,
                            size: 64,
                            color: colors.outline.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No category data available',
                            style: texts.titleMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Category statistics will appear here once approval data is available',
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
                    overflow: TextOverflow.ellipsis,
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
    );
  }
}
