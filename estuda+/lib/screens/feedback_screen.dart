import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() async {
    if (_feedbackController.text.isEmpty) {
      showSnackBarFeedback(context, 'Insira seu Feedback', Colors.orange);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simule o envio do feedback (substitua por lógica real, como uma chamada de API)
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Obrigado pelo seu feedback!'),
        backgroundColor: Colors.green,
      ),
    );

    _feedbackController.clear();
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
              controller: _feedbackController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite seu feedback aqui...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
              ).copyWith(
                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.blue; // Cor quando pressionado
                    }
                    return Colors.indigo; // Cor padrão
                  },
                ),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    )
                  : Text(
                      'Enviar',
                      style: AppTheme.customTextStyle2(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
