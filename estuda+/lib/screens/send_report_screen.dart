import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:estudamais/controller/controller_report_resum.dart';
import 'package:provider/provider.dart';

class SendReportScreen extends StatefulWidget {
  const SendReportScreen({super.key});

  @override
  State<SendReportScreen> createState() => _SendReportScreenState();
}

class _SendReportScreenState extends State<SendReportScreen> {
  final TextEditingController emailController = TextEditingController();
  final ControllerReportResum controller = ControllerReportResum();

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProviders>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(title: const Text('Enviar Relatório')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail do destinatário',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text.trim();

                  if (email.isNotEmpty) {
                    controller.sendReportToBackend(
                        value.reportsCorrects,
                        value.reportsCorrects.length.toString(),
                        value.reportsIncorrects,
                        value.reportsIncorrects.length.toString(),
                        email,
                        context, (onError) {
                      showSnackBarError(context, onError, Colors.red);
                    }, value.answeredsCurrents);
                    //if(!mounted)
                    //Navigator.pop(context);
                  } else {
                    showSnackBarError(context,
                        'Por favor, insira um e-mail válido.', Colors.orange);
                  }
                },
                child: const Text('Enviar Relatório'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
