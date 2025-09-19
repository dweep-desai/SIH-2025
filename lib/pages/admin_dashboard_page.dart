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
                quickAccessButtons(context),
                const SizedBox(height: 16),
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

  Widget quickAccessButtons(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final Color buttonColor = Colors.grey.shade600;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.dashboard_customize, color: buttonColor),
                const SizedBox(width: 8),
                Text(
                  "Quick Access",
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _buildQuickButton(
                  context,
                  "Institute Analytics",
                  Icons.analytics,
                  buttonColor,
                  () {
                    // TODO: Navigate to Institute Analytics
                  },
                ),
                _buildQuickButton(
                  context,
                  "Department Analytics",
                  Icons.bar_chart,
                  buttonColor,
                  () {
                    // TODO: Navigate to Department Analytics
                  },
                ),
                _buildQuickButton(
                  context,
                  "Faculty Search",
                  Icons.search,
                  buttonColor,
                  () {
                    // TODO: Navigate to Faculty Search
                  },
                ),
                _buildQuickButton(
                  context,
                  "Student Search",
                  Icons.search,
                  buttonColor,
                  () {
                    // TODO: Navigate to Student Search
                  },
                ),
                _buildQuickButton(
                  context,
                  "Add New Student",
                  Icons.person_add,
                  buttonColor,
                  () {
                    // TODO: Navigate to Add New Student
                  },
                ),
                _buildQuickButton(
                  context,
                  "Add New Faculty",
                  Icons.person_add_outlined,
                  buttonColor,
                  () {
                    // TODO: Navigate to Add New Faculty
                  },
                ),
                _buildQuickButton(
                  context,
                  "Database Link",
                  Icons.link,
                  buttonColor,
                  () {
                    // TODO: Navigate to Database Link
                  },
                ),
                _buildQuickButton(
                  context,
                  "System Settings",
                  Icons.settings,
                  buttonColor,
                  () {
                    // TODO: Navigate to System Settings
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: colorScheme.onSurface),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
