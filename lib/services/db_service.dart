import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

enum AppUserRole { student, faculty, admin, unknown }

class RealtimeDbService {
  RealtimeDbService._();
  static final RealtimeDbService instance = RealtimeDbService._();

  final FirebaseDatabase _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://hackproj-190-default-rtdb.asia-southeast1.firebasedatabase.app',
  );

  Future<AppUserRole> getUserRoleByEmail(String email) async {
    final String trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) return AppUserRole.unknown;
    // Try students
    final DataSnapshot studentSnap = await _db
        .ref('students')
        .orderByChild('email')
        .equalTo(trimmedEmail)
        .get();
    if (studentSnap.exists && (studentSnap.value is Map)) {
      return AppUserRole.student;
    }

    // Try faculty
    final DataSnapshot facultySnap = await _db
        .ref('faculty')
        .orderByChild('email')
        .equalTo(trimmedEmail)
        .get();
    if (facultySnap.exists && (facultySnap.value is Map)) {
      return AppUserRole.faculty;
    }

    // Optional: admins node if present
    try {
      final DataSnapshot adminSnap = await _db
          .ref('admins')
          .orderByChild('email')
          .equalTo(trimmedEmail)
          .get();
      if (adminSnap.exists && (adminSnap.value is Map)) {
        return AppUserRole.admin;
      }
    } catch (_) {
      // ignore if admins path not present
    }

    return AppUserRole.unknown;
  }
}




