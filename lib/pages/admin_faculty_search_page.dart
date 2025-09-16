import 'package:flutter/material.dart';
import '../widgets/admin_drawer.dart';

class AdminFacultySearchPage extends StatefulWidget {
  const AdminFacultySearchPage({super.key});

  @override
  State<AdminFacultySearchPage> createState() => _AdminFacultySearchPageState();
}

class _AdminFacultySearchPageState extends State<AdminFacultySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Dummy data for faculty
  final List<Map<String, dynamic>> allFaculty = [
    {
      'name': 'Dr. John Doe',
      'id': 'FAC001',
      'department': 'Computer Science',
      'email': 'john.doe@nirmauni.ac.in',
      'designation': 'Professor',
    },
    {
      'name': 'Dr. Jane Smith',
      'id': 'FAC002',
      'department': 'Information Technology',
      'email': 'jane.smith@nirmauni.ac.in',
      'designation': 'Associate Professor',
    },
    {
      'name': 'Dr. Bob Johnson',
      'id': 'FAC003',
      'department': 'Computer Science',
      'email': 'bob.johnson@nirmauni.ac.in',
      'designation': 'Assistant Professor',
    },
    {
      'name': 'Dr. Alice Brown',
      'id': 'FAC004',
      'department': 'Electrical Engineering',
      'email': 'alice.brown@nirmauni.ac.in',
      'designation': 'Lecturer',
    },
  ];

  List<Map<String, dynamic>> get filteredFaculty {
    if (_searchQuery.isEmpty) return [];
    return allFaculty.where((faculty) {
      return faculty['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             faculty['id'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

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
                                  Text('ID: ${faculty['id']}', style: textTheme.bodyMedium),
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
