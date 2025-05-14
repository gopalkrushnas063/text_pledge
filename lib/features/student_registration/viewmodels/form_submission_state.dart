class FormSubmissionState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  FormSubmissionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  FormSubmissionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return FormSubmissionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
    );
  }
}