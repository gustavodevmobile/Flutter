import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/pdf_view.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/button_next.dart';
import 'package:estudamais/widgets/show_loading_dialog.dart';
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
  final FocusNode emailFocusNode = FocusNode();
  bool isEmailSaved = false; // Estado do checkbox
  String savedEmail = ''; // E-mail salvo

  Future<List<Map<String, dynamic>>>? future =
      StorageSharedPreferences().getReportHistory();

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose(); // Limpe o FocusNode
    super.dispose();
  }

  @override
  void initState() {
    storageSharedPreferences.getSavedEmail((error) {
      print('Erro ao recuperar e-mail salvo: $error');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProviders>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Envio de Resumo de Desempenho',
            style: AppTheme.customTextStyle2(fontSize: 17),
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
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Colors.black12,
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                TextField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'E-mail do destinatário',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Checkbox(
                          value: isEmailSaved,
                          onChanged: (value) {
                            setState(() {
                              isEmailSaved = value ?? false;
                              print('isEmailSaved: $isEmailSaved');
                            });

                            if (isEmailSaved) {
                              // Salva o e-mail no SharedPreferences
                              savedEmail = emailController.text.trim();
                            } else {
                              savedEmail = '';
                            }
                          },
                        ),
                        const Text('Salvar e-mail'),
                      ],
                    ),
                  ),
                ),
                //const SizedBox(height: 8),
                GestureDetector(
                    onTap: () async {
                      emailFocusNode.unfocus();
                      final email = emailController.text.trim();
                      if (email.isNotEmpty) {
                        showLoadingDialog(context, 'Enviando...');
                        controller.sendReportToBackend(
                            value.reportsCorrects,
                            value.reportsCorrects.length.toString(),
                            value.reportsIncorrects,
                            value.reportsIncorrects.length.toString(),
                            email,
                            context, (onError) {
                          showSnackBarFeedback(context, onError, Colors.orange);
                        }, value.answeredsCurrents).then((_) {
                          setState(() {
                            future =
                                storageSharedPreferences.getReportHistory();
                          });
                        });
                        if(isEmailSaved){
                          storageSharedPreferences.savedEmail(email, (onError) {
                          showSnackBarFeedback(context, onError, Colors.red);
                        });
                        }
                      } else {
                        showSnackBarFeedback(
                            context, 'Insira um e-mail válido.', Colors.orange);
                      }
                      emailController.clear();
                    },
                    child: const ButtonNext(
                      textContent: 'Enviar Resumo',
                      fontSize: 15,
                      height: 35,
                    )),
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
                    style: AppTheme.customTextStyle(
                        color: Colors.indigo, fontWeight: true),
                  ),
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Erro: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Nenhum relatório encontrado.'),
                      );
                    } else {
                      final reports = snapshot.data!;
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          final report = reports[index];
                          return Dismissible(
                            key: Key(report['id']),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              // Remove o item da lista imediatamente
                              reports.removeWhere(
                                  (el) => el['id'] == report['id']);
                              // Remove o relatório da lista e atualiza o estado
                              setState(() {
                                // Remova o relatório do armazenamento local
                                StorageSharedPreferences().removeReportHistory(
                                    report['id'], (success) {
                                  showSnackBarFeedback(
                                      context, success, Colors.green);
                                }, (error) {
                                  showSnackBarFeedback(
                                      context, error, Colors.red);
                                  Navigator.pop(context);
                                });
                              });
                            },
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  'Resumo Gerado',
                                  style: AppTheme.customTextStyle2(
                                      color: Colors.black, fontSize: 16),
                                ),
                                subtitle: Text(
                                  '${report['date']} - ${report['hours']}',
                                  style: AppTheme.customTextStyle2(
                                      color: Colors.indigo, fontSize: 12),
                                ),
                                trailing: const Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  Routes().pushFade(
                                    context,
                                    PdfViewerScreen(
                                      filePath: report['filePath'],
                                    ),
                                  );
                                },
                              ),
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
        ),
      );
    });
  }
}
