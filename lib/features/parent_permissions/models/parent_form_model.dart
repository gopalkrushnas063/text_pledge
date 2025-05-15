import 'dart:typed_data';
import 'dart:convert';

class ParentFormModel {
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String city;
  final String zip;
  final String studentName;
  final String studentAge;
  final String referringSchool;
  final String churchOrGroup;
  final String gradeLevel;
  final List<bool> permissions;

  ParentFormModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.zip,
    required this.studentName,
    required this.studentAge,
    required this.referringSchool,
    required this.churchOrGroup,
    required this.gradeLevel,
    required this.permissions,
  });

  static String bytesToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'city': city,
      'zip': zip,
      'student_name': studentName,
      'student_age': studentAge,
      'referring_school': referringSchool,
      'church_or_group': churchOrGroup,
      'grade_level': gradeLevel,
      'permission_participate': permissions[0],
      'permission_view_materials': permissions[1],
      'interested_products': permissions[2],
      'reviewed_information': permissions[3],
    };
  }
}