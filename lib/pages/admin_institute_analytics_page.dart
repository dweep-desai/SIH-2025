import 'package:flutter/material.dart';
import '../widgets/admin_drawer.dart';

class AdminInstituteAnalyticsPage extends StatelessWidget {
  const AdminInstituteAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Institute Analytics'),
      ),
      drawer: AdminDrawer(context: context),
      body: const Center(
        child: Text('Institute Analytics Page - Placeholder'),
      ),
    );
  }
}
