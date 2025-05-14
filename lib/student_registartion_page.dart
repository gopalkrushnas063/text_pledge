import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signature/signature.dart';

class StudentRegistrationPage extends StatefulWidget {
  const StudentRegistrationPage({super.key});

  @override
  State<StudentRegistrationPage> createState() =>
      _StudentRegistrationPageState();
}

class _StudentRegistrationPageState extends State<StudentRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'school name': TextEditingController(),
    'address': TextEditingController(),
    'city': TextEditingController(),
    'zip': TextEditingController(),
    'parent name': TextEditingController(),
    'student name': TextEditingController(),
  };

  bool _isChecked = false;
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _isChecked &&
        !_signatureController.isEmpty) {
      Fluttertoast.showToast(msg: "Form submitted successfully");
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3F51B5),
            ),
            onPressed: _submitForm,
            child: const Text(
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
                          hintText: field.key,
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: const UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter ${field.key}';
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
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
