import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/approval_request.dart';
import '../data/approval_data.dart';
import '../widgets/student_drawer.dart';

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

  void submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (!isPdfOptional && pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF file is required for this category')),
      );
      return;
    }

    ApprovalRequest newRequest = ApprovalRequest(
      title: title,
      description: description,
      category: selectedCategory!,
      pdfPath: pickedFile?.path,
      link: link,
      status: isAutoAccepted ? 'accepted' : 'pending',
    );

    addApprovalRequest(newRequest);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request submitted with status: ${newRequest.status}')),
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

    // Optionally navigate to approval status page or update UI accordingly
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
