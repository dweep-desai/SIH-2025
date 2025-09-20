import 'package:flutter/material.dart';
import '../widgets/faculty_drawer.dart';
import '../data/approval_data.dart';

class FacultyStudentRecordPage extends StatelessWidget {
  const FacultyStudentRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    const List<String> categoryOrder = [
      'Certifications',
      'Achievements',
      'Experience',
      'Research papers',
      'Projects',
      'Workshops',
    ];

    final Map<String, List> grouped = {};
    for (final req in approvalRequests.where((r) => r.status == 'accepted')) {
      grouped.putIfAbsent(req.category, () => []).add(req);
    }
    // Sort by points (highest first) for categories that need top items
    for (final category in ['Certifications', 'Achievements', 'Research papers', 'Projects', 'Workshops']) {
      if (grouped.containsKey(category)) {
        grouped[category]!.sort((a, b) => (b.points ?? 0).compareTo(a.points ?? 0));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Student Record')),
      drawer: MainDrawer(context: context, isFaculty: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...categoryOrder.map((cat) {
              final realItems = grouped[cat] ?? [];
              final List<Map<String, String?>> itemsData = realItems
                  .map<Map<String, String?>>((req) => {
                        'title': req.title,
                        'description': req.description,
                        'points': req.points?.toString(),
                      })
                  .toList();
              final int limit = _getItemLimit(cat);
              final limitedItems = itemsData.take(limit).toList();
              return _CategoryCard(title: cat, items: limitedItems);
            }),
          ],
        ),
      ),
    );
  }

  int _getItemLimit(String category) {
    switch (category) {
      case 'Certifications':
      case 'Achievements':
      case 'Projects':
      case 'Workshops':
        return 3; // Top 3 (highest points)
      case 'Research papers':
        return 5; // Top 5 (highest points)
      case 'Experience':
        return 5; // Any 5 (not necessarily highest points)
      default:
        return 5;
    }
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final List items;

  const _CategoryCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final texts = theme.textTheme;
    final colors = theme.colorScheme;
    final icon = _iconForCategory(title);

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
                Icon(icon, color: colors.primary),
                const SizedBox(width: 8),
                Text(title, style: texts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 16),
            ...items.map((req) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.description_outlined, color: colors.secondary),
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


