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
                  
                  // Debug profile photo fetching
                  print('🖼️ ==========================================');
                  print('🖼️ AUTH SERVICE PROFILE PHOTO DEBUG');
                  print('🖼️ ==========================================');
                  print('🖼️ User ID: $userId');
                  print('🖼️ Collection: $collectionName');
                  print('🖼️ Raw profile_photo from Firebase: ${user['profile_photo']}');
                  print('🖼️ Profile photo type: ${user['profile_photo'].runtimeType}');
                  print('🖼️ Profile photo isNull: ${user['profile_photo'] == null}');
                  if (user['profile_photo'] != null) {
                    print('🖼️ Profile photo value: "${user['profile_photo']}"');
                    print('🖼️ Profile photo length: ${user['profile_photo'].toString().length}');
                    print('🖼️ Profile photo isEmpty: ${user['profile_photo'].toString().isEmpty}');
                  }
                  print('🖼️ ==========================================');

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

  Future<Map<String, dynamic>?> getStudentData(String studentId) async {
    try {
      final snapshot = await _databaseRef.child('students').child(studentId).get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        return data;
      }
      return null;
    } catch (e) {
      print('Error getting student data: $e');
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
      print('❌ No grades data available for GPA calculation');
      return 0.0;
    }
    
    double totalGradePoints = 0;
    int totalCourses = 0;

    try {
      print('🔍 Calculating GPA from grades: $grades');
      
      for (String semester in grades.keys) {
        try {
          if (grades[semester] is Map) {
            Map<String, dynamic> semesterGrades = Map<String, dynamic>.from(grades[semester] as Map<dynamic, dynamic>);
            print('🔍 Processing semester $semester: $semesterGrades');
            
            for (String course in semesterGrades.keys) {
              // Grades are already on 1-10 scale, no conversion needed
              int numericGrade = semesterGrades[course] as int? ?? 0;
              
              print('🔍 Course $course: Grade $numericGrade');
              
              totalGradePoints += numericGrade;
              totalCourses++;
            }
          }
        } catch (e) {
          print('❌ Error processing semester $semester: $e');
        }
      }
      
      double gpa = totalCourses > 0 ? totalGradePoints / totalCourses : 0.0;
      print('✅ GPA calculated: $gpa (Total Grade Points: $totalGradePoints, Total Courses: $totalCourses)');
      return gpa;
    } catch (e) {
      print('❌ Error calculating GPA: $e');
      return 0.0;
    }
  }



  // Update user profile photo
  Future<void> updateProfilePhoto(String userId, String category, String photoUrl) async {
    try {
      print('🖼️ ==========================================');
      print('🖼️ AUTH SERVICE UPDATE PROFILE PHOTO DEBUG');
      print('🖼️ ==========================================');
      print('🖼️ User ID: $userId');
      print('🖼️ Category: $category');
      print('🖼️ Photo URL: "$photoUrl"');
      
      // Fix the database path - use plural form for the collection
      String collectionName = category == 'student' ? 'students' : category;
      print('🖼️ Collection Name: $collectionName');
      print('🖼️ Database Path: ${_databaseRef.child(collectionName).child(userId).child('profile_photo').path}');
      print('🖼️ ==========================================');
      
      await _databaseRef.child(collectionName).child(userId).child('profile_photo').set(photoUrl);
      
      print('🖼️ ==========================================');
      print('🖼️ PROFILE PHOTO SAVED TO DATABASE');
      print('🖼️ ==========================================');
      
      if (_currentUser != null) {
        _currentUser!['profile_photo'] = photoUrl;
        print('🖼️ Updated local _currentUser profile_photo');
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
      print('🔄 Database URL: https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app');
      print('🔄 Full path: ${_databaseRef.child(category).child(userId).path}');
      
      // Check what's currently in Firebase before update
      print('🔄 Checking current Firebase data before update...');
      DataSnapshot beforeSnapshot = await _databaseRef.child(category).child(userId).get();
      if (beforeSnapshot.exists) {
        Map<dynamic, dynamic> beforeData = beforeSnapshot.value as Map<dynamic, dynamic>;
        print('🔍 Before update - domain1: "${beforeData['domain1']}", domain2: "${beforeData['domain2']}"');
        print('🔍 Before update - all keys: ${beforeData.keys.toList()}');
      }
      
      // Update domain1
      print('🔄 Setting domain1...');
      await _databaseRef.child(category).child(userId).child('domain1').set(domain1);
      print('✅ Domain1 set successfully');
      
      // Update domain2
      print('🔄 Setting domain2...');
      await _databaseRef.child(category).child(userId).child('domain2').set(domain2);
      print('✅ Domain2 set successfully');
      
      // Verify the update by reading back immediately
      print('🔄 Verifying update by reading back immediately...');
      DataSnapshot snapshot = await _databaseRef.child(category).child(userId).get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        print('✅ Immediate verification - domain1: "${data['domain1']}", domain2: "${data['domain2']}"');
        print('✅ Domain1 type: ${data['domain1'].runtimeType}');
        print('✅ Domain2 type: ${data['domain2'].runtimeType}');
        print('✅ Domain1 isEmpty: ${data['domain1'].toString().isEmpty}');
        print('✅ Domain2 isEmpty: ${data['domain2'].toString().isEmpty}');
        print('✅ All keys after update: ${data.keys.toList()}');
      } else {
        print('❌ Verification failed - no data found at path');
      }
      
      
      // Update local data
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
      print('❌ Error type: ${e.runtimeType}');
      print('❌ Error details: ${e.toString()}');
      throw e;
    }
  }


  // Method to directly check Firebase approval data
  Future<Map<String, dynamic>> debugStudentApprovalData() async {
    try {
      if (_currentUser == null) {
        print('❌ No current user found');
        return {};
      }
      
      String studentId = _currentUser!['id'];
      print('🔍 ==========================================');
      print('🔍 DIRECT FIREBASE CHECK FOR STUDENT: $studentId');
      print('🔍 ==========================================');
      
      // Check approval_accepted directly
      DataSnapshot acceptedSnapshot = await _databaseRef.child('students').child(studentId).child('approval_accepted').get();
      print('🔍 approval_accepted exists: ${acceptedSnapshot.exists}');
      print('🔍 approval_accepted value: ${acceptedSnapshot.value}');
      
      // Check approval_rejected directly
      DataSnapshot rejectedSnapshot = await _databaseRef.child('students').child(studentId).child('approval_rejected').get();
      print('🔍 approval_rejected exists: ${rejectedSnapshot.exists}');
      print('🔍 approval_rejected value: ${rejectedSnapshot.value}');
      
      // Check approval_history directly
      DataSnapshot historySnapshot = await _databaseRef.child('students').child(studentId).child('approval_list').get();
      print('🔍 approval_list exists: ${historySnapshot.exists}');
      print('🔍 approval_list value: ${historySnapshot.value}');
      
      return {
        'accepted': acceptedSnapshot.value,
        'rejected': rejectedSnapshot.value,
        'history': historySnapshot.value,
      };
    } catch (e) {
      print('❌ Error checking Firebase data: $e');
      return {};
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
      print('🔍 Loading approval history for student: $studentId');
      
      List<Map<String, dynamic>> history = [];
      
      // Load approved requests
      DataSnapshot approvedSnapshot = await _databaseRef.child('students').child(studentId).child('approval_accepted').get();
      print('🔍 Raw approval_accepted data: ${approvedSnapshot.value}');
      print('🔍 Approval_accepted exists: ${approvedSnapshot.exists}');
      
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
        print('🔍 Loaded ${approvedData.length} approved requests');
      } else {
        print('🔍 No approved requests found');
      }
      
      // Load rejected requests
      DataSnapshot rejectedSnapshot = await _databaseRef.child('students').child(studentId).child('approval_rejected').get();
      print('🔍 Raw approval_rejected data: ${rejectedSnapshot.value}');
      print('🔍 Approval_rejected exists: ${rejectedSnapshot.exists}');
      
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
        print('🔍 Loaded ${rejectedData.length} rejected requests');
      } else {
        print('🔍 No rejected requests found');
      }
      
      // Load pending requests (from approval_list with status 'pending')
      DataSnapshot pendingSnapshot = await _databaseRef.child('students').child(studentId).child('approval_list').get();
      print('🔍 Raw approval_list data: ${pendingSnapshot.value}');
      print('🔍 Approval_list exists: ${pendingSnapshot.exists}');
      
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
        print('🔍 Loaded $pendingCount pending requests from approval_list');
      } else {
        print('🔍 No pending requests found');
      }
      
      print('🔍 Total history loaded: ${history.length} requests');
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
      print('🔄 Current domains before refresh - domain1: "${_currentUser!['domain1']}", domain2: "${_currentUser!['domain2']}"');
      
      Map<String, dynamic>? updatedUser = await _findUserInFirebaseDatabase(email, category);
      if (updatedUser != null) {
        print('✅ Fresh data from Firebase - domain1: "${updatedUser['domain1']}", domain2: "${updatedUser['domain2']}"');
        print('✅ Domain1 type: ${updatedUser['domain1'].runtimeType}');
        print('✅ Domain2 type: ${updatedUser['domain2'].runtimeType}');
        print('✅ Domain1 isEmpty: ${updatedUser['domain1'].toString().isEmpty}');
        print('✅ Domain2 isEmpty: ${updatedUser['domain2'].toString().isEmpty}');
        
        _currentUser = updatedUser;
        print('✅ User data refreshed successfully');
      } else {
        print('❌ Failed to get updated user data from Firebase');
      }
    } catch (e) {
      print('❌ Error refreshing user data: $e');
    }
  }

  // Method to directly read domains from Firebase for debugging
  Future<void> debugReadDomains(String userId, String category) async {
    try {
      print('🔍 Debug: Reading domains directly from Firebase...');
      print('🔍 Path: $category/$userId');
      
      DataSnapshot snapshot = await _databaseRef.child(category).child(userId).get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        print('🔍 Raw data: $data');
        print('🔍 Domain1: "${data['domain1']}" (type: ${data['domain1'].runtimeType})');
        print('🔍 Domain2: "${data['domain2']}" (type: ${data['domain2'].runtimeType})');
      } else {
        print('❌ No data found at path: $category/$userId');
      }
    } catch (e) {
      print('❌ Error reading domains: $e');
    }
  }


  // Method to force refresh user data directly from Firebase
  Future<Map<String, dynamic>?> forceRefreshUserData() async {
    try {
      if (_currentUser == null) {
        print('❌ _currentUser is null, cannot force refresh');
        return null;
      }
      
      String email = _currentUser!['email'];
      String category = _currentUser!['category'];
      
      print('🔄 Force refreshing user data directly from Firebase...');
      print('🔄 Email: $email, Category: $category');
      
      // Get fresh data directly from Firebase
      Map<String, dynamic>? freshUserData = await _findUserInFirebaseDatabase(email, category);
      
      if (freshUserData != null) {
        print('✅ Fresh user data retrieved from Firebase');
        print('✅ Fresh domains - domain1: "${freshUserData['domain1']}", domain2: "${freshUserData['domain2']}"');
        
        // Debug profile photo in refreshed data
        print('🖼️ ==========================================');
        print('🖼️ FORCE REFRESH PROFILE PHOTO DEBUG');
        print('🖼️ ==========================================');
        print('🖼️ Refreshed profile_photo: ${freshUserData['profile_photo']}');
        print('🖼️ Profile photo type: ${freshUserData['profile_photo'].runtimeType}');
        print('🖼️ Profile photo isNull: ${freshUserData['profile_photo'] == null}');
        if (freshUserData['profile_photo'] != null) {
          print('🖼️ Profile photo value: "${freshUserData['profile_photo']}"');
          print('🖼️ Profile photo length: ${freshUserData['profile_photo'].toString().length}');
        }
        print('🖼️ ==========================================');
        
        // Update the current user with fresh data
        _currentUser = freshUserData;
        
        return freshUserData;
      } else {
        print('❌ Failed to get fresh user data from Firebase');
        return null;
      }
    } catch (e) {
      print('❌ Error force refreshing user data: $e');
      return null;
    }
  }

  // Method to directly fetch user data by user ID from Firebase
  Future<Map<String, dynamic>?> fetchUserById(String userId, String category) async {
    try {
      print('🔄 Fetching user data by ID: $userId, Category: $category');
      
      DataSnapshot snapshot = await _databaseRef.child(category).child(userId).get();
      
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        Map<String, dynamic> userData = Map<String, dynamic>.from(data);
        
        // Add the user ID to the data
        userData['id'] = userId;
        userData['category'] = category;
        
        print('✅ User data fetched by ID');
        print('✅ Domains - domain1: "${userData['domain1']}", domain2: "${userData['domain2']}"');
        print('✅ Domain1 type: ${userData['domain1'].runtimeType}');
        print('✅ Domain2 type: ${userData['domain2'].runtimeType}');
        print('✅ Domain1 isEmpty: ${userData['domain1'].toString().isEmpty}');
        print('✅ Domain2 isEmpty: ${userData['domain2'].toString().isEmpty}');
        
        return userData;
      } else {
        print('❌ No user found with ID: $userId in category: $category');
        return null;
      }
    } catch (e) {
      print('❌ Error fetching user by ID: $e');
      return null;
    }
  }

  // Method to fetch domains from the student branch structure
  Future<Map<String, String>> fetchDomainsFromStudentBranch(String userId) async {
    try {
      print('🔄 Fetching domains from student branch for user: $userId');
      print('🔄 Path: student/$userId');
      
      DataSnapshot snapshot = await _databaseRef.child('student').child(userId).get();
      
      Map<String, String> domains = {
        'domain1': '',
        'domain2': '',
      };
      
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        
        // Check for domain1
        if (data.containsKey('domain1')) {
          domains['domain1'] = data['domain1']?.toString() ?? '';
          print('✅ Domain1 found: "${domains['domain1']}"');
        } else {
          print('❌ Domain1 not found in student branch');
        }
        
        // Check for domain2
        if (data.containsKey('domain2')) {
          domains['domain2'] = data['domain2']?.toString() ?? '';
          print('✅ Domain2 found: "${domains['domain2']}"');
        } else {
          print('❌ Domain2 not found in student branch');
        }
        
        print('✅ Domains fetched from student branch: $domains');
      } else {
        print('❌ No data found in student branch for user: $userId');
      }
      
      return domains;
    } catch (e) {
      print('❌ Error fetching domains from student branch: $e');
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
      
      print('🎯 ==========================================');
      print('🎯 ASSIGNING APPROVAL REQUEST TO FACULTY');
      print('🎯 ==========================================');
      print('🎯 Student: $studentName ($studentId)');
      print('🎯 Student Department: $studentBranch');
      print('🎯 🎲 RANDOMLY ASSIGNED FACULTY: $facultyName ($assignedFacultyId)');
      print('🎯 Faculty Department: $facultyDepartment');
      print('🎯 Department Match: ${facultyDepartment == studentBranch ? "✅ YES" : "❌ NO"}');
      print('🎯 Request ID: $requestId');
      print('🎯 Request Title: ${requestData['title']}');
      print('🎯 ==========================================');
      print('🎯 📨 SENDING APPROVAL REQUEST TO: $facultyName');
      print('🎯 ==========================================');
      
      // Add to faculty's approval section
      print('🔄 Adding to faculty approval section...');
      await _databaseRef.child('faculty').child(assignedFacultyId).child('approval_section').child(requestId).set(requestData);
      print('✅ Added to faculty approval section');
      
      // Verify the addition
      DataSnapshot verifySnapshot = await _databaseRef.child('faculty').child(assignedFacultyId).child('approval_section').get();
      print('🔍 Verification - Faculty approval section now contains: ${verifySnapshot.value}');
      
      // Add to student's approval list
      print('🔄 Adding to student approval list...');
      await _databaseRef.child('students').child(studentId).child('approval_list').child(requestId).set({
        ...requestData,
        'assigned_faculty_id': assignedFacultyId,
        'status': 'pending',
      });
      print('✅ Added to student approval list');
      
      print('✅ Approval request submitted successfully');
    } catch (e) {
      print('❌ Error submitting approval request: $e');
      throw e;
    }
  }

  // Method to find a random faculty member in the same department
  Future<String?> _findRandomFacultyInDepartment(String department) async {
    try {
      print('🔍 Searching for faculty in department: $department');
      
      DataSnapshot facultySnapshot = await _databaseRef.child('faculty').get();
      
      if (!facultySnapshot.exists) {
        print('❌ No faculty data found in Firebase');
        return null;
      }
      
      Map<dynamic, dynamic> faculty = facultySnapshot.value as Map<dynamic, dynamic>;
      List<String> matchingFaculty = [];
      List<String> allFaculty = [];
      
      print('🔍 Total faculty in database: ${faculty.length}');
      
      for (String facultyId in faculty.keys) {
        Map<String, dynamic> facultyData = Map<String, dynamic>.from(faculty[facultyId] as Map<dynamic, dynamic>);
        String facultyDept = facultyData['department'] ?? 'Unknown';
        String facultyName = facultyData['name'] ?? 'Unknown';
        
        allFaculty.add('$facultyId ($facultyName - $facultyDept)');
        
        if (facultyDept == department) {
          matchingFaculty.add(facultyId);
          print('✅ Found matching faculty: $facultyId ($facultyName - $facultyDept)');
        } else {
          print('❌ Faculty not in same department: $facultyId ($facultyName - $facultyDept)');
        }
      }
      
      print('🔍 All faculty: $allFaculty');
      print('🔍 Matching faculty count: ${matchingFaculty.length}');
      
      if (matchingFaculty.isEmpty) {
        print('❌ No faculty found in department: $department');
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
      
      print('🎯 ==========================================');
      print('🎯 RANDOM FACULTY SELECTION');
      print('🎯 ==========================================');
      print('🎯 Student Department: $department');
      print('🎯 Available faculty in same department: $matchingFaculty');
      print('🎯 Random index selected: $randomIndex (out of ${matchingFaculty.length} faculty)');
      print('🎯 Selected faculty ID: $randomFaculty');
      print('🎯 Selected faculty name: $facultyName');
      print('🎯 Selected faculty department: $facultyDepartment');
      print('🎯 Department match: ${facultyDepartment == department ? "✅ YES" : "❌ NO"}');
      print('🎯 ==========================================');
      print('🎯 🎲 RANDOM ASSIGNMENT COMPLETE! 🎲');
      print('🎯 📧 Approval request will be sent to: $facultyName ($randomFaculty)');
      print('🎯 ==========================================');
      return randomFaculty;
    } catch (e) {
      print('❌ Error finding faculty in department: $e');
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
        print('✅ Added to student approval_accepted section');
      } else {
        // Add to student's approval_rejected section
        await _databaseRef.child('students').child(studentId).child('approval_rejected').child(requestId).set(approvalHistory);
        print('✅ Added to student approval_rejected section');
      }
      
      // Remove from student's approval_list since it's now processed
      await _databaseRef.child('students').child(studentId).child('approval_list').child(requestId).remove();
      print('✅ Removed from student approval_list');
      
      // Remove from faculty's approval section
      await _databaseRef.child('faculty').child(facultyId).child('approval_section').child(requestId).remove();
      print('✅ Removed from faculty approval section');
      
      // Update faculty analytics
      await _updateFacultyAnalytics(facultyId, approved, points);
      
      print('✅ Approval request handled successfully');
      print('🎯 Student $studentId - Request $requestId ${approved ? "APPROVED" : "REJECTED"}');
      print('🎯 Points awarded: ${approved ? points : 0}');
      print('🎯 Reason: ${approved ? "Approved" : reason}');
    } catch (e) {
      print('❌ Error handling approval request: $e');
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
      print('❌ Error updating faculty analytics: $e');
    }
  }

}
