import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LocalDataService {
  LocalDataService._();
  static final LocalDataService instance = LocalDataService._();

  Map<String, dynamic>? _cache;

  Future<Map<String, dynamic>> _load() async {
    if (_cache != null) return _cache!;
    final String jsonStr = await rootBundle.loadString('database/latest_with_courses.json');
    final Map<String, dynamic> data = json.decode(jsonStr) as Map<String, dynamic>;
    _cache = data;
    return data;
  }

  Future<Map<String, dynamic>?> getStudentById(String studentId) async {
    final Map<String, dynamic> data = await _load();
    final dynamic students = data['students'];
    if (students is Map) {
      final dynamic v = students[studentId];
      if (v is Map) return Map<String, dynamic>.from(v);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getStudentByEmail(String email) async {
    final Map<String, dynamic> data = await _load();
    final dynamic students = data['students'];
    if (students is Map) {
      for (final entry in students.entries) {
        final dynamic v = entry.value;
        if (v is Map) {
          final dynamic em = v['email'];
          if (em is String && em.toLowerCase().trim() == email.toLowerCase().trim()) {
            return Map<String, dynamic>.from(v);
          }
        }
      }
    }
    return null;
  }

  Future<List<dynamic>> getCoursesForSemester(String studentId, int semester) async {
    final Map<String, dynamic>? student = await getStudentById(studentId);
    if (student == null) return const [];
    final dynamic coursesMap = student['courses'];
    if (coursesMap is Map) {
      // Exact match first
      final dynamic semCourses = coursesMap[semester.toString()];
      if (semCourses is List) {
        return semCourses.where((e) => e != null).toList();
      }
      // Fallback: choose nearest previous semester available
      int best = -1;
      for (final key in coursesMap.keys) {
        final int? semInt = int.tryParse(key.toString());
        if (semInt != null && semInt <= semester) {
          if (semInt > best) best = semInt;
        }
      }
      if (best != -1) {
        final dynamic v = coursesMap[best.toString()];
        if (v is List) {
          return v.where((e) => e != null).toList();
        }
      }
    }
    return const [];
  }
}


