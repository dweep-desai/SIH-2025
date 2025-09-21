import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/student_drawer.dart';
import '../widgets/form_components.dart';
import '../utils/responsive_utils.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting request. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Approval'),
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
              // Category Selection Section
              ModernFormComponents.buildFormSection(
                title: 'Request Category',
                subtitle: 'Select the type of approval request',
                icon: Icons.category_outlined,
                context: context,
                child: ModernFormComponents.buildModernDropdownField<String>(
                  value: selectedCategory,
                  items: categories
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  labelText: 'Category',
                  hintText: 'Select a category',
                  prefixIcon: Icons.category_outlined,
                  onChanged: (val) {
                    setState(() {
                      selectedCategory = val;
                      pickedFile = null;
                      link = null;
                      experienceType = null;
                    });
                  },
                  validator: (val) => val == null ? 'Please select a category' : null,
                  context: context,
                ),
              ),

              // Experience Type Section (conditional)
              if (selectedCategory == 'Experience') ...[
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                ModernFormComponents.buildFormSection(
                  title: 'Experience Type',
                  subtitle: 'Specify the type of experience',
                  icon: Icons.work_outline,
                  context: context,
                  child: ModernFormComponents.buildModernDropdownField<String>(
                    value: experienceType,
                    items: const [
                      DropdownMenuItem(value: 'Internship', child: Text('Internship')),
                      DropdownMenuItem(value: 'Club roles', child: Text('Club roles')),
                      DropdownMenuItem(value: 'Jobs', child: Text('Jobs')),
                    ],
                    labelText: 'Experience Type',
                    hintText: 'Select experience type',
                    prefixIcon: Icons.work_outline,
                    onChanged: (val) {
                      setState(() {
                        experienceType = val;
                      });
                    },
                    validator: (val) => selectedCategory == 'Experience' && val == null ? 'Select experience type' : null,
                    context: context,
                  ),
                ),
              ],

              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),

              // Request Details Section
              ModernFormComponents.buildFormSection(
                title: 'Request Details',
                subtitle: 'Provide information about your request',
                icon: Icons.description_outlined,
                context: context,
                child: Column(
                  children: [
                    // Title Field
                    ModernFormComponents.buildModernTextField(
                      controller: TextEditingController(text: title),
                      labelText: 'Title',
                      hintText: 'Enter a descriptive title',
                      prefixIcon: Icons.title,
                      onChanged: (val) => title = val,
                      validator: (val) => val == null || val.isEmpty ? 'Title is required' : null,
                      context: context,
                    ),

                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),

                    // Description Field
                    ModernFormComponents.buildModernTextField(
                      controller: TextEditingController(text: description),
                      labelText: 'Description',
                      hintText: 'Provide detailed description',
                      prefixIcon: Icons.description_outlined,
                      maxLines: 3,
                      onChanged: (val) => description = val,
                      validator: (val) => val == null || val.isEmpty ? 'Description is required' : null,
                      context: context,
                    ),

                    // Link Field (conditional)
                    if (isPdfOptional) ...[
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                      ModernFormComponents.buildModernTextField(
                        controller: TextEditingController(text: link ?? ''),
                        labelText: 'Link (optional if PDF uploaded)',
                        hintText: 'Enter a relevant link',
                        prefixIcon: Icons.link,
                        onChanged: (val) => link = val,
                        context: context,
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),

              // File Upload Section
              ModernFormComponents.buildFormSection(
                title: 'Document Upload',
                subtitle: isPdfOptional 
                    ? 'Upload a PDF document (optional for this category)'
                    : 'Upload a PDF document (required for this category)',
                icon: Icons.upload_file_outlined,
                context: context,
                child: Column(
                  children: [
                    ModernFormComponents.buildFileUploadButton(
                      text: 'Upload PDF',
                      fileName: pickedFile?.name,
                      icon: Icons.upload_file_outlined,
                      onPressed: pickPdfFile,
                      context: context,
                    ),
                    if (pickedFile != null) ...[
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                      ModernFormComponents.buildValidationMessage(
                        message: 'File selected: ${pickedFile!.name}',
                        isError: false,
                        context: context,
                      ),
                    ],
                    if (!isPdfOptional && pickedFile == null) ...[
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                      ModernFormComponents.buildValidationMessage(
                        message: 'PDF file is required for this category',
                        isError: true,
                        context: context,
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 32)),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ModernFormComponents.buildModernButton(
                  text: 'Submit Request',
                  icon: Icons.send_outlined,
                  onPressed: submit,
                  context: context,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
