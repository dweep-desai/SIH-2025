import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class PushToFirebasePage extends StatefulWidget {
  const PushToFirebasePage({super.key});

  @override
  State<PushToFirebasePage> createState() => _PushToFirebasePageState();
}

class _PushToFirebasePageState extends State<PushToFirebasePage> {
  bool _isLoading = false;
  String _status = 'Ready to push data to Firebase';
  int _studentsCount = 0;
  int _facultyCount = 0;
  int _adminCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push to Firebase'),
        backgroundColor: Colors.blue,
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
                      'Firebase Database Push',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(_status),
                    const SizedBox(height: 16),
                    if (_isLoading)
                      const LinearProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: _pushToFirebase,
                        child: const Text('Push Data to Firebase'),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_studentsCount > 0 || _facultyCount > 0 || _adminCount > 0)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Data Summary',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Students: $_studentsCount'),
                      Text('Faculty: $_facultyCount'),
                      Text('Admin: $_adminCount'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pushToFirebase() async {
    setState(() {
      _isLoading = true;
      _status = 'Loading database file...';
    });

    try {
      // Load the cleaned database file
      final String jsonString = await rootBundle.loadString('database/database_fixed_sanitized.json');
      final Map<String, dynamic> database = jsonDecode(jsonString);

      setState(() {
        _status = 'Connecting to Firebase...';
      });

      // Get Firebase Database reference
      final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();

      setState(() {
        _status = 'Pushing data to Firebase...';
      });

      // Push all data to Firebase
      await databaseRef.set(database);

      // Count records
      _studentsCount = database['students']?.length ?? 0;
      _facultyCount = database['faculty']?.length ?? 0;
      _adminCount = database['admin']?.length ?? 0;

      setState(() {
        _status = '✅ Successfully pushed all data to Firebase!';
        _isLoading = false;
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success!'),
          content: Text('Pushed $_studentsCount students, $_facultyCount faculty, and $_adminCount admin records to Firebase.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );

    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
        _isLoading = false;
      });

      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to push data to Firebase: $e'),
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
