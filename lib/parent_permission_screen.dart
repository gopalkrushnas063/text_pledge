import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signature/signature.dart';

class ParentPermissionPage extends StatefulWidget {
  const ParentPermissionPage({super.key});

  @override
  State<ParentPermissionPage> createState() => _ParentPermissionPageState();
}

class _ParentPermissionPageState extends State<ParentPermissionPage> {
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

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );
  List<bool> _checkboxes = [false, false, false, false];

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        !_signatureController.isEmpty &&
        _checkboxes.every((e) => e)) {
      Fluttertoast.showToast(msg: "Form submitted successfully");
    } else {
      if (!_checkboxes.every((e) => e)) {
        Fluttertoast.showToast(msg: "Please accept all required permissions");
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F51B5),
        title: const Text(
          'PARENT PERMISSION',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
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
