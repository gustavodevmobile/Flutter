import 'package:estudamais/controller/controller_feedback_app.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/show_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';

class FeedbackModal extends StatefulWidget {
  final String questionId;

  const FeedbackModal({required this.questionId, super.key});

  @override
  FeedbackModalState createState() => FeedbackModalState();
}

class FeedbackModalState extends State<FeedbackModal> {
  final FeedbackController feedbackController = FeedbackController();
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
    Navigator.pop(context); // Fecha o modal
    if (selectedOptions.isEmpty) {
      showSnackBarFeedback(context,
          'Selecione pelo menos uma opção de feedback!', Colors.orange);
      Navigator.pop(context); // Fecha o modal
    }
    //Navigator.pop(context); // Fecha o modal
    // Exibe o loading dialog
    showLoadingDialog(context, 'Enviando feedback...');
    // Envia o feedback para o controller
    await feedbackController.sendFeedbackFailures(
      widget.questionId,
      selectedOptions,
      (success) {
        if (!mounted) return;
        showSnackBarFeedback(context, success, Colors.green);
        Navigator.pop(context); // Fecha o modal
      },
      (error) {
        if (!mounted) return;
        showSnackBarFeedback(context, error, Colors.red);
        Navigator.pop(context); // Fecha o modal
      },
    );
    //Navigator.pop(context); // Fecha o modal
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecione os problemas encontrados:',
              style:
                  AppTheme.customTextStyle2(color: Colors.black, fontSize: 16),
            ),
            //const SizedBox(height: 10),
            ...feedbackOptions.map((option) {
              return CheckboxListTile(
                title: Text(
                  option,
                  style: AppTheme.customTextStyle2(
                      color: Colors.indigo, fontSize: 18),
                ),
                value: selectedOptions.contains(option),
                onChanged: (_) {
                  toggleOption(option);
                },
              );
            }),
            // const SizedBox(height: 10),
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
                  child: Text(
                    'Cancelar',
                    style: AppTheme.customTextStyle2(color: Colors.red),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
