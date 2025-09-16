import 'package:flutter/material.dart';
import '../widgets/student_drawer.dart';
import '../widgets/achievement_widgets.dart';

// ---------------- ACHIEVEMENTS PAGE ----------------
class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // final ColorScheme colorScheme = theme.colorScheme; // Not directly used here, but good practice if needed

    // Sample Data - In a real app, this would come from a data source
    final List<String> userAchievements = [
      "Won 1st place in Inter-University Debate Competition",
      "Published a research paper on AI Ethics",
      "Successfully completed a 3-month internship at Tech Solutions Inc.",
      "Led the university's coding club for two consecutive years",
      "Volunteered as a mentor for underprivileged students"
    ];

    final List<String> userCertifications = [
      "Certified Flutter Developer - Google",
      "AWS Certified Cloud Practitioner",
      "Advanced Python Programming - Coursera",
      "Data Science Specialization - Johns Hopkins University"
    ];

    return Scaffold(
        appBar: AppBar(
          title: const Text("Achievements & Certifications"),
          // backgroundColor: colorScheme.surface, // Or primary for a colored AppBar
          // elevation: 0,
        ),
        drawer: MainDrawer(context: context),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), // Add padding around the content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Make cards take full width if desired
            children: [
              AchievementsCard(achievements: userAchievements),
              const SizedBox(height: 16), // Spacing between cards
              CertificationsCard(certifications: userCertifications),
              // You could add more sections or widgets here if needed
            ],
          ),
        )
    );
  }
}
