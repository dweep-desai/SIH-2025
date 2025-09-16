import 'package:flutter/material.dart';
import '../data/approval_data.dart';
import '../widgets/student_drawer.dart';

class ApprovalStatusPage extends StatelessWidget {
  const ApprovalStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            _buildStatusList('accepted'),
            _buildStatusList('rejected'),
            _buildStatusList('pending'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusList(String status) {
    var filteredRequests = approvalRequests.where((req) => req.status == status).toList();
    
    // Sort research papers and projects by points (highest first)
    filteredRequests.sort((a, b) {
      if ((a.category == 'Research papers' || a.category == 'Projects') &&
          (b.category == 'Research papers' || b.category == 'Projects')) {
        final aPoints = a.points ?? 0;
        final bPoints = b.points ?? 0;
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
            title: Text(request.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(request.description),
                Text('Category: ${request.category}'),
                if (request.points != null && 
                    (request.category == 'Research papers' || request.category == 'Projects'))
                  Text('Points: ${request.points}/50', 
                       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700])),
                Text('Submitted: ${request.submittedAt.toLocal()}'),
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
                          content: Text(request.rejectionReason ?? 'No reason provided.'),
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
