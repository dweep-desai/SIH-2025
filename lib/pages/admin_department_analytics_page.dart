import 'package:flutter/material.dart';
import '../widgets/admin_drawer.dart';

class AdminDepartmentAnalyticsPage extends StatelessWidget {
  const AdminDepartmentAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Department Analytics'),
      ),
      drawer: AdminDrawer(context: context),
      body: const Center(
        child: Text('Department Analytics Page - Placeholder'),
      ),
    );
  }
}
