import 'package:flutter/material.dart';
import 'login_page.dart'; // For navigating back to login
import '../widgets/form_components.dart';
import '../utils/responsive_utils.dart';

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
  final TextEditingController _confirmPasswordController = TextEditingController(); // Added for confirm password
  final _formKey = GlobalKey<FormState>();

  void _performRegistration() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement actual registration logic (e.g., API call)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful (Placeholder)')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()), // Navigate to login after registration
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withOpacity(0.25),
              colorScheme.surface.withOpacity(0.4),
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
              padding: ResponsiveUtils.getResponsivePadding(context),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveUtils.getResponsiveMaxWidth(context),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Category Selection
                    _buildCategorySelection(context, colorScheme, textTheme),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 30)),
                    
                    // Header
                    _buildHeader(context, colorScheme, textTheme),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 30)),
                    
                    // Registration Form
                    ModernFormComponents.buildModernCard(
                      context: context,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Email Field
                            ModernFormComponents.buildModernTextField(
                              controller: _emailController,
                              labelText: "Email Address",
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) return "Please enter your email";
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return "Please enter a valid email address";
                                }
                                return null;
                              },
                              context: context,
                            ),
                            
                            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                            
                            // Password Field
                            ModernFormComponents.buildModernTextField(
                              controller: _passwordController,
                              labelText: "Password",
                              prefixIcon: Icons.lock_outline,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) return "Please enter your password";
                                if (value.length < 6) return "Password must be at least 6 characters";
                                if (value.length > 50) return "Password must be less than 50 characters";
                                return null;
                              },
                              context: context,
                            ),
                            
                            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                            
                            // Confirm Password Field
                            ModernFormComponents.buildModernTextField(
                              controller: _confirmPasswordController,
                              labelText: "Confirm Password",
                              prefixIcon: Icons.lock_reset_outlined,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) return "Please confirm your password";
                                if (value != _passwordController.text) return "Passwords do not match";
                                return null;
                              },
                              context: context,
                            ),
                            
                            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
                            
                            // Register Button
                            SizedBox(
                              width: double.infinity,
                              child: ModernFormComponents.buildModernButton(
                                text: "CREATE ACCOUNT",
                                icon: Icons.app_registration_rounded,
                                onPressed: _performRegistration,
                                context: context,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
                    
                    // Login Link
                    _buildLoginLink(context, colorScheme, textTheme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelection(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 8)),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest.withOpacity(0.9),
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 8)),
          selectedColor: colorScheme.onPrimary,
          color: colorScheme.primary,
          fillColor: colorScheme.primary,
          borderColor: colorScheme.outline.withOpacity(0.3),
          selectedBorderColor: colorScheme.primary,
          constraints: BoxConstraints(
            minHeight: ResponsiveUtils.getResponsiveSpacing(context, 38),
            minWidth: ResponsiveUtils.getResponsiveSpacing(context, 80),
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16)),
              child: Text("STUDENT", style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16)),
              child: Text("FACULTY", style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16)),
              child: Text("ADMIN", style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        Icon(
          Icons.person_add_alt_1_outlined,
          size: ResponsiveUtils.getResponsiveIconSize(context, 60),
          color: colorScheme.primary,
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
        Text(
          "CREATE ACCOUNT",
          textAlign: TextAlign.center,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          },
          child: Text(
            "Login",
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
