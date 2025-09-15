import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart'; // Will be created
import '../widgets/achievement_widgets.dart'; // Will be created

// ---------------- ACHIEVEMENTS PAGE ----------------
class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Achievements"),
        ),
        drawer: MainDrawer(context: context),
        body: Column(
          children: [
            // Assuming these will be imported from achievement_widgets.dart
            AchievementsCard(achievements: ["Won 1st place in competitive programming", "Won 1st place in hackathon"]),
            CertificationsCard(certifications: ["AWS Course Certificate", "Flutter Course Certificate"])
          ],
        )
    );
  }
}
