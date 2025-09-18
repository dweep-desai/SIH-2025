import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class StudentService {
  StudentService._();
  static final StudentService instance = StudentService._();

  final FirebaseDatabase _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://hackproj-190-default-rtdb.asia-southeast1.firebasedatabase.app',
  );

  Future<Map<String, dynamic>?> getCurrentStudentByEmail() async {
    final String? rawEmail = FirebaseAuth.instance.currentUser?.email;
    final String email = (rawEmail ?? '').trim();
    if (email.isEmpty) return null;
    final DataSnapshot snap = await _db
        .ref('students')
        .orderByChild('email')
        .equalTo(email)
        .get();
    if (!snap.exists || snap.value is! Map) return null;
    final Map data = snap.value as Map;
    if (data.isEmpty) return null;
    final String key = data.keys.first;
    final dynamic value = data[key];
    if (value is Map) {
      final raw = Map<String, dynamic>.from(value);
      // Normalize field names so UI remains unchanged
      final Map<String, dynamic> result = {};
      result.addAll(raw);
      result['studentId'] = key;
      // current_sem -> currentSemester
      if (!result.containsKey('currentSemester') && result.containsKey('current_sem')) {
        result['currentSemester'] = result['current_sem'];
      }
      // faculty_advisor -> facultyAdvisor
      if (!result.containsKey('facultyAdvisor') && result.containsKey('faculty_advisor')) {
        result['facultyAdvisor'] = result['faculty_advisor'];
      }
      // grades_till_previous_sem -> grades
      if (!result.containsKey('grades') && result.containsKey('grades_till_previous_sem')) {
        final dynamic g = result['grades_till_previous_sem'];
        if (g is Map) result['grades'] = Map<String, dynamic>.from(g);
      }
      // domains compatibility (optional)
      if (!result.containsKey('domain') && result.containsKey('domains')) {
        result['domain'] = result['domains'];
      }
      // profile photo compatibility (optional)
      if (!result.containsKey('profile_photo_url') && result.containsKey('photo_url')) {
        result['profile_photo_url'] = result['photo_url'];
      }
      return result;
    }
    return null;
  }

  Stream<Map<String, dynamic>?> getCurrentStudentStream() {
    final String? rawEmail = FirebaseAuth.instance.currentUser?.email;
    final String email = (rawEmail ?? '').trim();
    if (email.isEmpty) {
      return Stream.value(null);
    }
    final Query query = _db.ref('students').orderByChild('email').equalTo(email);
    return query.onValue.map((DatabaseEvent event) {
      final DataSnapshot snap = event.snapshot;
      if (!snap.exists || snap.value is! Map) return null;
      final Map data = snap.value as Map;
      if (data.isEmpty) return null;
      final String key = data.keys.first;
      final dynamic value = data[key];
      if (value is Map) {
        final raw = Map<String, dynamic>.from(value);
        final Map<String, dynamic> result = {};
        result.addAll(raw);
        result['studentId'] = key;
        if (!result.containsKey('currentSemester') && result.containsKey('current_sem')) {
          result['currentSemester'] = result['current_sem'];
        }
        if (!result.containsKey('facultyAdvisor') && result.containsKey('faculty_advisor')) {
          result['facultyAdvisor'] = result['faculty_advisor'];
        }
        if (!result.containsKey('grades') && result.containsKey('grades_till_previous_sem')) {
          final dynamic g = result['grades_till_previous_sem'];
          if (g is Map) result['grades'] = Map<String, dynamic>.from(g);
        }
        if (!result.containsKey('domain') && result.containsKey('domains')) {
          result['domain'] = result['domains'];
        }
        if (!result.containsKey('profile_photo_url') && result.containsKey('photo_url')) {
          result['profile_photo_url'] = result['photo_url'];
        }
        return result;
      }
      return null;
    });
  }

  static double letterToGpa(String letter) {
    switch (letter.trim().toUpperCase()) {
      case 'O':
        return 10.0;
      case 'A+':
        return 9.0;
      case 'A':
        return 8.0;
      case 'B+':
        return 7.0;
      case 'B':
        return 6.0;
      case 'C':
        return 5.0;
      case 'D':
        return 4.0;
      case 'E':
        return 1.0;
      default:
        return 0.0;
    }
  }

  static double computeAverageGpa(Map<String, dynamic>? gradesTillPrevious) {
    if (gradesTillPrevious == null) return 0.0;
    double total = 0.0;
    int count = 0;
    gradesTillPrevious.forEach((_, courses) {
      if (courses is Map) {
        courses.forEach((_, grade) {
          if (grade is String) {
            total += letterToGpa(grade);
            count += 1;
          }
        });
      }
    });
    if (count == 0) return 0.0;
    return total / count;
  }

  Future<List<dynamic>> getAchievements(String studentId) async {
    // Prefer records/achievements, fallback to achievements at root
    DataSnapshot snap = await _db.ref('students/$studentId/records/achievements').get();
    if (!snap.exists) {
      snap = await _db.ref('students/$studentId/achievements').get();
      if (!snap.exists) return [];
    }
    if (snap.value is List) return (snap.value as List).where((e) => e != null).toList();
    if (snap.value is Map) return (snap.value as Map).values.where((e) => e != null).toList();
    return [];
  }

  Future<double> getAttendancePercent(String studentId) async {
    final DataSnapshot snap = await _db.ref('students/$studentId/attendance').get();
    if (!snap.exists) return 0.0;
    final dynamic v = snap.value;
    if (v is num) {
      final double d = v.toDouble();
      return (d > 1.0 ? d / 100.0 : d).clamp(0.0, 1.0);
    }
    if (v is String) {
      final parsed = double.tryParse(v);
      if (parsed != null) return (parsed > 1.0 ? parsed / 100.0 : parsed).clamp(0.0, 1.0);
    }
    return 0.0;
  }

  Future<List<dynamic>> getCoursesForSemester(String studentId, int semester) async {
    final DataSnapshot snap = await _db.ref('students/$studentId/courses/$semester').get();
    if (snap.exists) {
      if (snap.value is List) return (snap.value as List).where((e) => e != null).toList();
      if (snap.value is Map) return (snap.value as Map).values.where((e) => e != null).toList();
    }
    // Try to fetch the courses map and pick the nearest previous semester
    final DataSnapshot allCourses = await _db.ref('students/$studentId/courses').get();
    if (allCourses.exists && allCourses.value is Map) {
      final Map coursesMap = allCourses.value as Map;
      int best = -1;
      for (final key in coursesMap.keys) {
        final int? semInt = int.tryParse(key.toString());
        if (semInt != null && semInt <= semester) {
          if (semInt > best) best = semInt;
        }
      }
      if (best != -1) {
        final dynamic v = coursesMap[best.toString()];
        if (v is List) return v.where((e) => e != null).toList();
        if (v is Map) return (v as Map).values.where((e) => e != null).toList();
      }
    }
    // Fallback: derive courses from grades_till_previous_sem/{semester} in latest.json
    final DataSnapshot gradesSnap = await _db.ref('students/$studentId/grades_till_previous_sem/$semester').get();
    if (gradesSnap.exists && gradesSnap.value is Map) {
      final Map m = gradesSnap.value as Map;
      final List<Map<String, dynamic>> derived = [];
      m.forEach((courseName, letter) {
        derived.add({
          'name': courseName.toString(),
          'grade': letter.toString(),
          'credits': null,
        });
      });
      return derived;
    }
    return const [];
  }

  Future<List<dynamic>> getTopRecords(String studentId, String section, {int limit = 3}) async {
    // section one of: certifications, achievements, experience, research_papers, projects, workshops
    DataSnapshot snap = await _db.ref('students/$studentId/records/$section').get();
    if (!snap.exists) snap = await _db.ref('students/$studentId/$section').get();
    List<dynamic> items = [];
    if (snap.exists) {
      if (snap.value is List) items = (snap.value as List).where((e) => e != null).toList();
      if (snap.value is Map) items = (snap.value as Map).values.where((e) => e != null).toList();
    }
    items.sort((a, b) {
      final pa = (a is Map && a['points'] is num) ? (a['points'] as num).toDouble() : 0.0;
      final pb = (b is Map && b['points'] is num) ? (b['points'] as num).toDouble() : 0.0;
      return pb.compareTo(pa);
    });
    if (items.length > limit) return items.sublist(0, limit);
    return items;
  }

  Future<Map<String, dynamic>?> getFacultyById(String facultyId) async {
    final DataSnapshot snap = await _db.ref('faculty/$facultyId').get();
    if (!snap.exists || snap.value is! Map) return null;
    return Map<String, dynamic>.from(snap.value as Map);
  }

  Future<String?> resolveFacultyAdvisorName(String? advisorField) async {
    if (advisorField == null || advisorField.isEmpty) return null;
    // If already a human-readable name, return as-is
    if (!advisorField.startsWith('F')) return advisorField;
    try {
      final m = await getFacultyById(advisorField);
      if (m == null) return advisorField; // keep id
      final dynamic name = m['name'];
      return name is String ? name : advisorField;
    } catch (_) {
      return advisorField;
    }
  }

  Future<void> requestApproval({
    required String studentId,
    required String studentName,
    required String branch,
    required String category,
    required String itemId,
  }) async {
    // Random faculty from same department
    final DatabaseReference byDeptRef = _db.ref('faculty_by_dept/$branch');
    final DataSnapshot byDeptSnap = await byDeptRef.get();
    if (!byDeptSnap.exists) {
      throw Exception('No faculty found for department: $branch');
    }
    List<String> facultyIds = [];
    if (byDeptSnap.value is Map) {
      final Map m = byDeptSnap.value as Map;
      facultyIds = m.keys.map((e) => e.toString()).toList();
    } else if (byDeptSnap.value is List) {
      facultyIds = (byDeptSnap.value as List)
          .where((e) => e != null)
          .map((e) => e.toString())
          .toList();
    }
    if (facultyIds.isEmpty) {
      throw Exception('No faculty found for department: $branch');
    }
    facultyIds.shuffle();
    final String facultyId = facultyIds.first;

    final DatabaseReference pendingRefFaculty = _db.ref('faculty/$facultyId/approvals/pending').push();
    final String pushId = pendingRefFaculty.key!;
    final Map<String, dynamic> approval = {
      'id': pushId,
      'studentId': studentId,
      'studentName': studentName,
      'branch': branch,
      'category': category,
      'itemId': itemId,
      'timestamp': ServerValue.timestamp,
      'status': 'pending',
      'pointsAssigned': null,
      'reason': null,
    };

    await Future.wait([
      pendingRefFaculty.set(approval),
      _db.ref('students/$studentId/approvals/pending/$pushId').set(approval),
    ]);
  }

  Future<Map<String, String>> getGradesForSemester(String studentId, int semester) async {
    final DataSnapshot snap = await _db.ref('students/$studentId/grades_till_previous_sem/$semester').get();
    if (!snap.exists || snap.value is! Map) return {};
    final Map m = snap.value as Map;
    final Map<String, String> out = {};
    m.forEach((k, v) {
      out[k.toString()] = v.toString();
    });
    return out;
  }
}




