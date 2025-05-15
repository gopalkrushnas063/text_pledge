import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:text_pledge/features/parent_permissions/models/parent_form_model.dart';

class GoogleSheetsServiceParentPermission {
  static final Dio _dio = Dio();
  static const String _scriptUrl = 'https://script.google.com/macros/s/AKfycbxrXksjRPeYy17mwFDg9VtTCX2MQKainfHs0h8lFzerjVCvgrXNDu-t97dHqhRTLvKLRg/exec';

  static Future<Map<String, dynamic>?> submitParentForm(
    ParentFormModel formData,
  ) async {
    try {
      final formDataToSend = formData.toJson();

      var response = await _dio.post(
        _scriptUrl,
        data: formDataToSend,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {'Accept': 'application/json'},
          followRedirects: false,
          validateStatus: (status) => true,
        ),
      );

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

      if (response.statusCode == 200) {
        return responseData;
      }

      throw Exception('Failed to store data. Status: ${response.statusCode}');
    } catch (e) {
      throw Exception('Submission error: ${e.toString()}');
    }
  }
}
