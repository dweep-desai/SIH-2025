import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/faculty_drawer.dart';
import '../services/auth_service.dart';

class FacultyApprovalHistoryPage extends StatefulWidget {
  const FacultyApprovalHistoryPage({super.key});

  @override
  State<FacultyApprovalHistoryPage> createState() => _FacultyApprovalHistoryPageState();
}

class _FacultyApprovalHistoryPageState extends State<FacultyApprovalHistoryPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _approvalHistory = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Force refresh user data from Firebase to get latest updates
      print('🔄 Loading faculty user data...');
      final userData = await _authService.forceRefreshUserData();
      if (userData != null) {
        print('✅ Faculty user data loaded: ${userData['name']}');
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
        
        // Load approval history directly from Firebase
        await _loadApprovalHistoryFromFirebase();
      } else {
        print('❌ No faculty user data found');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('❌ Error loading faculty data: $e');
      setState(() => _isLoading = false);
    }
  }

  // Method to load approval history directly from Firebase
  Future<void> _loadApprovalHistoryFromFirebase() async {
    try {
      String facultyId = _userData!['id'];
      print('🔍 Loading approval history directly from Firebase for faculty: $facultyId');
      
      // Get Firebase Database reference
      final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();
      
      // Get approval history directly from Firebase
      DataSnapshot historySnapshot = await databaseRef.child('faculty').child(facultyId).child('approval_history').get();
      
      print('🔍 Raw approval history from Firebase: ${historySnapshot.value}');
      print('🔍 Approval history exists: ${historySnapshot.exists}');
      
      if (historySnapshot.exists && historySnapshot.value != null) {
        if (historySnapshot.value is Map) {
          Map<dynamic, dynamic> historyMap = historySnapshot.value as Map<dynamic, dynamic>;
          _approvalHistory = historyMap.entries.map((entry) {
            Map<String, dynamic> item = Map<String, dynamic>.from(entry.value as Map<dynamic, dynamic>);
            item['request_id'] = entry.key; // Add the request ID
            return item;
          }).toList();
          print('🔍 Loaded ${_approvalHistory.length} approval history items from Firebase');
        } else {
          print('🔍 Approval history is not a Map: ${historySnapshot.value.runtimeType}');
          _approvalHistory = [];
        }
      } else {
        print('🔍 No approval history found in Firebase');
        _approvalHistory = [];
      }
    } catch (e) {
      print('❌ Error loading approval history from Firebase: $e');
      _approvalHistory = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Faculty theme: green
    final Color facultyPrimary = Colors.green.shade700;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Approval History'),
          backgroundColor: facultyPrimary,
          foregroundColor: Colors.white,
        ),
        drawer: MainDrawer(context: context, isFaculty: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval History'),
        backgroundColor: facultyPrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadApprovalHistoryFromFirebase,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Approval History',
          ),
        ],
      ),
      drawer: MainDrawer(context: context, isFaculty: true),
      body: _approvalHistory.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No approval history to display',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _approvalHistory.length,
              itemBuilder: (context, index) {
                final item = _approvalHistory[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: ListTile(
                    title: Text("${item['student_name'] ?? 'Unknown'} - ${item['project_name'] ?? 'Untitled'}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Status: ${item['status'] ?? 'Unknown'}"),
                        if (item['status'] == 'rejected' && item['reason'] != null)
                          Text("Reason: ${item['reason']}", style: TextStyle(color: Colors.red)),
                        if (item['status'] == 'accepted' && item['points_awarded'] != null)
                          Text("Points: ${item['points_awarded']}", style: TextStyle(color: Colors.green)),
                      ],
                    ),
                    trailing: Icon(
                      item['status'] == 'accepted' ? Icons.check_circle : Icons.cancel,
                      color: item['status'] == 'accepted' ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            ),
    );
  }
}




