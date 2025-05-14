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
      final signatureImage = await _signatureController.toPngBytes();
      if (signatureImage == null) {
        Fluttertoast.showToast(msg: "Failed to process signature");
        return;
      }

      final formData = StudentFormModel(
        name: _controllers['name']!.text,
        schoolName: _controllers['school_name']!.text,
        address: _controllers['address']!.text,
        city: _controllers['city']!.text,
        zip: _controllers['zip']!.text,
        parentName: _controllers['parent_name']!.text,
        studentName: _controllers['student_name']!.text,
        signature: signatureImage.toString(),
      );

      await ref.read(formSubmissionProvider.notifier).submitForm(formData);

      final state = ref.read(formSubmissionProvider);
      if (state.isSuccess) {
        Fluttertoast.showToast(msg: "Form submitted successfully");
        _resetForm();
      } else if (state.error != null) {
        Fluttertoast.showToast(msg: "Error: ${state.error}");
      }
    } else {
      if (!_isChecked) {
        Fluttertoast.showToast(msg: "Please accept the pledges");
      }
      if (_signatureController.isEmpty) {
        Fluttertoast.showToast(msg: "Please provide your signature");
      }
      Fluttertoast.showToast(msg: "Please fill all required fields");
    }
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
      builder:
          (context) => AlertDialog(
            title: const Text("Signature Pad"),
            content: SizedBox(
              height: 200,
              width: double.maxFinite,
              child: Signature(
                controller: _signatureController,
                backgroundColor: Colors.grey[200]!,
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
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _openSignaturePad,
                child: Row(
                  children: const [
                    Icon(Icons.edit, color: Color(0xFF3F51B5)),
                    SizedBox(width: 8),
                    Text(
                      'Draw Your Signature',
                      style: TextStyle(
                        color: Color(0xFF3F51B5),
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
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
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Signature(
                    controller: _signatureController,
                    height: 100,
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
