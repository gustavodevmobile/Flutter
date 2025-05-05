import 'dart:async';
import 'package:estudamais/controller/controller_loading_next_page.dart';
import 'package:estudamais/controller/controller_report_resum.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/service/service.dart';
import 'package:estudamais/service/service_resum_questions.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:estudamais/widgets/loading.dart';
import 'package:provider/provider.dart';

class LoadingNextPage extends StatefulWidget {
  final String msgFeedbasck;
  const LoadingNextPage({
    required this.msgFeedbasck,
    super.key,
  });

  @override
  State<LoadingNextPage> createState() => _LoadingNextPageState();
}

class _LoadingNextPageState extends State<LoadingNextPage> {
  ServiceResumQuestions questionsCorrectsAndIncorrects =
      ServiceResumQuestions();

  Service service = Service();
  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();
  ValueNotifier<String> msgLoading = ValueNotifier<String>('Buscando dados...');
  ControllerReportResum controllerReportResum = ControllerReportResum();
  ControllerLoadingNextPage controllerLoadingNextPage =
      ControllerLoadingNextPage();

  TextStyle textStyle = AppTheme.customTextStyle(
      fontWeight: true, color: Colors.indigo, fontSize: 13.0);

  late final StreamController controller = controllerLoadingNextPage
      .streamProccess(mounted, widget.msgFeedbasck, context, (msgFeedback) {
    msgLoading.value = msgFeedback;
  });

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: msgLoading,
        builder: (context, value, child) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder(
              stream: controller.stream,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  // Navigator.pop(context);
                  return const Text(
                      'Algo saiu errado, tente novamente mais tarde');
                } else {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      //print('none');
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Loading(),
                          Text('Aguardando dados...', style: textStyle),
                        ],
                      );
                    case ConnectionState.waiting:
                      //print('waiting');
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Loading(),
                          Text('Aguardando informações...', style: textStyle),
                        ],
                      );
                    case ConnectionState.active:
                      //print('active');
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Loading(),
                          Text(value, style: textStyle),
                        ],
                      );
                    case ConnectionState.done:
                      if (Provider.of<GlobalProviders>(listen: false, context)
                          .isTimeOut) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Loading(),
                            Text('Tempo excedido!', style: textStyle),
                          ],
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Loading(),
                            Text('Pronto!', style: textStyle),
                          ],
                        );
                      }
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }
}
