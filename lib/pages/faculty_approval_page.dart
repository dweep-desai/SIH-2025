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
      // Force refresh user data from Firebase to get latest updates
      print('🔄 Loading faculty user data...');
      final userData = await _authService.forceRefreshUserData();
      if (userData != null) {
        print('✅ Faculty user data loaded: ${userData['name']}');
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
        
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
      String facultyId = _userData!['id'];
      print('🔍 Loading approval requests directly from Firebase for faculty: $facultyId');
      
      // Get Firebase Database reference
      final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();
      
      // Get approval section directly from Firebase
      DataSnapshot approvalSnapshot = await databaseRef.child('faculty').child(facultyId).child('approval_section').get();
      
      print('🔍 Raw approval section from Firebase: ${approvalSnapshot.value}');
      print('🔍 Approval section exists: ${approvalSnapshot.exists}');
      
      if (approvalSnapshot.exists && approvalSnapshot.value != null) {
        if (approvalSnapshot.value is Map) {
          Map<dynamic, dynamic> approvalMap = approvalSnapshot.value as Map<dynamic, dynamic>;
          _approvalRequests = approvalMap.entries.map((entry) {
            Map<String, dynamic> request = Map<String, dynamic>.from(entry.value as Map<dynamic, dynamic>);
            request['request_id'] = entry.key; // Add the request ID
            return request;
          }).toList();
          print('🔍 Loaded ${_approvalRequests.length} approval requests from Firebase');
          
          // Log each request for debugging
          for (var request in _approvalRequests) {
            print('🔍 Request: ${request['request_id']} - ${request['title']} from ${request['student_name']}');
          }
        } else {
          print('🔍 Approval section is not a Map: ${approvalSnapshot.value.runtimeType}');
          _approvalRequests = [];
        }
      } else {
        print('🔍 No approval section found in Firebase');
        _approvalRequests = [];
      }
    } catch (e) {
      print('❌ Error loading approval requests from Firebase: $e');
      _approvalRequests = [];
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
                hintText: 'Enter points (1-100)',
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
              if (points < 1 || points > 100) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter points between 1 and 100'),
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
    // Faculty theme: green
    final Color facultyPrimary = Colors.green.shade700;

    if (_isLoading) {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Section'),
        backgroundColor: facultyPrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadApprovalRequestsFromFirebase,
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
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _approvalRequests.length,
              itemBuilder: (context, index) {
                final request = _approvalRequests[index];
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
