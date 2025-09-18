import 'package:flutter/material.dart';
import '../widgets/student_drawer.dart';
import '../data/profile_data.dart';
import 'semester_info_page.dart';
import 'student_edit_profile_page.dart';
import 'achievements_page.dart';
import '../services/student_service.dart';

// ---------------- DASHBOARD PAGE ----------------
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme is used within child cards/widgets
    // Student theme: blue
    final Color studentPrimary = Colors.blue.shade800;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: studentPrimary,
        foregroundColor: Colors.white,
      ),
      drawer: MainDrawer(context: context),
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: StudentService.instance.getCurrentStudentStream(),
        builder: (context, snapshot) {
          final Map<String, dynamic>? student = snapshot.data;
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    quickButtons(context),
                    const SizedBox(height: 16),
                    personalCard(context, student),
                    const SizedBox(height: 16),
                    gpaCard(context, student),
                    const SizedBox(height: 16),
                    attendanceCard(context, student),
                    const SizedBox(height: 16),
                    achievementsCard(context, student),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ---------------- Widgets ----------------
  Widget personalCard(BuildContext context, Map<String, dynamic>? student) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final String displayName = (student?["name"] as String?) ?? "Tathya Barot";
    final String studentId = (student?["studentId"] as String?) ?? "24BCE294";
    final String branch = (student?["branch"] as String?) ?? "Computer Science";
    final String institute = (student?["institute"] as String?) ?? "Nirma University";
    String facultyAdvisor = (student?["facultyAdvisor"] as String?) ?? "Dr. John Doe";
    final List domains = (student?["domain"] is List) ? (student!["domain"] as List) : ProfileData.getDomains();
    final String? photoUrl = student?["profile_photo_url"] as String?;

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
                  backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                      ? NetworkImage(photoUrl)
                      : ProfileData.getProfileImageProvider(),
                  child: (photoUrl == null || photoUrl.isEmpty) && ProfileData.getProfileImageProvider() == null
                      ? Icon(Icons.person, size: 40, color: colorScheme.onPrimaryContainer)
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  displayName,
                  style: textTheme.titleLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Student ID: $studentId",
                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Divider(color: colorScheme.outline.withOpacity(0.5)),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align details to the start
                  children: [
                    _buildDetailRow(context, Icons.school, "Branch: $branch"),
                    _buildDetailRow(context, Icons.account_balance, "Institute: $institute"),
                    _buildDetailRow(context, Icons.person_outline, "Faculty Advisor: $facultyAdvisor"),
                    if (domains.isNotEmpty)
                      _buildDetailRow(context, Icons.work_outline, "Domains: ${domains.join(', ')}"),
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

  Widget gpaCard(BuildContext context, Map<String, dynamic>? student) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final int currentSem = (student?["currentSemester"] is int)
        ? student!["currentSemester"] as int
        : 3;
    // Use service resolver that falls back to local JSON if DB is empty
    // We’ll render asynchronously using FutureBuilder
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
          child: FutureBuilder<double>(
            future: StudentService.instance.getOverallGpaForCurrentStudent(upToSemester: currentSem),
            builder: (context, snapshot) {
              final double avg = (snapshot.data ?? 0.0).clamp(0.0, 10.0);
              final double normalized = (avg / 10.0).clamp(0.0, 1.0);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current Semester: $currentSem",
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Overall GPA: ${avg.toStringAsFixed(1)} / 10", style: textTheme.bodyLarge),
                      Icon(Icons.show_chart, color: colorScheme.primary)
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: normalized,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    color: colorScheme.primary,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget attendanceCard(BuildContext context, Map<String, dynamic>? student) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final String? studentId = student?["studentId"] as String?;

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
          child: FutureBuilder<double>(
            future: studentId != null ? StudentService.instance.getAttendancePercent(studentId) : Future.value(0.0),
            builder: (context, snapshot) {
              final double attendancePercentage = (snapshot.data ?? 0.0).clamp(0.0, 1.0);
              return Column(
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
              );
            },
          ),
        ),
      ),
    );
  }

  // Removed Recent Grades card from dashboard per requirement

  Widget achievementsCard(BuildContext context, Map<String, dynamic>? student) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final String? studentId = student?["studentId"] as String?;

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
          child: FutureBuilder<List<dynamic>>(
            future: studentId != null ? StudentService.instance.getAchievements(studentId) : Future.value(const []),
            builder: (context, snapshot) {
              final achievements = snapshot.data ?? const [];
              return Column(
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
                  if (achievements.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: Text("No achievements to display", style: textTheme.bodyMedium)),
                    )
                  else
                    ...achievements.map((a) {
                      final text = a is String
                          ? a
                          : (a is Map && a['title'] != null)
                              ? a['title'].toString()
                              : a.toString();
                      return ListTile(
                        dense: true,
                        title: Text(text, style: textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: colorScheme.onSurfaceVariant),
                      );
                    }).toList(),
                ],
              );
            },
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
