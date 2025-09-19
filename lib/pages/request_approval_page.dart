import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/student_drawer.dart';
import '../services/auth_service.dart';

class RequestApprovalPage extends StatefulWidget {
  const RequestApprovalPage({super.key});

  @override
  State<RequestApprovalPage> createState() => _RequestApprovalPageState();
}

class _RequestApprovalPageState extends State<RequestApprovalPage> {
  final _formKey = GlobalKey<FormState>();

  final List<String> categories = [
    'Certifications',
    'Achievements',
    'Experience',
    'Research papers',
    'Projects',
    'Workshops',
  ];

  String? selectedCategory;
  String title = '';
  String description = '';
  String? link;
  PlatformFile? pickedFile;
  String? experienceType; // Internship, Club roles, Jobs

  bool get isPdfOptional {
    return selectedCategory == 'Research papers' || selectedCategory == 'Projects';
  }

  bool get isAutoAccepted {
    return selectedCategory == 'Certifications' || selectedCategory == 'Workshops';
  }

  Future<void> pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        pickedFile = result.files.first;
      });
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (!isPdfOptional && pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF file is required for this category')),
      );
      return;
    }

    try {
      final AuthService authService = AuthService();
      
      // Create request data for Firebase
      Map<String, dynamic> requestData = {
        'title': title,
        'description': description,
        'category': selectedCategory!,
        'link': link,
        'pdf_path': pickedFile?.path,
        'experience_type': experienceType,
        'status': isAutoAccepted ? 'accepted' : 'pending',
        'submitted_at': DateTime.now().toIso8601String(),
      };

      // Submit to Firebase
      await authService.submitApprovalRequest(requestData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request submitted with status: ${requestData['status']}')),
      );

      // Clear form
      setState(() {
        selectedCategory = null;
        title = '';
        description = '';
        link = null;
        pickedFile = null;
        experienceType = null;
      });

    } catch (e) {
      print('Error submitting approval request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting request. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Approval'),
      ),
      drawer: MainDrawer(context: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: categories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                initialValue: selectedCategory,
                onChanged: (val) {
                  setState(() {
                    selectedCategory = val;
                    pickedFile = null;
                    link = null;
                    experienceType = null;
                  });
                },
                validator: (val) => val == null ? 'Please select a category' : null,
              ),
              if (selectedCategory == 'Experience') ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Experience Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Internship', child: Text('Internship')),
                    DropdownMenuItem(value: 'Club roles', child: Text('Club roles')),
                    DropdownMenuItem(value: 'Jobs', child: Text('Jobs')),
                  ],
                  initialValue: experienceType,
                  onChanged: (val) {
                    setState(() {
                      experienceType = val;
                    });
                  },
                  validator: (val) => selectedCategory == 'Experience' && val == null ? 'Select experience type' : null,
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onSaved: (val) => title = val ?? '',
                validator: (val) => val == null || val.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (val) => description = val ?? '',
                validator: (val) => val == null || val.isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 16),
              if (isPdfOptional)
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Link (optional if PDF uploaded)',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (val) => link = val,
                ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: pickPdfFile,
                icon: const Icon(Icons.upload_file),
                label: Text(pickedFile == null ? 'Upload PDF' : 'Change PDF (${pickedFile!.name})'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: submit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
