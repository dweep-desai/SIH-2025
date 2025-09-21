import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/admin_drawer.dart';
import '../services/auth_service.dart';

class AdminFacultySearchPage extends StatefulWidget {
  const AdminFacultySearchPage({super.key});

  @override
  _AdminFacultySearchPageState createState() => _AdminFacultySearchPageState();
}

class _AdminFacultySearchPageState extends State<AdminFacultySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _deptFilter = 'All';
  String _domainFilter = 'All';
  String _sortBy = 'Name'; // Name or Department
  
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> _allFaculty = [];
  List<Map<String, dynamic>> _filteredFaculty = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFacultyData();
    _searchController.addListener(_filterFaculty);
  }

  Future<void> _loadFacultyData() async {
    try {
      final facultyList = await _authService.getAllFaculty();
      setState(() {
        _allFaculty = facultyList;
        _filteredFaculty = facultyList;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading faculty data: $e');
      setState(() {
        _isLoading = false;
      });
    }
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
    
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Faculty Search')),
        drawer: AdminDrawer(context: context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Search'),
      ),
      drawer: AdminDrawer(context: context),
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
                            trailing: const Icon(Icons.info_outline),
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

  Widget _buildDeptFilter(ColorScheme colors) {
    final departments = ['All'] + _allFaculty.map((f) => f['department'] as String? ?? '').where((d) => d.isNotEmpty).toSet().toList();
    
    return DropdownButtonFormField<String>(
      initialValue: _deptFilter,
      decoration: InputDecoration(
        labelText: 'Department',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        filled: true,
        fillColor: colors.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: departments.map((String dept) {
        return DropdownMenuItem<String>(
          value: dept,
          child: Text(dept, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _deptFilter = value ?? 'All';
        });
        _filterFaculty();
      },
    );
  }

  Widget _buildDomainFilter(ColorScheme colors) {
    final domains = ['All'] + _allFaculty.map((f) => f['domain'] as String? ?? '').where((d) => d.isNotEmpty).toSet().toList();
    
    return DropdownButtonFormField<String>(
      initialValue: _domainFilter,
      decoration: InputDecoration(
        labelText: 'Domain',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        filled: true,
        fillColor: colors.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: domains.map((String domain) {
        return DropdownMenuItem<String>(
          value: domain,
          child: Text(domain, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _domainFilter = value ?? 'All';
        });
        _filterFaculty();
      },
    );
  }

  Widget _buildSortFilter(ColorScheme colors) {
    return DropdownButtonFormField<String>(
      initialValue: _sortBy,
      decoration: InputDecoration(
        labelText: 'Sort By',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        filled: true,
        fillColor: colors.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem<String>(value: 'Name', child: Text('Name')),
        DropdownMenuItem<String>(value: 'Department', child: Text('Department')),
      ],
      onChanged: (String? value) {
        setState(() {
          _sortBy = value ?? 'Name';
        });
        _filterFaculty();
      },
    );
  }

  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      return FileImage(File(imagePath));
    }
  }

  void _openFacultyDetailSheet(BuildContext context, Map<String, dynamic> faculty) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    
    // Get faculty_record data with proper type casting
    final facultyRecordRaw = faculty['faculty_record'];
    final facultyRecord = facultyRecordRaw is Map ? Map<String, dynamic>.from(facultyRecordRaw) : <String, dynamic>{};
    
    final papersRaw = facultyRecord['papers_and_publications'];
    final papers = papersRaw is List ? List<Map<String, dynamic>>.from(papersRaw.map((item) => item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{})) : <Map<String, dynamic>>[];
    
    final projectsRaw = facultyRecord['projects'];
    final projects = projectsRaw is List ? List<Map<String, dynamic>>.from(projectsRaw.map((item) => item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{})) : <Map<String, dynamic>>[];
    
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
              // Faculty Profile Header
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: colors.primaryContainer,
                        backgroundImage: faculty['profile_photo'] != null && faculty['profile_photo'].toString().isNotEmpty
                            ? _getImageProvider(faculty['profile_photo'])
                            : null,
                        child: faculty['profile_photo'] == null || faculty['profile_photo'].toString().isEmpty
                            ? Icon(Icons.person, color: colors.onPrimaryContainer, size: 28)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(faculty['name'] ?? 'Unknown', style: texts.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Faculty ID: ${faculty['faculty_id'] ?? 'N/A'}', style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                            Text('Department: ${faculty['department'] ?? 'N/A'}', style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                            Text('Designation: ${faculty['designation'] ?? 'N/A'}', style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                            Text('Email: ${faculty['email'] ?? 'N/A'}', style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Educational Qualifications
              if (faculty['educational_qualifications'] != null)
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
                            const Icon(Icons.school, color: Colors.blue, size: 20),
                            const SizedBox(width: 8),
                            Text('Educational Qualifications', style: texts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(faculty['educational_qualifications'], style: texts.bodyMedium),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              
              // Papers & Publications
              if (papers.isNotEmpty)
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
                            const Icon(Icons.article, color: Colors.green, size: 20),
                            const SizedBox(width: 8),
                            Text('Papers & Publications', style: texts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...papers.map((paper) => ListTile(
                          leading: const Icon(Icons.description, color: Colors.grey, size: 16),
                          title: Text(paper['title'] ?? 'Untitled', style: texts.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                          subtitle: Text(paper['description'] ?? 'No description', style: texts.bodySmall),
                          dense: true,
                        )),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              
              // Projects
              if (projects.isNotEmpty)
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
                            const Icon(Icons.work, color: Colors.orange, size: 20),
                            const SizedBox(width: 8),
                            Text('Projects', style: texts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...projects.map((project) => ListTile(
                          leading: const Icon(Icons.folder, color: Colors.grey, size: 16),
                          title: Text(project['title'] ?? 'Untitled', style: texts.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                          subtitle: Text(project['description'] ?? 'No description', style: texts.bodySmall),
                          dense: true,
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
}
