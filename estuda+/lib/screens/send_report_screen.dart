import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/pdf_view.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/theme/app_theme.dart';
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
  final StorageSharedPreferences storageSharedPreferences =
      StorageSharedPreferences();

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProviders>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Envio de Resumo de Desempenho',
            style: AppTheme.customTextStyle2(fontSize: 16),
          ),
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
          child: ListView(
            shrinkWrap: true,
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
                    //Routes().pushRoute(context, const HomeScreen());
                    setState(() {});
                  } else {
                    showSnackBarError(context,
                        'Por favor, insira um e-mail válido.', Colors.orange);
                  }
                },
                child: Text(
                  'Enviar Relatório',
                  style: AppTheme.customTextStyle2(color: Colors.indigo),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  color: Colors.black45,
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Resumos Enviados',
                    style: AppTheme.customTextStyle(color: Colors.black),
                  )),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: storageSharedPreferences.getReportHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Nenhum relatório encontrado.'));
                  } else {
                    final reports = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final report = reports[index];
                        return Card(
                          child: ListTile(
                            title: Text('Relatório de ${report['userName']}'),
                            subtitle: Text('Data: ${report['date']}'),
                            trailing: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                            ),
                            onTap: () {
                              print(report['filePath']);
                              Routes().pushFade(
                                context,
                                PdfViewerScreen(
                                  filePath: report['filePath'],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
