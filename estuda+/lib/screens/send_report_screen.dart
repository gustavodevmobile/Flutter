import 'dart:async';
import 'dart:io';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/pdf_view.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/button_next.dart';
import 'package:estudamais/widgets/custom_dropdown.dart';
import 'package:estudamais/widgets/show_loading_dialog.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:estudamais/controller/controller_report_resum.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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
  List<String> listSavedEmails = []; // Lista de e-mails salvos
  String? selectedEmail; // E-mail selecionado no dropdown
  final GlobalKey<CustomDropdownState> dropdownKey = GlobalKey();

  Future<List<Map<String, dynamic>>>? future =
      StorageSharedPreferences().getReportHistory();

  //void shareFile(String filePath) async {
    
    // final file = File(filePath);

    // if (file.existsSync()) {
    //   SharePlus.instance.([filePath], text: 'Confira este documento PDF!');
    // } else {
    //   showSnackBarFeedback(context, 'Arquivo não encontrado.', Colors.red);
    // }
    // final params = ShareParams(
    //   text: 'Confira este documento PDF!',
    //   files: [XFile(filePath)],
    // );

    // final result = await SharePlus.instance.share(params);

    // if (result.status == ShareResultStatus.success) {
    //   print('Arquivo compartilhado com sucesso!');
    // }
  //}

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    storageSharedPreferences.getSavedEmail((error) {
      showSnackBarFeedback(context, error, Colors.red);
    }).then((list) {
      setState(() {
        listSavedEmails = list;
      });
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
              // fecha o dropdown menu se estiver aberto
              onPressed: () {
                if (value.isMenuOpen) {
                  value.closeDropdownMenu(false);
                  dropdownKey.currentState?.closeMenu();
                }

                //dropdownKey.currentState?.overlayEntry?.remove();
                //dropdownKey.currentState?.overlayEntry = null;
                Routes().popRoutes(
                  context,
                  const HomeScreen(),
                );
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
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                  ),
                  child: Text(
                    'Emails salvos:',
                    style: AppTheme.customTextStyle2(color: Colors.indigo),
                  ),
                ),
                CustomDropdown(
                  key: dropdownKey,
                  items: listSavedEmails,
                  onItemSelected: (value) {
                    setState(() {
                      selectedEmail = value;
                      emailController.text = selectedEmail!;
                    });
                  },
                ),
                const SizedBox(height: 18),
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
                            });

                            if (isEmailSaved) {
                              // Hábilita salvar o e-mail no SharedPreferences
                              savedEmail = emailController.text.trim();
                            } else {
                              savedEmail = '';
                            }
                          },
                        ),
                        Text(
                          'Salvar e-mail',
                          style: AppTheme.customTextStyle2(
                              color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
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
                            // atualiaza a lista de resumos enviados
                            future =
                                storageSharedPreferences.getReportHistory();
                            // atualiza a lista de emails salvos
                            storageSharedPreferences.getSavedEmail((error) {
                              showSnackBarFeedback(context, error, Colors.red);
                            }).then((list) {
                              setState(() {
                                listSavedEmails = list;
                              });
                            });
                            isEmailSaved = false;
                          });
                        });
                        if (isEmailSaved) {
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
                                storageSharedPreferences.removeReportHistory(
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
                                minTileHeight: 4,
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
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.share,
                                        color: Colors.black87,
                                      ),
                                      onPressed: () {
                                        //shareFile(report['filePath']);
                                      },
                                    ),
                                    const Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.red,
                                    ),
                                  ],
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
