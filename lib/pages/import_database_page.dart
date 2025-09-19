import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class ImportDatabasePage extends StatefulWidget {
  const ImportDatabasePage({super.key});

  @override
  State<ImportDatabasePage> createState() => _ImportDatabasePageState();
}

class _ImportDatabasePageState extends State<ImportDatabasePage> {
  bool _isImporting = false;
  String _status = 'Ready to import database';
  int _studentsImported = 0;
  int _facultyImported = 0;
  int _adminImported = 0;

  Future<void> _importDatabase() async {
    setState(() {
      _isImporting = true;
      _status = 'Starting import...';
    });

    try {
      // Read the database_fixed.json file from assets
      final String jsonString = await rootBundle.loadString('assets/database/database_fixed.json');
      final Map<String, dynamic> databaseData = json.decode(jsonString);

      setState(() {
        _status = 'Database loaded, importing...';
      });

      // Get Firebase Database reference
      final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();

      // Import students
      if (databaseData['students'] != null) {
        setState(() {
          _status = 'Importing students...';
        });
        await databaseRef.child('students').set(databaseData['students']);
        _studentsImported = (databaseData['students'] as Map).length;
      }

      // Import faculty
      if (databaseData['faculty'] != null) {
        setState(() {
          _status = 'Importing faculty...';
        });
        await databaseRef.child('faculty').set(databaseData['faculty']);
        _facultyImported = (databaseData['faculty'] as Map).length;
      }

      // Import admin
      if (databaseData['admin'] != null) {
        setState(() {
          _status = 'Importing admin...';
        });
        await databaseRef.child('admin').set(databaseData['admin']);
        _adminImported = (databaseData['admin'] as Map).length;
      }

      setState(() {
        _status = 'Import completed successfully!';
        _isImporting = false;
      });

      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Import Successful'),
            content: Text(
              'Database imported successfully!\n\n'
              'Students: $_studentsImported\n'
              'Faculty: $_facultyImported\n'
              'Admin: $_adminImported',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }

    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _isImporting = false;
      });

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Import Error'),
            content: Text('Error importing database: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _verifyDatabase() async {
    setState(() {
      _status = 'Verifying database...';
    });

    try {
      final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();

      final DataSnapshot studentsSnapshot = await databaseRef.child('students').get();
      final DataSnapshot facultySnapshot = await databaseRef.child('faculty').get();
      final DataSnapshot adminSnapshot = await databaseRef.child('admin').get();

      final int studentsCount = studentsSnapshot.exists ? (studentsSnapshot.value as Map).length : 0;
      final int facultyCount = facultySnapshot.exists ? (facultySnapshot.value as Map).length : 0;
      final int adminCount = adminSnapshot.exists ? (adminSnapshot.value as Map).length : 0;

      setState(() {
        _status = 'Verification complete';
        _studentsImported = studentsCount;
        _facultyImported = facultyCount;
        _adminImported = adminCount;
      });

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Database Verification'),
            content: Text(
              'Current database status:\n\n'
              'Students: $studentsCount\n'
              'Faculty: $facultyCount\n'
              'Admin: $adminCount',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }

    } catch (e) {
      setState(() {
        _status = 'Verification error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Database'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Database Import',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This will import the database_fixed.json data into Firebase Realtime Database.',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isImporting ? null : _importDatabase,
                      child: _isImporting
                          ? const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: 8),
                                Text('Importing...'),
                              ],
                            )
                          : const Text('Import Database'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Database Verification',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Check the current status of the Firebase database.',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _verifyDatabase,
                      child: const Text('Verify Database'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(_status),
                    const SizedBox(height: 16),
                    if (_studentsImported > 0 || _facultyImported > 0 || _adminImported > 0) ...[
                      const Text('Import Results:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Students: $_studentsImported'),
                      Text('Faculty: $_facultyImported'),
                      Text('Admin: $_adminImported'),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
