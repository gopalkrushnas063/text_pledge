import 'dart:convert';
import 'dart:typed_data';

class StudentFormModel {
  final String name;
  final String schoolName;
  final String address;
  final String city;
  final String zip;
  final String parentName;
  final String studentName;
  final String signature; // Base64 encoded signature

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

  // Convert Uint8List to base64 string
  static String bytesToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'school_name': schoolName,
      'address': address,
      'city': city,
      'zip': zip,
      'parent_name': parentName,
      'student_name': studentName,
      'signature_base64': signature, // Include signature in JSON
    };
  }
}