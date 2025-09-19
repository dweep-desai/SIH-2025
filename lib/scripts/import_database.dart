import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';

Future<void> main() async {
  print('🚀 Starting database import...');
  
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Firebase Database
  final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();
  
  // Read the database_fixed.json file
  final File file = File('database/database_fixed.json');
  if (!await file.exists()) {
    print('❌ database_fixed.json file not found at: ${file.path}');
    exit(1);
  }
  
  final String jsonString = await file.readAsString();
  final Map<String, dynamic> databaseData = json.decode(jsonString);
  
  print('📊 Database structure:');
  print('  - Students: ${databaseData['students']?.length ?? 0}');
  print('  - Faculty: ${databaseData['faculty']?.length ?? 0}');
  print('  - Admin: ${databaseData['admin']?.length ?? 0}');
  
  try {
    // Import students
    if (databaseData['students'] != null) {
      print('📝 Importing students...');
      await databaseRef.child('students').set(databaseData['students']);
      print('✅ Students imported successfully');
    }
    
    // Import faculty
    if (databaseData['faculty'] != null) {
      print('📝 Importing faculty...');
      await databaseRef.child('faculty').set(databaseData['faculty']);
      print('✅ Faculty imported successfully');
    }
    
    // Import admin
    if (databaseData['admin'] != null) {
      print('📝 Importing admin...');
      await databaseRef.child('admin').set(databaseData['admin']);
      print('✅ Admin imported successfully');
    }
    
    print('🎉 Database import completed successfully!');
    
    // Verify the import
    print('🔍 Verifying import...');
    final DataSnapshot studentsSnapshot = await databaseRef.child('students').get();
    final DataSnapshot facultySnapshot = await databaseRef.child('faculty').get();
    final DataSnapshot adminSnapshot = await databaseRef.child('admin').get();
    
    print('✅ Verification results:');
    print('  - Students in Firebase: ${studentsSnapshot.exists ? (studentsSnapshot.value as Map).length : 0}');
    print('  - Faculty in Firebase: ${facultySnapshot.exists ? (facultySnapshot.value as Map).length : 0}');
    print('  - Admin in Firebase: ${adminSnapshot.exists ? (adminSnapshot.value as Map).length : 0}');
    
  } catch (e) {
    print('❌ Error importing database: $e');
    exit(1);
  }
  
  exit(0);
}
