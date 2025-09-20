import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/faculty_drawer.dart' as faculty_drawer;
import '../widgets/student_drawer.dart' as student_drawer;
import '../widgets/admin_drawer.dart';
import '../services/auth_service.dart';

class FacultyStudentSearchPage extends StatefulWidget {
  const FacultyStudentSearchPage({super.key});

  @override
  State<FacultyStudentSearchPage> createState() => _FacultyStudentSearchPageState();
}

class _FacultyStudentSearchPageState extends State<FacultyStudentSearchPage> {
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
      drawer: _getAppropriateDrawer(context),
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

  Widget _getAppropriateDrawer(BuildContext context) {
    final userCategory = _authService.getUserCategory();
    switch (userCategory) {
      case 'student':
        return student_drawer.MainDrawer(context: context);
      case 'faculty':
        return faculty_drawer.MainDrawer(context: context);
      case 'admin':
        return AdminDrawer(context: context);
      default:
        return faculty_drawer.MainDrawer(context: context);
    }
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
          Row(
            children: [
              Expanded(child: _buildBranchFilter()),
              const SizedBox(width: 8),
              Expanded(child: _buildDomainFilter()),
              const SizedBox(width: 8),
              Expanded(child: _buildSortFilter()),
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
          child: Text(branch),
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
    final domains = ['All'];
    for (var student in _allStudents) {
      final domain1 = student['domain1'] as String?;
      final domain2 = student['domain2'] as String?;
      if (domain1 != null && domain1.isNotEmpty) domains.add(domain1);
      if (domain2 != null && domain2.isNotEmpty) domains.add(domain2);
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
      items: ['Name', 'Branch'].map((String sort) {
        return DropdownMenuItem<String>(
          value: sort,
          child: Text(sort),
        );
      }).toList(),
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
      itemCount: _filteredStudents.length,
      itemBuilder: (context, index) {
        final student = _filteredStudents[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                (student['name'] as String? ?? 'N')[0].toUpperCase(),
                style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(student['name'] ?? 'Unknown'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${student['student_id'] ?? 'N/A'}'),
                Text('Branch: ${student['branch'] ?? 'N/A'}'),
                Text('Semester: ${student['current_semester'] ?? 'N/A'}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () => _showStudentQuickView(student),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Student Dashboard'),
                      onTap: () => _openStudentDetail(student, 'dashboard'),
                    ),
                    PopupMenuItem(
                      child: const Text('Student Record'),
                      onTap: () => _openStudentDetail(student, 'record'),
                    ),
                    PopupMenuItem(
                      child: const Text('View Grades'),
                      onTap: () => _openStudentDetail(student, 'grades'),
                    ),
                    PopupMenuItem(
                      child: const Text('Semester Info'),
                      onTap: () => _openStudentDetail(student, 'semester'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showStudentQuickView(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(student['name'] ?? 'Unknown'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Student ID: ${student['student_id'] ?? 'N/A'}'),
            Text('Branch: ${student['branch'] ?? 'N/A'}'),
            Text('Current Semester: ${student['current_semester'] ?? 'N/A'}'),
            Text('Attendance: ${student['attendance'] ?? 'N/A'}%'),
            Text('Email: ${student['email'] ?? 'N/A'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _openStudentDetail(Map<String, dynamic> student, String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _getDetailTitle(type, student['name'] ?? 'Unknown'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: _buildDetailContent(type, student['student_id']),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDetailTitle(String type, String studentName) {
    switch (type) {
      case 'dashboard':
        return 'Student Dashboard - $studentName';
      case 'record':
        return 'Student Record - $studentName';
      case 'grades':
        return 'Student Grades - $studentName';
      case 'semester':
        return 'Semester Info - $studentName';
      default:
        return 'Student Details - $studentName';
    }
  }

  Widget _buildDetailContent(String type, String? studentId) {
    switch (type) {
      case 'dashboard':
        return _StudentDashboardView(studentId: studentId);
      case 'record':
        return _StudentRecordView(studentId ?? '');
      case 'grades':
        return _StudentGradesView(studentId ?? '');
      case 'semester':
        return _StudentSemesterInfoView(studentId ?? '');
      default:
        return const Center(child: Text('Unknown detail type'));
    }
  }

  Widget _StudentRecordView(String studentId) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _authService.getStudentData(studentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Student data not found'));
        }

        final studentData = snapshot.data!;
        final studentRecordRaw = studentData['student_record'];
        final studentRecord = studentRecordRaw is Map 
          ? Map<String, dynamic>.from(studentRecordRaw) 
          : <String, dynamic>{};
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student Record Header
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade600, Colors.blue.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: _getImageProvider(studentData['profile_photo']),
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: _getImageProvider(studentData['profile_photo']) == null
                          ? const Icon(Icons.person, size: 40, color: Colors.white)
                          : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        studentData['name'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        studentData['student_id'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (studentData['domain1'] != null || studentData['domain2'] != null)
                        Wrap(
                          spacing: 8,
                          children: [
                            if (studentData['domain1'] != null)
                              Chip(
                                label: Text(studentData['domain1']),
                                backgroundColor: Colors.white.withOpacity(0.2),
                                labelStyle: const TextStyle(color: Colors.white),
                              ),
                            if (studentData['domain2'] != null)
                              Chip(
                                label: Text(studentData['domain2']),
                                backgroundColor: Colors.white.withOpacity(0.2),
                                labelStyle: const TextStyle(color: Colors.white),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Record sections
              _buildRecordSection('Certifications', studentRecord['certifications']),
              _buildRecordSection('Achievements', studentRecord['achievements']),
              _buildRecordSection('Projects', studentRecord['projects']),
              _buildRecordSection('Research Papers', studentRecord['research_papers']),
              _buildRecordSection('Experience', studentRecord['experience']),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecordSection(String title, dynamic items) {
    if (items == null) return const SizedBox.shrink();
    
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
    
    if (itemList.isEmpty) return const SizedBox.shrink();
    
    // Apply sorting and limits
    if (['Certifications', 'Achievements', 'Projects', 'Workshops'].contains(title)) {
      itemList.sort((a, b) => (b['points'] ?? 0).compareTo(a['points'] ?? 0));
      itemList = itemList.take(3).toList();
    } else if (title == 'Research Papers') {
      itemList.sort((a, b) => (b['points'] ?? 0).compareTo(a['points'] ?? 0));
      itemList = itemList.take(5).toList();
    } else if (title == 'Experience') {
      itemList = itemList.take(5).toList();
    }
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text('${itemList.length} item${itemList.length != 1 ? 's' : ''}'),
        children: itemList.map((item) {
          return ListTile(
            title: Text(item['title'] ?? 'No Title'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['description'] != null)
                  Text(item['description']),
                if (item['points'] != null)
                  Text('Points: ${item['points']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            trailing: item['points'] != null 
              ? Chip(
                  label: Text('${item['points']}'),
                  backgroundColor: Colors.green.shade100,
                )
              : null,
          );
        }).toList(),
      ),
    );
  }

  Widget _StudentGradesView(String studentId) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _authService.getStudentData(studentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Student data not found'));
        }

        final studentData = snapshot.data!;
        final gradesRaw = studentData['grades'];
        final grades = gradesRaw is Map 
          ? Map<String, dynamic>.from(gradesRaw) 
          : <String, dynamic>{};
        
        return StatefulBuilder(
          builder: (context, setState) {
            String selectedSemester = grades.keys.isNotEmpty ? grades.keys.first : '';
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Academic Performance Header
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.green.shade600, Colors.green.shade800],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(Icons.school, size: 48, color: Colors.white),
                          const SizedBox(height: 16),
                          const Text(
                            'Academic Performance',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            studentData['name'] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Semester Selector
                  if (grades.isNotEmpty) ...[
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DropdownButtonFormField<String>(
                          value: selectedSemester,
                          decoration: const InputDecoration(
                            labelText: 'Select Semester',
                            border: OutlineInputBorder(),
                          ),
                          items: grades.keys.map((semester) {
                            return DropdownMenuItem<String>(
                              value: semester,
                              child: Text(semester),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedSemester = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Grades Display
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Grades for $selectedSemester',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (grades[selectedSemester] != null)
                              ...((grades[selectedSemester] as Map).entries.map((entry) {
                                final subjectCode = entry.key;
                                final grade = entry.value;
                                final subjectName = _getSubjectName(subjectCode);
                                final letterGrade = _getLetterGrade(grade);
                                final gradeColor = _getGradeColor(grade);
                                
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: gradeColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: gradeColor.withOpacity(0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              subjectName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              subjectCode,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '$grade/10',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: gradeColor,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: gradeColor,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            letterGrade,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList()),
                          ],
                        ),
                      ),
                    ),
                  ] else
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No grades available'),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getSubjectName(String subjectCode) {
    final subjectMap = {
      'CS101': 'Computer Science Fundamentals',
      'CS102': 'Programming Principles',
      'CS201': 'Data Structures',
      'CS202': 'Algorithms',
      'CS301': 'Database Systems',
      'CS302': 'Software Engineering',
      'CS401': 'Machine Learning',
      'CS402': 'Artificial Intelligence',
      'ME101': 'Engineering Mechanics',
      'ME102': 'Thermodynamics',
      'ME201': 'Fluid Mechanics',
      'ME202': 'Heat Transfer',
      'ME301': 'Machine Design',
      'ME302': 'Manufacturing Processes',
      'ME401': 'Control Systems',
      'ME402': 'Robotics',
    };
    return subjectMap[subjectCode] ?? subjectCode;
  }

  String _getLetterGrade(dynamic grade) {
    if (grade == null) return 'N/A';
    final numGrade = grade is num ? grade.toDouble() : double.tryParse(grade.toString()) ?? 0.0;
    
    if (numGrade >= 9.0) return 'A+';
    if (numGrade >= 8.0) return 'A';
    if (numGrade >= 7.0) return 'B+';
    if (numGrade >= 6.0) return 'B';
    if (numGrade >= 5.0) return 'C+';
    if (numGrade >= 4.0) return 'C';
    return 'F';
  }

  Color _getGradeColor(dynamic grade) {
    if (grade == null) return Colors.grey;
    final numGrade = grade is num ? grade.toDouble() : double.tryParse(grade.toString()) ?? 0.0;
    
    if (numGrade >= 9.0) return Colors.green.shade700;
    if (numGrade >= 8.0) return Colors.green;
    if (numGrade >= 7.0) return Colors.lightGreen;
    if (numGrade >= 6.0) return Colors.orange;
    if (numGrade >= 5.0) return Colors.orange.shade700;
    if (numGrade >= 4.0) return Colors.red.shade300;
    return Colors.red;
  }

  Widget _StudentSemesterInfoView(String studentId) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _authService.getStudentData(studentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Student data not found'));
        }

        final studentData = snapshot.data!;
        final currentSemester = studentData['current_semester'] ?? 'sem1';
        final coursesRaw = studentData['courses'];
        final courses = coursesRaw is Map 
          ? Map<String, dynamic>.from(coursesRaw) 
          : <String, dynamic>{};
        final semesterCoursesRaw = courses[currentSemester];
        final semesterCourses = semesterCoursesRaw is List 
          ? List<dynamic>.from(semesterCoursesRaw) 
          : <dynamic>[];
        
        return DefaultTabController(
          length: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Semester Info Header
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [Colors.purple.shade600, Colors.purple.shade800],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.calendar_today, size: 48, color: Colors.white),
                        const SizedBox(height: 16),
                        const Text(
                          'Semester Information',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentSemester.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Tab Bar
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          indicator: BoxDecoration(
                            color: Colors.purple.shade600,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey.shade600,
                          tabs: const [
                            Tab(
                              icon: Icon(Icons.book),
                              text: 'Courses',
                            ),
                            Tab(
                              icon: Icon(Icons.check_circle_outline),
                              text: 'Attendance',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          children: [
                            // Courses Tab
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: semesterCourses.isNotEmpty
                                ? ListView.builder(
                                    itemCount: semesterCourses.length,
                                    itemBuilder: (context, index) {
                                      final courseCode = semesterCourses[index].toString();
                                      final courseName = _getSubjectName(courseCode);
                                      
                                      return Card(
                                        elevation: 1,
                                        margin: const EdgeInsets.only(bottom: 8),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.purple.shade100,
                                            child: Text(
                                              (index + 1).toString(),
                                              style: TextStyle(
                                                color: Colors.purple.shade800,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            courseName,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(courseCode),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text('No courses available for this semester'),
                                  ),
                            ),
                            
                            // Attendance Tab
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: semesterCourses.isNotEmpty
                                ? ListView.builder(
                                    itemCount: semesterCourses.length,
                                    itemBuilder: (context, index) {
                                      final courseCode = semesterCourses[index].toString();
                                      final courseName = _getSubjectName(courseCode);
                                      final attendance = _generateCourseAttendance(
                                        courseCode,
                                        studentData['attendance'] as num? ?? 85,
                                      );
                                      
                                      return Card(
                                        elevation: 1,
                                        margin: const EdgeInsets.only(bottom: 8),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: attendance >= 75 
                                              ? Colors.green.shade100 
                                              : Colors.red.shade100,
                                            child: Text(
                                              '${attendance.round()}%',
                                              style: TextStyle(
                                                color: attendance >= 75 
                                                  ? Colors.green.shade800 
                                                  : Colors.red.shade800,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            courseName,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text('$courseCode - ${attendance.toStringAsFixed(1)}%'),
                                          trailing: LinearProgressIndicator(
                                            value: attendance / 100,
                                            backgroundColor: Colors.grey.shade300,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              attendance >= 75 ? Colors.green : Colors.red,
                                            ),
                                            minHeight: 6,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text('No attendance data available'),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

  ImageProvider? _getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else if (imagePath.startsWith('/data/')) {
      return FileImage(File(imagePath));
    }
    return null;
  }
}
class _StudentDashboardView extends StatefulWidget {
  final String? studentId;

  const _StudentDashboardView({required this.studentId});

  @override
  State<_StudentDashboardView> createState() => _StudentDashboardViewState();
}

class _StudentDashboardViewState extends State<_StudentDashboardView> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _studentData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    if (widget.studentId == null) return;
    
    try {
      final studentData = await _authService.getStudentData(widget.studentId!);
      setState(() {
        _studentData = studentData;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading student data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_studentData == null) {
      return const Center(child: Text('Student data not found'));
    }

    return _buildStudentDashboardContent(_studentData!);
  }

  Widget _buildStudentDashboardContent(Map<String, dynamic> studentData) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    
    // Calculate GPA from grades
    double gpa = _calculateGPA(studentData);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student Profile Card
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
                    backgroundImage: _getImageProvider(studentData['profile_photo'] as String?),
                    child: studentData['profile_photo'] == null || studentData['profile_photo'].toString().isEmpty
                        ? Icon(Icons.person, color: colors.onPrimaryContainer, size: 28)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(studentData['name'] ?? 'Unknown', style: texts.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Student ID: ${studentData['student_id'] ?? 'N/A'}', style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                        Text('Branch: ${studentData['branch'] ?? 'N/A'}', style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                        Text('Current Semester: ${studentData['current_semester'] ?? 'N/A'}', style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Current Semester Card
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
                      Text('Current Semester: ${studentData['current_semester'] ?? 'N/A'}', style: texts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('GPA: ${gpa.toStringAsFixed(2)} / 10', style: texts.bodyLarge),
                      Icon(Icons.trending_up, color: Colors.green.shade600),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: gpa / 10.0,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Attendance Card
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
                      Icon(Icons.check_circle_outline, color: colors.primary),
                      const SizedBox(width: 8),
                      Text('Attendance Overview', style: texts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Overall: ${studentData['attendance'] ?? 'N/A'}%', style: texts.bodyLarge),
                      Icon(Icons.present_to_all, color: Colors.blue.shade600),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: ((studentData['attendance'] as num?)?.toDouble() ?? 0.0) / 100.0,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateGPA(Map<String, dynamic> studentData) {
    final gradesRaw = studentData['grades'];
    final grades = gradesRaw is Map 
      ? Map<String, dynamic>.from(gradesRaw) 
      : <String, dynamic>{};
    if (grades.isEmpty) return 0.0;
    
    double totalGrade = 0.0;
    int totalSubjects = 0;
    
    grades.forEach((semester, semesterGrades) {
      if (semesterGrades is Map<String, dynamic>) {
        semesterGrades.forEach((subject, grade) {
          if (grade is num) {
            totalGrade += grade.toDouble();
            totalSubjects++;
          }
        });
      }
    });
    
    return totalSubjects > 0 ? totalGrade / totalSubjects : 0.0;
  }

  ImageProvider? _getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else if (imagePath.startsWith('/data/')) {
      return FileImage(File(imagePath));
    }
    return null;
  }

  Widget _StudentRecordView(String studentId) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _authService.getStudentData(studentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Student data not found'));
        }

        final studentData = snapshot.data!;
        final studentRecordRaw = studentData['student_record'];
        final studentRecord = studentRecordRaw is Map 
          ? Map<String, dynamic>.from(studentRecordRaw) 
          : <String, dynamic>{};
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student Record Header
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade600, Colors.blue.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: _getImageProvider(studentData['profile_photo']),
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: _getImageProvider(studentData['profile_photo']) == null
                          ? const Icon(Icons.person, size: 40, color: Colors.white)
                          : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        studentData['name'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        studentData['student_id'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (studentData['domain1'] != null || studentData['domain2'] != null)
                        Wrap(
                          spacing: 8,
                          children: [
                            if (studentData['domain1'] != null)
                              Chip(
                                label: Text(studentData['domain1']),
                                backgroundColor: Colors.white.withOpacity(0.2),
                                labelStyle: const TextStyle(color: Colors.white),
                              ),
                            if (studentData['domain2'] != null)
                              Chip(
                                label: Text(studentData['domain2']),
                                backgroundColor: Colors.white.withOpacity(0.2),
                                labelStyle: const TextStyle(color: Colors.white),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Record sections
              _buildRecordSection('Certifications', studentRecord['certifications']),
              _buildRecordSection('Achievements', studentRecord['achievements']),
              _buildRecordSection('Projects', studentRecord['projects']),
              _buildRecordSection('Research Papers', studentRecord['research_papers']),
              _buildRecordSection('Experience', studentRecord['experience']),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecordSection(String title, dynamic items) {
    if (items == null) return const SizedBox.shrink();
    
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
    
    if (itemList.isEmpty) return const SizedBox.shrink();
    
    // Apply sorting and limits
    if (['Certifications', 'Achievements', 'Projects', 'Workshops'].contains(title)) {
      itemList.sort((a, b) => (b['points'] ?? 0).compareTo(a['points'] ?? 0));
      itemList = itemList.take(3).toList();
    } else if (title == 'Research Papers') {
      itemList.sort((a, b) => (b['points'] ?? 0).compareTo(a['points'] ?? 0));
      itemList = itemList.take(5).toList();
    } else if (title == 'Experience') {
      itemList = itemList.take(5).toList();
    }
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text('${itemList.length} item${itemList.length != 1 ? 's' : ''}'),
        children: itemList.map((item) {
          return ListTile(
            title: Text(item['title'] ?? 'No Title'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['description'] != null)
                  Text(item['description']),
                if (item['points'] != null)
                  Text('Points: ${item['points']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            trailing: item['points'] != null 
              ? Chip(
                  label: Text('${item['points']}'),
                  backgroundColor: Colors.green.shade100,
                )
              : null,
          );
        }).toList(),
      ),
    );
  }

  Widget _StudentGradesView(String studentId) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _authService.getStudentData(studentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Student data not found'));
        }

        final studentData = snapshot.data!;
        final gradesRaw = studentData['grades'];
        final grades = gradesRaw is Map 
          ? Map<String, dynamic>.from(gradesRaw) 
          : <String, dynamic>{};
        
        return StatefulBuilder(
          builder: (context, setState) {
            String selectedSemester = grades.keys.isNotEmpty ? grades.keys.first : '';
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Academic Performance Header
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.green.shade600, Colors.green.shade800],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(Icons.school, size: 48, color: Colors.white),
                          const SizedBox(height: 16),
                          const Text(
                            'Academic Performance',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            studentData['name'] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Semester Selector
                  if (grades.isNotEmpty) ...[
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DropdownButtonFormField<String>(
                          value: selectedSemester,
                          decoration: const InputDecoration(
                            labelText: 'Select Semester',
                            border: OutlineInputBorder(),
                          ),
                          items: grades.keys.map((semester) {
                            return DropdownMenuItem<String>(
                              value: semester,
                              child: Text(semester),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedSemester = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Grades Display
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Grades for $selectedSemester',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (grades[selectedSemester] != null)
                              ...((grades[selectedSemester] as Map).entries.map((entry) {
                                final subjectCode = entry.key;
                                final grade = entry.value;
                                final subjectName = _getSubjectName(subjectCode);
                                final letterGrade = _getLetterGrade(grade);
                                final gradeColor = _getGradeColor(grade);
                                
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: gradeColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: gradeColor.withOpacity(0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              subjectName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              subjectCode,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '$grade/10',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: gradeColor,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: gradeColor,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            letterGrade,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList()),
                          ],
                        ),
                      ),
                    ),
                  ] else
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No grades available'),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getSubjectName(String subjectCode) {
    final subjectMap = {
      'CS101': 'Computer Science Fundamentals',
      'CS102': 'Programming Principles',
      'CS201': 'Data Structures',
      'CS202': 'Algorithms',
      'CS301': 'Database Systems',
      'CS302': 'Software Engineering',
      'CS401': 'Machine Learning',
      'CS402': 'Artificial Intelligence',
      'ME101': 'Engineering Mechanics',
      'ME102': 'Thermodynamics',
      'ME201': 'Fluid Mechanics',
      'ME202': 'Heat Transfer',
      'ME301': 'Machine Design',
      'ME302': 'Manufacturing Processes',
      'ME401': 'Control Systems',
      'ME402': 'Robotics',
    };
    return subjectMap[subjectCode] ?? subjectCode;
  }

  String _getLetterGrade(dynamic grade) {
    if (grade == null) return 'N/A';
    final numGrade = grade is num ? grade.toDouble() : double.tryParse(grade.toString()) ?? 0.0;
    
    if (numGrade >= 9.0) return 'A+';
    if (numGrade >= 8.0) return 'A';
    if (numGrade >= 7.0) return 'B+';
    if (numGrade >= 6.0) return 'B';
    if (numGrade >= 5.0) return 'C+';
    if (numGrade >= 4.0) return 'C';
    return 'F';
  }

  Color _getGradeColor(dynamic grade) {
    if (grade == null) return Colors.grey;
    final numGrade = grade is num ? grade.toDouble() : double.tryParse(grade.toString()) ?? 0.0;
    
    if (numGrade >= 9.0) return Colors.green.shade700;
    if (numGrade >= 8.0) return Colors.green;
    if (numGrade >= 7.0) return Colors.lightGreen;
    if (numGrade >= 6.0) return Colors.orange;
    if (numGrade >= 5.0) return Colors.orange.shade700;
    if (numGrade >= 4.0) return Colors.red.shade300;
    return Colors.red;
  }

  Widget _StudentSemesterInfoView(String studentId) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _authService.getStudentData(studentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Student data not found'));
        }

        final studentData = snapshot.data!;
        final currentSemester = studentData['current_semester'] ?? 'sem1';
        final coursesRaw = studentData['courses'];
        final courses = coursesRaw is Map 
          ? Map<String, dynamic>.from(coursesRaw) 
          : <String, dynamic>{};
        final semesterCoursesRaw = courses[currentSemester];
        final semesterCourses = semesterCoursesRaw is List 
          ? List<dynamic>.from(semesterCoursesRaw) 
          : <dynamic>[];
        
        return DefaultTabController(
          length: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Semester Info Header
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [Colors.purple.shade600, Colors.purple.shade800],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.calendar_today, size: 48, color: Colors.white),
                        const SizedBox(height: 16),
                        const Text(
                          'Semester Information',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentSemester.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Tab Bar
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          indicator: BoxDecoration(
                            color: Colors.purple.shade600,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey.shade600,
                          tabs: const [
                            Tab(
                              icon: Icon(Icons.book),
                              text: 'Courses',
                            ),
                            Tab(
                              icon: Icon(Icons.check_circle_outline),
                              text: 'Attendance',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          children: [
                            // Courses Tab
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: semesterCourses.isNotEmpty
                                ? ListView.builder(
                                    itemCount: semesterCourses.length,
                                    itemBuilder: (context, index) {
                                      final courseCode = semesterCourses[index].toString();
                                      final courseName = _getSubjectName(courseCode);
                                      
                                      return Card(
                                        elevation: 1,
                                        margin: const EdgeInsets.only(bottom: 8),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.purple.shade100,
                                            child: Text(
                                              (index + 1).toString(),
                                              style: TextStyle(
                                                color: Colors.purple.shade800,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            courseName,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(courseCode),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text('No courses available for this semester'),
                                  ),
                            ),
                            
                            // Attendance Tab
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: semesterCourses.isNotEmpty
                                ? ListView.builder(
                                    itemCount: semesterCourses.length,
                                    itemBuilder: (context, index) {
                                      final courseCode = semesterCourses[index].toString();
                                      final courseName = _getSubjectName(courseCode);
                                      final attendance = _generateCourseAttendance(
                                        courseCode,
                                        studentData['attendance'] as num? ?? 85,
                                      );
                                      
                                      return Card(
                                        elevation: 1,
                                        margin: const EdgeInsets.only(bottom: 8),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: attendance >= 75 
                                              ? Colors.green.shade100 
                                              : Colors.red.shade100,
                                            child: Text(
                                              '${attendance.round()}%',
                                              style: TextStyle(
                                                color: attendance >= 75 
                                                  ? Colors.green.shade800 
                                                  : Colors.red.shade800,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            courseName,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text('$courseCode - ${attendance.toStringAsFixed(1)}%'),
                                          trailing: LinearProgressIndicator(
                                            value: attendance / 100,
                                            backgroundColor: Colors.grey.shade300,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              attendance >= 75 ? Colors.green : Colors.red,
                                            ),
                                            minHeight: 6,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text('No attendance data available'),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
