import 'package:flutter/material.dart';
import '../widgets/faculty_drawer.dart';
import '../data/faculty_profile_data.dart';
import '../data/approval_data.dart';
import '../widgets/approval_donut_chart.dart';
import 'faculty_edit_profile_page.dart';

// ---------------- FACULTY DASHBOARD PAGE ----------------
class FacultyDashboardPage extends StatelessWidget {
  const FacultyDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    // Faculty theme: green
    final Color facultyPrimary = Colors.green.shade700;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Faculty Dashboard"),
        backgroundColor: facultyPrimary,
        foregroundColor: Colors.white,
      ),
      drawer: MainDrawer(context: context, isFaculty: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                personalCard(context),
                const SizedBox(height: 16),
                researchPapersCard(context),
                const SizedBox(height: 16),
                studentResearchCard(context),
                const SizedBox(height: 16),
                approvalAnalyticsCard(context),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------- Widgets ----------------
  Widget personalCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: colorScheme.primaryContainer,
                  backgroundImage: FacultyProfileData.getProfileImageProvider(),
                  child: FacultyProfileData.getProfileImageProvider() == null
                      ? Icon(Icons.person, size: 40, color: colorScheme.onPrimaryContainer)
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  "Dr. John Doe", // Replace with dynamic data
                  style: textTheme.titleLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Faculty ID: FAC001", // Example detail
                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Divider(color: colorScheme.outline.withOpacity(0.5)),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(context, Icons.work, "Designation: Professor - Computer Science"),
                    _buildDetailRow(context, Icons.business, "Department: Computer Science"),
                    _buildDetailRow(context, Icons.school, "Educational Qualifications: PhD in Computer Science"),
                    _buildDetailRow(context, Icons.email, "Email: john.doe@nirmauni.ac.in"),
                    if (FacultyProfileData.getDomains().isNotEmpty)
                      _buildDetailRow(context, Icons.domain, "Domains: ${FacultyProfileData.getDomains().join(', ')}"),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FacultyEditProfilePage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorScheme.primary, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, size: 18, color: colorScheme.primary),
                        const SizedBox(width: 4),
                        Text("Edit", style: textTheme.labelMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.secondary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget researchPapersCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    // Dummy data - replace with actual data
    final papers = [
      "Paper on Machine Learning in Healthcare - IEEE Conference 2023",
      "Research on AI Ethics - ACM Journal 2022",
      "Project on Data Mining Techniques - Springer 2021"
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(Icons.article, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text("Papers and Publications", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        children: papers.isNotEmpty
            ? papers.map((paper) => ListTile(
                dense: true,
                title: Text(paper, style: textTheme.bodyMedium),
              )).toList()
            : [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: Text("No papers and publications to display", style: textTheme.bodyMedium)),
                ),
              ],
      ),
    );
  }

  Widget studentResearchCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    // Dummy data - replace with actual data
    final studentResearches = [
      {
        "topic": "AI in Education",
        "conference": "ICML 2023",
        "students": "Alice, Bob"
      },
      {
        "topic": "Blockchain Security",
        "conference": "IEEE Security 2022",
        "students": "Charlie, David"
      }
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(Icons.group, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text("Student Research", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        children: studentResearches.isNotEmpty
            ? studentResearches.map((research) => ListTile(
                dense: true,
                title: Text("${research['topic']} - ${research['conference']}", style: textTheme.bodyMedium),
                subtitle: Text("Students: ${research['students']}", style: textTheme.bodySmall),
              )).toList()
            : [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: Text("No student research to display", style: textTheme.bodyMedium)),
                ),
              ],
      ),
    );
  }

  Widget approvalAnalyticsCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedBuilder(
          animation: approvalStats,
          builder: (context, _) {
            final totalApproved = approvalStats.approvedCount;
            final totalRejected = approvalStats.rejectedCount;
            final approvalRate = approvalStats.approvalRatePercent;
            final avgPoints = computeAveragePointsAwarded();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.analytics_outlined, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text("Approval Analytics", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _metricTile(context, 'Total Approved', '$totalApproved', Icons.check_circle, Colors.green)),
                    const SizedBox(width: 12),
                    Expanded(child: _metricTile(context, 'Total Rejected', '$totalRejected', Icons.cancel, Colors.red)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _metricTile(context, 'Approval Rate', approvalRate.toStringAsFixed(1), Icons.percent, colorScheme.primary)),
                    const SizedBox(width: 12),
                    Expanded(child: _metricTile(context, 'Avg. Points Awarded', avgPoints.toStringAsFixed(1), Icons.star_rate, colorScheme.tertiary)),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ApprovalDonutChart(
                        approved: totalApproved,
                        rejected: totalRejected,
                        pending: 0,
                        includePending: false,
                        showLegend: true,
                        thicknessMultiplier: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _metricTile(BuildContext context, String title, String value, IconData icon, Color color) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: colors.outline.withOpacity(0.2))),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 100),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(title, style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant), maxLines: 2, softWrap: true)),
                ],
              ),
              const SizedBox(height: 8),
              Text(value, style: textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget quickButtons(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () { /* TODO: Implement Download Profile */ },
            icon: const Icon(Icons.download, size: 20),
            label: Text("Download Profile", style: textTheme.labelLarge),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () { /* TODO: Implement View Analytics */ },
            icon: const Icon(Icons.analytics, size: 20),
            label: Text("View Analytics", style: textTheme.labelLarge),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }

}
