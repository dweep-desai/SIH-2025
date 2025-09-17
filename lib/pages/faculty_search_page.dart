import 'package:flutter/material.dart';
import '../widgets/faculty_drawer.dart';

class FacultySearchPage extends StatefulWidget {
  const FacultySearchPage({super.key});

  @override
  _FacultySearchPageState createState() => _FacultySearchPageState();
}

class _FacultySearchPageState extends State<FacultySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _deptFilter = 'All';
  String _domainFilter = 'All';
  String _sortBy = 'Name'; // Name or Department

  final List<Map<String, dynamic>> _allFaculty = [
    {
      'name': 'Dr. John Smith',
      'department': 'Computer Science',
      'domain': 'AI/ML',
      'papers': [
        'Deep Learning for Edge Devices (IEEE 2022)',
        'Efficient CNN Architectures (ACM 2023)'
      ],
      'research': [
        {'topic': 'Edge AI', 'conference': 'IEEE Edge 2023', 'students': 'Alice, Bob'},
      ],
    },
    {
      'name': 'Prof. Jane Doe',
      'department': 'Information Technology',
      'domain': 'Data Science',
      'papers': [
        'Privacy in Federated Learning (Springer 2021)'
      ],
      'research': [
        {'topic': 'Federated Learning', 'conference': 'NeurIPS 2023', 'students': 'Charlie'},
      ],
    },
    {
      'name': 'Dr. Emily Johnson',
      'department': 'Computer Science',
      'domain': 'Cybersecurity',
      'papers': [],
      'research': [],
    },
    {
      'name': 'Prof. Michael Brown',
      'department': 'IT',
      'domain': 'Web Development',
      'papers': ['Network Security Advances (Elsevier 2020)'],
      'research': [
        {'topic': 'Network Security', 'conference': 'BlackHat 2022', 'students': 'David, Erin'},
      ],
    },
  ];
  List<Map<String, dynamic>> _filteredFaculty = [];

  @override
  void initState() {
    super.initState();
    _filteredFaculty = _allFaculty;
    _searchController.addListener(_filterFaculty);
  }

  void _filterFaculty() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      List<Map<String, dynamic>> result = _allFaculty;

      // Department filter
      if (_deptFilter != 'All') {
        result = result.where((f) => (f['department'] as String) == _deptFilter).toList();
      }

      // Domain filter
      if (_domainFilter != 'All') {
        result = result.where((f) => ((f['domain'] as String?) ?? '').toLowerCase() == _domainFilter.toLowerCase()).toList();
      }

      // Query filter (name, department, domain)
      if (query.isNotEmpty) {
        result = result.where((f) {
          final name = (f['name'] as String).toLowerCase();
          final dept = (f['department'] as String).toLowerCase();
          final dom = ((f['domain'] as String?) ?? '').toLowerCase();
          return name.contains(query) || dept.contains(query) || dom.contains(query);
        }).toList();
      }

      // Sort
      if (_sortBy == 'Name') {
        result.sort((a, b) => (a['name'] as String).toLowerCase().compareTo((b['name'] as String).toLowerCase()));
      } else {
        result.sort((a, b) => (a['department'] as String).toLowerCase().compareTo((b['department'] as String).toLowerCase()));
      }

      _filteredFaculty = result;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterFaculty);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Search'),
      ),
      drawer: MainDrawer(context: context, isFaculty: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Faculty Name or Department',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: colors.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 12.0),
            // Filters: Department, Domain, Sort By (responsive like student search)
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 700) {
                  return Row(
                    children: [
                      Expanded(child: _buildDeptFilter(colors)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildDomainFilter(colors)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildSortFilter(colors)),
                    ],
                  );
                } else if (constraints.maxWidth > 500) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildDeptFilter(colors)),
                          const SizedBox(width: 8),
                          Expanded(child: _buildDomainFilter(colors)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildSortFilter(colors),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildDeptFilter(colors),
                      const SizedBox(height: 8),
                      _buildDomainFilter(colors),
                      const SizedBox(height: 8),
                      _buildSortFilter(colors),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 12.0),
            Expanded(
              child: _filteredFaculty.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredFaculty.length,
                      itemBuilder: (context, index) {
                        final faculty = _filteredFaculty[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: colors.primary,
                              child: const Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(faculty['name'], style: texts.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                            subtitle: Text('Department: ${faculty['department']}', style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _openFacultyDetailSheet(context, faculty),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No faculty found.',
                        style: texts.titleMedium,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
  // Removed unused helper (integrated directly in detail sheet)

  // Removed unused helper (integrated directly in detail sheet)

  void _openFacultyDetailSheet(BuildContext context, Map<String, dynamic> faculty) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    final papers = faculty['papers'] as List? ?? [];
    final research = faculty['research'] as List? ?? [];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        minChildSize: 0.6,
        maxChildSize: 0.98,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            controller: controller,
            children: [
              // Personal header (similar to faculty dashboard)
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: colors.primaryContainer,
                    child: Icon(Icons.person, color: colors.onPrimaryContainer, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(faculty['name'], style: texts.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Department: ${faculty['department']}', style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                        if ((faculty['domain'] as String?) != null)
                          Text('Domain: ${faculty['domain']}', style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Papers & Publications card
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
                          Icon(Icons.article, color: colors.primary),
                          const SizedBox(width: 8),
                          Text('Papers & Publications', style: texts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(height: 16),
                      if (papers.isEmpty)
                        Center(child: Text('No papers available', style: texts.bodyMedium))
                      else ...papers.map((p) => ListTile(
                            dense: true,
                            leading: Icon(Icons.description_outlined, color: colors.secondary),
                            title: Text(p.toString()),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Student Research card
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
                          Icon(Icons.group, color: colors.primary),
                          const SizedBox(width: 8),
                          Text('Student Research', style: texts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(height: 16),
                      if (research.isEmpty)
                        Center(child: Text('No student research available', style: texts.bodyMedium))
                      else ...research.map((r) => ListTile(
                            dense: true,
                            leading: Icon(Icons.topic_outlined, color: colors.secondary),
                            title: Text('${r['topic']} - ${r['conference']}'),
                            subtitle: Text('Students: ${r['students']}'),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeptFilter(ColorScheme colors) {
    return DropdownButtonFormField<String>(
      value: _deptFilter,
      decoration: InputDecoration(
        labelText: 'Department',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: colors.surfaceContainerHighest,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: 'All', child: Text('All')),
        DropdownMenuItem(value: 'Computer Science', child: Text('Computer Science')),
        DropdownMenuItem(value: 'Information Technology', child: Text('Information Technology')),
        DropdownMenuItem(value: 'IT', child: Text('IT')),
      ],
      onChanged: (v) {
        _deptFilter = v ?? 'All';
        _filterFaculty();
      },
    );
  }

  Widget _buildDomainFilter(ColorScheme colors) {
    return DropdownButtonFormField<String>(
      value: _domainFilter,
      decoration: InputDecoration(
        labelText: 'Domain',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: colors.surfaceContainerHighest,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: 'All', child: Text('All')),
        DropdownMenuItem(value: 'AI/ML', child: Text('AI/ML')),
        DropdownMenuItem(value: 'Data Science', child: Text('Data Science')),
        DropdownMenuItem(value: 'Cybersecurity', child: Text('Cybersecurity')),
        DropdownMenuItem(value: 'Web Development', child: Text('Web Development')),
      ],
      onChanged: (v) {
        _domainFilter = v ?? 'All';
        _filterFaculty();
      },
    );
  }

  Widget _buildSortFilter(ColorScheme colors) {
    return DropdownButtonFormField<String>(
      value: _sortBy,
      decoration: InputDecoration(
        labelText: 'Sort By',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: colors.surfaceContainerHighest,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: 'Name', child: Text('Name (A-Z)')),
        DropdownMenuItem(value: 'Department', child: Text('Department (A-Z)')),
      ],
      onChanged: (v) {
        _sortBy = v ?? 'Name';
        _filterFaculty();
      },
    );
  }
}
