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
      print('🔍 ==========================================');
      print('🔍 FACULTY APPROVAL HISTORY PAGE - LOADING USER DATA');
      print('🔍 ==========================================');
      
      // Force refresh user data from Firebase to get latest updates
      print('🔄 Loading faculty user data...');
      final userData = await _authService.forceRefreshUserData();
      if (userData != null) {
        print('✅ Faculty user data loaded: ${userData['name']}');
        print('✅ Faculty ID: ${userData['id']}');
        print('✅ Faculty Category: ${userData['category']}');
        print('✅ Faculty Department: ${userData['department']}');
        
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
        
        print('🔄 Now loading approval history from Firebase...');
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
      print('🔍 ==========================================');
      print('🔍 LOADING APPROVAL HISTORY FROM FIREBASE');
      print('🔍 ==========================================');
      
      String facultyId = _userData!['id'];
      print('🔍 Faculty ID: $facultyId');
      print('🔍 Firebase Path: /faculty/$facultyId/approval_history');
      
      // Get Firebase Database reference
      final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();
      
      print('🔍 Firebase Database Reference created');
      print('🔍 Database URL: https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app');
      
      // Get approval_history directly from Firebase
      print('🔍 Fetching data from Firebase...');
      DataSnapshot historySnapshot = await databaseRef.child('faculty').child(facultyId).child('approval_history').get();
      
      print('🔍 ==========================================');
      print('🔍 FIREBASE RESPONSE ANALYSIS');
      print('🔍 ==========================================');
      print('🔍 Raw approval_history from Firebase: ${historySnapshot.value}');
      print('🔍 Approval_history exists: ${historySnapshot.exists}');
      print('🔍 Data type: ${historySnapshot.value.runtimeType}');
      print('🔍 Data is null: ${historySnapshot.value == null}');
      
      if (historySnapshot.exists && historySnapshot.value != null) {
        if (historySnapshot.value is Map) {
          Map<dynamic, dynamic> historyMap = historySnapshot.value as Map<dynamic, dynamic>;
          print('🔍 Approval_history is a Map with ${historyMap.length} entries');
          print('🔍 Map keys: ${historyMap.keys.toList()}');
          
          _approvalHistory = historyMap.entries.map((entry) {
            Map<String, dynamic> item = Map<String, dynamic>.from(entry.value as Map<dynamic, dynamic>);
            item['request_id'] = entry.key; // Add the request ID
            return item;
          }).toList();
          
          print('🔍 ==========================================');
          print('🔍 PROCESSED APPROVAL HISTORY');
          print('🔍 ==========================================');
          print('🔍 Loaded ${_approvalHistory.length} approval history items from Firebase');
          
          // Log each history item for debugging
          for (int i = 0; i < _approvalHistory.length; i++) {
            var item = _approvalHistory[i];
            print('🔍 History Item $i:');
            print('🔍   - ID: ${item['request_id']}');
            print('🔍   - Student: ${item['student_name']}');
            print('🔍   - Project: ${item['project_name']}');
            print('🔍   - Status: ${item['status']}');
            print('🔍   - Points Awarded: ${item['points_awarded']}');
            print('🔍   - Reason: ${item['reason']}');
            print('🔍   - Approved At: ${item['approved_at']}');
            print('🔍   - Full data: $item');
          }
        } else {
          print('🔍 Approval_history is not a Map: ${historySnapshot.value.runtimeType}');
          print('🔍 Actual value: ${historySnapshot.value}');
          _approvalHistory = [];
        }
      } else {
        print('🔍 No approval_history found in Firebase');
        print('🔍 This could mean:');
        print('🔍   1. No approval history exists for this faculty');
        print('🔍   2. The path is incorrect');
        print('🔍   3. Firebase connection issue');
        _approvalHistory = [];
      }
      
      print('🔍 ==========================================');
      print('🔍 FINAL RESULT');
      print('🔍 ==========================================');
      print('🔍 _approvalHistory.length: ${_approvalHistory.length}');
      print('🔍 _approvalHistory.isEmpty: ${_approvalHistory.isEmpty}');
      print('🔍 ==========================================');
      
      // Update the UI with the loaded data
      setState(() {});
      
    } catch (e) {
      print('❌ ==========================================');
      print('❌ ERROR LOADING APPROVAL HISTORY');
      print('❌ ==========================================');
      print('❌ Error: $e');
      print('❌ Error type: ${e.runtimeType}');
      print('❌ Stack trace: ${StackTrace.current}');
      print('❌ ==========================================');
      _approvalHistory = [];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🔍 ==========================================');
    print('🔍 FACULTY APPROVAL HISTORY PAGE - BUILD METHOD');
    print('🔍 ==========================================');
    print('🔍 _isLoading: $_isLoading');
    print('🔍 _userData: $_userData');
    print('🔍 _approvalHistory.length: ${_approvalHistory.length}');
    print('🔍 _approvalHistory.isEmpty: ${_approvalHistory.isEmpty}');
    print('🔍 ==========================================');
    
    // Faculty theme: green
    final Color facultyPrimary = Colors.green.shade700;

    if (_isLoading) {
      print('🔍 Showing loading screen...');
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

    print('🔍 Showing main content screen...');
    print('🔍 _approvalHistory.isEmpty: ${_approvalHistory.isEmpty}');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval History'),
        backgroundColor: facultyPrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              print('🔍 Refresh button pressed - reloading approval history...');
              _loadApprovalHistoryFromFirebase();
            },
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
                  const SizedBox(height: 16),
                  Text(
                    'Debug: _approvalHistory.length = ${_approvalHistory.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
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
                print('🔍 Building ListTile for history item $index: ${item['project_name']}');
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




