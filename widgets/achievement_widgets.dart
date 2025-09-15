import 'package:flutter/material.dart';

// Achievements Card Widget (used in AchievementsPage)
class AchievementsCard extends StatelessWidget {
  final List<String> achievements;

  const AchievementsCard({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Achievements", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...achievements.map((a) => ListTile(
              leading: const Icon(Icons.emoji_events, color: Colors.amber),
              title: Text(a),
            )),
          ],
        ),
      ),
    );
  }
}

// Certifications Card Widget (used in AchievementsPage)
class CertificationsCard extends StatelessWidget {
  final List<String> certifications;

  const CertificationsCard({super.key, required this.certifications});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Certifications", style: Theme.of(context).textTheme.titleLarge),
            ...certifications.map((c) => ListTile(
              leading: const Icon(Icons.verified, color: Colors.green),
              title: Text(c),
            )),
          ],
        ),
      ),
    );
  }
}

// AttendanceCard (was defined in main.dart, might be used elsewhere or can be specific to a page)
// If this is only used in DashboardPage, it might be better to move it there or to a dashboard_widgets.dart
class AttendanceCard extends StatelessWidget {
  final double percentage;

  const AttendanceCard({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Attendance", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage / 100,
              borderRadius: BorderRadius.circular(8),
              minHeight: 12,
            ),
            const SizedBox(height: 8),
            Text("$percentage% present"),
          ],
        ),
      ),
    );
  }
}
