import 'package:flutter/material.dart';
import '../widgets/student_drawer.dart';

class StudentEditProfilePage extends StatefulWidget {
  const StudentEditProfilePage({super.key});

  @override
  State<StudentEditProfilePage> createState() => _StudentEditProfilePageState();
}

class _StudentEditProfilePageState extends State<StudentEditProfilePage> {
  String? _selectedDomain1;
  String? _selectedDomain2;
  ImageProvider? _avatar;

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
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // TODO: pick image from gallery / camera
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image picker not implemented')));
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedDomain1,
                    items: const [
                      DropdownMenuItem(value: 'AI/ML', child: Text('AI/ML')),
                      DropdownMenuItem(value: 'Data Science', child: Text('Data Science')),
                      DropdownMenuItem(value: 'Cybersecurity', child: Text('Cybersecurity')),
                      DropdownMenuItem(value: 'Web Development', child: Text('Web Development')),
                    ],
                    onChanged: (v) => setState(() => _selectedDomain1 = v),
                    decoration: const InputDecoration(
                      labelText: 'Domain 1',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedDomain2,
                    items: const [
                      DropdownMenuItem(value: 'AI/ML', child: Text('AI/ML')),
                      DropdownMenuItem(value: 'Data Science', child: Text('Data Science')),
                      DropdownMenuItem(value: 'Cybersecurity', child: Text('Cybersecurity')),
                      DropdownMenuItem(value: 'Web Development', child: Text('Web Development')),
                    ],
                    onChanged: (v) => setState(() => _selectedDomain2 = v),
                    decoration: const InputDecoration(
                      labelText: 'Domain 2 (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: persist profile edits
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
            )
          ],
        ),
      ),
    );
  }
}


