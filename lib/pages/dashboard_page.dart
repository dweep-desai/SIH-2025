import 'package:flutter/material.dart';
import '../widgets/student_drawer.dart';
import '../data/profile_data.dart';
import 'semester_info_page.dart';
import 'student_edit_profile_page.dart';
import 'achievements_page.dart';

// ---------------- DASHBOARD PAGE ----------------
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    // Student theme: blue
    final Color studentPrimary = Colors.blue.shade800;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: studentPrimary,
        foregroundColor: Colors.white,
      ),
      drawer: MainDrawer(context: context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                quickButtons(context),
                const SizedBox(height: 16),
                personalCard(context),
                const SizedBox(height: 16),
                gpaCard(context),
                const SizedBox(height: 16),
                attendanceCard(context),
                const SizedBox(height: 16),
                achievementsCard(context),
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
      elevation: 2, // Softer elevation
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
                  backgroundImage: ProfileData.getProfileImageProvider(),
                  child: ProfileData.getProfileImageProvider() == null
                      ? Icon(Icons.person, size: 40, color: colorScheme.onPrimaryContainer)
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  "Tathya Barot", // Replace with dynamic data if available
                  style: textTheme.titleLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Student ID: 24BCE294", // Example detail
                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Divider(color: colorScheme.outline.withOpacity(0.5)),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align details to the start
                  children: [
                    _buildDetailRow(context, Icons.calendar_today, "DOB: 28 Aug 2006"),
                    _buildDetailRow(context, Icons.school, "Branch: Computer Science"),
                    _buildDetailRow(context, Icons.account_balance, "Institute: Nirma University"),
                    _buildDetailRow(context, Icons.person_outline, "Faculty Advisor: Dr. John Doe"),
                    if (ProfileData.getDomains().isNotEmpty)
                      _buildDetailRow(context, Icons.work_outline, "Domains: ${ProfileData.getDomains().join(', ')}"),
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
                      MaterialPageRoute(builder: (_) => const StudentEditProfilePage()),
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

  Widget gpaCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell( // Make card tappable with ripple effect
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SemesterInfoPage()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current Semester: 3", // Replace with dynamic data
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("GPA: 8 / 10", style: textTheme.bodyLarge), // Replace with dynamic data
                  Icon(Icons.show_chart, color: colorScheme.primary)
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.8, // Replace with dynamic data
                backgroundColor: colorScheme.surfaceContainerHighest, // Softer background
                color: colorScheme.primary,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget attendanceCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final double attendancePercentage = 0.85; // Replace with dynamic data

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SemesterInfoPage(startTabIndex: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Attendance Overview",
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Overall: ${(attendancePercentage * 100).toStringAsFixed(0)}%", style: textTheme.bodyLarge),
                  Icon(Icons.check_circle_outline, color: attendancePercentage >= 0.75 ? Colors.green.shade600 : colorScheme.error),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: attendancePercentage,
                backgroundColor: colorScheme.surfaceContainerHighest,
                color: attendancePercentage >= 0.75 ? Colors.green.shade600 : colorScheme.error,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Removed Recent Grades card from dashboard per requirement

  Widget achievementsCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    // Dummy data
    final achievements = ["Won 2nd place in App Making Competition", "Designed website for MUN"];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AchievementsPage()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                     Icon(Icons.workspace_premium, color: colorScheme.primary),
                     const SizedBox(width: 8),
                     Text("Student Record", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                  ],
                ),
              ),
              const Divider(height: 16, indent: 16, endIndent: 16),
              ...achievements.map((achievement) => ListTile(
                dense: true,
                title: Text(achievement, style: textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Icon(Icons.arrow_forward_ios, size: 14, color: colorScheme.onSurfaceVariant),
              )),
              if (achievements.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: Text("No achievements to display", style: textTheme.bodyMedium)),
                ),
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
            icon: const Icon(Icons.download, size: 20), // Slightly smaller icon
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
