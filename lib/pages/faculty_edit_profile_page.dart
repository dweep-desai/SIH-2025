import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/faculty_drawer.dart';
import '../data/faculty_profile_data.dart';
import '../services/auth_service.dart';
import 'faculty_dashboard_page.dart';

class FacultyEditProfilePage extends StatefulWidget {
  const FacultyEditProfilePage({super.key});

  @override
  State<FacultyEditProfilePage> createState() => _FacultyEditProfilePageState();
}

class _FacultyEditProfilePageState extends State<FacultyEditProfilePage> {
  String? _primaryDomain;
  String? _secondaryDomain;
  ImageProvider? _avatar;
  String? _selectedImagePath;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
      setState(() {
        _userData = userData;
        _primaryDomain = FacultyProfileData.primaryDomain;
        _secondaryDomain = FacultyProfileData.secondaryDomain;
        _avatar = userData['profile_photo'] != null && userData['profile_photo'].toString().isNotEmpty
            ? _getImageProvider(userData['profile_photo'].toString())
            : FacultyProfileData.getProfileImageProvider();
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
        setState(() {
          _avatar = FileImage(File(image.path));
        });
        _selectedImagePath = image.path;
        FacultyProfileData.setProfileImagePath(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: ' + e.toString())),
        );
      }
    }
  }

  Future<void> _save() async {
    if (_isLoading || !mounted) return;
    setState(() { _isLoading = true; });
    try {

      FacultyProfileData.setPrimaryDomain(_primaryDomain);
      FacultyProfileData.setSecondaryDomain(_secondaryDomain);

      // Update profile photo in database if a new image was selected
      if (_selectedImagePath != null && _userData != null) {
        await _authService.updateProfilePhoto(
          _userData!['id'],
          _userData!['category'],
          _selectedImagePath!,
        );
      }

      // Force refresh user data
      await _authService.forceRefreshUserData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 1200),
        ),
      );

      final canPop = Navigator.of(context).canPop();
      if (canPop) {
        Navigator.of(context).pop(true);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const FacultyDashboardPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: ' + e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      drawer: MainDrawer(context: context, isFaculty: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
            LayoutBuilder(
              builder: (context, constraints) {
                // Use responsive layout based on screen width
                if (constraints.maxWidth < 600) {
                  // Stack vertically on smaller screens
                  return Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Primary Domain',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colors.onSurface),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: colors.outline),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            constraints: const BoxConstraints(minHeight: 48),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _primaryDomain,
                                isExpanded: true,
                                hint: const Text('Select Primary Domain'),
                                items: const [
                                  DropdownMenuItem(value: null, child: Text('Select Primary Domain')),
                                  DropdownMenuItem(value: 'AI/ML', child: Text('AI/ML')),
                                  DropdownMenuItem(value: 'Data Science', child: Text('Data Science')),
                                  DropdownMenuItem(value: 'Cybersecurity', child: Text('Cybersecurity')),
                                  DropdownMenuItem(value: 'Web Development', child: Text('Web Development')),
                                ],
                                onChanged: (v) {
                                  if (v != null && v == _secondaryDomain) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Already selected as Secondary Domain'), duration: Duration(seconds: 2)),
                                    );
                                    return;
                                  }
                                  setState(() => _primaryDomain = v);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Secondary Domain (optional)',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colors.onSurface),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: colors.outline),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            constraints: const BoxConstraints(minHeight: 48),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _secondaryDomain,
                                isExpanded: true,
                                hint: const Text('Select Secondary Domain'),
                                items: const [
                                  DropdownMenuItem(value: null, child: Text('Select Secondary Domain')),
                                  DropdownMenuItem(value: 'AI/ML', child: Text('AI/ML')),
                                  DropdownMenuItem(value: 'Data Science', child: Text('Data Science')),
                                  DropdownMenuItem(value: 'Cybersecurity', child: Text('Cybersecurity')),
                                  DropdownMenuItem(value: 'Web Development', child: Text('Web Development')),
                                ],
                                onChanged: (v) {
                                  if (v != null && v == _primaryDomain) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Already selected as Primary Domain'), duration: Duration(seconds: 2)),
                                    );
                                    return;
                                  }
                                  setState(() => _secondaryDomain = v);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  // Use horizontal layout on larger screens
                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Primary Domain',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colors.onSurface),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: colors.outline),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              constraints: const BoxConstraints(minHeight: 48),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _primaryDomain,
                                  isExpanded: true,
                                  hint: const Text('Select Primary Domain'),
                                  items: const [
                                    DropdownMenuItem(value: null, child: Text('Select Primary Domain')),
                                    DropdownMenuItem(value: 'AI/ML', child: Text('AI/ML')),
                                    DropdownMenuItem(value: 'Data Science', child: Text('Data Science')),
                                    DropdownMenuItem(value: 'Cybersecurity', child: Text('Cybersecurity')),
                                    DropdownMenuItem(value: 'Web Development', child: Text('Web Development')),
                                  ],
                                  onChanged: (v) {
                                    if (v != null && v == _secondaryDomain) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Already selected as Secondary Domain'), duration: Duration(seconds: 2)),
                                      );
                                      return;
                                    }
                                    setState(() => _primaryDomain = v);
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
                            Text(
                              'Secondary Domain (optional)',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colors.onSurface),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: colors.outline),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              constraints: const BoxConstraints(minHeight: 48),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _secondaryDomain,
                                  isExpanded: true,
                                  hint: const Text('Select Secondary Domain'),
                                  items: const [
                                    DropdownMenuItem(value: null, child: Text('Select Secondary Domain')),
                                    DropdownMenuItem(value: 'AI/ML', child: Text('AI/ML')),
                                    DropdownMenuItem(value: 'Data Science', child: Text('Data Science')),
                                    DropdownMenuItem(value: 'Cybersecurity', child: Text('Cybersecurity')),
                                    DropdownMenuItem(value: 'Web Development', child: Text('Web Development')),
                                  ],
                                  onChanged: (v) {
                                    if (v != null && v == _primaryDomain) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Already selected as Primary Domain'), duration: Duration(seconds: 2)),
                                      );
                                      return;
                                    }
                                    setState(() => _secondaryDomain = v);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _save,
              icon: _isLoading
                  ? const SizedBox(
                      width: 16, 
                      height: 16, 
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(_isLoading ? 'Saving...' : 'Save Changes'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(0, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


