import 'package:flutter/material.dart';
import '../widgets/faculty_drawer.dart';
import '../data/approval_data.dart';

class FacultyApprovalHistoryPage extends StatelessWidget {
  const FacultyApprovalHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approval History')),
      drawer: MainDrawer(context: context, isFaculty: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: facultyApprovalHistory.length,
        itemBuilder: (context, index) {
          final item = facultyApprovalHistory[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              title: Text(item.studentName),
              subtitle: Text('${item.action.toUpperCase()} • ${item.title}'),
              trailing: item.action == 'rejected' && item.reason != null
                  ? IconButton(
                      icon: const Icon(Icons.info, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Rejection Reason'),
                            content: Text(item.reason ?? 'No reason provided.'),
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
      ),
    );
  }
}



