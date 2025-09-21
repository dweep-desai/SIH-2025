import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/student_drawer.dart';
import '../widgets/form_components.dart';
import '../utils/responsive_utils.dart';
import '../utils/image_utils.dart';
import '../services/auth_service.dart';
import 'dashboard_page.dart';

class StudentEditProfilePage extends StatefulWidget {
  const StudentEditProfilePage({super.key});

  @override
  State<StudentEditProfilePage> createState() => _StudentEditProfilePageState();
}

class _StudentEditProfilePageState extends State<StudentEditProfilePage> {
  String? _selectedDomain1;
  String? _selectedDomain2;
  ImageProvider? _avatar;
  String? _selectedImagePath;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Valid domain options
  static const List<String> _validDomains = [
    'AI/ML',
    'Data Science',
    'Cybersecurity',
    'Web Development',
  ];

  // Method to validate domain values
  String? _validateDomain(String? domain) {
    if (domain == null || domain.isEmpty) return null;
    if (_validDomains.contains(domain)) return domain;
    return null;
  }

  // Helper method to get appropriate image provider
  ImageProvider? _getImageProvider(String? imagePath) {
    return ImageUtils.getImageProvider(imagePath);
  }

  Future<void> _loadUserData() async {
    final userData = _authService.getCurrentUser();
    if (userData != null) {
      
      setState(() {
        _userData = userData;
        // Handle empty strings and null values properly
        String domain1 = userData['domain1']?.toString() ?? '';
        String domain2 = userData['domain2']?.toString() ?? '';
        
        // Validate domain values before setting
        _selectedDomain1 = _validateDomain(domain1.isEmpty ? null : domain1);
        _selectedDomain2 = _validateDomain(domain2.isEmpty ? null : domain2);
        
        _avatar = userData['profile_photo'] != null && userData['profile_photo'].toString().isNotEmpty
            ? _getImageProvider(userData['profile_photo'].toString())
            : null;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512.0,
        maxHeight: 512.0,
        imageQuality: 85,
      );
      
      if (image != null) {
        
        setState(() {
          _avatar = FileImage(File(image.path));
        });
        // Store the image path for saving to database
        _selectedImagePath = image.path;
        
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_isLoading || !mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_userData != null) {
        String domain1ToSave = _selectedDomain1 ?? '';
        String domain2ToSave = _selectedDomain2 ?? '';
        
        // Debug _selectedImagePath before any operations
        
        // Update domains
        await _authService.updateDomains(
          _userData!['id'],
          _userData!['category'],
          domain1ToSave,
          domain2ToSave,
        );
        
        // Update profile photo if a new image was selected
        if (_selectedImagePath != null && _selectedImagePath!.isNotEmpty) {
          
          // For now, we'll store the local file path
          // In a production app, you'd upload to Firebase Storage and get a URL
          await _authService.updateProfilePhoto(
            _userData!['id'],
            _userData!['category'],
            _selectedImagePath!,
          );
          
        } else {
        }
        
        // Force refresh user data directly from Firebase to get latest updates
        await _authService.forceRefreshUserData();
        
        // Reload the profile page data to show updated values
        await _loadUserData();
      }

      // Feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 1200),
        ),
      );

      // Safe navigation: pop if possible, else replace with dashboard
      final canPop = Navigator.of(context).canPop();
      if (canPop) {
        Navigator.of(context).pop(true); // Pass true to indicate data was updated
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: ' + e.toString()),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      drawer: MainDrawer(context: context),
      body: SingleChildScrollView(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Photo Section
              _buildProfilePhotoSection(context, colorScheme, textTheme),
              
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
              
              // Domain Selection Section
              ModernFormComponents.buildFormSection(
                title: 'Domain Selection',
                subtitle: 'Choose your areas of expertise',
                icon: Icons.category_outlined,
                context: context,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Use responsive layout based on screen width
                    if (constraints.maxWidth < 600) {
                      // Stack vertically on smaller screens
                      return Column(
                        children: [
                          ModernFormComponents.buildModernDropdownField<String>(
                            value: _selectedDomain1,
                            items: const [
                              DropdownMenuItem(value: 'AI/ML', child: Text('AI/ML')),
                              DropdownMenuItem(value: 'Data Science', child: Text('Data Science')),
                              DropdownMenuItem(value: 'Cybersecurity', child: Text('Cybersecurity')),
                              DropdownMenuItem(value: 'Web Development', child: Text('Web Development')),
                            ],
                            labelText: 'Domain 1',
                            hintText: 'Select Domain 1',
                            prefixIcon: Icons.star_outline,
                            onChanged: (v) {
                              if (v != null && v == _selectedDomain2) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('This domain is already selected in Domain 2'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                return;
                              }
                              setState(() => _selectedDomain1 = v);
                            },
                            context: context,
                          ),
                          
                          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                          
                          ModernFormComponents.buildModernDropdownField<String>(
                            value: _selectedDomain2,
                            items: const [
                              DropdownMenuItem(value: 'AI/ML', child: Text('AI/ML')),
                              DropdownMenuItem(value: 'Data Science', child: Text('Data Science')),
                              DropdownMenuItem(value: 'Cybersecurity', child: Text('Cybersecurity')),
                              DropdownMenuItem(value: 'Web Development', child: Text('Web Development')),
                            ],
                            labelText: 'Domain 2 (optional)',
                            hintText: 'Select Domain 2',
                            prefixIcon: Icons.star_border_outlined,
                            onChanged: (v) {
                              if (v != null && v == _selectedDomain1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('This domain is already selected in Domain 1'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                return;
                              }
                              setState(() => _selectedDomain2 = v);
                            },
                            context: context,
                          ),
                        ],
                      );
                    } else {
                      // Use horizontal layout on larger screens
                      return Row(
                        children: [
                          Expanded(
                            child: ModernFormComponents.buildModernDropdownField<String>(
                              value: _selectedDomain1,
                              items: const [
                                DropdownMenuItem(value: 'AI/ML', child: Text('AI/ML')),
                                DropdownMenuItem(value: 'Data Science', child: Text('Data Science')),
                                DropdownMenuItem(value: 'Cybersecurity', child: Text('Cybersecurity')),
                                DropdownMenuItem(value: 'Web Development', child: Text('Web Development')),
                              ],
                              labelText: 'Domain 1',
                              hintText: 'Select Domain 1',
                              prefixIcon: Icons.star_outline,
                              onChanged: (v) {
                                if (v != null && v == _selectedDomain2) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('This domain is already selected in Domain 2'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  return;
                                }
                                setState(() => _selectedDomain1 = v);
                              },
                              context: context,
                            ),
                          ),
                          
                          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                          
                          Expanded(
                            child: ModernFormComponents.buildModernDropdownField<String>(
                              value: _selectedDomain2,
                              items: const [
                                DropdownMenuItem(value: 'AI/ML', child: Text('AI/ML')),
                                DropdownMenuItem(value: 'Data Science', child: Text('Data Science')),
                                DropdownMenuItem(value: 'Cybersecurity', child: Text('Cybersecurity')),
                                DropdownMenuItem(value: 'Web Development', child: Text('Web Development')),
                              ],
                              labelText: 'Domain 2 (optional)',
                              hintText: 'Select Domain 2',
                              prefixIcon: Icons.star_border_outlined,
                              onChanged: (v) {
                                if (v != null && v == _selectedDomain1) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('This domain is already selected in Domain 1'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  return;
                                }
                                setState(() => _selectedDomain2 = v);
                              },
                              context: context,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 32)),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ModernFormComponents.buildModernButton(
                  text: _isLoading ? 'Saving...' : 'Save Changes',
                  icon: Icons.save_outlined,
                  onPressed: _isLoading ? null : _saveProfile,
                  isLoading: _isLoading,
                  context: context,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhotoSection(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return ModernFormComponents.buildFormSection(
      title: 'Profile Photo',
      subtitle: 'Upload a photo to personalize your profile',
      icon: Icons.photo_camera_outlined,
      context: context,
      child: Center(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: ResponsiveUtils.getResponsiveIconSize(context, 48),
                backgroundImage: _avatar,
                backgroundColor: colorScheme.primaryContainer,
                child: _avatar == null
                    ? Icon(
                        Icons.person,
                        color: colorScheme.onPrimaryContainer,
                        size: ResponsiveUtils.getResponsiveIconSize(context, 40),
                      )
                    : null,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    color: colorScheme.onPrimary,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 20),
                  ),
                  onPressed: _isLoading ? null : _pickImage,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


