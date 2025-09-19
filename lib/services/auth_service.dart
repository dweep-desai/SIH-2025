import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? _database;
  Map<String, dynamic>? _currentUser;

  // Load database from assets
  Future<void> loadDatabase() async {
    try {
      final jsonString = await rootBundle.loadString('assets/database/database_fixed.json');
      _database = json.decode(jsonString);
      print('✅ Database loaded successfully from assets');
    } catch (e) {
      print('❌ Error loading database: $e');
      _database = {};
    }
  }

  // Authenticate user with Firebase Auth and validate category from local database
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
      
      // Step 2: Load local database to validate category
      if (_database == null) {
        await loadDatabase();
      }

      if (_database == null) {
        print('❌ Local database not loaded');
        await _auth.signOut(); // Sign out since we can't validate category
        return null;
      }

      // Step 3: Find user in local database and validate category
      Map<String, dynamic>? localUser = _findUserInDatabase(email, category);
      
      if (localUser == null) {
        print('❌ User not found in local database or category mismatch');
        await _auth.signOut(); // Sign out since category validation failed
        return null;
      }

      print('✅ Category validation successful: ${localUser['category']}');
      _currentUser = localUser;
      return localUser;

    } catch (e) {
      print('❌ Authentication error: $e');
      return null;
    }
  }

  // Find user in local database by email and validate category
  Map<String, dynamic>? _findUserInDatabase(String email, String expectedCategory) {
    // Search in all collections
    for (String collectionName in ['students', 'faculty', 'admin']) {
      if (_database![collectionName] != null) {
        Map<String, dynamic> collection = _database![collectionName];
        
        for (String userId in collection.keys) {
          Map<String, dynamic> user = collection[userId];
          
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
                  'courses': user['courses'],
                  'grades': user['grades'],
                  'student_record': user['student_record'],
                });
              } else if (user['category'] == 'faculty') {
                userData.addAll({
                  'department': user['department'],
                  'faculty_id': user['faculty_id'],
                  'designation': user['designation'],
                  'educational_qualifications': user['educational_qualifications'],
                  'faculty_record': user['faculty_record'],
                });
              } else if (user['category'] == 'admin') {
                userData.addAll({
                  'admin_id': user['admin_id'],
                });
              }

              return userData;
            } else {
              print('❌ Category mismatch. Expected: $expectedCategory, Found: ${user['category']}');
              return null;
            }
          }
        }
      }
    }

    print('❌ User not found in local database');
    return null;
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
  List<Map<String, dynamic>> getAllStudents() {
    if (_database == null) return [];
    
    final students = <Map<String, dynamic>>[];
    if (_database!['students'] != null) {
      final studentsData = _database!['students'] as Map<String, dynamic>;
      studentsData.forEach((key, value) {
        students.add({
          'id': key,
          ...value as Map<String, dynamic>,
        });
      });
    }
    return students;
  }

  // Get all faculty for admin
  List<Map<String, dynamic>> getAllFaculty() {
    if (_database == null) return [];
    
    final faculty = <Map<String, dynamic>>[];
    if (_database!['faculty'] != null) {
      final facultyData = _database!['faculty'] as Map<String, dynamic>;
      facultyData.forEach((key, value) {
        faculty.add({
          'id': key,
          ...value as Map<String, dynamic>,
        });
      });
    }
    return faculty;
  }

  // Get students by branch (for faculty)
  List<Map<String, dynamic>> getStudentsByBranch(String branch) {
    return getAllStudents().where((student) => student['branch'] == branch).toList();
  }

  // Get faculty by department (for students)
  List<Map<String, dynamic>> getFacultyByDepartment(String department) {
    return getAllFaculty().where((faculty) => faculty['department'] == department).toList();
  }
}
