import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart'; // Will be created
import 'semester_info_page.dart'; // Will be created
import 'grades_page.dart'; // Will be created
import 'achievements_page.dart'; // Will be created

// ---------------- DASHBOARD PAGE ----------------
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      drawer: MainDrawer(context: context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                quickButtons(),
                const SizedBox(height: 16),
                personalCard(),
                const SizedBox(height: 16),
                gpaCard(context),
                const SizedBox(height: 16),
                attendanceCard(context),
                const SizedBox(height: 16),
                gradesCard(context),
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
  Widget personalCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.indigo,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              "Tathya Barot",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Roll No: 24BCE294"),
                SizedBox(height: 4),
                Text("DOB: 28 Aug 2006"),
                SizedBox(height: 4),
                Text("Branch: Computer Science"),
                SizedBox(height: 4),
                Text("Institute: Nirma University"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget gpaCard(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              Text(
                "Current Semester: 3",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text("GPA: 8 / 10"),
              SizedBox(height: 5),
              LinearProgressIndicator(
                value: 0.8,
                backgroundColor: Colors.grey,
                color: Colors.indigo,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SemesterInfoPage()),
        );
      },
    );
  }

  Widget attendanceCard(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              Text(
                "Attendance Overview",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text("Overall: 85%"),
              SizedBox(height: 5),
              LinearProgressIndicator(
                value: 0.85,
                backgroundColor: Colors.grey,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SemesterInfoPage(startTabIndex: 1),
          ),
        );
      },
    );
  }

  Widget gradesCard(BuildContext context) {
    return GestureDetector(
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ListTile(
                leading: Icon(Icons.grade, color: Colors.indigo),
                title: Text("Grades"),
              ),
              Divider(),
              ListTile(title: Text("Data Structures - A")),
              ListTile(title: Text("Object Oriented - B+")),
              ListTile(title: Text("Digital Electronics - A-")),
              ListTile(title: Text("MFCS - A")),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GradesPage(startTabIndex: 0),
            ),
          );
        }
    );
  }

  Widget achievementsCard(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ListTile(
              leading: Icon(Icons.workspace_premium, color: Colors.indigo),
              title: Text("Achievements & Certifications"),
            ),
            Divider(),
            ListTile(
              title: Text(
                "Won 2nd place in International App Making Competition\n"
                    "Designed and created a professional website for MUN",
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AchievementsPage(),
            )
        );
      },
    );
  }

  Widget quickButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download, size: 28),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text("Download Profile", style: TextStyle(fontSize: 16)),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.analytics, size: 28),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text("View Analytics", style: TextStyle(fontSize: 16)),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
