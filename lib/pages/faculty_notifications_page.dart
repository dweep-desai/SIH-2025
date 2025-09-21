import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/auth_service.dart';
import '../widgets/faculty_drawer.dart';
import 'faculty_approval_page.dart';

class FacultyNotificationsPage extends StatefulWidget {
  const FacultyNotificationsPage({super.key});

  @override
  State<FacultyNotificationsPage> createState() => _FacultyNotificationsPageState();
}

class _FacultyNotificationsPageState extends State<FacultyNotificationsPage> {
  final AuthService _authService = AuthService();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  bool _isLoading = true;
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      setState(() => _isLoading = true);
      
      final userData = await _authService.forceRefreshUserData();
      if (userData == null) return;

      final facultyId = userData['faculty_id'] ?? userData['id'];

      // Get approval requests from faculty's approval_section
      final snapshot = await _databaseRef.child('faculty').child(facultyId).child('approval_section').get();
      
      if (snapshot.exists) {
        final approvalData = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        
        _notifications = [];
        
        approvalData.forEach((key, value) {
          if (value is Map) {
            final approval = Map<String, dynamic>.from(value);
            _notifications.add({
              'id': key,
              'student_name': approval['student_name'] ?? 'Unknown Student',
              'title': approval['title'] ?? approval['project_name'] ?? 'Approval Request',
              'type': approval['category'] ?? 'Unknown Type',
              'timestamp': approval['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
              'status': approval['status'] ?? 'pending',
            });
          }
        });
        
        // Sort by timestamp (newest first)
        _notifications.sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));
        
      } else {
        _notifications = [];
      }
      
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _goToApprovalSection() {
    Navigator.pop(context); // Close notifications page
    // Navigate to approval section
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FacultyApprovalPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadNotifications,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Notifications',
          ),
        ],
      ),
      drawer: MainDrawer(context: context, isFaculty: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? _buildEmptyState()
              : _buildNotificationsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications currently',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You will receive notifications when students send approval requests.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.green.shade50,
          child: Text(
            '${_notifications.length} notification${_notifications.length == 1 ? '' : 's'}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              final notification = _notifications[index];
              return _buildNotificationCard(notification);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final timestamp = DateTime.fromMillisecondsSinceEpoch(notification['timestamp'] as int);
    final timeAgo = _getTimeAgo(timestamp);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(
            Icons.approval,
            color: Colors.green.shade700,
          ),
        ),
        title: Text(
          notification['student_name'] as String,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification['title'] as String,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Type: ${notification['type'] as String}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              timeAgo,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 11,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: _goToApprovalSection,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: const Text(
            'Go to Approval',
            style: TextStyle(fontSize: 12),
          ),
        ),
        isThreeLine: true,
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}
