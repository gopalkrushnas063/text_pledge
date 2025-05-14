// lib/features/student_registration/models/student_form_model.dart
class StudentFormModel {
  final String name;
  final String schoolName;
  final String address;
  final String city;
  final String zip;
  final String parentName;
  final String studentName;
  final String signature; // This will store the Base64 string

  StudentFormModel({
    required this.name,
    required this.schoolName,
    required this.address,
    required this.city,
    required this.zip,
    required this.parentName,
    required this.studentName,
    required this.signature,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'school_name': schoolName,
      'address': address,
      'city': city,
      'zip': zip,
      'parent_name': parentName,
      'student_name': studentName,
      'signature': signature, // Send the Base64 string
    };
  }
}