import 'package:flutter/material.dart';
import '../widgets/faculty_drawer.dart';
import '../data/approval_data.dart';

class FacultyStudentSearchPage extends StatefulWidget {
  const FacultyStudentSearchPage({super.key});

  @override
  State<FacultyStudentSearchPage> createState() => _FacultyStudentSearchPageState();
}

class _FacultyStudentSearchPageState extends State<FacultyStudentSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _branchFilter = 'All';
  String _sortBy = 'Name'; // Name or Roll No

  // Dummy data for students
  final List<Map<String, dynamic>> allStudents = [
    {
      'name': 'Alice Johnson',
      'id': '24BCE001',
      'department': 'Computer Science',
      'email': 'alice@nirmauni.ac.in',
    },
    {
      'name': 'Bob Smith',
      'id': '24BCE010',
      'department': 'Computer Science',
      'email': 'bob@nirmauni.ac.in',
    },
    {
      'name': 'Charlie Brown',
      'id': '24BIT003',
      'department': 'Information Technology',
      'email': 'charlie@nirmauni.ac.in',
    },
    {
      'name': 'Diana Prince',
      'id': '24BCE005',
      'department': 'Computer Science',
      'email': 'diana@nirmauni.ac.in',
    },
  ];

  List<Map<String, dynamic>> get filteredStudents {
    List<Map<String, dynamic>> result = allStudents;

    // Branch filter
    if (_branchFilter != 'All') {
      result = result.where((s) => (s['department'] as String) == _branchFilter).toList();
    }

    // Search by name or roll no
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((s) =>
        (s['name'] as String).toLowerCase().contains(q) ||
        (s['id'] as String).toLowerCase().contains(q)
      ).toList();
    }

    // Lexicographic sort
    if (_sortBy == 'Name') {
      result.sort((a, b) => (a['name'] as String).toLowerCase().compareTo((b['name'] as String).toLowerCase()));
    } else {
      result.sort((a, b) => (a['id'] as String).toLowerCase().compareTo((b['id'] as String).toLowerCase()));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Search'),
      ),
      drawer: MainDrawer(context: context, isFaculty: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by Name or Roll No',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Branch filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _branchFilter,
                        decoration: InputDecoration(
                          labelText: 'Branch',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'All', child: Text('All')),
                          DropdownMenuItem(value: 'Computer Science', child: Text('Computer Science')),
                          DropdownMenuItem(value: 'Information Technology', child: Text('Information Technology')),
                        ],
                        onChanged: (v) {
                          setState(() { _branchFilter = v ?? 'All'; });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Sort by
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _sortBy,
                        decoration: InputDecoration(
                          labelText: 'Sort By',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Name', child: Text('Name (A-Z)')),
                          DropdownMenuItem(value: 'Roll No', child: Text('Roll No (A-Z)')),
                        ],
                        onChanged: (v) {
                          setState(() { _sortBy = v ?? 'Name'; });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _searchQuery.isEmpty && _branchFilter == 'All'
                ? Center(
                    child: Text(
                      'Use the search or filters to find students',
                      style: textTheme.bodyLarge,
                    ),
                  )
                : filteredStudents.isEmpty
                    ? Center(
                        child: Text(
                          'No students found',
                          style: textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: filteredStudents.length,
                        itemBuilder: (context, index) {
                          final student = filteredStudents[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            child: ListTile(
                              isThreeLine: true,
                              title: Text(
                                student['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Roll No: ${student['id']}',
                                    style: textTheme.bodyMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                  Text(
                                    'Branch: ${student['department']}',
                                    style: textTheme.bodyMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                  Text(
                                    'Email: ${student['email']}',
                                    style: textTheme.bodyMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ],
                              ),
                              onTap: () => _showStudentQuickView(student),
                              trailing: const Icon(Icons.chevron_right),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _showStudentQuickView(Map<String, dynamic> student) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final colors = theme.colorScheme;
        final texts = theme.textTheme;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colors.primaryContainer,
                    child: Icon(Icons.person, color: colors.onPrimaryContainer, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student['name'], style: texts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text('Roll No: ${student['id']}', style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                        Text('Branch: ${student['department']}', style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close),
                      label: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _openFacultyStudentDetail(student);
                      },
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('View Details'),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _openFacultyStudentDetail(Map<String, dynamic> student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FacultyStudentDetailPage(student: student),
      ),
    );
  }
}

class FacultyStudentDetailPage extends StatelessWidget {
  final Map<String, dynamic> student;

  const FacultyStudentDetailPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final texts = theme.textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Student Overview')),
      drawer: MainDrawer(context: context, isFaculty: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: colors.primaryContainer,
                      child: Icon(Icons.person, color: colors.onPrimaryContainer, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(student['name'], style: texts.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Roll No: ${student['id']}', style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                          Text('Branch: ${student['department']}', style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                          Text('Email: ${student['email']}', style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _openStudentDashboardSheet(context),
                    icon: const Icon(Icons.dashboard_outlined),
                    label: const Text('Open Student Dashboard'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openStudentRecordSheetExact(context),
                    icon: const Icon(Icons.workspace_premium_outlined),
                    label: const Text('Student Record'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openStudentGradesSheet(context),
                    icon: const Icon(Icons.school_outlined),
                    label: const Text('View Grades'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening analytics...')));
                    },
                    icon: const Icon(Icons.analytics_outlined),
                    label: const Text('View Analytics'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloading profile...')));
                    },
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('Download Profile'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _openStudentDashboardSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final colors = Theme.of(ctx).colorScheme;
        final texts = Theme.of(ctx).textTheme;
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              controller: controller,
              children: [
                Row(
                  children: [
                    Icon(Icons.dashboard_outlined, color: colors.primary),
                    const SizedBox(width: 8),
                    Text('Student Dashboard (Preview)', style: texts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Current Semester: 3', style: texts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('GPA: 8 / 10', style: texts.bodyLarge),
                            Icon(Icons.show_chart, color: colors.primary),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: 0.8, minHeight: 6, borderRadius: BorderRadius.circular(3)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Attendance Overview', style: texts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Overall: 85%', style: texts.bodyLarge),
                            Icon(Icons.check_circle_outline, color: Colors.green.shade600),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: 0.85, minHeight: 6, borderRadius: BorderRadius.circular(3)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
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
                            Icon(Icons.grade, color: colors.primary),
                            const SizedBox(width: 8),
                            Text('Recent Grades', style: texts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(height: 16),
                        const ListTile(title: Text('Data Structures - A')),
                        const ListTile(title: Text('Object Oriented - B+')),
                        const ListTile(title: Text('Digital Electronics - A-')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  

  

  void _openStudentRecordSheetExact(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final colors = Theme.of(ctx).colorScheme;
        final texts = Theme.of(ctx).textTheme;
        // Build EXACT record content same as AchievementsPage categories
        const List<String> categoryOrder = [
          'Certifications', 'Achievements', 'Experience', 'Research papers', 'Projects', 'Workshops'
        ];
        final Map<String, List> grouped = {};
        for (final req in approvalRequests.where((r) => r.status == 'accepted')) {
          grouped.putIfAbsent(req.category, () => []).add(req);
        }
        for (final category in ['Research papers', 'Projects']) {
          if (grouped.containsKey(category)) {
            grouped[category]!.sort((a, b) => (b.points ?? 0).compareTo(a.points ?? 0));
          }
        }

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9,
          minChildSize: 0.6,
          maxChildSize: 0.98,
          builder: (_, controller) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              controller: controller,
              children: [
                Row(
                  children: [
                    Icon(Icons.workspace_premium_outlined, color: colors.primary),
                    const SizedBox(width: 8),
                    Text('Student Record', style: texts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
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
                  return _RecordCategoryCard(title: cat, items: limitedItems);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  int _getItemLimit(String category) {
    switch (category) {
      case 'Projects':
      case 'Achievements':
      case 'Research papers':
      case 'Workshops':
        return 3;
      case 'Experience':
        return 10;
      default:
        return 5;
    }
  }

  void _openStudentGradesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return const _GradesBottomSheet();
      },
    );
  }

}

class _RecordCategoryCard extends StatelessWidget {
  final String title;
  final List items; // List<Map<String,String?>>

  const _RecordCategoryCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
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
                Icon(_iconForCategory(title), color: colors.primary),
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
}

class _GradesBottomSheet extends StatefulWidget {
  const _GradesBottomSheet();

  @override
  State<_GradesBottomSheet> createState() => _GradesBottomSheetState();
}

class _GradesBottomSheetState extends State<_GradesBottomSheet> {
  int _selectedSemester = 1;
  final int _totalSemesters = 7;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final texts = theme.textTheme;

    // Mock data mirroring Grades page style
    final List<Map<String, dynamic>> grades = [
      {"course": "Subject A - Sem $_selectedSemester", "grade": "A", "credits": 4},
      {"course": "Subject B - Sem $_selectedSemester", "grade": "B+", "credits": 3},
      {"course": "Subject C - Sem $_selectedSemester", "grade": "A-", "credits": 3},
      {"course": "Subject D - Sem $_selectedSemester", "grade": "A", "credits": 3},
    ];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.6,
      maxChildSize: 0.98,
      builder: (_, controller) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          controller: controller,
          children: [
            Row(
              children: [
                Icon(Icons.school_outlined, color: colors.primary),
                const SizedBox(width: 8),
                Text('Grades', style: texts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: colors.outline.withOpacity(0.5)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedSemester,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down_rounded, color: colors.primary, size: 30),
                  dropdownColor: colors.surfaceContainerHighest,
                  style: texts.titleMedium?.copyWith(color: colors.onSurface),
                  items: List.generate(_totalSemesters, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text("Semester ${index + 1}"),
                    );
                  }),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedSemester = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: colors.surfaceContainerLow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        Icon(Icons.school_outlined, color: colors.primary, size: 28),
                        const SizedBox(width: 12),
                        Text(
                          "Grades - Semester $_selectedSemester",
                          style: texts.titleLarge?.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ...grades.map((g) => ListTile(
                        title: Text(g['course'].toString(), style: texts.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
                        subtitle: Text("Credits: ${g['credits']}", style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: colors.primaryContainer.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            g['grade'].toString(),
                            style: texts.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.onPrimaryContainer,
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

