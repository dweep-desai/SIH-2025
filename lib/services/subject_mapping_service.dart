import 'package:flutter/services.dart';
import 'dart:convert';

class SubjectMappingService {
  static final SubjectMappingService _instance = SubjectMappingService._internal();
  factory SubjectMappingService() => _instance;
  SubjectMappingService._internal();

  Map<String, String> _subjectMapping = {};

  // Initialize the subject mapping from the database
  Future<void> initializeMapping() async {
    try {
      // Load the database file to extract subject mappings
      final String jsonString = await rootBundle.loadString('assets/database/database_fixed.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      
      _subjectMapping.clear();
      
      // Extract subject mappings from all students' courses
      if (data['students'] != null) {
        Map<String, dynamic> students = data['students'];
        
        for (String studentId in students.keys) {
          Map<String, dynamic> student = students[studentId];
          
          if (student['courses'] != null) {
            Map<String, dynamic> courses = student['courses'];
            
            // Process each semester's courses
            for (String semesterKey in courses.keys) {
              List<dynamic> semesterCourses = courses[semesterKey] as List<dynamic>;
              
              for (String courseString in semesterCourses) {
                // Parse course string format: "CS101 - Programming Fundamentals"
                if (courseString.contains(' - ')) {
                  List<String> parts = courseString.split(' - ');
                  if (parts.length >= 2) {
                    String courseCode = parts[0].trim();
                    String courseName = parts[1].trim();
                    _subjectMapping[courseCode] = courseName;
                  }
                }
              }
            }
          }
        }
      }
      
      print('✅ Subject mapping initialized with ${_subjectMapping.length} subjects');
      print('✅ Sample mappings: ${_subjectMapping.entries.take(5).toList()}');
      
    } catch (e) {
      print('❌ Error initializing subject mapping: $e');
      // Fallback to empty mapping
      _subjectMapping = {};
    }
  }

  // Get subject name from course code
  String getSubjectName(String courseCode) {
    return _subjectMapping[courseCode] ?? courseCode;
  }

  // Get subject code from course name (reverse lookup)
  String getSubjectCode(String courseName) {
    for (String code in _subjectMapping.keys) {
      if (_subjectMapping[code] == courseName) {
        return code;
      }
    }
    return courseName;
  }

  // Get all available subjects
  Map<String, String> getAllSubjects() {
    return Map.from(_subjectMapping);
  }

  // Check if subject mapping is initialized
  bool isInitialized() {
    return _subjectMapping.isNotEmpty;
  }

  // Get subject info (both code and name)
  Map<String, String> getSubjectInfo(String courseCode) {
    return {
      'code': courseCode,
      'name': getSubjectName(courseCode),
    };
  }
}
