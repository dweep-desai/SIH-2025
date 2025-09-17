import 'package:flutter/material.dart';
import '../widgets/admin_drawer.dart';

// ---------------- ADMIN DASHBOARD PAGE ----------------
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    // Admin theme: orange
    final Color adminPrimary = Colors.orange.shade700;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: adminPrimary,
        foregroundColor: Colors.white,
      ),
      drawer: AdminDrawer(context: context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                personalCard(context),
                const SizedBox(height: 16),
                // Add more cards if needed, but for now just personal card
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------- Widgets ----------------
  Widget personalCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(Icons.admin_panel_settings, size: 40, color: colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: 12),
            Text(
              "Admin User", // Replace with dynamic data
              style: textTheme.titleLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Admin ID: ADM001", // Example detail
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Divider(color: colorScheme.outline.withOpacity(0.5)),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(context, Icons.work, "Designation: System Administrator"),
                _buildDetailRow(context, Icons.business, "Department: IT Administration"),
                _buildDetailRow(context, Icons.email, "Email: admin@nirmauni.ac.in"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.secondary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
