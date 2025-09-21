import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/image_utils.dart';
import '../utils/color_utils.dart';

class ProfilePhotoTestPage extends StatefulWidget {
  const ProfilePhotoTestPage({super.key});

  @override
  State<ProfilePhotoTestPage> createState() => _ProfilePhotoTestPageState();
}

class _ProfilePhotoTestPageState extends State<ProfilePhotoTestPage> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = _authService.getCurrentUser();
    setState(() {
      _userData = userData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Photo Test'),
        backgroundColor: ColorUtils.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Photo Display
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profile Photo Test',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: _userData?['profile_photo'] != null && 
                                             _userData!['profile_photo'].toString().isNotEmpty
                                  ? ImageUtils.getImageProvider(_userData!['profile_photo'])
                                  : null,
                              child: _userData?['profile_photo'] == null || 
                                     _userData!['profile_photo'].toString().isEmpty
                                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Name: ${_userData?['name'] ?? 'Unknown'}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Profile Photo Data
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profile Photo Data',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          if (_userData?['profile_photo'] != null) ...[
                            Text(
                              'Type: ${_getPhotoType(_userData!['profile_photo'].toString())}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Length: ${_userData!['profile_photo'].toString().length} characters',
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Preview: ${_userData!['profile_photo'].toString().substring(0, _userData!['profile_photo'].toString().length > 100 ? 100 : _userData!['profile_photo'].toString().length)}...',
                              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                            ),
                          ] else ...[
                            const Text('No profile photo data'),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Test Buttons
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Test Actions',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadUserData,
                            child: const Text('Refresh Data'),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              // Force refresh from Firebase
                              _authService.forceRefreshUserData().then((_) {
                                _loadUserData();
                              });
                            },
                            child: const Text('Force Refresh from Firebase'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _getPhotoType(String photoData) {
    if (photoData.startsWith('data:image/')) {
      return 'Base64 Data URL';
    } else if (photoData.startsWith('http://') || photoData.startsWith('https://')) {
      return 'Network URL';
    } else if (photoData.startsWith('/') || photoData.startsWith('C:')) {
      return 'Local File Path';
    } else if (photoData.length > 100) {
      return 'Base64 String';
    } else {
      return 'Unknown';
    }
  }
}
