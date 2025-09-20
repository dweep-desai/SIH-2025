import 'package:flutter/material.dart';
import '../widgets/admin_drawer.dart';
import '../services/auth_service.dart';

class AdminFacultySearchPage extends StatefulWidget {
  const AdminFacultySearchPage({super.key});

  @override
  State<AdminFacultySearchPage> createState() => _AdminFacultySearchPageState();
}

class _AdminFacultySearchPageState extends State<AdminFacultySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> allFaculty = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFacultyData();
  }

  Future<void> _loadFacultyData() async {
    try {
      final facultyList = await _authService.getAllFaculty();
      setState(() {
        allFaculty = facultyList;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading faculty data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get filteredFaculty {
    if (_searchQuery.isEmpty) return [];
    return allFaculty.where((faculty) {
      return faculty['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             faculty['faculty_id'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Name or ID',
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
          ),
          Expanded(
            child: _searchQuery.isEmpty
                ? Center(
                    child: Text(
                      'Enter a name or ID to search',
                      style: textTheme.bodyLarge,
                    ),
                  )
                : filteredFaculty.isEmpty
                    ? Center(
                        child: Text(
                          'No faculty found',
                          style: textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: filteredFaculty.length,
                        itemBuilder: (context, index) {
                          final faculty = filteredFaculty[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            child: ListTile(
                              title: Text(
                                faculty['name'],
                                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: ${faculty['faculty_id']}', style: textTheme.bodyMedium),
                                  Text('Department: ${faculty['department']}', style: textTheme.bodyMedium),
                                  Text('Designation: ${faculty['designation']}', style: textTheme.bodyMedium),
                                  Text('Email: ${faculty['email']}', style: textTheme.bodyMedium),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.info, color: Colors.blue),
                                onPressed: () {
                                  // TODO: Implement view faculty details
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('View details for ${faculty['name']}')),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
