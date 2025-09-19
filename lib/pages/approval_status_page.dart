import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import '../widgets/student_drawer.dart';

class ApprovalStatusPage extends StatefulWidget {
  const ApprovalStatusPage({super.key});

  @override
  State<ApprovalStatusPage> createState() => _ApprovalStatusPageState();
}

class _ApprovalStatusPageState extends State<ApprovalStatusPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Stream<DatabaseEvent>? _studentStream;
  Map<String, dynamic>? _studentData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeStream();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeStream() {
    final db = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://hackproj-190-default-rtdb.asia-southeast1.firebasedatabase.app',
    );
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      final Query q = db.ref('students').orderByChild('email').equalTo(email);
      _studentStream = q.onValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Status'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Accepted'),
            Tab(text: 'Rejected'),
            Tab(text: 'Pending'),
          ],
        ),
      ),
      drawer: MainDrawer(context: context),
      body: _studentStream == null
          ? const Center(child: Text('Not signed in'))
          : StreamBuilder<DatabaseEvent>(
              stream: _studentStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final DataSnapshot snap = snapshot.data!.snapshot;
                if (!snap.exists || snap.value is! Map) {
                  return const Center(child: Text('No requests found.'));
                }
                final Map m = snap.value as Map;
                if (m.isEmpty) return const Center(child: Text('No requests found.'));
                final dynamic first = m.values.first;
                Map approvals = {};
                if (first is Map) {
                  approvals = (first['approvals'] is Map) ? first['approvals'] as Map : {};
                }
                _studentData = Map<String, dynamic>.from(approvals);

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildStatusList('accepted'),
                    _buildStatusList('rejected'),
                    _buildStatusList('pending'),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildStatusList(String status) {
    if (_studentData == null) {
      return const Center(child: Text('No data available'));
    }

    final Map statusMap = _studentData![status] is Map ? _studentData![status] as Map : {};
    final List<Map<String, dynamic>> items = statusMap.values
        .where((e) => e != null)
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    
    // Sort for research/projects by points desc if present
    items.sort((a, b) {
      final ca = (a['category'] ?? '').toString();
      final cb = (b['category'] ?? '').toString();
      if ((ca == 'Research papers' || ca == 'Projects') && (cb == 'Research papers' || cb == 'Projects')) {
        final pa = (a['pointsAssigned'] is num) ? (a['pointsAssigned'] as num).toDouble() : 0.0;
        final pb = (b['pointsAssigned'] is num) ? (b['pointsAssigned'] as num).toDouble() : 0.0;
        return pb.compareTo(pa);
      }
      return 0;
    });

    if (items.isEmpty) {
      return const Center(child: Text('No requests found.'));
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final request = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          child: ListTile(
            title: Text(request['title']?.toString() ?? request['studentName']?.toString() ?? 'Request'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (request['description'] != null) Text(request['description'].toString()),
                Text('Category: ${request['category']}'),
                if (status == 'rejected' && request['reason'] != null)
                  Text('Reason: ${request['reason']}'),
                if (request['pointsAssigned'] != null)
                  Text('Points: ${request['pointsAssigned']}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700])),
              ],
            ),
          ),
        );
      },
    );
  }
}
