import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../utils/responsive_utils.dart';
import '../utils/navigation_utils.dart';
import 'dashboard_page.dart';
import 'faculty_dashboard_page.dart';
import 'admin_dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  int selectedIndex = 0;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _hasNetworkError = false;
  
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  
  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  String get _expectedCategory {
    if (selectedIndex == 1) return 'faculty';
    if (selectedIndex == 2) return 'admin';
    return 'student';
  }

  void _selectCategory(int index) {
    if (selectedIndex == index) return;
    
    setState(() {
      selectedIndex = index;
    });
    
    HapticFeedback.lightImpact();
  }

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
    _rotationController.forward();
  }


  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      
      
      // Validate email format
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        _showSnack('Please enter a valid email address.');
        return;
      }
      
      // Validate password
      if (password.length < 6 || password.length > 50) {
        _showSnack('Password must be between 6 and 50 characters.');
        return;
      }
      
      // Authenticate user using our custom service
      final user = await AuthService().authenticateUser(email, password, _expectedCategory);
      
      if (user != null) {
        
        // Route based on category
        Widget page = const DashboardPage();
        if (user['category'] == 'faculty') {
          page = const FacultyDashboardPage();
        } else if (user['category'] == 'admin') {
          page = const AdminDashboardPage();
        }
        
        if (!mounted) return;
        NavigationUtils.pushReplacementWithScale(
          context,
          page,
        );
      } else {
        _showSnack('Invalid email, password, or category mismatch. Please check your credentials.');
      }
    } catch (e) {
      
      // Handle specific Firebase Auth errors
      String errorMessage = 'Login failed. Please try again.';
      
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found with this email address.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password. Please try again.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email address format.';
            break;
          case 'user-disabled':
            errorMessage = 'This account has been disabled.';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many failed attempts. Please try again later.';
            break;
          case 'network-request-failed':
            errorMessage = 'Network error. Please check your internet connection.';
            break;
          case 'invalid-credential':
            errorMessage = 'Invalid credentials. Please check your email and password.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Email/password accounts are not enabled.';
            break;
          default:
            errorMessage = 'Authentication failed: ${e.message ?? 'Unknown error'}';
        }
              } else if (e.toString().contains('Query#get')) {
                errorMessage = 'Database connection error. Please check your internet connection and try again.';
              } else if (e.toString().contains('timeout')) {
                errorMessage = 'Connection timeout. Please check your internet connection.';
              } else if (e.toString().contains('network-request-failed')) {
                errorMessage = 'Network error. Please check your internet connection and try again.';
                _hasNetworkError = true;
              } else if (e.toString().contains('unreachable host')) {
                errorMessage = 'Cannot reach Firebase servers. Please check your internet connection.';
                _hasNetworkError = true;
              }
      
      _showSnack(errorMessage);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer,
              colorScheme.secondaryContainer,
              colorScheme.tertiaryContainer,
            ],
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo and Title
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: _buildAnimatedLogo(context, colorScheme, textTheme),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 40)),
                      
                      // Animated Category Selection
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _buildAnimatedCategorySelection(context, colorScheme, textTheme),
                        ),
                      ),
                      
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 30)),
                      
                      // Animated Login Form
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _buildAnimatedLoginForm(context, colorScheme, textTheme),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: ResponsiveUtils.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 24)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: ResponsiveUtils.getResponsiveElevation(context, 20),
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.1),
            blurRadius: ResponsiveUtils.getResponsiveElevation(context, 30),
            offset: const Offset(0, 12),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Animated rotating icon
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value * 0.1,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 60),
                    color: colorScheme.onPrimary,
                  ),
                ),
              );
            },
          ),
          
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
          
          // App title with gradient text
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              'SMART STUDENT HUB',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
          
          Text(
            'Welcome Back!',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCategorySelection(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: ResponsiveUtils.getResponsiveElevation(context, 15),
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
        child: Stack(
          children: [
            // Smooth sliding background
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              top: 0,
              left: (MediaQuery.of(context).size.width - ResponsiveUtils.getResponsivePadding(context).left * 2) / 3 * selectedIndex,
              child: Container(
                width: (MediaQuery.of(context).size.width - ResponsiveUtils.getResponsivePadding(context).left * 2) / 3,
                height: double.infinity, // Cover the entire height
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
                ),
              ),
            ),
            // Category buttons
            Row(
              children: [
                Expanded(child: _buildAnimatedCategoryButton(0, 'STUDENT', Icons.person_rounded, context, colorScheme, textTheme)),
                Expanded(child: _buildAnimatedCategoryButton(1, 'FACULTY', Icons.school_rounded, context, colorScheme, textTheme)),
                Expanded(child: _buildAnimatedCategoryButton(2, 'ADMIN', Icons.admin_panel_settings_rounded, context, colorScheme, textTheme)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCategoryButton(int index, String label, IconData icon, BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    final isSelected = selectedIndex == index;
    
    return Container(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _selectCategory(index);
          },
          child: Container(
            padding: ResponsiveUtils.getResponsivePadding(context).copyWith(
              left: ResponsiveUtils.getResponsivePadding(context).left / 2,
              right: ResponsiveUtils.getResponsivePadding(context).right / 2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Colors.black.withOpacity(0.1)
                        : colorScheme.primaryContainer.withOpacity(0.5),
                    shape: BoxShape.circle,
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected 
                        ? Colors.black 
                        : colorScheme.primary.withOpacity(0.6),
                    size: ResponsiveUtils.getResponsiveIconSize(context, 24),
                  ),
                ),
                
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                
                Text(
                  label,
                  style: textTheme.labelLarge?.copyWith(
                    color: isSelected 
                        ? Colors.black 
                        : colorScheme.primary.withOpacity(0.6),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLoginForm(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: ResponsiveUtils.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 24)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: ResponsiveUtils.getResponsiveElevation(context, 20),
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.05),
            blurRadius: ResponsiveUtils.getResponsiveElevation(context, 30),
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Form title
          Text(
            'Login to Your Account',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
          
          // Email Field
          _buildAnimatedTextField(
            controller: _emailController,
            labelText: 'Email Address',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            context: context,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          
          // Password Field
          _buildAnimatedTextField(
            controller: _passwordController,
            labelText: 'Password',
            prefixIcon: Icons.lock_outlined,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              if (value.length > 50) {
                return 'Password is too long';
              }
              return null;
            },
            context: context,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
          
          // Login Button
          _buildAnimatedLoginButton(context, colorScheme, textTheme),
          
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          
          // Network Error Retry Button
          if (_hasNetworkError)
            _buildAnimatedRetryButton(context, colorScheme, textTheme),
          
          // Forgot Password
          _buildForgotPasswordButton(context, colorScheme, textTheme),
        ],
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    required BuildContext context,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        style: textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
            borderSide: BorderSide(
              color: colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
            borderSide: BorderSide(
              color: colorScheme.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
            borderSide: BorderSide(
              color: colorScheme.error,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
            vertical: ResponsiveUtils.getResponsiveSpacing(context, 16),
          ),
          labelStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLoginButton(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: ResponsiveUtils.getResponsiveSpacing(context, 56),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: ResponsiveUtils.getResponsiveElevation(context, 4),
          shadowColor: colorScheme.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
          ),
        ),
        child: _isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: ResponsiveUtils.getResponsiveIconSize(context, 20),
                    height: ResponsiveUtils.getResponsiveIconSize(context, 20),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                  Text(
                    'Signing In...',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.login_rounded,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 20),
                  ),
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                  Text(
                    'LOGIN',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAnimatedRetryButton(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: ResponsiveUtils.getResponsiveSpacing(context, 48),
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveSpacing(context, 16)),
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _hasNetworkError = false;
          });
          _login();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          elevation: ResponsiveUtils.getResponsiveElevation(context, 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
          ),
        ),
        icon: Icon(
          Icons.refresh_rounded,
          size: ResponsiveUtils.getResponsiveIconSize(context, 18),
        ),
        label: Text(
          'Retry Login',
          style: textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return TextButton(
      onPressed: () {
        _showSnack('Please contact your administrator for password reset.');
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
          vertical: ResponsiveUtils.getResponsiveSpacing(context, 8),
        ),
      ),
      child: Text(
        'Forgot Password?',
        style: textTheme.labelLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }


  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}