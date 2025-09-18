import 'package:flutter/material.dart';
import '../widgets/student_drawer.dart';
import '../services/student_service.dart';

// ---------------- ACHIEVEMENTS PAGE ----------------
class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Desired order of categories as per request approval section
    const List<String> categoryOrder = [
      'Certifications',
      'Achievements',
      'Experience',
      'Research papers',
      'Projects',
      'Workshops',
    ];

    // Map UI category to DB section key
    const Map<String, String> sectionKey = {
      'Certifications': 'certifications',
      'Achievements': 'achievements',
      'Experience': 'experience',
      'Research papers': 'research_papers',
      'Projects': 'projects',
      'Workshops': 'workshops',
    };

    return Scaffold(
        appBar: AppBar(
          title: const Text("Student Record"),
        ),
        drawer: MainDrawer(context: context),
        body: StreamBuilder<Map<String, dynamic>?>(
          stream: StudentService.instance.getCurrentStudentStream(),
          builder: (context, snapshot) {
            final student = snapshot.data;
            final String? studentId = student?["studentId"] as String?;
            if (studentId == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...categoryOrder.map((cat) {
                    final String key = sectionKey[cat]!;
                    return FutureBuilder<List<dynamic>>(
                      future: StudentService.instance.getTopRecords(studentId, key, limit: 1000),
                      builder: (context, snap) {
                        final itemsRaw = snap.data ?? const [];
                        final List<Map<String, String?>> itemsData = itemsRaw.map<Map<String, String?>>((e) {
                          if (e is Map) {
                            return {
                              'title': e['title']?.toString() ?? (e['name']?.toString() ?? 'Item'),
                              'description': e['description']?.toString() ?? '',
                              'points': e['points']?.toString(),
                            };
                          }
                          return {'title': e.toString(), 'description': '', 'points': null};
                        }).toList();
                        return _CategoryCard(title: cat, items: itemsData);
                      },
                    );
                  }),
                ],
              ),
            );
          },
        )
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final List items; // List<Map<String,String?>> with 'title', 'description', and optional 'points'

  const _CategoryCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final IconData headerIcon = _iconForCategory(title);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(headerIcon, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 16),
            ...items.map((req) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.description_outlined, color: colorScheme.secondary),
                  title: Text(req['title'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(req['description'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                      if (req['points'] != null)
                        Text('Points: ${req['points']}/50', 
                             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700], fontSize: 12)),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                )),
          ],
        ),
      ),
    );
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'Certifications':
        return Icons.verified_outlined;
      case 'Achievements':
        return Icons.emoji_events_outlined;
      case 'Experience':
        return Icons.work_outline;
      case 'Research papers':
        return Icons.menu_book_outlined;
      case 'Projects':
        return Icons.build_outlined;
      case 'Workshops':
        return Icons.school_outlined;
      default:
        return Icons.folder_open;
    }
  }
}

// Removed status chip – Student Record shows accepted items only and no status labels
