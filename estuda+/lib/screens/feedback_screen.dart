import 'package:estudamais/controller/controller_feedback_app.dart';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/button_next.dart';
import 'package:estudamais/widgets/show_loading_dialog.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController feedbackMessage = TextEditingController();
  final FeedbackController feedbackController = FeedbackController();
  final FocusNode feedbackMessageFocusNode = FocusNode();

  @override
  void dispose() {
    feedbackMessage.dispose();
    super.dispose();
  }

  void submitFeedback() {
    if (feedbackMessage.text.isEmpty) {
      showSnackBarFeedback(context, 'Insira seu Feedback', Colors.orange);
      return;
    }
    feedbackMessageFocusNode.unfocus(); // Remove o foco do campo de texto
    showLoadingDialog(context, 'Enviando Feedback...');

    feedbackController.sendFeedbackApp(
      feedbackMessage.text,
      (success) {
        if (!mounted) return;
        showSnackBarFeedback(context, success, Colors.green);
        Navigator.pop(context); // Fecha o loading dialog
      },
      (error) {
        if (!mounted) return;
        showSnackBarFeedback(context, error, Colors.red);
        Navigator.pop(context); // Fecha o loading dialog
      },
    );

    feedbackMessage.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Deixe seu Feedback',
          style: AppTheme.customTextStyle2(fontSize: 20),
        ),
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Routes().popRoutes(context, const HomeScreen());
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sua opinião é muito importante para nós! Deixe seu feedback abaixo:',
              style: AppTheme.customTextStyle2(color: Colors.black87),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: feedbackMessage,
              focusNode: feedbackMessageFocusNode,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite seu feedback aqui...',
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
                onTap: () {
                  submitFeedback();
                },
                child: const ButtonNext(
                  textContent: 'Enviar',
                ))
          ],
        ),
      ),
    );
  }
}
