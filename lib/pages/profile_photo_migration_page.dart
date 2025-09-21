import 'package:flutter/material.dart';
import '../services/profile_photo_migration_service.dart';
import '../utils/color_utils.dart';

class ProfilePhotoMigrationPage extends StatefulWidget {
  const ProfilePhotoMigrationPage({super.key});

  @override
  State<ProfilePhotoMigrationPage> createState() => _ProfilePhotoMigrationPageState();
}

class _ProfilePhotoMigrationPageState extends State<ProfilePhotoMigrationPage> {
  final ProfilePhotoMigrationService _migrationService = ProfilePhotoMigrationService();
  bool _isLoading = false;
  Map<String, dynamic>? _migrationStatus;
  Map<String, dynamic>? _migrationResults;

  @override
  void initState() {
    super.initState();
    _loadMigrationStatus();
  }

  Future<void> _loadMigrationStatus() async {
    setState(() => _isLoading = true);
    try {
      final status = await _migrationService.getMigrationStatus();
      setState(() {
        _migrationStatus = status;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load migration status: $e');
    }
  }

  Future<void> _runMigration() async {
    setState(() => _isLoading = true);
    try {
      final results = await _migrationService.migrateAllProfilePhotos();
      setState(() {
        _migrationResults = results;
        _isLoading = false;
      });
      
      // Reload status after migration
      await _loadMigrationStatus();
      
      _showSuccessSnackBar('Migration completed! Check results below.');
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Migration failed: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Photo Migration'),
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
                  // Migration Status Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Migration Status',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          if (_migrationStatus != null) ...[
                            _buildStatusRow('Total Users', _migrationStatus!['total_users'].toString()),
                            _buildStatusRow('Local Photos', _migrationStatus!['local_photos'].toString()),
                            _buildStatusRow('Network Photos', _migrationStatus!['network_photos'].toString()),
                            _buildStatusRow('No Photos', _migrationStatus!['no_photos'].toString()),
                            const SizedBox(height: 16),
                            Text(
                              'By Category:',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            if (_migrationStatus!['categories'] != null)
                              ...(_migrationStatus!['categories'] as Map<String, Map<String, int>>)
                                  .entries
                                  .map((entry) => _buildCategoryStatus(entry.key, entry.value)),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Migration Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _migrationStatus?['local_photos'] > 0 ? _runMigration : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorUtils.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        _migrationStatus?['local_photos'] > 0 
                            ? 'Migrate ${_migrationStatus!['local_photos']} Local Photos'
                            : 'No Local Photos to Migrate',
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Migration Results
                  if (_migrationResults != null) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Migration Results',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 16),
                            _buildStatusRow('Successfully Migrated', _migrationResults!['success'].toString(), Colors.green),
                            _buildStatusRow('Failed', _migrationResults!['failed'].toString(), Colors.red),
                            _buildStatusRow('Skipped', _migrationResults!['skipped'].toString(), Colors.orange),
                            
                            if (_migrationResults!['errors'].isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Text(
                                'Errors:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              ...(_migrationResults!['errors'] as List<String>)
                                  .map((error) => Padding(
                                        padding: const EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          '• $error',
                                          style: const TextStyle(color: Colors.red, fontSize: 12),
                                        ),
                                      )),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 16),
                  
                  // Information Card
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              Text(
                                'About Profile Photo Migration',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'This tool helps migrate existing local profile photos to Base64 format. '
                            'This ensures that profile photos are accessible across all devices and don\'t disappear when users log in from different devices.',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'After migration, all profile photos will be stored as Base64 strings in the database and accessible from any device.',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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

  Widget _buildStatusRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryStatus(String category, Map<String, int> data) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          _buildStatusRow('  Total', data['total'].toString()),
          _buildStatusRow('  Local', data['local'].toString(), Colors.orange),
          _buildStatusRow('  Network', data['network'].toString(), Colors.green),
          _buildStatusRow('  None', data['none'].toString(), Colors.grey),
        ],
      ),
    );
  }
}

