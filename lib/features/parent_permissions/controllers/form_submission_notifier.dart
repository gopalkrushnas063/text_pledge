import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:text_pledge/features/parent_permissions/services/parent_permission_google_sheets_service.dart';
import 'package:text_pledge/features/parent_permissions/viewmodels/form_submission_state.dart';
import '../models/parent_form_model.dart';

final parentFormSubmissionProvider = StateNotifierProvider<ParentFormSubmissionNotifier, FormSubmissionState>((ref) {
  return ParentFormSubmissionNotifier();
});

class ParentFormSubmissionNotifier extends StateNotifier<FormSubmissionState> {
  ParentFormSubmissionNotifier() : super(FormSubmissionState());

  Future<void> submitForm(ParentFormModel formData) async {
    state = state.copyWith(isLoading: true, error: null, fileUrl: null);
    
    try {
      final response = await GoogleSheetsServiceParentPermission.submitParentForm(formData);
      
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