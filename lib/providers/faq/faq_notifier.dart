import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'faq_state.dart';

class FAQNotifier extends StateNotifier<FAQState> {
  FAQNotifier() : super(FAQState.initial());

  static String get formspreeId =>
      dotenv.get('FORMSPREE_ID', fallback: 'meerbnjk');
  static String get apiEndpoint =>
      dotenv.get('APIENDPOINT', fallback: 'https://formspree.io/f/');

  Future<void> submitQuestion({
    required String name,
    required String email,
    required String question,
  }) async {
    state = state.copyWith(
      isSubmitting: true,
      submissionError: null,
      submissionSuccess: false,
    );

    try {
      final response = await http
          .post(
            Uri.parse('https://formspree.io/f/$formspreeId'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'name': name.trim(),
              'email': email.trim(),
              'question': question.trim(),
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        state = state.copyWith(
          isSubmitting: false,
          submissionSuccess: true,
        );
      } else {
        throw Exception(
            'Failed to send question: ${response.statusCode}, ${response.body} ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint(e.toString());
      state = state.copyWith(
        isSubmitting: false,
        submissionError:
            'Could not send your question. Please check your connection and try again.',
      );
    }
  }

  void reset() {
    state = FAQState.initial();
  }
}

final faqProvider = StateNotifierProvider<FAQNotifier, FAQState>((ref) {
  return FAQNotifier();
});
