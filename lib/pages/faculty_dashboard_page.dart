import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';
import 'achievements_page.dart'; // Assuming faculty can have achievements

// ---------------- FACULTY DASHBOARD PAGE ----------------
class FacultyDashboardPage extends StatelessWidget {
  const FacultyDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Faculty Dashboard"),
      ),
      drawer: MainDrawer(context: context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                quickButtons(context),
                const SizedBox(height: 16),
                personalCard(context),
                const SizedBox(height: 16),
                researchPapersCard(context),
                const SizedBox(height: 16),
                studentResearchCard(context),
                const SizedBox(height: 16),
                achievementsCard(context),
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
              child: Icon(Icons.person, size: 40, color: colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: 12),
            Text(
              "Dr. John Doe", // Replace with dynamic data
              style: textTheme.titleLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Faculty ID: FAC001", // Example detail
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Divider(color: colorScheme.outline.withOpacity(0.5)),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(context, Icons.work, "Designation: Professor - Computer Science"),
                _buildDetailRow(context, Icons.business, "Department: Computer Science"),
                _buildDetailRow(context, Icons.school, "Educational Qualifications: PhD in Computer Science"),
                _buildDetailRow(context, Icons.email, "Email: john.doe@nirmauni.ac.in"),
                Row(
                  children: [
                    Icon(Icons.domain, size: 18, color: colorScheme.secondary),
                    const SizedBox(width: 8),
                    Text("Domain: ", style: textTheme.bodyMedium),
                    Expanded(
                      child: DropdownButton<String>(
                        value: "Machine Learning", // Default value
                        items: ["Machine Learning", "Data Science", "AI", "Cybersecurity"].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          // TODO: Handle domain change
                        },
                        style: textTheme.bodyMedium,
                        underline: Container(),
                      ),
                    ),
                  ],
                ),
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

  Widget researchPapersCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    // Dummy data - replace with actual data
    final papers = [
      "Paper on Machine Learning in Healthcare - IEEE Conference 2023",
      "Research on AI Ethics - ACM Journal 2022",
      "Project on Data Mining Techniques - Springer 2021"
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Icon(Icons.article, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text("Research Papers/Projects/Publications", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                ],
              ),
            ),
            const Divider(height: 16, indent: 16, endIndent: 16),
            ...papers.map((paper) => ListTile(
              dense: true,
              title: Text(paper, style: textTheme.bodyMedium),
              trailing: Icon(Icons.arrow_forward_ios, size: 14, color: colorScheme.onSurfaceVariant),
            )),
            if (papers.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: Text("No research papers to display", style: textTheme.bodyMedium)),
              ),
          ],
        ),
      ),
    );
  }

  Widget studentResearchCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    // Dummy data - replace with actual data
    final studentResearches = [
      {
        "topic": "AI in Education",
        "conference": "ICML 2023",
        "students": "Alice, Bob"
      },
      {
        "topic": "Blockchain Security",
        "conference": "IEEE Security 2022",
        "students": "Charlie, David"
      }
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Icon(Icons.group, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text("Student Research", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                ],
              ),
            ),
            const Divider(height: 16, indent: 16, endIndent: 16),
            ...studentResearches.map((research) => ListTile(
              dense: true,
              title: Text("${research['topic']} - ${research['conference']}", style: textTheme.bodyMedium),
              subtitle: Text("Students: ${research['students']}", style: textTheme.bodySmall),
              trailing: Icon(Icons.arrow_forward_ios, size: 14, color: colorScheme.onSurfaceVariant),
            )),
            if (studentResearches.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: Text("No student research to display", style: textTheme.bodyMedium)),
              ),
          ],
        ),
      ),
    );
  }

  Widget achievementsCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    // Dummy data
    final achievements = ["Best Teacher Award 2023", "Published 10+ Papers"];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AchievementsPage()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                     Icon(Icons.workspace_premium, color: colorScheme.primary),
                     const SizedBox(width: 8),
                     Text("Achievements & Awards", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                  ],
                ),
              ),
              const Divider(height: 16, indent: 16, endIndent: 16),
              ...achievements.map((achievement) => ListTile(
                dense: true,
                title: Text(achievement, style: textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Icon(Icons.arrow_forward_ios, size: 14, color: colorScheme.onSurfaceVariant),
              )),
              if (achievements.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: Text("No achievements to display", style: textTheme.bodyMedium)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget quickButtons(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () { /* TODO: Implement Download Profile */ },
            icon: const Icon(Icons.download, size: 20),
            label: Text("Download Profile", style: textTheme.labelLarge),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () { /* TODO: Implement View Analytics */ },
            icon: const Icon(Icons.analytics, size: 20),
            label: Text("View Analytics", style: textTheme.labelLarge),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
