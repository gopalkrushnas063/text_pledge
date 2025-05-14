import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signature/signature.dart';
import '../controllers/form_submission_notifier.dart';
import '../models/student_form_model.dart';

class StudentRegistrationPage extends ConsumerStatefulWidget {
  const StudentRegistrationPage({super.key});

  @override
  ConsumerState<StudentRegistrationPage> createState() =>
      _StudentRegistrationPageState();
}

class _StudentRegistrationPageState
    extends ConsumerState<StudentRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'school_name': TextEditingController(),
    'address': TextEditingController(),
    'city': TextEditingController(),
    'zip': TextEditingController(),
    'parent_name': TextEditingController(),
    'student_name': TextEditingController(),
  };

  bool _isChecked = false;
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _isChecked &&
        !_signatureController.isEmpty) {
      
      // Show loading dialog
      _showLoadingDialog();
      
      try {
        // Convert signature to PNG bytes
        final signatureImage = await _signatureController.toPngBytes();
        if (signatureImage == null) {
          if (mounted) Navigator.pop(context); // Close loading dialog
          Fluttertoast.showToast(msg: "Failed to process signature");
          return;
        }

        // Convert signature bytes to base64 string - this is temporary for transfer
        final base64Signature = base64Encode(signatureImage);
        
        // Debug info
        print('Signature size: ${signatureImage.length} bytes');
        print('Base64 signature prepared for upload');

        final formData = StudentFormModel(
          name: _controllers['name']!.text,
          schoolName: _controllers['school_name']!.text,
          address: _controllers['address']!.text,
          city: _controllers['city']!.text,
          zip: _controllers['zip']!.text,
          parentName: _controllers['parent_name']!.text,
          studentName: _controllers['student_name']!.text,
          signature: base64Signature, // Will be processed as an image file on server
        );

        await ref.read(formSubmissionProvider.notifier).submitForm(formData);

        if (mounted) Navigator.pop(context); // Close loading dialog
        
        final state = ref.read(formSubmissionProvider);
        if (state.isSuccess) {
          Fluttertoast.showToast(msg: "Form submitted successfully");
          
          // Show success dialog with link if available
          if (state.fileUrl != null && state.fileUrl!.isNotEmpty) {
            _showSuccessDialog(state.fileUrl!);
          }
          
          _resetForm();
        } else if (state.error != null) {
          Fluttertoast.showToast(msg: "Error: ${state.error}");
        }
      } catch (e) {
        print('Error in form submission: $e');
        if (mounted) Navigator.pop(context); // Close loading dialog
        Fluttertoast.showToast(msg: "Error: $e");
      }
    } else {
      String errorMessage = "Please fill all required fields";
      if (!_isChecked) {
        errorMessage = "Please accept the pledges";
      } else if (_signatureController.isEmpty) {
        errorMessage = "Please provide your signature";
      }
      Fluttertoast.showToast(msg: errorMessage);
    }
  }

  void _showSuccessDialog(String fileUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Form Submitted Successfully"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your form has been submitted successfully."),
            const SizedBox(height: 16),
            const Text("Your signature has been stored in Google Drive."),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                // Implementation for opening the URL would go here
                // Typically uses url_launcher package
                print('Opening signature URL: $fileUrl');
              },
              child: Text(
                "View Signature",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Submitting form..."),
              ],
            ),
          ),
        );
      },
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    for (var controller in _controllers.values) {
      controller.clear();
    }
    _signatureController.clear();
    setState(() => _isChecked = false);
  }

  void _openSignaturePad() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Signature Pad"),
        content: SizedBox(
          height: 300,
          width: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Signature(
                    controller: _signatureController,
                    backgroundColor: Colors.white,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text("Please sign in the box above", 
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _signatureController.clear(),
            child: const Text("Clear"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(formSubmissionProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F51B5),
        title: const Text(
          'STUDENT REGISTRATION',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: state.isLoading ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3F51B5),
            ),
            child:
                state.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                      'CREATE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var field in _controllers.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        field.key.replaceAll('_', ' ').toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: field.value,
                        decoration: InputDecoration(
                          hintText: field.key.replaceAll('_', ' '),
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: const UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter ${field.key.replaceAll('_', ' ')}';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) => setState(() => _isChecked = value!),
                  ),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        children: [
                          TextSpan(text: 'I have read text '),
                          TextSpan(
                            text: 'Pledges',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' or have went through the grade level material and am ready to the ',
                          ),
                          TextSpan(
                            text: 'Pledges',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: '. I understand why they are very important.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _openSignaturePad,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.edit, color: Color(0xFF3F51B5)),
                      SizedBox(width: 8),
                      Text(
                        'Tap to Sign',
                        style: TextStyle(
                          color: Color(0xFF3F51B5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!_signatureController.isEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Signature Preview:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Signature(
                    controller: _signatureController,
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}