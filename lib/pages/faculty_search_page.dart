import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/faculty_drawer.dart' as faculty_drawer;
import '../widgets/student_drawer.dart' as student_drawer;
import '../widgets/admin_drawer.dart';
import '../services/auth_service.dart';

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

  Widget _getAppropriateDrawer(BuildContext context) {
    final userCategory = _authService.getUserCategory();
    
    switch (userCategory) {
      case 'student':
        return student_drawer.MainDrawer(context: context);
      case 'faculty':
        return faculty_drawer.MainDrawer(context: context, isFaculty: true);
      case 'admin':
        return AdminDrawer(context: context);
      default:
        return student_drawer.MainDrawer(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Faculty Search'),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        drawer: _getAppropriateDrawer(context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Search'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      drawer: _getAppropriateDrawer(context),
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
  // Removed unused helper (integrated directly in detail sheet)

  // Removed unused helper (integrated directly in detail sheet)

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
                            Icon(Icons.school, color: colors.primary),
                            const SizedBox(width: 8),
                            Text('Educational Qualifications', style: texts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(height: 16),
                        Text(faculty['educational_qualifications'].toString(), style: texts.bodyMedium),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              
              // Papers & Publications
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
                      else ...papers.take(5).map((paper) => ListTile(
                            dense: true,
                            leading: Icon(Icons.description_outlined, color: colors.secondary),
                            title: Text(paper['title']?.toString() ?? 'Untitled'),
                            subtitle: Text(paper['description']?.toString() ?? 'No description'),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Projects
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
                          Icon(Icons.work_outline, color: colors.primary),
                          const SizedBox(width: 8),
                          Text('Projects', style: texts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(height: 16),
                      if (projects.isEmpty)
                        Center(child: Text('No projects available', style: texts.bodyMedium))
                      else ...projects.take(5).map((project) => ListTile(
                            dense: true,
                            leading: Icon(Icons.work_outline, color: colors.secondary),
                            title: Text(project['title']?.toString() ?? 'Untitled'),
                            subtitle: Text(project['description']?.toString() ?? 'No description'),
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

  // Helper method to get appropriate image provider
  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else if (imagePath.startsWith('/') || imagePath.startsWith('C:')) {
      return FileImage(File(imagePath));
    } else {
      return NetworkImage(imagePath);
    }
  }

  Widget _buildDeptFilter(ColorScheme colors) {
    // Get unique departments from faculty data
    final departments = ['All', ..._allFaculty.map((f) => f['department'] as String).toSet().toList()..sort()];
    
    return DropdownButtonFormField<String>(
      initialValue: _deptFilter,
      decoration: InputDecoration(
        labelText: 'Department',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: colors.surfaceContainerHighest,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: departments.map((dept) => DropdownMenuItem(value: dept, child: Text(dept))).toList(),
      onChanged: (v) {
        _deptFilter = v ?? 'All';
        _filterFaculty();
      },
    );
  }

  Widget _buildDomainFilter(ColorScheme colors) {
    return DropdownButtonFormField<String>(
      initialValue: _domainFilter,
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
      initialValue: _sortBy,
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
