import 'package:flutter/material.dart';

// Achievements Card Widget (used in AchievementsPage)
class AchievementsCard extends StatelessWidget {
  final List<String> achievements;

  const AchievementsCard({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorScheme.surfaceContainerLow, // Material 3 card color
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Consistent margin
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events_outlined, color: colorScheme.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  "Achievements", 
                  style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.w600)
                ),
              ],
            ),
            if (achievements.isNotEmpty) const Divider(height: 24, thickness: 1),
            if (achievements.isNotEmpty)
              ...achievements.map((achievement) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.star_border_rounded, size: 20, color: colorScheme.secondary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          achievement,
                          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ), 
              ))
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text("No achievements recorded yet.", style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                ),
              ),
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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorScheme.surfaceContainerLow,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified_outlined, color: colorScheme.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  "Certifications", 
                  style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.w600)
                ),
              ],
            ),
            if (certifications.isNotEmpty) const Divider(height: 24, thickness: 1),
            if (certifications.isNotEmpty)
              ...certifications.map((certification) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Icon(Icons.badge_outlined, size: 20, color: colorScheme.secondary),
                     const SizedBox(width: 10),
                     Expanded(
                        child: Text(
                          certification,
                          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ),
                  ],
                ),
              ))
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text("No certifications recorded yet.", style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// AttendanceCard - Kept as is, as the request focuses on AchievementsPage widgets
class AttendanceCard extends StatelessWidget {
  final double percentage;

  const AttendanceCard({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Attendance", style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage / 100,
              borderRadius: BorderRadius.circular(8),
              minHeight: 12,
              backgroundColor: colorScheme.surfaceContainerHighest, 
              color: colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text("$percentage% present", style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
