import 'package:estudamais/theme/app_theme.dart';
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
    'Erro de digitação',
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
      Navigator.pop(context); // Fecha o modal
    }

    await serviceFeedbacks.sendFeedback(
      widget.questionId,
      context,
      selectedOptions,
      (success) {
        if(!mounted) return;
        showSnackBarError(context, success, Colors.green);
        Navigator.pop(context); // Fecha o modal
      },
      (error) {
        if(!mounted) return;
        showSnackBarError(context, error, Colors.red);
        Navigator.pop(context); // Fecha o modal
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
          const SizedBox(height: 14),
          ...feedbackOptions.map((option) {
            return CheckboxListTile(
              title: Text(option,
                  style: AppTheme.customTextStyle2(
                      color: Colors.indigo, fontSize: 18)),
              value: selectedOptions.contains(option),
              onChanged: (_) {
                toggleOption(option);
              },
            );
          }),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: sendFeedback,
                child: Text(
                  'Enviar Feedback',
                  style: AppTheme.customTextStyle2(color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Fecha o modal
                },
                child: Text('Cancelar',
                    style: AppTheme.customTextStyle2(color: Colors.red)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
