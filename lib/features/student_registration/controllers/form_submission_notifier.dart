import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:text_pledge/features/student_registration/viewmodels/form_submission_state.dart';
import '../models/student_form_model.dart';
import '../services/google_sheets_service.dart';

final formSubmissionProvider = StateNotifierProvider<FormSubmissionNotifier, FormSubmissionState>((ref) {
  return FormSubmissionNotifier();
});

class FormSubmissionNotifier extends StateNotifier<FormSubmissionState> {
  FormSubmissionNotifier() : super(FormSubmissionState());

  Future<void> submitForm(StudentFormModel formData) async {
    state = state.copyWith(isLoading: true, error: null, fileUrl: null);
    
    try {
      final response = await GoogleSheetsService.submitForm(formData);
      
      // If the response contains a file URL, store it
      if (response != null && response.containsKey('fileUrl')) {
        state = state.copyWith(
          isLoading: false, 
          isSuccess: true,
          fileUrl: response['fileUrl']
        );
      } else {
        state = state.copyWith(isLoading: false, isSuccess: true);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}