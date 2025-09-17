import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/faculty_drawer.dart';
import '../data/approval_data.dart';

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
      'approvalType': 'Projects',
      'title': 'Smart Campus App',
      'description': 'Flutter app for student services.',
      'link': 'https://example.com',
      'status': 'pending',
    },
    {
      'studentName': 'Bob Smith',
      'approvalType': 'Research papers',
      'title': 'AI in Education',
      'description': 'Exploring adaptive learning systems.',
      'pdfPath': '/path/to/paper.pdf',
      'status': 'pending',
    },
    {
      'studentName': 'Charlie Brown',
      'approvalType': 'Workshops',
      'title': 'Flutter Bootcamp',
      'description': 'Hands-on basics of Flutter.',
      'status': 'pending',
    },
  ];

  @override
  void initState() {
    super.initState();
    final int pendingNow = approvals.where((a) => a['status'] == 'pending').length;
    approvalStats.setPending(pendingNow);
  }

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
                int approvedNow = 0;
                setState(() {
                  for (var approval in approvals.where((a) => a['status'] == 'pending')) {
                    approval['status'] = 'approved';
                    approvedNow += 1;
                  }
                  approvals.removeWhere((a) => a['status'] != 'pending');
                });
                if (approvedNow > 0) {
                  approvalStats.incrementApproved(by: approvedNow);
                  for (int i = 0; i < approvedNow; i++) {
                    approvalStats.decrementPending();
                  }
                }
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
                setState(() {
                  approvals.removeAt(index);
                });
                approvalStats.incrementApproved();
                approvalStats.decrementPending();
                logFacultyApproval(
                  studentName: approvals[index > approvals.length ? approvals.length - 1 : (index.clamp(0, approvals.length))]['studentName'] ?? 'Student',
                  action: 'approved',
                  title: approvals.isNotEmpty ? approvals.first['title'] ?? 'Request' : 'Request',
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
                  approvals[index]['rejectionReason'] = reasonController.text.trim();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Rejected for ${approvals[index]['studentName']}')),
                );
                setState(() {
                  approvals.removeAt(index);
                });
                approvalStats.incrementRejected();
                approvalStats.decrementPending();
                logFacultyApproval(
                  studentName: approvals[index > approvals.length ? approvals.length - 1 : (index.clamp(0, approvals.length))]['studentName'] ?? 'Student',
                  action: 'rejected',
                  title: approvals.isNotEmpty ? approvals.first['title'] ?? 'Request' : 'Request',
                  reason: reasonController.text.trim(),
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
    // final ColorScheme colorScheme = theme.colorScheme; // not used currently
    final TextTheme textTheme = theme.textTheme;

    final colors = Theme.of(context).colorScheme;
    // Faculty theme: green
    final Color facultyPrimary = Colors.green.shade700;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Section'),
        backgroundColor: facultyPrimary,
        foregroundColor: Colors.white,
        actions: [
          ElevatedButton.icon(
            onPressed: _approveAll,
            icon: const Icon(Icons.check_circle),
            label: const Text('Approve All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
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
          final isPending = approval['status'] == 'pending';
          return Card(
            color: isPending ? colors.surfaceContainerLow : colors.surface,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              title: Text(
                approval['studentName'],
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colors.onSurface),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    approval['approvalType'],
                    style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.info, color: colors.primary),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Row(
                            children: [
                              Icon(Icons.info, color: colors.primary),
                              const SizedBox(width: 8),
                              const Text('Approval Details'),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Category: ${approval['approvalType']}'),
                              const SizedBox(height: 8),
                              if (approval['title'] != null) Text('Title: ${approval['title']}'),
                              if (approval['description'] != null) Text('Description: ${approval['description']}'),
                              if (approval['link'] != null) ...[
                                const SizedBox(height: 8),
                                Text('Link:', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                InkWell(
                                  onTap: () async {
                                    final uri = Uri.parse(approval['link']);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                                    }
                                  },
                                  child: Text(
                                    approval['link'],
                                    style: TextStyle(
                                      color: Colors.blue.shade700, 
                                      decoration: TextDecoration.underline,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                              if (approval['pdfPath'] != null) ...[
                                const SizedBox(height: 8),
                                Text('PDF Document:', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                InkWell(
                                  onTap: () async {
                                    final path = approval['pdfPath'] as String;
                                    try {
                                      final uri = Uri.parse(path);
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                                      }
                                    } catch (_) {}
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.picture_as_pdf, color: Colors.red.shade600, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Open PDF Document',
                                        style: TextStyle(
                                          color: Colors.red.shade600,
                                          decoration: TextDecoration.underline,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('Close'),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  Tooltip(
                    message: 'Approve',
                    child: IconButton(
                      icon: const Icon(Icons.check_circle),
                      color: isPending ? Colors.green.shade600 : colors.outline,
                      onPressed: isPending ? () => _approveSingle(index) : null,
                    ),
                  ),
                  Tooltip(
                    message: 'Reject',
                    child: IconButton(
                      icon: const Icon(Icons.cancel),
                      color: isPending ? Colors.red.shade600 : colors.outline,
                      onPressed: isPending ? () => _rejectSingle(index) : null,
                    ),
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
