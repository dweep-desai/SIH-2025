import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/db_service.dart';
import 'dashboard_page.dart';
import 'faculty_dashboard_page.dart';
import 'admin_dashboard_page.dart';

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
  bool _isLoading = false;

  String get _expectedRole {
    if (selectedIndex == 1) return 'faculty';
    if (selectedIndex == 2) return 'admin';
    return 'student';
  }

  void _devLogin() {
    Widget page = const DashboardPage();
    if (selectedIndex == 1) {
      page = const FacultyDashboardPage();
    } else if (selectedIndex == 2) {
      page = const AdminDashboardPage();
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Enforce role via Realtime DB: users/{uid}/role must match selected tab
      final uid = cred.user!.uid;
      final DatabaseReference roleRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://hackproj-190-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref('users/$uid/role');
      final DataSnapshot roleSnap = await roleRef.get();
      String? storedRole = roleSnap.exists ? (roleSnap.value as String?) : null;
      if (storedRole == null) {
        // Attempt to infer role based on presence in students/faculty/admins collections
        final inferred = await RealtimeDbService.instance.getUserRoleByEmail(email);
        if (inferred == AppUserRole.unknown) {
          await FirebaseAuth.instance.signOut();
          _showSnack('Account not configured. Missing role for this user.');
          return;
        }
        storedRole = inferred.name; // 'student' | 'faculty' | 'admin'
        // Persist the inferred role for next time
        await FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://hackproj-190-default-rtdb.asia-southeast1.firebasedatabase.app',
        ).ref('users/$uid/role').set(storedRole);
      }
      if (storedRole != _expectedRole) {
        await FirebaseAuth.instance.signOut();
        _showSnack('Unable to authenticate');
        return;
      }

      // Route based on role
      Widget page = const DashboardPage();
      if (storedRole == 'faculty') {
        page = const FacultyDashboardPage();
      } else if (storedRole == 'admin') {
        page = const AdminDashboardPage();
      }
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
    } on FirebaseAuthException catch (e) {
      final message = _mapAuthError(e.code);
      _showSnack(message);
    } catch (_) {
      _showSnack('Login failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-disabled':
        return 'This user is disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return 'Authentication error: $code';
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // Registration flow removed per requirements

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    // Role-themed primary colors
    final Color rolePrimary = selectedIndex == 0
        ? Colors.blue.shade800
        : selectedIndex == 1
            ? const Color.fromARGB(255, 25, 107, 30)
            : Colors.orange.shade700;
    final Color rolePrimaryLight = rolePrimary.withOpacity(0.25);
    final Color roleSurfaceBlend = colorScheme.surface.withOpacity(0.4);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              rolePrimaryLight,
              roleSurfaceBlend,
              colorScheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch, 
                children: [
                  Center( 
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLowest.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ToggleButtons(
                        isSelected: [
                          selectedIndex == 0,
                          selectedIndex == 1,
                          selectedIndex == 2,
                        ],
                        onPressed: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        selectedColor: Colors.white,
                        color: rolePrimary,
                        fillColor: rolePrimary,
                        borderColor: rolePrimary.withOpacity(0.3),
                        selectedBorderColor: rolePrimary,
                        constraints: const BoxConstraints(minHeight: 38),
                        children: const [
                          Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text("STUDENT")),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text("FACULTY")),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text("ADMIN")),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: Icon(
                      Icons.school_outlined,
                      key: ValueKey<int>(selectedIndex),
                      size: 60,
                      color: rolePrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "SMART STUDENT HUB",
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: rolePrimary,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: colorScheme.surfaceContainerLow, 
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: "Email Address",
                                prefixIcon: Icon(Icons.email_outlined, color: rolePrimary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: rolePrimary, width: 2),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceContainerHighest,
                                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return "Please enter your email";
                                if (!value.contains("@")) return "Enter a valid email";
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock_outlined, color: rolePrimary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: rolePrimary, width: 2),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceContainerHighest,
                                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) return "Please enter your password";
                                if (value.length < 6) return "Password must be at least 6 characters";
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              icon: _isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.login_rounded, color: Colors.white),
                              label: const Text("LOGIN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                backgroundColor: rolePrimary,
                              ),
                              onPressed: _isLoading ? null : _login,
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                side: BorderSide(color: rolePrimary.withOpacity(0.7)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: _isLoading ? null : _devLogin,
                              child: Text("Developer Login", style: TextStyle(fontSize: 15, color: rolePrimary)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _isLoading ? null : () { /* TODO: Implement Forgot Password */ },
                      child: Text("Forgot Password?", style: TextStyle(color: rolePrimary.withOpacity(0.9))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
