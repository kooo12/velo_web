import 'package:flutter/foundation.dart';

@immutable
class FAQState {
  final bool isSubmitting;
  final bool submissionSuccess;
  final String? submissionError;

  const FAQState({
    required this.isSubmitting,
    required this.submissionSuccess,
    this.submissionError,
  });

  factory FAQState.initial() {
    return const FAQState(
      isSubmitting: false,
      submissionSuccess: false,
      submissionError: null,
    );
  }

  FAQState copyWith({
    bool? isSubmitting,
    bool? submissionSuccess,
    String? submissionError,
  }) {
    return FAQState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
      submissionError: submissionError, // Can be null
    );
  }
}
