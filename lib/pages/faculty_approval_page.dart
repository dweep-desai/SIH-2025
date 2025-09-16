import 'package:flutter/material.dart';
import '../widgets/faculty_drawer.dart';

class FacultyApprovalPage extends StatefulWidget {
  const FacultyApprovalPage({super.key});

  @override
  State<FacultyApprovalPage> createState() => _FacultyApprovalPageState();
}

class _FacultyApprovalPageState extends State<FacultyApprovalPage> {
  // Dummy data for approvals
  final List<Map<String, dynamic>> approvals = [
    {
      'studentName': 'Alice Johnson',
      'approvalType': 'Project Proposal',
      'status': 'pending',
    },
    {
      'studentName': 'Bob Smith',
      'approvalType': 'Paper Submission',
      'status': 'pending',
    },
    {
      'studentName': 'Charlie Brown',
      'approvalType': 'Conference Attendance',
      'status': 'pending',
    },
  ];

  void _approveAll() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Approval'),
          content: const Text('Are you sure you want to approve all pending requests?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  for (var approval in approvals) {
                    approval['status'] = 'approved';
                  }
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All requests approved')),
                );
              },
              child: const Text('Approve All'),
            ),
          ],
        );
      },
    );
  }

  void _approveSingle(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Approval'),
          content: Text('Approve request for ${approvals[index]['studentName']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  approvals[index]['status'] = 'approved';
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Approved for ${approvals[index]['studentName']}')),
                );
              },
              child: const Text('Approve'),
            ),
          ],
        );
      },
    );
  }

  void _rejectSingle(int index) {
    TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reject Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Reject request for ${approvals[index]['studentName']}?'),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason (required)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (reasonController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reason is required')),
                  );
                  return;
                }
                setState(() {
                  approvals[index]['status'] = 'rejected';
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Rejected for ${approvals[index]['studentName']}')),
                );
              },
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Section'),
        actions: [
          ElevatedButton.icon(
            onPressed: _approveAll,
            icon: const Icon(Icons.check_circle),
            label: const Text('Approve All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
      drawer: MainDrawer(context: context, isFaculty: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: approvals.length,
        itemBuilder: (context, index) {
          final approval = approvals[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              title: Text(
                approval['studentName'],
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                approval['approvalType'],
                style: textTheme.bodyMedium,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.info, color: Colors.blue),
                    onPressed: () {
                      // TODO: Implement view details
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('View details for ${approval['studentName']}')),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.check,
                      color: approval['status'] == 'approved' ? Colors.green : Colors.grey,
                    ),
                    onPressed: approval['status'] == 'pending' ? () => _approveSingle(index) : null,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: approval['status'] == 'rejected' ? Colors.red : Colors.grey,
                    ),
                    onPressed: approval['status'] == 'pending' ? () => _rejectSingle(index) : null,
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
