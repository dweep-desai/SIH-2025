import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Smart Student Hub",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const LoginPage(),
    );
  }
}

// ---------------- GLOBAL DRAWER ----------------
class MainDrawer extends StatelessWidget {
  final BuildContext context;

  const MainDrawer({super.key, required this.context});

  void _signOut() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _semInfo() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => SemesterInfo()),
    );
  }

  void _dashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardPage()),
    );
  }

  void _grades() {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (_) => const Grades()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Center(
              child: Text(
                "Smart Student Hub",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: _dashboard,
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("Semester Info"),
            onTap: _semInfo,
          ),
          ListTile(
            leading: const Icon(Icons.grade),
            title: const Text("Grades"),
            onTap: _grades,
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text("Achievements"),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text("Search Faculty"),
          ),
          ListTile(
            leading: const Icon(Icons.lock_open),
            title: const Text("Sign Out"),
            onTap: _signOut,
          ),
        ],
      ),
    );
  }
}

// ---------------- LOGIN PAGE ----------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int selectedIndex = 0;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _devLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardPage()),
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    }
  }

  void _register() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Role selector
            Container(
              color: Colors.indigo[50],
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ToggleButtons(
                isSelected: [
                  selectedIndex == 0,
                  selectedIndex == 1,
                  selectedIndex == 2
                ],
                onPressed: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                borderRadius: BorderRadius.circular(10),
                selectedColor: Colors.white,
                color: Colors.indigo,
                fillColor: Colors.indigo,
                constraints: const BoxConstraints(
                  minWidth: 100,
                  minHeight: 40,
                ),
                children: const [
                  Text("STUDENT"),
                  Text("FACULTY"),
                  Text("ADMIN"),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // App Logo
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 60),
              decoration: BoxDecoration(
                color: Colors.indigo[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  "SMART STUDENT HUB",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        if (!value.contains("@")) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.indigo,
                        ),
                        onPressed: _login,
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),

                    SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.indigo,
                        ),
                        onPressed: _devLogin,
                        child: const Text(
                          "DEVELOPER LOGIN",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Register & Forgot Password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _register,
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- REGISTRATION PAGE ----------------
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int selectedIndex = 0;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: MainDrawer(context: context),
      body: SafeArea(
        child: Column(
          children: [
            // Role selector
            Container(
              color: Colors.indigo[50],
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ToggleButtons(
                isSelected: [
                  selectedIndex == 0,
                  selectedIndex == 1,
                  selectedIndex == 2
                ],
                onPressed: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                borderRadius: BorderRadius.circular(10),
                selectedColor: Colors.white,
                color: Colors.indigo,
                fillColor: Colors.indigo,
                constraints: const BoxConstraints(
                  minWidth: 100,
                  minHeight: 40,
                ),
                children: const [
                  Text("STUDENT"),
                  Text("FACULTY"),
                  Text("ADMIN"),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Logo
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 60),
              decoration: BoxDecoration(
                color: Colors.indigo[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  "REGISTRATION",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        if (!value.contains("@")) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.indigo,
                        ),
                        onPressed: _login,
                        child: const Text(
                          "REGISTER",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}

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
                achievementsCard(),
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
        MaterialPageRoute(builder: (context) => const SemesterInfo()),
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
          builder: (context) => const SemesterInfo(startTabIndex: 1), 
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
          builder: (context) => const Grades(startTabIndex: 3), 
        ),
        );
      }
    );
  }

  Widget achievementsCard() {
    return Card(
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


// ---------------- SEMESTER INFO PAGE ----------------
class SemesterInfo extends StatelessWidget {
  final int startTabIndex;

  const SemesterInfo({super.key, this.startTabIndex = 0});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: startTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Semester Info"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.book), text: "Courses"),
              Tab(icon: Icon(Icons.check_circle), text: "Attendance"),
              Tab(icon: Icon(Icons.grade), text: "Grades"),
            ],
          ),
        ),
        drawer: MainDrawer(context: context),
        body: const TabBarView(
          children: [
            CoursesTab(),
            AttendanceTab(),
            GradesTab(),
          ],
        ),
      ),
    );
  }
}



// ---------------- OVERVIEW TAB ----------------
class SemesterOverviewTab extends StatelessWidget {
  const SemesterOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    double progress = 90 / 120; // Example credits

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Semester: 5",
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text("GPA: 8.3",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          )),
                  const SizedBox(height: 16),
                  Text("Credits Completed: 90 / 120"),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- COURSES TAB ----------------
