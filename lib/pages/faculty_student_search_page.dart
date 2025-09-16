import 'package:flutter/material.dart';
import '../widgets/faculty_drawer.dart';

class FacultyStudentSearchPage extends StatefulWidget {
  const FacultyStudentSearchPage({super.key});

  @override
  State<FacultyStudentSearchPage> createState() => _FacultyStudentSearchPageState();
}

class _FacultyStudentSearchPageState extends State<FacultyStudentSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Dummy data for students
  final List<Map<String, dynamic>> allStudents = [
    {
      'name': 'Alice Johnson',
      'id': 'STU001',
      'department': 'Computer Science',
      'email': 'alice@nirmauni.ac.in',
    },
    {
      'name': 'Bob Smith',
      'id': 'STU002',
      'department': 'Computer Science',
      'email': 'bob@nirmauni.ac.in',
    },
    {
      'name': 'Charlie Brown',
      'id': 'STU003',
      'department': 'Information Technology',
      'email': 'charlie@nirmauni.ac.in',
    },
    {
      'name': 'Diana Prince',
      'id': 'STU004',
      'department': 'Computer Science',
      'email': 'diana@nirmauni.ac.in',
    },
  ];

  List<Map<String, dynamic>> get filteredStudents {
    if (_searchQuery.isEmpty) return [];
    return allStudents.where((student) {
      return student['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             student['id'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
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
                              title: Text(
                                student['name'],
                                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: ${student['id']}', style: textTheme.bodyMedium),
                                  Text('Department: ${student['department']}', style: textTheme.bodyMedium),
                                  Text('Email: ${student['email']}', style: textTheme.bodyMedium),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.info, color: Colors.blue),
                                onPressed: () {
                                  // TODO: Implement view student details
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('View details for ${student['name']}')),
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
