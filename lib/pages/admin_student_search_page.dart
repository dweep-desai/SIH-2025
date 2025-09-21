import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/admin_drawer.dart';
import '../services/auth_service.dart';

class AdminStudentSearchPage extends StatefulWidget {
  const AdminStudentSearchPage({super.key});

  @override
  State<AdminStudentSearchPage> createState() => _AdminStudentSearchPageState();
}

class _AdminStudentSearchPageState extends State<AdminStudentSearchPage> {
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> _allStudents = [];
  List<Map<String, dynamic>> _filteredStudents = [];
  bool _isLoading = true;
  String _branchFilter = 'All';
  String _domainFilter = 'All';
  String _sortBy = 'Name';

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final students = await _authService.getAllStudents();
      setState(() {
        _allStudents = students;
        _filteredStudents = students;
        _isLoading = false;
      });
      print('Loaded ${students.length} students');
    } catch (e) {
      print('Error loading students: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterStudents() {
    setState(() {
      _filteredStudents = _allStudents.where((student) {
        final branchMatch = _branchFilter == 'All' || student['branch'] == _branchFilter;
        final domainMatch = _domainFilter == 'All' || 
            student['domain1'] == _domainFilter || 
            student['domain2'] == _domainFilter;
        return branchMatch && domainMatch;
      }).toList();

      // Sort the filtered results
      if (_sortBy == 'Name') {
        _filteredStudents.sort((a, b) => (a['name'] ?? '').compareTo(b['name'] ?? ''));
      } else if (_sortBy == 'Branch') {
        _filteredStudents.sort((a, b) => (a['branch'] ?? '').compareTo(b['branch'] ?? ''));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Search'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      drawer: AdminDrawer(context: context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildSearchAndFilters(),
                Expanded(
                  child: _buildStudentList(),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search students...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              _filterStudents();
            },
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              _buildBranchFilter(),
              const SizedBox(height: 8),
              _buildDomainFilter(),
              const SizedBox(height: 8),
              _buildSortFilter(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBranchFilter() {
    final branches = ['All'] + _allStudents.map((s) => s['branch'] as String? ?? '').where((b) => b.isNotEmpty).toSet().toList();
    
    return DropdownButtonFormField<String>(
      initialValue: _branchFilter,
      decoration: const InputDecoration(
        labelText: 'Branch',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: branches.map((String branch) {
        return DropdownMenuItem<String>(
          value: branch,
          child: Text(
            branch,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _branchFilter = value ?? 'All';
        });
        _filterStudents();
      },
    );
  }

  Widget _buildDomainFilter() {
    // Predefined domain options
    const List<String> predefinedDomains = [
      'AI/ML',
      'Data Science',
      'Cybersecurity',
      'Web Development',
    ];

    final domains = ['All', ...predefinedDomains];

    // Add domains from student data
    for (var student in _allStudents) {
      final domain1 = student['domain1'] as String?;
      final domain2 = student['domain2'] as String?;
      if (domain1 != null && domain1.isNotEmpty && !domains.contains(domain1)) {
        domains.add(domain1);
      }
      if (domain2 != null && domain2.isNotEmpty && !domains.contains(domain2)) {
        domains.add(domain2);
      }
    }
    final uniqueDomains = domains.toSet().toList();

    return DropdownButtonFormField<String>(
      initialValue: _domainFilter,
      decoration: const InputDecoration(
        labelText: 'Domain',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: uniqueDomains.map((String domain) {
        return DropdownMenuItem<String>(
          value: domain,
          child: Text(domain),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _domainFilter = value ?? 'All';
        });
        _filterStudents();
      },
    );
  }

  Widget _buildSortFilter() {
    return DropdownButtonFormField<String>(
      initialValue: _sortBy,
      decoration: const InputDecoration(
        labelText: 'Sort by',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem<String>(value: 'Name', child: Text('Name')),
        DropdownMenuItem<String>(value: 'Branch', child: Text('Branch')),
      ],
      onChanged: (String? value) {
        setState(() {
          _sortBy = value ?? 'Name';
        });
        _filterStudents();
      },
    );
  }

  Widget _buildStudentList() {
    if (_filteredStudents.isEmpty) {
      return const Center(
        child: Text('No students found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _filteredStudents.length,
      itemBuilder: (context, index) {
        final student = _filteredStudents[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade700,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              student['name'] ?? 'Unknown',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${student['student_id'] ?? 'N/A'}'),
                Text('Branch: ${student['branch'] ?? 'N/A'}'),
                Text('Email: ${student['email'] ?? 'N/A'}'),
                Text('Semester: ${student['current_semester'] ?? 'N/A'}'),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (String value) {
                print('🔍 Admin Search - Menu item selected: $value for student: ${student['name']}');
                _openStudentDetail(student, value);
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'dashboard',
                  child: Text('Student Dashboard'),
                ),
                const PopupMenuItem<String>(
                  value: 'record',
                  child: Text('Student Record'),
                ),
                const PopupMenuItem<String>(
                  value: 'grades',
                  child: Text('View Grades'),
                ),
                const PopupMenuItem<String>(
                  value: 'semester',
                  child: Text('Semester Info'),
                ),
              ],
            ),
          ),
        );
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

  void _openStudentDetail(Map<String, dynamic> student, String viewType) {
    switch (viewType) {
      case 'dashboard':
        _showStudentDashboard(student);
        break;
      case 'record':
        _showStudentRecord(student);
        break;
      case 'grades':
        _showStudentGrades(student);
        break;
      case 'semester':
        _showStudentSemesterInfo(student);
        break;
    }
  }

  void _showStudentDashboard(Map<String, dynamic> student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        minChildSize: 0.6,
        maxChildSize: 0.98,
        builder: (_, controller) => _StudentDashboardView(studentId: student['student_id']),
      ),
    );
  }

  void _showStudentRecord(Map<String, dynamic> student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        minChildSize: 0.6,
        maxChildSize: 0.98,
        builder: (_, controller) => _StudentRecordView(studentId: student['student_id']),
      ),
    );
  }

  void _showStudentGrades(Map<String, dynamic> student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        minChildSize: 0.6,
        maxChildSize: 0.98,
        builder: (_, controller) => _StudentGradesView(studentId: student['student_id']),
      ),
    );
  }

  void _showStudentSemesterInfo(Map<String, dynamic> student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        minChildSize: 0.6,
        maxChildSize: 0.98,
        builder: (_, controller) => _StudentSemesterInfoView(studentId: student['student_id']),
      ),
    );
  }
}

// Student View Widgets (copied from faculty_student_search_page.dart)
class _StudentDashboardView extends StatefulWidget {
  final String studentId;

  const _StudentDashboardView({required this.studentId});

  @override
  State<_StudentDashboardView> createState() => _StudentDashboardViewState();
}

class _StudentDashboardViewState extends State<_StudentDashboardView> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? studentData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    try {
      final data = await _authService.getStudentData(widget.studentId);
      setState(() {
        studentData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading student data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  double _calculateGPA(Map<String, dynamic>? grades) {
    if (grades == null || grades.isEmpty) return 0.0;
    
    double total = 0.0;
    int count = 0;
    
    grades.forEach((semester, subjects) {
      if (subjects is Map) {
        subjects.forEach((subject, grade) {
          if (grade is num) {
            total += grade.toDouble();
            count++;
          }
        });
      }
    });
    
    return count > 0 ? total / count : 0.0;
  }

  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      return FileImage(File(imagePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (studentData == null) {
      return const Center(child: Text('Student not found'));
    }

    final gradesRaw = studentData!['grades'];
    Map<String, dynamic>? grades;
    if (gradesRaw is Map) {
      grades = Map<String, dynamic>.from(gradesRaw);
    }
    final gpa = _calculateGPA(grades);
    final attendance = studentData!['attendance'] ?? 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student Profile Header
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.blue.shade700,
                    backgroundImage: studentData!['profile_photo'] != null && studentData!['profile_photo'].toString().isNotEmpty
                        ? _getImageProvider(studentData!['profile_photo'])
                        : null,
                    child: studentData!['profile_photo'] == null || studentData!['profile_photo'].toString().isEmpty
                        ? const Icon(Icons.person, color: Colors.white, size: 28)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studentData!['name'] ?? 'Unknown',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text('Student ID: ${studentData!['student_id'] ?? 'N/A'}'),
                        Text('Branch: ${studentData!['branch'] ?? 'N/A'}'),
                        Text('Semester: ${studentData!['current_semester'] ?? 'N/A'}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // GPA and Attendance Row
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.school, size: 32, color: Colors.blue),
                        const SizedBox(height: 8),
                        Text(
                          '${gpa.toStringAsFixed(2)} / 10',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text('GPA'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.present_to_all, size: 32, color: Colors.green),
                        const SizedBox(height: 8),
                        Text(
                          '${attendance.toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text('Attendance'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Domains
          if (studentData!['domain1'] != null || studentData!['domain2'] != null)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Domains', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        if (studentData!['domain1'] != null)
                          Chip(label: Text(studentData!['domain1'])),
                        if (studentData!['domain2'] != null)
                          Chip(label: Text(studentData!['domain2'])),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StudentRecordView extends StatefulWidget {
  final String studentId;

  const _StudentRecordView({required this.studentId});

  @override
  State<_StudentRecordView> createState() => _StudentRecordViewState();
}

class _StudentRecordViewState extends State<_StudentRecordView> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? studentData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    try {
      final data = await _authService.getStudentData(widget.studentId);
      setState(() {
        studentData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading student data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (studentData == null) {
      return const Center(child: Text('Student not found'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student Record Header
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  backgroundImage: studentData!['profile_photo'] != null && studentData!['profile_photo'].toString().isNotEmpty
                      ? _getImageProvider(studentData!['profile_photo'])
                      : null,
                  child: studentData!['profile_photo'] == null || studentData!['profile_photo'].toString().isEmpty
                      ? const Icon(Icons.person, color: Colors.white, size: 40)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  studentData!['name'] ?? 'Unknown Student',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Student ID: ${studentData!['student_id'] ?? 'N/A'}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                // Student Info Stats Row
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.school, color: Colors.white, size: 20),
                          const SizedBox(height: 4),
                          Text(
                            studentData!['branch'] ?? 'N/A',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const Text(
                            'Branch',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      Column(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                          const SizedBox(height: 4),
                          Text(
                            'Sem ${studentData!['current_semester'] ?? 'N/A'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const Text(
                            'Semester',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      Column(
                        children: [
                          const Icon(Icons.present_to_all, color: Colors.white, size: 20),
                          const SizedBox(height: 4),
                          Text(
                            '${studentData!['attendance'] ?? 0}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const Text(
                            'Attendance',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Contact Info Row
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email,
                        color: Colors.white.withOpacity(0.8),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          studentData!['email'] ?? 'No email provided',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Domains
          if (studentData!['domain1'] != null || studentData!['domain2'] != null)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Domains', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        if (studentData!['domain1'] != null)
                          Chip(label: Text(studentData!['domain1'])),
                        if (studentData!['domain2'] != null)
                          Chip(label: Text(studentData!['domain2'])),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 20),
          
          // Student Record Sections
          _buildStudentRecordSections(),
        ],
      ),
    );
  }

  Widget _buildStudentRecordSections() {
    final studentRecord = studentData!['student_record'];
    if (studentRecord == null) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(Icons.folder_open, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'No student record found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This student has not uploaded any records yet.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Safely cast student_record
    Map<String, dynamic> recordMap = {};
    if (studentRecord is Map) {
      recordMap = Map<String, dynamic>.from(studentRecord);
    }

    return Column(
      children: [
        _buildRecordSection('Certifications', recordMap['certifications']),
        _buildRecordSection('Achievements', recordMap['achievements']),
        _buildRecordSection('Projects', recordMap['projects']),
        _buildRecordSection('Research Papers', recordMap['research_papers']),
        _buildRecordSection('Experience', recordMap['experience']),
        
        // Fallback message if no records found
        if (recordMap.isEmpty)
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(Icons.folder_open, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No records found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This student has not uploaded any records yet.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRecordSection(String title, dynamic items) {
    print('🔍 Building record section: $title with items: $items');
    if (items == null) {
      print('❌ No items for $title');
      return const SizedBox.shrink();
    }
    
    List<Map<String, dynamic>> itemList = [];
    if (items is Map) {
      itemList = items.values.map((item) {
        if (item is Map) {
          return Map<String, dynamic>.from(item);
        }
        return <String, dynamic>{};
      }).toList();
    } else if (items is List) {
      itemList = items.map((item) {
        if (item is Map) {
          return Map<String, dynamic>.from(item);
        }
        return <String, dynamic>{};
      }).toList();
    }
    
    if (itemList.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort items by points (highest first) for certain categories
    if (['Certifications', 'Achievements', 'Projects', 'Research Papers'].contains(title)) {
      itemList.sort((a, b) {
        final pointsA = (a['points'] as num?)?.toDouble() ?? 0.0;
        final pointsB = (b['points'] as num?)?.toDouble() ?? 0.0;
        return pointsB.compareTo(pointsA);
      });
    }

    // Limit items based on category
    int limit = _getItemLimit(title);
    if (itemList.length > limit) {
      itemList = itemList.take(limit).toList();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            ...itemList.map((item) => _buildRecordItem(item, title)),
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
        return 3;
      case 'Research Papers':
      case 'Experience':
        return 5;
      default:
        return 10;
    }
  }

  Widget _buildRecordItem(Map<String, dynamic> item, String category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item['title'] ?? item['name'] ?? 'Untitled',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              if (item['points'] != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${item['points']} pts',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
            ],
          ),
          if (item['description'] != null) ...[
            const SizedBox(height: 4),
            Text(
              item['description'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
          if (item['date'] != null || item['year'] != null) ...[
            const SizedBox(height: 4),
            Text(
              item['date'] ?? item['year'] ?? '',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      return FileImage(File(imagePath));
    }
  }
}

class _StudentGradesView extends StatefulWidget {
  final String studentId;

  const _StudentGradesView({required this.studentId});

  @override
  State<_StudentGradesView> createState() => _StudentGradesViewState();
}

class _StudentGradesViewState extends State<_StudentGradesView> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? studentData;
  bool isLoading = true;
  String _selectedSemester = '';

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    try {
      final data = await _authService.getStudentData(widget.studentId);
      setState(() {
        studentData = data;
        if (data != null && data['grades'] != null) {
          final gradesRaw = data['grades'];
          if (gradesRaw is Map) {
            final grades = Map<String, dynamic>.from(gradesRaw);
            final sortedSemesters = grades.keys.toList()..sort((a, b) {
              final aNum = int.tryParse(a.replaceAll('sem', '')) ?? 0;
              final bNum = int.tryParse(b.replaceAll('sem', '')) ?? 0;
              return aNum.compareTo(bNum);
            });
            _selectedSemester = sortedSemesters.isNotEmpty ? sortedSemesters.first : '';
          }
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error loading student data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (studentData == null) {
      return const Center(child: Text('Student not found'));
    }

    final gradesRaw = studentData!['grades'];
    Map<String, dynamic> grades = {};
    if (gradesRaw is Map) {
      grades = Map<String, dynamic>.from(gradesRaw);
    }
    final sortedSemesters = grades.keys.toList()..sort((a, b) {
      final aNum = int.tryParse(a.replaceAll('sem', '')) ?? 0;
      final bNum = int.tryParse(b.replaceAll('sem', '')) ?? 0;
      return aNum.compareTo(bNum);
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Academic Performance Header
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.school, size: 32, color: Colors.blue),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Academic Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Student: ${studentData!['name'] ?? 'Unknown'}'),
                        Text('ID: ${studentData!['student_id'] ?? 'N/A'}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Semester Selection
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Semester', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedSemester,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: sortedSemesters.map((semester) {
                      return DropdownMenuItem<String>(
                        value: semester,
                        child: Text(semester),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedSemester = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Grades Display
          if (_selectedSemester.isNotEmpty && grades[_selectedSemester] != null)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Grades for $_selectedSemester', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...(() {
                      final semesterGrades = grades[_selectedSemester];
                      if (semesterGrades is Map) {
                        final semesterGradesMap = Map<String, dynamic>.from(semesterGrades);
                        return semesterGradesMap.entries.map((entry) {
                          final subject = entry.key;
                          final grade = entry.value;
                          final letterGrade = _getLetterGrade(grade);
                          final gradeColor = _getGradeColor(grade);
                          
                          return ListTile(
                            title: Text(subject),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: gradeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: gradeColor),
                              ),
                              child: Text(
                                '$grade ($letterGrade)',
                                style: TextStyle(
                                  color: gradeColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList();
                      }
                      return <Widget>[];
                    })(),
                  ],
                ),
              ),
            )
          else
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No grades available for this semester'),
              ),
            ),
        ],
      ),
    );
  }

  String _getLetterGrade(dynamic grade) {
    if (grade is num) {
      final g = grade.toDouble();
      if (g >= 9.0) return 'A+';
      if (g >= 8.0) return 'A';
      if (g >= 7.0) return 'B+';
      if (g >= 6.0) return 'B';
      if (g >= 5.0) return 'C+';
      if (g >= 4.0) return 'C';
      return 'D';
    }
    return 'N/A';
  }

  Color _getGradeColor(dynamic grade) {
    if (grade is num) {
      final g = grade.toDouble();
      if (g >= 8.0) return Colors.green;
      if (g >= 6.0) return Colors.orange;
      return Colors.red;
    }
    return Colors.grey;
  }
}

class _StudentSemesterInfoView extends StatefulWidget {
  final String studentId;

  const _StudentSemesterInfoView({required this.studentId});

  @override
  State<_StudentSemesterInfoView> createState() => _StudentSemesterInfoViewState();
}

class _StudentSemesterInfoViewState extends State<_StudentSemesterInfoView> with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? studentData;
  bool isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadStudentData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadStudentData() async {
    try {
      final data = await _authService.getStudentData(widget.studentId);
      setState(() {
        studentData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading student data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (studentData == null) {
      return const Center(child: Text('Student not found'));
    }

    final currentSemesterRaw = studentData!['current_semester'] ?? 1;
    final currentSemester = currentSemesterRaw is int
        ? 'sem$currentSemesterRaw'
        : currentSemesterRaw.toString();

    return Column(
      children: [
        // Semester Info Header
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 32, color: Colors.blue),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Semester ${currentSemester.toString().replaceAll('sem', '').toUpperCase()}', 
                           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Student: ${studentData!['name'] ?? 'Unknown'}'),
                      Text('ID: ${studentData!['student_id'] ?? 'N/A'}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Tab Bar
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Courses'),
                  Tab(text: 'Attendance'),
                ],
              ),
              SizedBox(
                height: 400,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCoursesTab(currentSemester),
                    _buildAttendanceTab(currentSemester),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoursesTab(String currentSemester) {
    final coursesRaw = studentData!['courses'];
    final courses = coursesRaw is Map
        ? Map<String, dynamic>.from(coursesRaw)
        : <String, dynamic>{};

    final semesterCoursesRaw = courses[currentSemester];
    final semesterCourses = semesterCoursesRaw is List
        ? List<dynamic>.from(semesterCoursesRaw)
        : <dynamic>[];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: semesterCourses.length,
      itemBuilder: (context, index) {
        final course = semesterCourses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            leading: const Icon(Icons.book, color: Colors.blue),
            title: Text(course.toString()),
            subtitle: Text('Course ${index + 1}'),
          ),
        );
      },
    );
  }

  Widget _buildAttendanceTab(String currentSemester) {
    final coursesRaw = studentData!['courses'];
    final courses = coursesRaw is Map
        ? Map<String, dynamic>.from(coursesRaw)
        : <String, dynamic>{};

    final semesterCoursesRaw = courses[currentSemester];
    final semesterCourses = semesterCoursesRaw is List
        ? List<dynamic>.from(semesterCoursesRaw)
        : <dynamic>[];

    final overallAttendance = studentData!['attendance'] ?? 0.0;

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: semesterCourses.length,
      itemBuilder: (context, index) {
        final course = semesterCourses[index];
        final courseCode = course.toString().split(' - ')[0];
        final attendance = _generateCourseAttendance(courseCode, overallAttendance);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            leading: const Icon(Icons.present_to_all, color: Colors.green),
            title: Text(course.toString()),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$courseCode - ${attendance.toStringAsFixed(1)}%'),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: attendance / 100.0,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    attendance >= 75 ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _generateCourseAttendance(String courseCode, num overallAttendance) {
    final baseAttendance = overallAttendance.toDouble();
    final variation = (courseCode.hashCode % 21) - 10; // -10 to +10
    final courseAttendance = baseAttendance + variation;
    return courseAttendance.clamp(60.0, 100.0);
  }
}
