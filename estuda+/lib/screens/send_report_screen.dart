import 'dart:async';
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
  //final GlobalKey<CustomDropdownState> dropdownKey = GlobalKey();

  Future<List<Map<String, dynamic>>>? future =
      StorageSharedPreferences().getReportHistory();

  void shareFile(String filePath) async {
    final params = ShareParams(
      text: 'Confira este documento PDF!',
      files: [XFile(filePath)],
    );

    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.success) {
      print('Arquivo compartilhado com sucesso!');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   storageSharedPreferences.getSavedEmail((error) {
  //     showSnackBarFeedback(context, error, Colors.red);
  //   }).then((list) {
  //     setState(() {
  //       listSavedEmails = list;
  //     });
  //   });
  //   super.initState();
  // }

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
                GestureDetector(
                    onTap: () async {
                      showLoadingDialog(context, 'Enviando...');
                      controller.sendReportToBackend(
                          value.reportsCorrects,
                          value.reportsCorrects.length.toString(),
                          value.reportsIncorrects,
                          value.reportsIncorrects.length.toString(),
                          context, (onError) {
                        showSnackBarFeedback(context, onError, Colors.red);
                      }, value.answeredsCurrents).then((_) {
                        setState(() {
                          // atualiaza a lista de resumos enviados
                          future = storageSharedPreferences.getReportHistory();
                        });
                      });
                    },
                    child: const ButtonNext(
                      textContent: 'Gerar resumo em PDF',
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
                    'Resumos Gerados',
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
                        child: Text('Nenhum resumo gerado.'),
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
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);
                              // Remova o relatório do armazenamento local
                              storageSharedPreferences.removeReportHistory(
                                  report['id'], (onSuccess) {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(onSuccess,
                                        style: AppTheme.customTextStyle2()),
                                    backgroundColor: Colors.green,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }, (onError) {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(onError,
                                        style: AppTheme.customTextStyle2()),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              });
                              setState(() {
                                reports.removeWhere(
                                    (el) => el['id'] == report['id']);
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
                                        shareFile(report['filePath']);
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
