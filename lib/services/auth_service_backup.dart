import 'dart:math';
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

      // Step 1: Authenticate with Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return null;
      }
      
      // Step 2: Find user in Firebase Realtime Database and validate category
      Map<String, dynamic>? userData = await _findUserInFirebaseDatabase(email, category);
      
      if (userData == null) {
        await _auth.signOut(); // Sign out since category validation failed
        return null;
      }

      _currentUser = userData;
      return userData;

    } catch (e) {
      return null;
    }
  }

  // Find user in Firebase Realtime Database by email and validate category
  Future<Map<String, dynamic>?> _findUserInFirebaseDatabase(String email, String expectedCategory) async {
    try {
      
      // Search in all collections
      for (String collectionName in ['students', 'faculty', 'admin']) {
        
        try {
          DataSnapshot snapshot = await _databaseRef.child(collectionName).get();
          
              if (snapshot.exists) {
                Map<dynamic, dynamic> collection = snapshot.value as Map<dynamic, dynamic>;
                
                for (String userId in collection.keys) {
                  Map<String, dynamic> user = Map<String, dynamic>.from(collection[userId] as Map<dynamic, dynamic>);
              
              if (user['email'] == email) {
                
                // Check if category matches
                if (user['category'] == expectedCategory) {
                  
                  // Return user data with proper structure
                  Map<String, dynamic> userData = {
                    'id': userId,
                    'category': user['category'],
                    'name': user['name'],
                    'email': user['email'],
                  };
                  
                  // Debug profile photo fetching
                  if (user['profile_photo'] != null) {
                  }

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
                  return null;
                }
              }
            }
          } else {
          }
        } catch (collectionError) {
          continue; // Try next collection
        }
      }

      return null;
    } catch (e) {
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
    } catch (e) {
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
        final rawData = snapshot.value;
        if (rawData is Map) {
          rawData.forEach((key, value) {
            if (value is Map) {
              students.add({
                'id': key,
                ...Map<String, dynamic>.from(value),
              });
            }
          });
        }
      }
      return students;
    } catch (e) {
      return [];
    }
  }

  // Get all faculty for admin
  Future<List<Map<String, dynamic>>> getAllFaculty() async {
    try {
      DataSnapshot snapshot = await _databaseRef.child('faculty').get();
      final faculty = <Map<String, dynamic>>[];
      
      if (snapshot.exists) {
        final rawData = snapshot.value;
        if (rawData is Map) {
          rawData.forEach((key, value) {
            if (value is Map) {
              faculty.add({
                'id': key,
                ...Map<String, dynamic>.from(value),
              });
            }
          });
        }
      }
      return faculty;
    } catch (e) {
      return [];
    }
  }

  // Get students by branch (for faculty)
  Future<List<Map<String, dynamic>>> getStudentsByBranch(String branch) async {
    List<Map<String, dynamic>> allStudents = await getAllStudents();
    return allStudents.where((student) => student['branch'] == branch).toList();
  }

  Future<Map<String, dynamic>?> getStudentData(String studentId) async {
    try {
      final snapshot = await _databaseRef.child('students').child(studentId).get();
      if (snapshot.exists) {
        final rawData = snapshot.value;
        if (rawData is Map) {
          final data = Map<String, dynamic>.from(rawData);
          return data;
        } else {
          return null;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get faculty by department (for students)
  Future<List<Map<String, dynamic>>> getFacultyByDepartment(String department) async {
    List<Map<String, dynamic>> allFaculty = await getAllFaculty();
    return allFaculty.where((faculty) => faculty['department'] == department).toList();
  }

  // Calculate GPA from grades
  double calculateGPA(Map<String, dynamic> grades) {
    if (grades.isEmpty) {
      return 0.0;
    }
    
    double totalGradePoints = 0;
    int totalCourses = 0;

    try {
      
      for (String semester in grades.keys) {
        try {
          if (grades[semester] is Map) {
            Map<String, dynamic> semesterGrades = Map<String, dynamic>.from(grades[semester] as Map<dynamic, dynamic>);
            
            for (String course in semesterGrades.keys) {
              // Grades are already on 1-10 scale, no conversion needed
              int numericGrade = semesterGrades[course] as int? ?? 0;
              
              
              totalGradePoints += numericGrade;
              totalCourses++;
            }
          }
        } catch (e) {
        }
      }
      
      double gpa = totalCourses > 0 ? totalGradePoints / totalCourses : 0.0;
      return gpa;
    } catch (e) {
      return 0.0;
    }
  }



  // Update user profile photo
  Future<void> updateProfilePhoto(String userId, String category, String photoUrl) async {
    try {
      
      // Fix the database path - use plural form for the collection
      String collectionName = category == 'student' ? 'students' : category;
      
      await _databaseRef.child(collectionName).child(userId).child('profile_photo').set(photoUrl);
      
      
      if (_currentUser != null) {
        _currentUser!['profile_photo'] = photoUrl;
      }
    } catch (e) {
      throw e;
    }
  }

  // Update user domains
  Future<void> updateDomains(String userId, String category, String domain1, String domain2) async {
    try {
      
      // Fix the database path - use plural form for the collection
      String collectionName = category == 'student' ? 'students' : category;
      
      // Check what's currently in Firebase before update
      DataSnapshot beforeSnapshot = await _databaseRef.child(collectionName).child(userId).get();
      if (beforeSnapshot.exists) {
        Map<dynamic, dynamic> beforeData = beforeSnapshot.value as Map<dynamic, dynamic>;
      }
      
      // Update domain1
      await _databaseRef.child(collectionName).child(userId).child('domain1').set(domain1);
      
      // Update domain2
      await _databaseRef.child(collectionName).child(userId).child('domain2').set(domain2);
      
      // Verify the update by reading back immediately
      DataSnapshot snapshot = await _databaseRef.child(collectionName).child(userId).get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      } else {
      }
      
      
      // Update local data
      if (_currentUser != null) {
        _currentUser!['domain1'] = domain1;
        _currentUser!['domain2'] = domain2;
      } else {
      }
      
    } catch (e) {
      throw e;
    }
  }


  // Method to directly check Firebase approval data
  Future<Map<String, dynamic>> debugStudentApprovalData() async {
    try {
      if (_currentUser == null) {
        return {};
      }
      
      String studentId = _currentUser!['id'];
      
      // Check approval_accepted directly
      DataSnapshot acceptedSnapshot = await _databaseRef.child('students').child(studentId).child('approval_accepted').get();
      
      // Check approval_rejected directly
      DataSnapshot rejectedSnapshot = await _databaseRef.child('students').child(studentId).child('approval_rejected').get();
      
      // Check approval_history directly
      DataSnapshot historySnapshot = await _databaseRef.child('students').child(studentId).child('approval_list').get();
      
      return {
        'accepted': acceptedSnapshot.value,
        'rejected': rejectedSnapshot.value,
        'history': historySnapshot.value,
      };
    } catch (e) {
      return {};
    }
  }

  // Get approval history for student
  Future<List<Map<String, dynamic>>> getStudentApprovalHistory() async {
    try {
      if (_currentUser == null) {
        return [];
      }
      
      String studentId = _currentUser!['id'];
      
      List<Map<String, dynamic>> history = [];
      
      // Load approved requests
      DataSnapshot approvedSnapshot = await _databaseRef.child('students').child(studentId).child('approval_accepted').get();
      
      if (approvedSnapshot.exists && approvedSnapshot.value != null) {
        Map<dynamic, dynamic> approvedData = approvedSnapshot.value as Map<dynamic, dynamic>;
        approvedData.forEach((key, value) {
          Map<String, dynamic> requestData = Map<String, dynamic>.from(value as Map<dynamic, dynamic>);
          history.add({
            'id': key,
            'status': requestData['status'] ?? 'approved', // Use the actual status from Firebase
            ...requestData,
          });
        });
      } else {
      }
      
      // Load rejected requests
      DataSnapshot rejectedSnapshot = await _databaseRef.child('students').child(studentId).child('approval_rejected').get();
      
      if (rejectedSnapshot.exists && rejectedSnapshot.value != null) {
        Map<dynamic, dynamic> rejectedData = rejectedSnapshot.value as Map<dynamic, dynamic>;
        rejectedData.forEach((key, value) {
          Map<String, dynamic> requestData = Map<String, dynamic>.from(value as Map<dynamic, dynamic>);
          history.add({
            'id': key,
            'status': requestData['status'] ?? 'rejected', // Use the actual status from Firebase
            ...requestData,
          });
        });
      } else {
      }
      
      // Load pending requests (from approval_list with status 'pending')
      DataSnapshot pendingSnapshot = await _databaseRef.child('students').child(studentId).child('approval_list').get();
      
      if (pendingSnapshot.exists && pendingSnapshot.value != null) {
        Map<dynamic, dynamic> pendingData = pendingSnapshot.value as Map<dynamic, dynamic>;
        int pendingCount = 0;
        pendingData.forEach((key, value) {
          Map<String, dynamic> requestData = Map<String, dynamic>.from(value as Map<dynamic, dynamic>);
          if (requestData['status'] == 'pending') {
            history.add({
              'id': key,
              'status': 'pending',
              ...requestData,
            });
            pendingCount++;
          }
        });
      } else {
      }
      
      return history;
    } catch (e) {
      return [];
    }
  }

  // Get faculty approval list
  Future<List<Map<String, dynamic>>> getFacultyApprovalList() async {
    try {
      if (_currentUser == null || _currentUser!['category'] != 'faculty') {
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
      return [];
    }
  }


  // Refresh current user data from Firebase
  Future<void> refreshCurrentUser() async {
    try {
      if (_currentUser == null) {
        return;
      }
      
      String email = _currentUser!['email'];
      String category = _currentUser!['category'];
      
      
      Map<String, dynamic>? updatedUser = await _findUserInFirebaseDatabase(email, category);
      if (updatedUser != null) {
        
        _currentUser = updatedUser;
      } else {
      }
    } catch (e) {
    }
  }

  // Method to directly read domains from Firebase for debugging
  Future<void> debugReadDomains(String userId, String category) async {
    try {
      
      DataSnapshot snapshot = await _databaseRef.child(category).child(userId).get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      } else {
      }
    } catch (e) {
    }
  }


  // Method to force refresh user data directly from Firebase
  Future<Map<String, dynamic>?> forceRefreshUserData() async {
    try {
      if (_currentUser == null) {
        return null;
      }
      
      String email = _currentUser!['email'];
      String category = _currentUser!['category'];
      
      
      // Get fresh data directly from Firebase
      Map<String, dynamic>? freshUserData = await _findUserInFirebaseDatabase(email, category);
      
      if (freshUserData != null) {
        
        // Debug profile photo in refreshed data
        if (freshUserData['profile_photo'] != null) {
        }
        
        // Update the current user with fresh data
        _currentUser = freshUserData;
        
        return freshUserData;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Method to directly fetch user data by user ID from Firebase
  Future<Map<String, dynamic>?> fetchUserById(String userId, String category) async {
    try {
      
      DataSnapshot snapshot = await _databaseRef.child(category).child(userId).get();
      
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        Map<String, dynamic> userData = Map<String, dynamic>.from(data);
        
        // Add the user ID to the data
        userData['id'] = userId;
        userData['category'] = category;
        
        
        return userData;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Method to fetch domains from the student branch structure
  Future<Map<String, String>> fetchDomainsFromStudentBranch(String userId) async {
    try {
      
      DataSnapshot snapshot = await _databaseRef.child('students').child(userId).get();
      
      Map<String, String> domains = {
        'domain1': '',
        'domain2': '',
      };
      
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        
        // Check for domain1
        if (data.containsKey('domain1')) {
          domains['domain1'] = data['domain1']?.toString() ?? '';
        } else {
        }
        
        // Check for domain2
        if (data.containsKey('domain2')) {
          domains['domain2'] = data['domain2']?.toString() ?? '';
        } else {
        }
        
      } else {
      }
      
      return domains;
    } catch (e) {
      return {'domain1': '', 'domain2': ''};
    }
  }

  // Method to submit approval request (for students)
  Future<void> submitApprovalRequest(Map<String, dynamic> requestData) async {
    try {
      if (_currentUser == null) {
        throw Exception('No current user found');
      }
      
      String requestId = DateTime.now().millisecondsSinceEpoch.toString();
      String studentId = _currentUser!['id'];
      String studentName = _currentUser!['name'];
      String studentBranch = _currentUser!['branch'];
      
      // Add student info to request
      requestData['student_id'] = studentId;
      requestData['student_name'] = studentName;
      requestData['project_name'] = requestData['title'] ?? 'Untitled';
      
      // Find a random faculty member in the same department
      String? assignedFacultyId = await _findRandomFacultyInDepartment(studentBranch);
      
      if (assignedFacultyId == null) {
        throw Exception('No faculty found in the same department');
      }
      
      // Get faculty details for better logging
      DataSnapshot facultySnapshot = await _databaseRef.child('faculty').child(assignedFacultyId).get();
      String facultyName = 'Unknown';
      String facultyDepartment = 'Unknown';
      
      if (facultySnapshot.exists) {
        Map<String, dynamic> facultyData = Map<String, dynamic>.from(facultySnapshot.value as Map<dynamic, dynamic>);
        facultyName = facultyData['name'] ?? 'Unknown';
        facultyDepartment = facultyData['department'] ?? 'Unknown';
      }
      
      print('🎯 🎲 RANDOMLY ASSIGNED FACULTY: $facultyName ($assignedFacultyId)');
      
      // Add to faculty's approval section
      await _databaseRef.child('faculty').child(assignedFacultyId).child('approval_section').child(requestId).set(requestData);
      
      // Verify the addition
      DataSnapshot verifySnapshot = await _databaseRef.child('faculty').child(assignedFacultyId).child('approval_section').get();
      
      // Add to student's approval list
      await _databaseRef.child('students').child(studentId).child('approval_list').child(requestId).set({
        ...requestData,
        'assigned_faculty_id': assignedFacultyId,
        'status': 'pending',
      });
      
    } catch (e) {
      throw e;
    }
  }

  // Method to find a random faculty member in the same department
  Future<String?> _findRandomFacultyInDepartment(String department) async {
    try {
      
      DataSnapshot facultySnapshot = await _databaseRef.child('faculty').get();
      
      if (!facultySnapshot.exists) {
        return null;
      }
      
      Map<dynamic, dynamic> faculty = facultySnapshot.value as Map<dynamic, dynamic>;
      List<String> matchingFaculty = [];
      List<String> allFaculty = [];
      
      
      for (String facultyId in faculty.keys) {
        Map<String, dynamic> facultyData = Map<String, dynamic>.from(faculty[facultyId] as Map<dynamic, dynamic>);
        String facultyDept = facultyData['department'] ?? 'Unknown';
        String facultyName = facultyData['name'] ?? 'Unknown';
        
        allFaculty.add('$facultyId ($facultyName - $facultyDept)');
        
        if (facultyDept == department) {
          matchingFaculty.add(facultyId);
        } else {
        }
      }
      
      
      if (matchingFaculty.isEmpty) {
        return null;
      }
      
      // Return a random faculty member using a more robust random selection
      Random random = Random();
      int randomIndex = random.nextInt(matchingFaculty.length);
      String randomFaculty = matchingFaculty[randomIndex];
      
      // Get faculty details for better logging
      Map<String, dynamic> selectedFacultyData = Map<String, dynamic>.from(faculty[randomFaculty] as Map<dynamic, dynamic>);
      String facultyName = selectedFacultyData['name'] ?? 'Unknown';
      String facultyDepartment = selectedFacultyData['department'] ?? 'Unknown';
      
      return randomFaculty;
    } catch (e) {
      return null;
    }
  }

  // Method to handle approval (for faculty)
  Future<void> handleApprovalRequest(String requestId, bool approved, int points, String reason) async {
    try {
      if (_currentUser == null || _currentUser!['category'] != 'faculty') {
        throw Exception('Only faculty can handle approval requests');
      }
      
      String facultyId = _currentUser!['id'];
      
      // Get the request from approval section
      DataSnapshot requestSnapshot = await _databaseRef.child('faculty').child(facultyId).child('approval_section').child(requestId).get();
      
      if (!requestSnapshot.exists) {
        throw Exception('Request not found');
      }
      
      Map<String, dynamic> requestData = Map<String, dynamic>.from(requestSnapshot.value as Map<dynamic, dynamic>);
      String studentId = requestData['student_id'];
      
      // Create approval history entry
      Map<String, dynamic> approvalHistory = {
        ...requestData,
        'status': approved ? 'accepted' : 'rejected',
        'points_awarded': approved ? points : 0,
        'reason': approved ? '' : reason,
        'faculty_id': facultyId,
        'approved_at': DateTime.now().toIso8601String(),
      };
      
      // Add to faculty's approval history
      await _databaseRef.child('faculty').child(facultyId).child('approval_history').child(requestId).set(approvalHistory);
      
      // Add to student's approval history
      await _databaseRef.child('students').child(studentId).child('approval_list').child(requestId).set(approvalHistory);
      
      // Update student's approval status sections
      if (approved) {
        // Add to student's approval_accepted section
        await _databaseRef.child('students').child(studentId).child('approval_accepted').child(requestId).set(approvalHistory);
      } else {
        // Add to student's approval_rejected section
        await _databaseRef.child('students').child(studentId).child('approval_rejected').child(requestId).set(approvalHistory);
      }
      
      // Remove from student's approval_list since it's now processed
      await _databaseRef.child('students').child(studentId).child('approval_list').child(requestId).remove();
      
      // Remove from faculty's approval section
      await _databaseRef.child('faculty').child(facultyId).child('approval_section').child(requestId).remove();
      
      // Update faculty analytics
      await _updateFacultyAnalytics(facultyId, approved, points);
      
    } catch (e) {
      throw e;
    }
  }

  // Method to update faculty analytics
  Future<void> _updateFacultyAnalytics(String facultyId, bool approved, int points) async {
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
      
      // Calculate average points awarded
      if (approved && points > 0) {
        int currentTotalPoints = (analytics['total_points_awarded'] ?? 0) + points;
        analytics['total_points_awarded'] = currentTotalPoints;
        analytics['avg_points_awarded'] = (analytics['total_approved'] ?? 0) > 0 
            ? currentTotalPoints / (analytics['total_approved'] ?? 1) 
            : 0.0;
      }
      
      await _databaseRef.child('faculty').child(facultyId).child('approval_analytics').set(analytics);
    } catch (e) {
    }
  }

}
