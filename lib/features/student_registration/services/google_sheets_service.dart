import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/student_form_model.dart';

class GoogleSheetsService {
  static final Dio _dio = Dio();
  static const String _scriptUrl = 'https://script.google.com/macros/s/AKfycbyNS7pwkqx46TylC4hHM-S7LdsNtvpOr_zc9RybEHf586on4JXaujcMkJ4wC2URWmM/exec';

  static Future<Map<String, dynamic>?> submitForm(
    StudentFormModel formData,
  ) async {
    try {
      // Create form data with signature as base64 string
      final formDataToSend = {
        'name': formData.name,
        'school_name': formData.schoolName,
        'address': formData.address,
        'city': formData.city,
        'zip': formData.zip,
        'parent_name': formData.parentName,
        'student_name': formData.studentName,
        'signature_file': formData.signature, // Pass the base64 string directly
      };

      // First attempt with no redirect following
      var response = await _dio.post(
        _scriptUrl,
        data: formDataToSend,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {'Accept': 'application/json'},
          followRedirects: false,
          validateStatus: (status) => true, // Accept all status codes
        ),
      );

      // Handle redirect manually
      if (response.statusCode == 302) {
        final redirectUrl = response.headers['location']?.first;
        if (redirectUrl != null) {
          response = await _dio.get(
            redirectUrl,
            options: Options(
              headers: {'Accept': 'application/json'},
              validateStatus: (status) => true,
            ),
          );
        }
      }

      // Parse response
      dynamic responseData;
      if (response.data is String) {
        try {
          responseData = jsonDecode(response.data);
        } catch (e) {
          responseData = {'rawResponse': response.data};
        }
      } else {
        responseData = response.data;
      }

      // Check for success
      if (response.statusCode == 200) {
        return responseData;
      }

      throw Exception('Failed to store signature. Status: ${response.statusCode}');
    } catch (e) {
      throw Exception('Submission error: ${e.toString()}');
    }
  }
}