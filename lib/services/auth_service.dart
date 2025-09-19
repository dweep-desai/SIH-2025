import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();
  Map<String, dynamic>? _currentUser;

  // Authenticate user with Firebase Auth and validate category from Firebase Realtime Database
  Future<Map<String, dynamic>?> authenticateUser(String email, String password, String category) async {
    try {
      print('🔍 Attempting Firebase Auth for: $email');
      print('🔍 Expected category: $category');

      // Step 1: Authenticate with Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        print('❌ Firebase authentication failed');
        return null;
      }

      print('✅ Firebase authentication successful');
      
      // Step 2: Find user in Firebase Realtime Database and validate category
      Map<String, dynamic>? userData = await _findUserInFirebaseDatabase(email, category);
      
      if (userData == null) {
        print('❌ User not found in Firebase database or category mismatch');
        await _auth.signOut(); // Sign out since category validation failed
        return null;
      }

      print('✅ Category validation successful: ${userData['category']}');
      _currentUser = userData;
      return userData;

    } catch (e) {
      print('❌ Authentication error: $e');
      return null;
    }
  }

  // Find user in Firebase Realtime Database by email and validate category
  Future<Map<String, dynamic>?> _findUserInFirebaseDatabase(String email, String expectedCategory) async {
    try {
      print('🔍 Searching Firebase database for email: $email');
      print('🔍 Database reference: ${_databaseRef.path}');
      
      // Search in all collections
      for (String collectionName in ['students', 'faculty', 'admin']) {
        print('🔍 Searching in collection: $collectionName');
        
        try {
          DataSnapshot snapshot = await _databaseRef.child(collectionName).get();
          print('🔍 Snapshot exists: ${snapshot.exists}');
          
              if (snapshot.exists) {
                Map<dynamic, dynamic> collection = snapshot.value as Map<dynamic, dynamic>;
                print('🔍 Collection has ${collection.length} entries');
                
                for (String userId in collection.keys) {
                  Map<String, dynamic> user = Map<String, dynamic>.from(collection[userId] as Map<dynamic, dynamic>);
                  print('🔍 Checking user: ${user['email']}');
              
              if (user['email'] == email) {
                print('✅ Found user in $collectionName collection');
                
                // Check if category matches
                if (user['category'] == expectedCategory) {
                  print('✅ Category matches: ${user['category']}');
                  
                  // Return user data with proper structure
                  Map<String, dynamic> userData = {
                    'id': userId,
                    'category': user['category'],
                    'name': user['name'],
                    'email': user['email'],
                  };

                          // Add category-specific fields
                          if (user['category'] == 'student') {
                            userData.addAll({
                              'branch': user['branch'],
                              'student_id': user['student_id'],
                              'university': user['university'],
                              'institute': user['institute'],
                              'attendance': user['attendance'],
                              'current_semester': user['current_semester'],
                              'start_year': user['start_year'],
                              'graduate_year': user['graduate_year'],
                              'courses': user['courses'] != null ? Map<String, dynamic>.from(user['courses'] as Map<dynamic, dynamic>) : {},
                              'grades': user['grades'] != null ? Map<String, dynamic>.from(user['grades'] as Map<dynamic, dynamic>) : {},
                              'student_record': user['student_record'] != null ? Map<String, dynamic>.from(user['student_record'] as Map<dynamic, dynamic>) : {},
                              'faculty_advisor': user['faculty_advisor'],
                              'profile_photo': user['profile_photo'] ?? '',
                              'domain1': user['domain1'] ?? '',
                              'domain2': user['domain2'] ?? '',
                              'approval_history': user['approval_history'] ?? [],
                            });
                  } else if (user['category'] == 'faculty') {
                    userData.addAll({
                      'department': user['department'],
                      'faculty_id': user['faculty_id'],
                      'designation': user['designation'],
                      'educational_qualifications': user['educational_qualifications'],
                      'faculty_record': user['faculty_record'] != null ? Map<String, dynamic>.from(user['faculty_record'] as Map<dynamic, dynamic>) : {},
                      'papers_publications': user['papers_publications'] ?? [],
                      'student_research': user['student_research'] ?? [],
                      'approval_list': user['approval_list'] ?? [],
                      'approval_history': user['approval_history'] ?? [],
                      'approval_analytics': user['approval_analytics'] != null ? Map<String, dynamic>.from(user['approval_analytics'] as Map<dynamic, dynamic>) : {},
                      'profile_photo': user['profile_photo'] ?? '',
                    });
                  } else if (user['category'] == 'admin') {
                    userData.addAll({
                      'admin_id': user['admin_id'],
                      'profile_photo': user['profile_photo'] ?? '',
                    });
                  }

                  return userData;
                } else {
                  print('❌ Category mismatch. Expected: $expectedCategory, Found: ${user['category']}');
                  return null;
                }
              }
            }
          } else {
            print('🔍 Collection $collectionName is empty or doesn\'t exist');
          }
        } catch (collectionError) {
          print('❌ Error accessing collection $collectionName: $collectionError');
          continue; // Try next collection
        }
      }

      print('❌ User not found in Firebase database');
      return null;
    } catch (e) {
      print('❌ Error searching Firebase database: $e');
      print('❌ Error type: ${e.runtimeType}');
      return null;
    }
  }

  // Get current user
  Map<String, dynamic>? getCurrentUser() {
    return _currentUser;
  }

  // Logout user from both Firebase and local session
  Future<void> logout() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      print('✅ Logged out successfully');
    } catch (e) {
      print('❌ Error during logout: $e');
      _currentUser = null; // Clear local session even if Firebase logout fails
    }
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return _currentUser != null;
  }

  // Get user category
  String? getUserCategory() {
    return _currentUser?['category'];
  }

  // Get user branch/department
  String? getUserBranch() {
    if (_currentUser?['category'] == 'student') {
      return _currentUser?['branch'];
    } else if (_currentUser?['category'] == 'faculty') {
      return _currentUser?['department'];
    }
    return null;
  }

  // Get user name
  String? getUserName() {
    return _currentUser?['name'];
  }

  // Get user email
  String? getUserEmail() {
    return _currentUser?['email'];
  }

  // Get all students for faculty/admin
  Future<List<Map<String, dynamic>>> getAllStudents() async {
    try {
      DataSnapshot snapshot = await _databaseRef.child('students').get();
      final students = <Map<String, dynamic>>[];
      
      if (snapshot.exists) {
        Map<dynamic, dynamic> studentsData = snapshot.value as Map<dynamic, dynamic>;
        studentsData.forEach((key, value) {
          students.add({
            'id': key,
            ...Map<String, dynamic>.from(value as Map<dynamic, dynamic>),
          });
        });
      }
      return students;
    } catch (e) {
      print('❌ Error getting all students: $e');
      return [];
    }
  }

  // Get all faculty for admin
  Future<List<Map<String, dynamic>>> getAllFaculty() async {
    try {
      DataSnapshot snapshot = await _databaseRef.child('faculty').get();
      final faculty = <Map<String, dynamic>>[];
      
      if (snapshot.exists) {
        Map<dynamic, dynamic> facultyData = snapshot.value as Map<dynamic, dynamic>;
        facultyData.forEach((key, value) {
          faculty.add({
            'id': key,
            ...Map<String, dynamic>.from(value as Map<dynamic, dynamic>),
          });
        });
      }
      return faculty;
    } catch (e) {
      print('❌ Error getting all faculty: $e');
      return [];
    }
  }

  // Get students by branch (for faculty)
  Future<List<Map<String, dynamic>>> getStudentsByBranch(String branch) async {
    List<Map<String, dynamic>> allStudents = await getAllStudents();
    return allStudents.where((student) => student['branch'] == branch).toList();
  }

  // Get faculty by department (for students)
  Future<List<Map<String, dynamic>>> getFacultyByDepartment(String department) async {
    List<Map<String, dynamic>> allFaculty = await getAllFaculty();
    return allFaculty.where((faculty) => faculty['department'] == department).toList();
  }

  // Calculate GPA from grades
  double calculateGPA(Map<String, dynamic> grades) {
    if (grades.isEmpty) {
      print('❌ No grades data available for GPA calculation');
      return 0.0;
    }
    
    double totalPoints = 0;
    int totalCredits = 0;

    try {
      print('🔍 Calculating GPA from grades: $grades');
      
      for (String semester in grades.keys) {
        try {
          if (grades[semester] is Map) {
            Map<String, dynamic> semesterGrades = Map<String, dynamic>.from(grades[semester] as Map<dynamic, dynamic>);
            print('🔍 Processing semester $semester: $semesterGrades');
            
            for (String course in semesterGrades.keys) {
              // Convert numeric grade (1-10) to points
              int numericGrade = semesterGrades[course] as int? ?? 0;
              int points = _getNumericGradePoints(numericGrade);
              int credits = 3; // Assuming 3 credits per course, adjust as needed
              
              print('🔍 Course $course: Grade $numericGrade -> Points $points');
              
              totalPoints += points * credits;
              totalCredits += credits;
            }
          }
        } catch (e) {
          print('❌ Error processing semester $semester: $e');
        }
      }
      
      double gpa = totalCredits > 0 ? totalPoints / totalCredits : 0.0;
      print('✅ GPA calculated: $gpa (Total Points: $totalPoints, Total Credits: $totalCredits)');
      return gpa;
    } catch (e) {
      print('❌ Error calculating GPA: $e');
      return 0.0;
    }
  }


  // Convert numeric grade (1-10) to points for GPA calculation
  int _getNumericGradePoints(int numericGrade) {
    if (numericGrade >= 9) return 10; // A+
    if (numericGrade >= 8) return 9;  // A
    if (numericGrade >= 7) return 8;  // B+
    if (numericGrade >= 6) return 7;  // B
    if (numericGrade >= 5) return 6;  // C+
    if (numericGrade >= 4) return 5;  // C
    if (numericGrade >= 3) return 4;  // D
    if (numericGrade >= 2) return 3;  // E
    return 1; // F
  }

  // Update user profile photo
  Future<void> updateProfilePhoto(String userId, String category, String photoUrl) async {
    try {
      await _databaseRef.child(category).child(userId).child('profile_photo').set(photoUrl);
      if (_currentUser != null) {
        _currentUser!['profile_photo'] = photoUrl;
      }
      print('✅ Profile photo updated successfully');
    } catch (e) {
      print('❌ Error updating profile photo: $e');
      throw e;
    }
  }

  // Update user domains
  Future<void> updateDomains(String userId, String category, String domain1, String domain2) async {
    try {
      print('🔄 Updating domains - userId: $userId, category: $category');
      print('🔄 Domain1: "$domain1", Domain2: "$domain2"');
      
      await _databaseRef.child(category).child(userId).child('domain1').set(domain1);
      await _databaseRef.child(category).child(userId).child('domain2').set(domain2);
      
      print('✅ Domains saved to Firebase successfully');
      
      if (_currentUser != null) {
        _currentUser!['domain1'] = domain1;
        _currentUser!['domain2'] = domain2;
        print('✅ Local _currentUser updated - domain1: ${_currentUser!['domain1']}, domain2: ${_currentUser!['domain2']}');
      } else {
        print('❌ _currentUser is null, cannot update local data');
      }
      
      print('✅ Domains updated successfully');
    } catch (e) {
      print('❌ Error updating domains: $e');
      throw e;
    }
  }

  // Submit approval request
  Future<void> submitApprovalRequest(Map<String, dynamic> requestData) async {
    try {
      String requestId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Add to student's approval history
      String studentId = _currentUser!['id'];
      await _databaseRef.child('students').child(studentId).child('approval_history').child(requestId).set(requestData);
      
      // Find faculty in same department and add to their approval list
      DataSnapshot facultySnapshot = await _databaseRef.child('faculty').get();
      if (facultySnapshot.exists) {
        Map<dynamic, dynamic> faculty = facultySnapshot.value as Map<dynamic, dynamic>;
        
        for (String facultyId in faculty.keys) {
          Map<String, dynamic> facultyData = Map<String, dynamic>.from(faculty[facultyId]);
          if (facultyData['department'] == _currentUser!['branch']) {
            await _databaseRef.child('faculty').child(facultyId).child('approval_list').child(requestId).set({
              ...requestData,
              'student_id': studentId,
              'student_name': _currentUser!['name'],
              'status': 'pending',
            });
            break; // Add to first faculty found in same department
          }
        }
      }
      
      print('✅ Approval request submitted successfully');
    } catch (e) {
      print('❌ Error submitting approval request: $e');
      throw e;
    }
  }

  // Get approval history for student
  Future<List<Map<String, dynamic>>> getStudentApprovalHistory() async {
    try {
      if (_currentUser == null) {
        print('❌ No current user found');
        return [];
      }
      
      String studentId = _currentUser!['id'];
      DataSnapshot snapshot = await _databaseRef.child('students').child(studentId).child('approval_history').get();
      
      List<Map<String, dynamic>> history = [];
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          history.add({
            'id': key,
            ...Map<String, dynamic>.from(value as Map<dynamic, dynamic>),
          });
        });
      }
      
      return history;
    } catch (e) {
      print('❌ Error getting approval history: $e');
      return [];
    }
  }

  // Get faculty approval list
  Future<List<Map<String, dynamic>>> getFacultyApprovalList() async {
    try {
      if (_currentUser == null || _currentUser!['category'] != 'faculty') {
        print('❌ No faculty user found');
        return [];
      }
      
      String facultyId = _currentUser!['id'];
      DataSnapshot snapshot = await _databaseRef.child('faculty').child(facultyId).child('approval_list').get();
      
      List<Map<String, dynamic>> approvalList = [];
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          approvalList.add({
            'id': key,
            ...Map<String, dynamic>.from(value as Map<dynamic, dynamic>),
          });
        });
      }
      
      return approvalList;
    } catch (e) {
      print('❌ Error getting faculty approval list: $e');
      return [];
    }
  }

  // Approve or reject a request
  Future<void> handleApprovalRequest(String requestId, bool approved, int points, String comment) async {
    try {
      if (_currentUser == null || _currentUser!['category'] != 'faculty') {
        throw Exception('Only faculty can handle approval requests');
      }
      
      String facultyId = _currentUser!['id'];
      String facultyName = _currentUser!['name'];
      
      // Get the request details
      DataSnapshot requestSnapshot = await _databaseRef.child('faculty').child(facultyId).child('approval_list').child(requestId).get();
      
      if (!requestSnapshot.exists) {
        throw Exception('Request not found');
      }
      
      Map<String, dynamic> requestData = Map<String, dynamic>.from(requestSnapshot.value as Map<dynamic, dynamic>);
      String studentId = requestData['student_id'];
      
      // Update request status
      Map<String, dynamic> updatedRequest = {
        ...requestData,
        'status': approved ? 'approved' : 'rejected',
        'points_awarded': approved ? points : 0,
        'faculty_comment': comment,
        'approved_by': facultyName,
        'approved_at': DateTime.now().toIso8601String(),
      };
      
      // Move to approval history
      await _databaseRef.child('faculty').child(facultyId).child('approval_history').child(requestId).set(updatedRequest);
      
      // Remove from approval list
      await _databaseRef.child('faculty').child(facultyId).child('approval_list').child(requestId).remove();
      
      // Update student's approval history
      await _databaseRef.child('students').child(studentId).child('approval_history').child(requestId).set(updatedRequest);
      
      // Update faculty analytics
      await _updateFacultyAnalytics(facultyId, approved);
      
      print('✅ Approval request handled successfully');
    } catch (e) {
      print('❌ Error handling approval request: $e');
      throw e;
    }
  }

  // Update faculty approval analytics
  Future<void> _updateFacultyAnalytics(String facultyId, bool approved) async {
    try {
      DataSnapshot analyticsSnapshot = await _databaseRef.child('faculty').child(facultyId).child('approval_analytics').get();
      
      Map<String, dynamic> analytics = analyticsSnapshot.exists 
          ? Map<String, dynamic>.from(analyticsSnapshot.value as Map<dynamic, dynamic>)
          : {
              'total_approved': 0,
              'total_rejected': 0,
              'approval_rate': 0.0,
              'avg_points_awarded': 0.0,
            };
      
      if (approved) {
        analytics['total_approved'] = (analytics['total_approved'] ?? 0) + 1;
      } else {
        analytics['total_rejected'] = (analytics['total_rejected'] ?? 0) + 1;
      }
      
      int total = (analytics['total_approved'] ?? 0) + (analytics['total_rejected'] ?? 0);
      analytics['approval_rate'] = total > 0 ? (analytics['total_approved'] ?? 0) / total : 0.0;
      
      await _databaseRef.child('faculty').child(facultyId).child('approval_analytics').set(analytics);
    } catch (e) {
      print('❌ Error updating faculty analytics: $e');
    }
  }

  // Refresh current user data from Firebase
  Future<void> refreshCurrentUser() async {
    try {
      if (_currentUser == null) {
        print('❌ _currentUser is null, cannot refresh');
        return;
      }
      
      String email = _currentUser!['email'];
      String category = _currentUser!['category'];
      
      print('🔄 Refreshing user data for: $email, category: $category');
      
      Map<String, dynamic>? updatedUser = await _findUserInFirebaseDatabase(email, category);
      if (updatedUser != null) {
        print('✅ Fresh data from Firebase - domain1: "${updatedUser['domain1']}", domain2: "${updatedUser['domain2']}"');
        _currentUser = updatedUser;
        print('✅ User data refreshed successfully');
      } else {
        print('❌ Failed to get updated user data from Firebase');
      }
    } catch (e) {
      print('❌ Error refreshing user data: $e');
    }
  }
}
