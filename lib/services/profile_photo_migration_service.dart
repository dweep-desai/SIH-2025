import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'base64_storage_service.dart';

class ProfilePhotoMigrationService {
  static final ProfilePhotoMigrationService _instance = ProfilePhotoMigrationService._internal();
  factory ProfilePhotoMigrationService() => _instance;
  ProfilePhotoMigrationService._internal();

  final DatabaseReference _databaseRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();
  
  final Base64StorageService _base64Service = Base64StorageService();

  /// Migrate all existing local profile photos to Base64 format
  /// This should be called once to migrate existing data
  Future<Map<String, dynamic>> migrateAllProfilePhotos() async {
    final results = <String, dynamic>{
      'success': 0,
      'failed': 0,
      'skipped': 0,
      'errors': <String>[],
    };

    try {
      // Get all users from all categories
      final categories = ['students', 'faculty', 'admin'];
      
      for (String category in categories) {
        final snapshot = await _databaseRef.child(category).get();
        
        if (snapshot.exists) {
          final data = snapshot.value as Map<dynamic, dynamic>;
          
          for (String userId in data.keys) {
            final userData = data[userId] as Map<dynamic, dynamic>;
            final profilePhoto = userData['profile_photo']?.toString();
            
            if (profilePhoto != null && profilePhoto.isNotEmpty) {
              // Check if it's a local file path that needs migration
              if (_isLocalFilePath(profilePhoto)) {
                try {
                  final file = File(profilePhoto);
                  if (await file.exists()) {
                    // Convert to Base64
                    final base64String = await _base64Service.imageToBase64(file);
                    
                    if (base64String != null) {
                      // Update the database with the Base64 string
                      await _databaseRef.child(category).child(userId).child('profile_photo').set(base64String);
                      results['success'] = (results['success'] as int) + 1;
                    } else {
                      results['failed'] = (results['failed'] as int) + 1;
                      (results['errors'] as List<String>).add('Failed to convert photo to Base64 for $category/$userId');
                    }
                  } else {
                    // File doesn't exist, remove the invalid path
                    await _databaseRef.child(category).child(userId).child('profile_photo').set('');
                    results['skipped'] = (results['skipped'] as int) + 1;
                    (results['errors'] as List<String>).add('File not found for $category/$userId: $profilePhoto');
                  }
                } catch (e) {
                  results['failed'] = (results['failed'] as int) + 1;
                  (results['errors'] as List<String>).add('Error migrating $category/$userId: $e');
                }
              } else {
                // Already a network URL or Base64, skip
                results['skipped'] = (results['skipped'] as int) + 1;
              }
            }
          }
        }
      }
    } catch (e) {
      (results['errors'] as List<String>).add('Migration failed: $e');
    }

    return results;
  }

  /// Migrate profile photo for a specific user
  Future<bool> migrateUserProfilePhoto(String userId, String category) async {
    try {
      final snapshot = await _databaseRef.child(category).child(userId).get();
      
      if (snapshot.exists) {
        final userData = snapshot.value as Map<dynamic, dynamic>;
        final profilePhoto = userData['profile_photo']?.toString();
        
        if (profilePhoto != null && profilePhoto.isNotEmpty && _isLocalFilePath(profilePhoto)) {
          final file = File(profilePhoto);
          if (await file.exists()) {
            final base64String = await _base64Service.imageToBase64(file);
            
            if (base64String != null) {
              await _databaseRef.child(category).child(userId).child('profile_photo').set(base64String);
              return true;
            }
          }
        }
      }
    } catch (e) {
      print('Error migrating profile photo for $userId: $e');
    }
    
    return false;
  }

  /// Check if a path is a local file path
  bool _isLocalFilePath(String path) {
    return path.startsWith('/') || 
           path.startsWith('C:') || 
           path.startsWith('D:') ||
           path.startsWith('E:') ||
           path.startsWith('F:');
  }

  /// Get migration status for all users
  Future<Map<String, dynamic>> getMigrationStatus() async {
    final status = <String, dynamic>{
      'total_users': 0,
      'local_photos': 0,
      'network_photos': 0,
      'no_photos': 0,
      'categories': <String, Map<String, int>>{},
    };

    try {
      final categories = ['students', 'faculty', 'admin'];
      
      for (String category in categories) {
        (status['categories'] as Map<String, Map<String, int>>)[category] = {
          'total': 0,
          'local': 0,
          'network': 0,
          'none': 0,
        };

        final snapshot = await _databaseRef.child(category).get();
        
        if (snapshot.exists) {
          final data = snapshot.value as Map<dynamic, dynamic>;
          
          for (String userId in data.keys) {
            final userData = data[userId] as Map<dynamic, dynamic>;
            final profilePhoto = userData['profile_photo']?.toString();
            
            status['total_users'] = (status['total_users'] as int) + 1;
            (status['categories'] as Map<String, Map<String, int>>)[category]!['total'] = 
                ((status['categories'] as Map<String, Map<String, int>>)[category]!['total'] ?? 0) + 1;
            
            if (profilePhoto == null || profilePhoto.isEmpty) {
              status['no_photos'] = (status['no_photos'] as int) + 1;
              (status['categories'] as Map<String, Map<String, int>>)[category]!['none'] = 
                  ((status['categories'] as Map<String, Map<String, int>>)[category]!['none'] ?? 0) + 1;
            } else if (_isLocalFilePath(profilePhoto)) {
              status['local_photos'] = (status['local_photos'] as int) + 1;
              (status['categories'] as Map<String, Map<String, int>>)[category]!['local'] = 
                  ((status['categories'] as Map<String, Map<String, int>>)[category]!['local'] ?? 0) + 1;
            } else {
              status['network_photos'] = (status['network_photos'] as int) + 1;
              (status['categories'] as Map<String, Map<String, int>>)[category]!['network'] = 
                  ((status['categories'] as Map<String, Map<String, int>>)[category]!['network'] ?? 0) + 1;
            }
          }
        }
      }
    } catch (e) {
      status['error'] = e.toString();
    }

    return status;
  }
}
