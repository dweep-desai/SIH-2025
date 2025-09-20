import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/faculty_drawer.dart';
import '../services/auth_service.dart';

class FacultyApprovalPage extends StatefulWidget {
  const FacultyApprovalPage({super.key});

  @override
  State<FacultyApprovalPage> createState() => _FacultyApprovalPageState();
}

class _FacultyApprovalPageState extends State<FacultyApprovalPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _approvalRequests = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      print('🔍 ==========================================');
      print('🔍 FACULTY APPROVAL PAGE - LOADING USER DATA');
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
        
        print('🔄 Now loading approval requests from Firebase...');
        // Load approval requests directly from Firebase
        await _loadApprovalRequestsFromFirebase();
      } else {
        print('❌ No faculty user data found');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('❌ Error loading faculty data: $e');
      setState(() => _isLoading = false);
    }
  }

  // Method to load approval requests directly from Firebase
  Future<void> _loadApprovalRequestsFromFirebase() async {
    try {
      print('🔍 ==========================================');
      print('🔍 LOADING APPROVAL REQUESTS FROM FIREBASE');
      print('🔍 ==========================================');
      
      String facultyId = _userData!['id'];
      print('🔍 Faculty ID: $facultyId');
      print('🔍 Firebase Path: /faculty/$facultyId/approval_section');
      
      // Get Firebase Database reference
      final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();
      
      print('🔍 Firebase Database Reference created');
      print('🔍 Database URL: https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app');
      
      // Get approval_section directly from Firebase
      print('🔍 Fetching data from Firebase...');
      DataSnapshot approvalSnapshot = await databaseRef.child('faculty').child(facultyId).child('approval_section').get();
      
      print('🔍 ==========================================');
      print('🔍 FIREBASE RESPONSE ANALYSIS');
      print('🔍 ==========================================');
      print('🔍 Raw approval_section from Firebase: ${approvalSnapshot.value}');
      print('🔍 Approval_section exists: ${approvalSnapshot.exists}');
      print('🔍 Data type: ${approvalSnapshot.value.runtimeType}');
      print('🔍 Data is null: ${approvalSnapshot.value == null}');
      
      if (approvalSnapshot.exists && approvalSnapshot.value != null) {
        if (approvalSnapshot.value is Map) {
          Map<dynamic, dynamic> approvalMap = approvalSnapshot.value as Map<dynamic, dynamic>;
          print('🔍 Approval_section is a Map with ${approvalMap.length} entries');
          print('🔍 Map keys: ${approvalMap.keys.toList()}');
          
          _approvalRequests = approvalMap.entries.map((entry) {
            Map<String, dynamic> request = Map<String, dynamic>.from(entry.value as Map<dynamic, dynamic>);
            request['request_id'] = entry.key; // Add the request ID
            return request;
          }).toList();
          
          print('🔍 ==========================================');
          print('🔍 PROCESSED APPROVAL REQUESTS');
          print('🔍 ==========================================');
          print('🔍 Loaded ${_approvalRequests.length} approval requests from Firebase');
          
          // Log each request for debugging
          for (int i = 0; i < _approvalRequests.length; i++) {
            var request = _approvalRequests[i];
            print('🔍 Request $i:');
            print('🔍   - ID: ${request['request_id']}');
            print('🔍   - Title: ${request['title']}');
            print('🔍   - Student: ${request['student_name']}');
            print('🔍   - Category: ${request['category']}');
            print('🔍   - Description: ${request['description']}');
            print('🔍   - Link: ${request['link']}');
            print('🔍   - Full data: $request');
          }
        } else {
          print('🔍 Approval_section is not a Map: ${approvalSnapshot.value.runtimeType}');
          print('🔍 Actual value: ${approvalSnapshot.value}');
          _approvalRequests = [];
        }
      } else {
        print('🔍 No approval_section found in Firebase');
        print('🔍 This could mean:');
        print('🔍   1. No approval requests have been assigned to this faculty');
        print('🔍   2. The path is incorrect');
        print('🔍   3. Firebase connection issue');
        _approvalRequests = [];
      }
      
      print('🔍 ==========================================');
      print('🔍 FINAL RESULT');
      print('🔍 ==========================================');
      print('🔍 _approvalRequests.length: ${_approvalRequests.length}');
      print('🔍 _approvalRequests.isEmpty: ${_approvalRequests.isEmpty}');
      print('🔍 ==========================================');
      
      // Update the UI with the loaded data
      setState(() {});
      
    } catch (e) {
      print('❌ ==========================================');
      print('❌ ERROR LOADING APPROVAL REQUESTS');
      print('❌ ==========================================');
      print('❌ Error: $e');
      print('❌ Error type: ${e.runtimeType}');
      print('❌ Stack trace: ${StackTrace.current}');
      print('❌ ==========================================');
      _approvalRequests = [];
      setState(() {});
    }
  }

  void _showRequestDetails(BuildContext context, Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${request['student_name'] ?? 'Unknown'} - ${request['project_name'] ?? 'Untitled'}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (request['title'] != null) ...[
              const Text('Title:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(request['title']),
              const SizedBox(height: 8),
            ],
            if (request['description'] != null) ...[
              const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(request['description']),
              const SizedBox(height: 8),
            ],
            if (request['link'] != null) ...[
              const Text('Link:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(request['link']),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleApproval(Map<String, dynamic> request, bool approved) async {
    try {
      if (approved) {
        // Show dialog for points input
        await _showApprovalDialog(request, true);
      } else {
        // Show dialog for rejection reason
        await _showRejectionDialog(request);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error handling approval: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showApprovalDialog(Map<String, dynamic> request, bool approved) async {
    final TextEditingController pointsController = TextEditingController();
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Approve Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Student: ${request['student_name']}'),
            Text('Project: ${request['project_name']}'),
            const SizedBox(height: 16),
            TextField(
              controller: pointsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Points to Award',
                hintText: 'Enter points (1-50)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              int points = int.tryParse(pointsController.text) ?? 0;
              if (points < 1 || points > 50) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter points between 1 and 50'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              Navigator.pop(context);
              await _processApproval(request, true, points, '');
            },
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  Future<void> _showRejectionDialog(Map<String, dynamic> request) async {
    final TextEditingController reasonController = TextEditingController();
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reject Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Student: ${request['student_name']}'),
            Text('Project: ${request['project_name']}'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for Rejection',
                hintText: 'Enter reason for rejection',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a reason for rejection'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              Navigator.pop(context);
              await _processApproval(request, false, 0, reasonController.text.trim());
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  Future<void> _processApproval(Map<String, dynamic> request, bool approved, int points, String reason) async {
    try {
      String requestId = request['request_id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
      
      await _authService.handleApprovalRequest(requestId, approved, points, reason);
      
      // Refresh data
      await _loadUserData();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request ${approved ? 'approved' : 'rejected'} successfully'),
          backgroundColor: approved ? Colors.green : Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing approval: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🔍 ==========================================');
    print('🔍 FACULTY APPROVAL PAGE - BUILD METHOD');
    print('🔍 ==========================================');
    print('🔍 _isLoading: $_isLoading');
    print('🔍 _userData: $_userData');
    print('🔍 _approvalRequests.length: ${_approvalRequests.length}');
    print('🔍 _approvalRequests.isEmpty: ${_approvalRequests.isEmpty}');
    print('🔍 ==========================================');
    
    // Faculty theme: green
    final Color facultyPrimary = Colors.green.shade700;

    if (_isLoading) {
      print('🔍 Showing loading screen...');
      return Scaffold(
        appBar: AppBar(
          title: const Text('Approval Section'),
          backgroundColor: facultyPrimary,
          foregroundColor: Colors.white,
        ),
        drawer: MainDrawer(context: context, isFaculty: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    print('🔍 Showing main content screen...');
    print('🔍 _approvalRequests.isEmpty: ${_approvalRequests.isEmpty}');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Section'),
        backgroundColor: facultyPrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              print('🔍 Refresh button pressed - reloading approval requests...');
              _loadApprovalRequestsFromFirebase();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Approval Requests',
          ),
        ],
      ),
      drawer: MainDrawer(context: context, isFaculty: true),
      body: _approvalRequests.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.approval_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No approval requests to display',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Debug: _approvalRequests.length = ${_approvalRequests.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _approvalRequests.length,
              itemBuilder: (context, index) {
                final request = _approvalRequests[index];
                print('🔍 Building ListTile for request $index: ${request['title']}');
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: ListTile(
                    title: Text(
                      "${request['student_name'] ?? 'Unknown'} - ${request['project_name'] ?? 'Untitled'}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Category: ${request['category'] ?? 'Unknown'}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () => _showRequestDetails(context, request),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => _handleApproval(request, true),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => _handleApproval(request, false),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
