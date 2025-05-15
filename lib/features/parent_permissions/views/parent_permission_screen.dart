import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart'; // Added QuickAlert import
import '../controllers/form_submission_notifier.dart';
import '../models/parent_form_model.dart';

class ParentPermissionPage extends ConsumerStatefulWidget {
  const ParentPermissionPage({super.key});

  @override
  ConsumerState<ParentPermissionPage> createState() =>
      _ParentPermissionPageState();
}

class _ParentPermissionPageState extends ConsumerState<ParentPermissionPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'email': TextEditingController(),
    'phone number': TextEditingController(),
    'address': TextEditingController(),
    'city': TextEditingController(),
    'zip': TextEditingController(),
    'student name': TextEditingController(),
    'student age': TextEditingController(),
    'referring school': TextEditingController(),
    'church or group': TextEditingController(),
    'grade level': TextEditingController(),
  };

  List<bool> _checkboxes = [false, false, false, false];

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _checkboxes.every((e) => e)) {
      _showLoadingDialog();

      try {
        final formData = ParentFormModel(
          name: _controllers['name']!.text,
          email: _controllers['email']!.text,
          phoneNumber: _controllers['phone number']!.text,
          address: _controllers['address']!.text,
          city: _controllers['city']!.text,
          zip: _controllers['zip']!.text,
          studentName: _controllers['student name']!.text,
          studentAge: _controllers['student age']!.text,
          referringSchool: _controllers['referring school']!.text,
          churchOrGroup: _controllers['church or group']!.text,
          gradeLevel: _controllers['grade level']!.text,
          permissions: _checkboxes,
        );

        await ref
            .read(parentFormSubmissionProvider.notifier)
            .submitForm(formData);

        if (mounted) Navigator.pop(context);

        final state = ref.read(parentFormSubmissionProvider);
        if (state.isSuccess) {
          // Replaced toast with QuickAlert
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Success',
            text: 'Form submitted successfully',
            onConfirmBtnTap: () {
              Navigator.pop(context); // Close the alert
              Navigator.pop(context); // Go back to home screen
            },
          );

          if (state.fileUrl != null && state.fileUrl!.isNotEmpty) {
            _showSuccessDialog(state.fileUrl!);
          }

          _resetForm();
        } else if (state.error != null) {
          // Replaced toast with QuickAlert
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Error',
            text: state.error,
          );
        }
      } catch (e) {
        if (mounted) Navigator.pop(context);
        // Replaced toast with QuickAlert
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: e.toString(),
        );
      }
    } else {
      String errorMessage = "Please fill all required fields";
      if (!_checkboxes.every((e) => e)) {
        errorMessage = "Please accept all required permissions";
      }
      // Replaced toast with QuickAlert
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Validation Error',
        text: errorMessage,
      );
    }
  }

  void _showSuccessDialog(String fileUrl) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Form Submitted Successfully',
      text: 'Your form has been submitted successfully.',
      confirmBtnText: 'OK',
      onConfirmBtnTap: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  void _showLoadingDialog() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Loading',
      text: 'Submitting form...',
      barrierDismissible: false,
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    for (var controller in _controllers.values) {
      controller.clear();
    }
    setState(() => _checkboxes = [false, false, false, false]);
  }

  Widget _buildCheckbox(int index, String title) {
    return Row(
      children: [
        Checkbox(
          value: _checkboxes[index],
          onChanged: (val) => setState(() => _checkboxes[index] = val!),
        ),
        Expanded(child: Text(title)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(parentFormSubmissionProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F51B5),
        title: const Text(
          'Parent Permission',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Chip(
              label: Text("Donate", style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.orange,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3F51B5),
            ),
            onPressed: state.isLoading ? null : _submitForm,
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
                        field.key.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: field.value,
                        decoration: InputDecoration(
                          hintText:
                              field.key[0].toUpperCase() +
                              field.key.substring(1),
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: const UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (field.key != 'church or group' &&
                              (value == null || value.trim().isEmpty)) {
                            return 'Please enter ${field.key}';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              const Text(
                "Parent Permission and Media Release",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                "Parent Permission and Media Release.pdf",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 8),
              _buildCheckbox(
                0,
                "I give to permission to participate in TextPledge's presentation or events.",
              ),
              _buildCheckbox(
                1,
                "I would like to view grade level materials and view bullet points of presentations.",
              ),
              _buildCheckbox(
                2,
                "I am interested in learning more about T.P. products",
              ),
              _buildCheckbox(
                3,
                "I have reviewed the information TextPledge shares.",
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
