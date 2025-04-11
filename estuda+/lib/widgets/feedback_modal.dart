import 'package:flutter/material.dart';
import 'package:estudamais/service/service_feedbacks.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';

class FeedbackModal extends StatefulWidget {
  final String questionId;

  const FeedbackModal({required this.questionId, super.key});

  @override
  FeedbackModalState createState() => FeedbackModalState();
}

class FeedbackModalState extends State<FeedbackModal> {
  final ServiceFeedbacks serviceFeedbacks = ServiceFeedbacks();
  final List<String> feedbackOptions = [
    'Erro no enunciado',
    'Erro nas alternativas',
    'Erro na resposta correta',
    'Outro problema'
  ];
  final List<String> selectedOptions = [];

  void toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  void sendFeedback() async {
    if (selectedOptions.isEmpty) {
      showSnackBarError(context, 'Selecione pelo menos uma opção de feedback!',
          Colors.orange);
      return;
    }

    await serviceFeedbacks.sendFeedback(
      widget.questionId,
      context,
      selectedOptions,
      (response) {
        showSnackBarError(
            context, response, Colors.green);
        Navigator.pop(context); // Fecha o modal
      },
      (error) {
        showSnackBarError(context, error, Colors.red);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione os problemas encontrados:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...feedbackOptions.map((option) {
            return CheckboxListTile(
              title: Text(option),
              value: selectedOptions.contains(option),
              onChanged: (_) {
                toggleOption(option);
              },
            );
          }),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: sendFeedback,
                child: const Text('Enviar Feedback'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Fecha o modal
                },
                child: const Text('Cancelar'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
