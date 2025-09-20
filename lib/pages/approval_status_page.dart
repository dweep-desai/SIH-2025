import 'package:flutter/material.dart';
import '../widgets/student_drawer.dart';
import '../services/auth_service.dart';

class ApprovalStatusPage extends StatefulWidget {
  const ApprovalStatusPage({super.key});

  @override
  State<ApprovalStatusPage> createState() => _ApprovalStatusPageState();
}

class _ApprovalStatusPageState extends State<ApprovalStatusPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _approvalHistory = [];

  @override
  void initState() {
    super.initState();
    _loadApprovalHistory();
  }

  Future<void> _loadApprovalHistory() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      print('🔄 ==========================================');
      print('🔄 LOADING STUDENT APPROVAL HISTORY');
      print('🔄 ==========================================');
      
      // Force refresh user data first
      print('🔄 Force refreshing user data...');
      await _authService.forceRefreshUserData();
      
      final history = await _authService.getStudentApprovalHistory();
      setState(() {
        _approvalHistory = history;
        _isLoading = false;
      });
      
      // Enhanced logging
      print('✅ Loaded ${history.length} total approval requests');
      
      // Log each request with details
      for (int i = 0; i < history.length; i++) {
        var request = history[i];
        print('🔍 Request $i: ${request['title']} - Status: ${request['status']}');
        print('🔍   ID: ${request['id']}');
        print('🔍   Points: ${request['points_awarded']}');
        print('🔍   Faculty: ${request['faculty_id']}');
        print('🔍   Approved At: ${request['approved_at']}');
      }
      
      // Count by status
      int accepted = history.where((req) => req['status'] == 'accepted').length;
      int rejected = history.where((req) => req['status'] == 'rejected').length;
      int pending = history.where((req) => req['status'] == 'pending').length;
      
      print('📊 Status Summary:');
      print('📊   Accepted: $accepted');
      print('📊   Rejected: $rejected');
      print('📊   Pending: $pending');
      print('🔄 ==========================================');
      
      // Show feedback to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Loaded $accepted accepted, $rejected rejected, $pending pending requests'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('❌ Error loading approval history: $e');
      setState(() => _isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading approval history: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Debug method to check approval data directly from Firebase
  Future<void> _debugApprovalData() async {
    try {
      print('🔍 ==========================================');
      print('🔍 DEBUGGING STUDENT APPROVAL DATA');
      print('🔍 ==========================================');
      
      final userData = _authService.getCurrentUser();
      if (userData == null) {
        print('❌ No current user found');
        return;
      }
      
      String studentId = userData['id'];
      print('🔍 Student ID: $studentId');
      
      // Check Firebase data directly
      print('🔍 Checking Firebase data directly...');
      final firebaseData = await _authService.debugStudentApprovalData();
      
      print('🔍 Firebase Data Summary:');
      print('🔍   approval_accepted: ${firebaseData['accepted']}');
      print('🔍   approval_rejected: ${firebaseData['rejected']}');
      print('🔍   approval_history: ${firebaseData['history']}');
      
      // Also check processed data
      print('🔍 Checking processed data...');
      final processedHistory = await _authService.getStudentApprovalHistory();
      
      print('🔍 Processed Data Summary:');
      print('🔍 Total requests loaded: ${processedHistory.length}');
      for (var request in processedHistory) {
        print('🔍 Request: ${request['title']} - Status: ${request['status']}');
        print('🔍   ID: ${request['id']}');
        print('🔍   Points: ${request['points_awarded']}');
        print('🔍   Faculty: ${request['faculty_id']}');
      }
      
      // Show in UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Debug info printed to console. Found ${processedHistory.length} requests.'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('❌ Error debugging approval data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Approval Status'),
          actions: [
            IconButton(
              onPressed: _debugApprovalData,
              icon: const Icon(Icons.bug_report),
              tooltip: 'Debug Approval Data',
            ),
            IconButton(
              onPressed: _loadApprovalHistory,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh Approval Status',
            ),
          ],
        ),
        drawer: MainDrawer(context: context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Approval Status'),
          actions: [
            IconButton(
              onPressed: _debugApprovalData,
              icon: const Icon(Icons.bug_report),
              tooltip: 'Debug Approval Data',
            ),
            IconButton(
              onPressed: _loadApprovalHistory,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh Approval Status',
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Accepted'),
              Tab(text: 'Rejected'),
              Tab(text: 'Pending'),
            ],
          ),
        ),
        drawer: MainDrawer(context: context),
        body: TabBarView(
          children: [
            _buildStatusList('accepted'),
            _buildStatusList('rejected'),
            _buildStatusList('pending'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusList(String status) {
    var filteredRequests = _approvalHistory.where((req) => req['status'] == status).toList();
    
    // Sort research papers and projects by points (highest first)
    filteredRequests.sort((a, b) {
      if ((a['category'] == 'Research papers' || a['category'] == 'Projects') &&
          (b['category'] == 'Research papers' || b['category'] == 'Projects')) {
        final aPoints = a['points_awarded'] ?? 0;
        final bPoints = b['points_awarded'] ?? 0;
        return bPoints.compareTo(aPoints); // Descending order
      }
      return 0; // Keep original order for other categories
    });

    if (filteredRequests.isEmpty) {
      return const Center(child: Text('No requests found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredRequests.length,
      itemBuilder: (context, index) {
        final request = filteredRequests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          child: ListTile(
            title: Text(request['title'] ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(request['description'] ?? ''),
                Text('Category: ${request['category'] ?? ''}'),
                if (request['points_awarded'] != null && request['points_awarded'] > 0 && 
                    (request['category'] == 'Research papers' || request['category'] == 'Projects'))
                  Text('Points: ${request['points_awarded']}/50', 
                       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700])),
                Text('Submitted: ${request['submitted_at'] ?? 'Unknown'}'),
                if (request['approved_at'] != null)
                  Text('${status == 'accepted' ? 'Accepted' : 'Rejected'}: ${request['approved_at']}'),
                if (request['faculty_id'] != null)
                  Text('Faculty: ${request['faculty_id']}'),
                if (request['reason'] != null && request['reason'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Reason: ${request['reason']}',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: status == 'rejected' ? Colors.red[600] : Colors.grey[600],
                      ),
                    ),
                  ),
                if (request['reason'] != null && request['reason'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Comment: ${request['reason']}',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ),
            trailing: status == 'rejected'
                ? IconButton(
                    icon: const Icon(Icons.info, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Rejection Reason'),
                          content: Text(request['reason'] ?? 'No reason provided.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : null,
          ),
        );
      },
    );
  }
}
