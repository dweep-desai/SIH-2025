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

  Future<void> _loadUserData() async {
    final userData = _authService.getCurrentUser();
    if (userData != null) {
      setState(() {
        _userData = userData;
        // Handle empty strings and null values properly
        _selectedDomain1 = userData['domain1']?.toString().isEmpty == true ? null : userData['domain1']?.toString();
        _selectedDomain2 = userData['domain2']?.toString().isEmpty == true ? null : userData['domain2']?.toString();
        _avatar = userData['profile_photo'] != null && userData['profile_photo'].toString().isNotEmpty
            ? NetworkImage(userData['profile_photo'].toString())
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
        setState(() {
          _avatar = FileImage(File(image.path));
        });
        // Store the image path locally (in a real app, you'd upload to Firebase Storage)
        print('Profile image selected: ${image.path}');
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
      // Debug: starting save
      print('[EditProfile] Save tapped');

      // Update domains in Firebase
      print('[EditProfile] Selected domain1: ${_selectedDomain1 ?? 'null'}');
      print('[EditProfile] Selected domain2: ${_selectedDomain2 ?? 'null'}');
      print('[EditProfile] User ID: ${_userData?['id']}');
      print('[EditProfile] User category: ${_userData?['category']}');
      
      if (_userData != null) {
        print('[EditProfile] Calling updateDomains...');
        await _authService.updateDomains(
          _userData!['id'],
          _userData!['category'],
          _selectedDomain1 ?? '',
          _selectedDomain2 ?? '',
        );
        print('[EditProfile] Domains updated in Firebase');
        
        // Refresh user data to get latest updates
        print('[EditProfile] Refreshing current user...');
        await _authService.refreshCurrentUser();
        print('[EditProfile] User data refreshed');
      } else {
        print('[EditProfile] ERROR: _userData is null!');
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
      print('[EditProfile] Navigator.canPop: ' + canPop.toString());
      if (canPop) {
        print('[EditProfile] Popping back to previous screen with refresh flag');
        Navigator.of(context).pop(true); // Pass true to indicate data was updated
      } else {
        print('[EditProfile] No back stack. Replacing with DashboardPage');
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
      print('[EditProfile] Error while saving: ' + e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('[EditProfile] Save flow finished');
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
                            value: _selectedDomain1?.isEmpty == true ? null : _selectedDomain1,
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
                            value: _selectedDomain2?.isEmpty == true ? null : _selectedDomain2,
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


