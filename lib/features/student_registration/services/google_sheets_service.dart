import 'package:dio/dio.dart';
import '../models/student_form_model.dart';

class GoogleSheetsService {
  static final Dio _dio = Dio();
  static const String _scriptUrl =
      'https://script.google.com/macros/s/AKfycbymowlqu0a_ttDlD7W-sEV2NR0kHL8BmK9zPoOeHEdP4E0VJKAr8pXvJH5Usu8HU06llw/exec';

  static Future<void> submitForm(StudentFormModel formData) async {
    try {
      // Prepare the data payload
      final payload = formData.toJson();

      // Make the POST request
      final response = await _dio.post(
        _scriptUrl,
        data: payload,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      // Check for successful response (200-299 range)
      if (response.statusCode! >= 200 && response.statusCode! < 302) {
        // Optionally parse the response body if your script returns data
        final responseData = response.data;
        if (responseData is Map && responseData['result'] != 'success') {
          throw Exception(responseData['error'] ?? 'Unknown error from server');
        }
      } else {
        throw Exception(
          'Failed to submit form. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        throw Exception(
          'Server responded with error: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error submitting form: $e');
    }
  }
}
