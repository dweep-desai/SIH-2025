import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/image_utils.dart';

class StudentAnalyticsView extends StatefulWidget {
  final String studentId;

  const StudentAnalyticsView({super.key, required this.studentId});

  @override
  State<StudentAnalyticsView> createState() => _StudentAnalyticsViewState();
}

class _StudentAnalyticsViewState extends State<StudentAnalyticsView> {
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
      return const Center(child: Text('Failed to load student data'));
    }

    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4A90E2).withOpacity(0.1), // Light blue
            const Color(0xFF7ED321).withOpacity(0.05), // Light green
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colors.primaryContainer,
                backgroundImage: studentData!['profile_photo'] != null && studentData!['profile_photo'].toString().isNotEmpty
                    ? _getImageProvider(studentData!['profile_photo'])
                    : null,
                child: studentData!['profile_photo'] == null || studentData!['profile_photo'].toString().isEmpty
                    ? Icon(Icons.person, color: colors.onPrimaryContainer, size: 20)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentData!['name'] ?? 'Unknown Student',
                      style: texts.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Student Analytics',
                      style: texts.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Analytics Cards
          // GPA Card
          _buildAnalyticsCard(
            'Current GPA',
            '${_calculateGPA(studentData!['grades']).toStringAsFixed(2)} / 10.0',
            Colors.blue,
            Icons.school,
          ),
          const SizedBox(height: 16),

          // Attendance Card
          _buildAnalyticsCard(
            'Overall Attendance',
            '${((studentData!['attendance'] as num?)?.toDouble() ?? 0.0).toStringAsFixed(1)}%',
            Colors.green,
            Icons.present_to_all,
          ),
          const SizedBox(height: 16),

          // Semester Card
          _buildAnalyticsCard(
            'Current Semester',
            'Semester ${studentData!['current_semester'] ?? 'N/A'}',
            Colors.orange,
            Icons.calendar_today,
          ),
          const SizedBox(height: 16),

          // Branch Card
          _buildAnalyticsCard(
            'Branch',
            studentData!['branch'] ?? 'N/A',
            Colors.purple,
            Icons.business,
          ),
          const SizedBox(height: 16),

          // Domains Card
          _buildDomainsCard(),
          const SizedBox(height: 16),

          // Student Record Summary
          _buildRecordSummaryCard(),
        ],
      ),
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDomainsCard() {
    final domain1 = studentData!['domain1'];
    final domain2 = studentData!['domain2'];
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.work_outline, color: Colors.teal, size: 24),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Domains',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (domain1 != null && domain1.toString().isNotEmpty)
              Chip(
                label: Text('Domain 1: $domain1'),
                backgroundColor: Colors.teal.withOpacity(0.1),
                labelStyle: const TextStyle(color: Colors.teal, fontWeight: FontWeight.w500),
              ),
            if (domain1 != null && domain1.toString().isNotEmpty && domain2 != null && domain2.toString().isNotEmpty)
              const SizedBox(height: 8),
            if (domain2 != null && domain2.toString().isNotEmpty)
              Chip(
                label: Text('Domain 2: $domain2'),
                backgroundColor: Colors.teal.withOpacity(0.1),
                labelStyle: const TextStyle(color: Colors.teal, fontWeight: FontWeight.w500),
              ),
            if ((domain1 == null || domain1.toString().isEmpty) && (domain2 == null || domain2.toString().isEmpty))
              const Text(
                'No domains set',
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordSummaryCard() {
    final studentRecord = studentData!['student_record'];
    if (studentRecord == null) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No student record data available',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
        ),
      );
    }

    Map<String, dynamic> recordMap = {};
    if (studentRecord is Map) {
      recordMap = Map<String, dynamic>.from(studentRecord);
    }

    final certifications = recordMap['certifications'] as List? ?? [];
    final achievements = recordMap['achievements'] as List? ?? [];
    final projects = recordMap['projects'] as List? ?? [];
    final researchPapers = recordMap['research_papers'] as List? ?? [];
    final experience = recordMap['experience'] as List? ?? [];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.analytics, color: Colors.indigo, size: 24),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Record Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildRecordStat('Certifications', certifications.length, Colors.blue),
                ),
                Expanded(
                  child: _buildRecordStat('Achievements', achievements.length, Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildRecordStat('Projects', projects.length, Colors.orange),
                ),
                Expanded(
                  child: _buildRecordStat('Research Papers', researchPapers.length, Colors.purple),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildRecordStat('Experience', experience.length, Colors.teal),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordStat(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  double _calculateGPA(dynamic grades) {
    if (grades == null) return 0.0;
    
    Map<String, dynamic> gradesMap = {};
    if (grades is Map) {
      gradesMap = Map<String, dynamic>.from(grades);
    }
    
    double totalPoints = 0.0;
    int totalSubjects = 0;
    
    gradesMap.forEach((semester, semesterGrades) {
      if (semesterGrades is Map) {
        final semesterGradesMap = Map<String, dynamic>.from(semesterGrades);
        semesterGradesMap.forEach((subject, grade) {
          if (grade is num) {
            totalPoints += grade.toDouble();
            totalSubjects++;
          }
        });
      }
    });
    
    return totalSubjects > 0 ? totalPoints / totalSubjects : 0.0;
  }

  ImageProvider? _getImageProvider(String? imagePath) {
    return ImageUtils.getImageProvider(imagePath);
  }
}
