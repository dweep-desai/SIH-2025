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
      final userData = await _authService.forceRefreshUserData();
      if (userData != null) {
        
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
        
        // Load approval requests directly from Firebase
        await _loadApprovalRequestsFromFirebase();
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // Method to load approval requests directly from Firebase
  Future<void> _loadApprovalRequestsFromFirebase() async {
    try {
      
      String facultyId = _userData!['id'];
      
      // Get Firebase Database reference
      final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://ssh-project-7ebc3-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();
      
      
      // Get approval_section directly from Firebase
      DataSnapshot approvalSnapshot = await databaseRef.child('faculty').child(facultyId).child('approval_section').get();
      
      
      if (approvalSnapshot.exists && approvalSnapshot.value != null) {
        if (approvalSnapshot.value is Map) {
          Map<dynamic, dynamic> approvalMap = approvalSnapshot.value as Map<dynamic, dynamic>;
          
          _approvalRequests = approvalMap.entries.map((entry) {
            Map<String, dynamic> request = Map<String, dynamic>.from(entry.value as Map<dynamic, dynamic>);
            request['request_id'] = entry.key; // Add the request ID
            return request;
          }).toList();
          
          
          // Log each request for debugging
          for (int i = 0; i < _approvalRequests.length; i++) {
            var request = _approvalRequests[i];
          }
        } else {
          _approvalRequests = [];
        }
      } else {
        _approvalRequests = [];
      }
      
      
      // Update the UI with the loaded data
      setState(() {});
      
    } catch (e) {
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
    
    // Faculty theme: green
    // final Color facultyPrimary = Colors.green.shade700;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Approval Section'),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4A90E2).withOpacity(0.8), // Blue
                  const Color(0xFF7ED321).withOpacity(0.6), // Green
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 0,
        ),
        drawer: MainDrawer(context: context, isFaculty: true),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF4A90E2).withOpacity(0.1), // Light blue
                const Color(0xFF7ED321).withOpacity(0.1), // Light green
              ],
            ),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Section'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF4A90E2).withOpacity(0.8), // Blue
                const Color(0xFF7ED321).withOpacity(0.6), // Green
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _loadApprovalRequestsFromFirebase();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Approval Requests',
          ),
        ],
      ),
      drawer: MainDrawer(context: context, isFaculty: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4A90E2).withOpacity(0.1), // Light blue
              const Color(0xFF7ED321).withOpacity(0.1), // Light green
            ],
          ),
        ),
        child: _approvalRequests.isEmpty
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
        ),
      );
  }
}