class CoursesTab extends StatelessWidget {
  const CoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      {"name": "Data Structures", "grade": "A", "credits": 4},
      {"name": "Operating Systems", "grade": "B+", "credits": 3},
      {"name": "Database Systems", "grade": "A-", "credits": 3},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(course["name"].toString()),
            subtitle: Text("Credits: ${course["credits"]}"),
            trailing: Text(
              course["grade"].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------- ATTENDANCE TAB ----------------

class AttendanceTab extends StatelessWidget {
  const AttendanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> attendance = [
      {"course": "Data Structures", "present": 42, "total": 50},
      {"course": "Operating Systems", "present": 35, "total": 45},
      {"course": "Database Systems", "present": 40, "total": 50},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: attendance.length,
      itemBuilder: (context, index) {
        final course = attendance[index];
        final int present = course["present"] as int;
        final int total = course["total"] as int;
        final double percentage = present / total;

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(course["course"].toString()),
            subtitle: Text("Attendance: $present/$total"),
            trailing: Text(
              "${(percentage * 100).toStringAsFixed(1)}%",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: percentage >= 0.75 ? Colors.green : Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }
}



// Attendance
class AttendanceCard extends StatelessWidget {
  final double percentage;

  AttendanceCard({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Attendance", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage / 100,
              borderRadius: BorderRadius.circular(8),
              minHeight: 12,
            ),
            SizedBox(height: 8),
            Text("$percentage% present"),
          ],
        ),
      ),
    );
  }
}

// ---------------- GRADES TAB ----------------
class GradesTab extends StatelessWidget {
  const GradesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> grades = [
      {"course": "Data Structures", "grade": "A", "credits": 4},
      {"course": "Operating Systems", "grade": "B+", "credits": 3},
      {"course": "Database Systems", "grade": "A-", "credits": 3},
      {"course": "Software Engineering", "grade": "A", "credits": 3},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ListTile(
                leading: Icon(Icons.grade, color: Colors.indigo),
                title: Text("Grades"),
              ),
              const Divider(height: 1),
              ...grades.map((g) => ListTile(
                    title: Text(g['course'].toString()),
                    trailing: Text(
                      g['grade'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

// Achievements
class AchievementsCard extends StatelessWidget {
  final List<String> achievements;

  AchievementsCard({required this.achievements});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Achievements", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            ...achievements.map((a) => ListTile(
                  leading: Icon(Icons.emoji_events, color: Colors.amber),
                  title: Text(a),
                )),
          ],
        ),
      ),
    );
  }
}

// Certifications
class CertificationsCard extends StatelessWidget {
  final List<String> certifications;

  CertificationsCard({required this.certifications});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Certifications", style: Theme.of(context).textTheme.titleLarge),
            ...certifications.map((c) => ListTile(
                  leading: Icon(Icons.verified, color: Colors.green),
                  title: Text(c),
                )),
          ],
        ),
      ),
    );
  }
}

// ---------------- GRADES PAGE ----------------
class Grades extends StatelessWidget {
  final int startTabIndex;
  final int currentSemester; // <- pass this to control number of tabs

  const Grades({
    super.key,
    this.startTabIndex = 0,
    this.currentSemester = 4, // example: current sem is 5
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: currentSemester, // number of tabs = current semester
      initialIndex: startTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Grades"),
          bottom: TabBar(
            isScrollable: true, // allows many tabs to scroll
            tabs: List.generate(
              currentSemester,
              (index) => Tab(text: "Sem ${index + 1}"),
            ),
          ),
        ),
        drawer: MainDrawer(context: context),
        body: TabBarView(
          children: List.generate(
            currentSemester,
            (index) => SemGradesTab(semester: index + 1),
          ),
        ),
      ),
    );
  }
}

// ---------------- TAB CONTENT ----------------
class SemGradesTab extends StatelessWidget {
  final int semester;

  const SemGradesTab({super.key, required this.semester});

  @override
  Widget build(BuildContext context) {
    // Mock grades - you can replace with real semester-specific data later
    final List<Map<String, dynamic>> grades = [
      {"course": "Sub 1", "grade": "A", "credits": 4},
      {"course": "Sub 2", "grade": "B+", "credits": 3},
      {"course": "Sub 3", "grade": "A-", "credits": 3},
      {"course": "Sub 4", "grade": "A", "credits": 3},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(Icons.grade, color: Colors.indigo),
                title: Text("Grades - Semester $semester"),
              ),
              const Divider(height: 1),
              ...grades.map((g) => ListTile(
                    title: Text(g['course'].toString()),
                    trailing: Text(
                      g['grade'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
