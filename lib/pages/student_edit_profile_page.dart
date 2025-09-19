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
    print('⚠️ Invalid domain value: "$domain", setting to null');
    return null;
  }

  Future<void> _loadUserData() async {
    final userData = _authService.getCurrentUser();
    if (userData != null) {
      setState(() {
        _userData = userData;
        // Handle empty strings and null values properly
        String domain1 = userData['domain1']?.toString() ?? '';
        String domain2 = userData['domain2']?.toString() ?? '';
        
        print('🔍 Loading domains - domain1: "$domain1", domain2: "$domain2"');
        print('🔍 Domain1 isEmpty: ${domain1.isEmpty}');
        print('🔍 Domain2 isEmpty: ${domain2.isEmpty}');
        
        // Validate domain values before setting
        _selectedDomain1 = _validateDomain(domain1.isEmpty ? null : domain1);
        _selectedDomain2 = _validateDomain(domain2.isEmpty ? null : domain2);
        
        print('🔍 Selected domain1: $_selectedDomain1');
        print('🔍 Selected domain2: $_selectedDomain2');
        
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
        String domain1ToSave = _selectedDomain1 ?? '';
        String domain2ToSave = _selectedDomain2 ?? '';
        
        print('[EditProfile] Domain1 to save: "$domain1ToSave"');
        print('[EditProfile] Domain2 to save: "$domain2ToSave"');
        print('[EditProfile] Domain1 isEmpty: ${domain1ToSave.isEmpty}');
        print('[EditProfile] Domain2 isEmpty: ${domain2ToSave.isEmpty}');
        
        print('[EditProfile] Calling updateDomains...');
        await _authService.updateDomains(
          _userData!['id'],
          _userData!['category'],
          domain1ToSave,
          domain2ToSave,
        );
        print('[EditProfile] Domains updated in Firebase');
        
        // Force refresh user data directly from Firebase to get latest updates
        print('[EditProfile] Force refreshing current user from Firebase...');
        await _authService.forceRefreshUserData();
        print('[EditProfile] User data force refreshed from Firebase');
        
        // Reload the profile page data to show updated values
        print('[EditProfile] Reloading profile page data...');
        await _loadUserData();
        print('[EditProfile] Profile page data reloaded');
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
            const SizedBox(height: 16),
            // Debug button to test domain selection
            OutlinedButton.icon(
              onPressed: () {
                print('🔍 DEBUG: Current domain1: "$_selectedDomain1"');
                print('🔍 DEBUG: Current domain2: "$_selectedDomain2"');
                print('🔍 DEBUG: Domain1 is null: ${_selectedDomain1 == null}');
                print('🔍 DEBUG: Domain2 is null: ${_selectedDomain2 == null}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Domain1: "$_selectedDomain1", Domain2: "$_selectedDomain2"'),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              icon: const Icon(Icons.bug_report),
              label: const Text('Debug Domains'),
            ),
            const SizedBox(height: 8),
            // Test Firebase write permissions
            OutlinedButton.icon(
              onPressed: () async {
                if (_userData != null) {
                  print('🧪 Testing Firebase write permissions...');
                  await _authService.testFirebaseWrite(_userData!['id'], _userData!['category']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Firebase write test completed - check console'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Test Firebase Write'),
            ),
            const SizedBox(height: 8),
            // Test domain update with hardcoded values
            OutlinedButton.icon(
              onPressed: () async {
                if (_userData != null) {
                  print('🧪 Testing domain update with hardcoded values...');
                  try {
                    await _authService.updateDomains(
                      _userData!['id'],
                      _userData!['category'],
                      'AI/ML',
                      'Data Science',
                    );
                    print('🧪 Hardcoded domain update completed');
                    await _loadUserData(); // Reload to see changes
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Hardcoded domain test completed - check console'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } catch (e) {
                    print('🧪 Hardcoded domain update failed: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Hardcoded domain test failed: $e'),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.edit),
              label: const Text('Test Domain Update'),
            ),
            const SizedBox(height: 8),
            // Test with empty values to clear domains
            OutlinedButton.icon(
              onPressed: () async {
                if (_userData != null) {
                  print('🧪 Testing domain update with empty values...');
                  try {
                    await _authService.updateDomains(
                      _userData!['id'],
                      _userData!['category'],
                      '',
                      '',
                    );
                    print('🧪 Empty domain update completed');
                    await _loadUserData(); // Reload to see changes
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Empty domain test completed - check console'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } catch (e) {
                    print('🧪 Empty domain update failed: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Empty domain test failed: $e'),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.clear),
              label: const Text('Test Clear Domains'),
            ),
            const SizedBox(height: 8),
            // Check authentication status
            OutlinedButton.icon(
              onPressed: () {
                _authService.checkAuthStatus();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Authentication status checked - see console'),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              icon: const Icon(Icons.security),
              label: const Text('Check Auth Status'),
            ),
            const SizedBox(height: 8),
            // Verify domains in Firebase
            OutlinedButton.icon(
              onPressed: () async {
                if (_userData != null) {
                  await _authService.verifyDomainsInFirebase(_userData!['id'], _userData!['category']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Firebase verification completed - see console'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.verified),
              label: const Text('Verify Firebase Domains'),
            ),
            const SizedBox(height: 16),
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


