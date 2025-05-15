class FormSubmissionState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final String? fileUrl;

  FormSubmissionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.fileUrl,
  });

  FormSubmissionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    String? fileUrl,
  }) {
    return FormSubmissionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }
}