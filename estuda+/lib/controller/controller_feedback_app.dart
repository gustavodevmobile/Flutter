import 'package:flutter/material.dart';

import '../service/service_feedbacks.dart';

// This class is responsible for handling feedback-related operations.
class FeedbackController {
  final ServiceFeedbacks serviceFeedbacks = ServiceFeedbacks();

  // This method sends feedback about failures in the app.
  Future<void> sendFeedbackFailures(String id, List<String> feedbackOptions,
      Function(String) onSuccess, Function(String) onError) async {
    try {
      await serviceFeedbacks.sendFeedbackFailures(id, feedbackOptions,
          (response) {
        // Exibe uma mensagem de sucesso
        onSuccess(response);
      }, (error) {
        // Exibe uma mensagem de erro
        onError(error);
       // Navigator.pop(context);
      });
      // Exibe uma mensagem de sucesso
    } catch (e) {
      // Exibe uma mensagem de erro
      onError('Erro ao enviar feedback de falhas: $e');
    }
  }

  // This method sends feedback about the app itself.
  Future<void> sendFeedbackApp(String message,
      Function(String) onSuccess, Function(String) onError) async {
    try {
      await serviceFeedbacks.sendFeedbackApp(message, (response) {
        // Exibe uma mensagem de sucesso
        onSuccess(response);
      }, (error) {
        // Exibe uma mensagem de erro
        onError(error);
       // Navigator.pop(context);
      });

      // Exibe uma mensagem de sucesso
    } catch (e) {
      // Exibe uma mensagem de erro
      onError('Erro ao enviar feedback do app: $e');
      // if (context.mounted) {
      //   Navigator.pop(context);
      // }
    }
  }
}
