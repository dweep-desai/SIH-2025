import 'package:flutter/material.dart';
import '../widgets/student_drawer.dart';
import '../services/auth_service.dart';

// ---------------- ACHIEVEMENTS PAGE ----------------
class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = _authService.getCurrentUser();
      if (userData != null) {
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Student Record")),
        drawer: MainDrawer(context: context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Desired order of categories as per request approval section
    const List<String> categoryOrder = [
      'Certifications',
      'Achievements',
      'Experience',
      'Research papers',
      'Projects',
      'Workshops',
    ];

    // Get student record from Firebase data
    final studentRecord = _userData?['student_record'] ?? {};
    
    // Group data by category
    final Map<String, List> grouped = {};
    for (final category in categoryOrder) {
      final categoryKey = category.toLowerCase().replaceAll(' ', '_');
      if (studentRecord[categoryKey] != null) {
        final items = studentRecord[categoryKey] is List 
            ? studentRecord[categoryKey] 
            : studentRecord[categoryKey].values.toList();
        grouped[category] = items;
      }
    }
    
    // Sort by points (highest first) for categories that need top items
    for (final category in ['Certifications', 'Achievements', 'Research papers', 'Projects', 'Workshops']) {
      if (grouped.containsKey(category)) {
        grouped[category]!.sort((a, b) {
          final aPoints = a is Map ? (a['points'] ?? 0) : 0;
          final bPoints = b is Map ? (b['points'] ?? 0) : 0;
          return bPoints.compareTo(aPoints);
        });
      }
    }

    // Sample fallback content for empty categories
    final Map<String, List<Map<String, String>>> sampleByCategory = {
      'Certifications': [
        {
          'title': 'AWS Cloud Practitioner',
          'description': 'Basic cloud concepts and AWS services.',
          'points': '50'
        }
      ],
      'Achievements': [
        {
          'title': 'Hackathon Finalist',
          'description': 'Top 10 in University Hackathon 2024.',
          'points': '45'
        }
      ],
      'Experience': [
        {
          'title': 'Internship at Tech Corp',
          'description': 'Summer intern, mobile development team.',
        }
      ],
      'Research papers': [
        {
          'title': 'AI in Education',
          'description': 'Exploring adaptive learning systems.',
          'points': '48'
        }
      ],
      'Projects': [
        {
          'title': 'Smart Campus App',
          'description': 'Flutter app for student services.',
          'points': '47'
        }
      ],
      'Workshops': [
        {
          'title': 'Flutter Bootcamp',
          'description': 'Hands-on workshop on Flutter basics.',
          'points': '43'
        }
      ],
    };

    return Scaffold(
        appBar: AppBar(
          title: const Text("Student Record"),
          // backgroundColor: colorScheme.surface, // Or primary for a colored AppBar
          // elevation: 0,
        ),
        drawer: MainDrawer(context: context),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...categoryOrder.map((cat) {
                final realItems = grouped[cat] ?? [];
                final List<Map<String, String?>> itemsData = realItems.isNotEmpty
                    ? realItems
                        .map<Map<String, String?>>((item) {
                          if (item is Map) {
                            return {
                              'title': item['title']?.toString() ?? '',
                              'description': item['description']?.toString() ?? '',
                              'points': item['points']?.toString(),
                            };
                          }
                          return {
                            'title': '',
                            'description': '',
                            'points': null,
                          };
                        })
                        .toList()
                    : (sampleByCategory[cat] ?? []);
                
                // Limit items based on category
                final int limit = _getItemLimit(cat);
                final limitedItems = itemsData.take(limit).toList();
                
                return _CategoryCard(title: cat, items: limitedItems);
              }),
            ],
          ),
        )
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
