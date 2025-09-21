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
      final userData = await _authService.forceRefreshUserData();
      if (userData != null) {
        
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
        
        // Load approval history directly from Firebase
        await _loadApprovalHistoryFromFirebase();
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // Method to load approval history directly from Firebase
  Future<void> _loadApprovalHistoryFromFirebase() async {
    try {
      
      String facultyId = _userData!['id'];
      
      // Get Firebase Database reference
      final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();
      
      
      // Get approval_history directly from Firebase
      DataSnapshot historySnapshot = await databaseRef.child('faculty').child(facultyId).child('approval_history').get();
      
      
      if (historySnapshot.exists && historySnapshot.value != null) {
        if (historySnapshot.value is Map) {
          Map<dynamic, dynamic> historyMap = historySnapshot.value as Map<dynamic, dynamic>;
          
          _approvalHistory = historyMap.entries.map((entry) {
            Map<String, dynamic> item = Map<String, dynamic>.from(entry.value as Map<dynamic, dynamic>);
            item['request_id'] = entry.key; // Add the request ID
            return item;
          }).toList();
          
          
          // Log each history item for debugging
          for (int i = 0; i < _approvalHistory.length; i++) {
            var item = _approvalHistory[i];
          }
        } else {
          _approvalHistory = [];
        }
      } else {
        _approvalHistory = [];
      }
      
      
      // Update the UI with the loaded data
      setState(() {});
      
    } catch (e) {
      _approvalHistory = [];
      setState(() {});
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
            onPressed: () {
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




