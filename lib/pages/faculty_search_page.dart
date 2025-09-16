import 'package:flutter/material.dart';
import 'package:sih_project/widgets/student_drawer.dart';

class FacultySearchPage extends StatefulWidget {
  const FacultySearchPage({Key? key}) : super(key: key);

  @override
  _FacultySearchPageState createState() => _FacultySearchPageState();
}

class _FacultySearchPageState extends State<FacultySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allFaculty = [
    'Dr. John Smith',
    'Prof. Jane Doe',
    'Dr. Emily Johnson',
    'Prof. Michael Brown',
    'Dr. Linda Davis',
    'Prof. William Wilson',
  ];
  List<String> _filteredFaculty = [];

  @override
  void initState() {
    super.initState();
    _filteredFaculty = _allFaculty;
    _searchController.addListener(_filterFaculty);
  }

  void _filterFaculty() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFaculty = _allFaculty
          .where((faculty) => faculty.toLowerCase().contains(query))
          .toList();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Faculty'),
      ),
      drawer: MainDrawer(context: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Faculty',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _filteredFaculty.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredFaculty.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.indigo,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(_filteredFaculty[index]),
                            onTap: () {
                              // TODO: Implement faculty detail navigation
                            },
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No faculty found.',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
