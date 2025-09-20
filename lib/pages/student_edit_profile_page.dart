import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/student_drawer.dart';
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
  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else if (imagePath.startsWith('/') || imagePath.startsWith('C:')) {
      return FileImage(File(imagePath));
    } else {
      return NetworkImage(imagePath);
    }
  }

  Future<void> _loadUserData() async {
    final userData = _authService.getCurrentUser();
    if (userData != null) {
      print('🖼️ ==========================================');
      print('🖼️ STUDENT EDIT PROFILE LOAD DEBUG');
      print('🖼️ ==========================================');
      print('🖼️ User ID: ${userData['id']}');
      print('🖼️ User Category: ${userData['category']}');
      print('🖼️ Profile Photo Raw: ${userData['profile_photo']}');
      print('🖼️ Profile Photo Type: ${userData['profile_photo'].runtimeType}');
      print('🖼️ Profile Photo isNull: ${userData['profile_photo'] == null}');
      print('🖼️ Profile Photo isEmpty: ${userData['profile_photo'].toString().isEmpty}');
      print('🖼️ ==========================================');
      
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
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      
      if (image != null) {
        print('🖼️ ==========================================');
        print('🖼️ IMAGE PICKED SUCCESSFULLY');
        print('🖼️ ==========================================');
        print('🖼️ Image Path: "${image.path}"');
        print('🖼️ Image Name: "${image.name}"');
        print('🖼️ Image Size: ${await image.length()} bytes');
        print('🖼️ ==========================================');
        
        setState(() {
          _avatar = FileImage(File(image.path));
        });
        // Store the image path for saving to database
        _selectedImagePath = image.path;
        
        print('🖼️ _selectedImagePath set to: "$_selectedImagePath"');
        print('🖼️ _selectedImagePath length: ${_selectedImagePath?.length ?? 0}');
        print('🖼️ _selectedImagePath isNull: ${_selectedImagePath == null}');
        print('🖼️ _selectedImagePath isEmpty: ${_selectedImagePath?.isEmpty ?? true}');
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
        print('🖼️ ==========================================');
        print('🖼️ SAVE PROFILE DEBUG - START');
        print('🖼️ ==========================================');
        print('🖼️ _selectedImagePath: "$_selectedImagePath"');
        print('🖼️ _selectedImagePath isNull: ${_selectedImagePath == null}');
        print('🖼️ _selectedImagePath isEmpty: ${_selectedImagePath?.isEmpty ?? true}');
        print('🖼️ ==========================================');
        
        // Update domains
        await _authService.updateDomains(
          _userData!['id'],
          _userData!['category'],
          domain1ToSave,
          domain2ToSave,
        );
        
        // Update profile photo if a new image was selected
        if (_selectedImagePath != null && _selectedImagePath!.isNotEmpty) {
          print('🖼️ ==========================================');
          print('🖼️ STUDENT EDIT PROFILE SAVE DEBUG');
          print('🖼️ ==========================================');
          print('🖼️ Selected Image Path: "$_selectedImagePath"');
          print('🖼️ User ID: ${_userData!['id']}');
          print('🖼️ User Category: ${_userData!['category']}');
          print('🖼️ About to save profile photo to database...');
          print('🖼️ ==========================================');
          
          // For now, we'll store the local file path
          // In a production app, you'd upload to Firebase Storage and get a URL
          await _authService.updateProfilePhoto(
            _userData!['id'],
            _userData!['category'],
            _selectedImagePath!,
          );
          
          print('🖼️ ==========================================');
          print('🖼️ PROFILE PHOTO SAVE COMPLETED');
          print('🖼️ ==========================================');
        } else {
          print('🖼️ ==========================================');
          print('🖼️ NO IMAGE SELECTED - SKIPPING PROFILE PHOTO SAVE');
          print('🖼️ ==========================================');
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
    final colors = theme.colorScheme;
    // final texts = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      drawer: MainDrawer(context: context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: _avatar,
                    backgroundColor: colors.primaryContainer,
                    child: _avatar == null
                        ? Icon(Icons.person, color: colors.onPrimaryContainer, size: 40)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.surface, width: 2),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: _isLoading ? null : _pickImage,
                        iconSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Domain 1', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colors.onSurface)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.outline),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedDomain1,
                            isExpanded: true,
                            hint: const Text('Select Domain 1'),
                            items: const [
                              DropdownMenuItem(value: 'AI/ML', child: Text('AI/ML')),
                              DropdownMenuItem(value: 'Data Science', child: Text('Data Science')),
                              DropdownMenuItem(value: 'Cybersecurity', child: Text('Cybersecurity')),
                              DropdownMenuItem(value: 'Web Development', child: Text('Web Development')),
                            ],
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Domain 2 (optional)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colors.onSurface)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.outline),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedDomain2,
                            isExpanded: true,
                            hint: const Text('Select Domain 2'),
                            items: const [
                              DropdownMenuItem(value: 'AI/ML', child: Text('AI/ML')),
                              DropdownMenuItem(value: 'Data Science', child: Text('Data Science')),
                              DropdownMenuItem(value: 'Cybersecurity', child: Text('Cybersecurity')),
                              DropdownMenuItem(value: 'Web Development', child: Text('Web Development')),
                            ],
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _saveProfile,
              icon: _isLoading 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
              label: Text(_isLoading ? 'Saving...' : 'Save Changes'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
            ],
          ),
        ),
      ),
    );
  }
}


