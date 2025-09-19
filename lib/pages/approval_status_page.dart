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
    try {
      final history = await _authService.getStudentApprovalHistory();
      setState(() {
        _approvalHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading approval history: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Approval Status')),
        drawer: MainDrawer(context: context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Approval Status'),
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
            _buildStatusList('approved'),
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
                if (request['faculty_comment'] != null && request['faculty_comment'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Comment: ${request['faculty_comment']}',
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
                          content: Text(request['faculty_comment'] ?? 'No reason provided.'),
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
