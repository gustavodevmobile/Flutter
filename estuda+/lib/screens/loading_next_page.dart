import 'dart:async';
import 'dart:convert';
import 'package:estudamais/controller/controller_loading_next_page.dart';
import 'package:estudamais/controller/controller_report_resum.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/service/service.dart';
import 'package:estudamais/service/service_resum_questions.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:estudamais/widgets/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
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

  TextStyle textStyle = GoogleFonts.aboreto(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.indigo,
  );

  late final StreamController controller = StreamController(
    onListen: () {
      if (mounted) {
        controller
            .addStream(controllerLoadingNextPage.processDatas(
                context, widget.msgFeedbasck, mounted, (msgFeedback) {
          msgLoading.value = msgFeedback;
        }))
            .whenComplete(() {
          controller.close();
          if (mounted) {
            controllerLoadingNextPage.toHomeScreen(context);
          }
        });
      }
    },
    onCancel: () {
      controller.close();
    },
  );

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
                  Navigator.pop(context);
                  return const Text(
                      'Algo saiu errado, tente novamente mais tarde');
                  //showSnackBar(context, 'deu ruim', Colors.red);
                } else {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Loading(),
                          Text('Aguardando dados...', style: textStyle),
                        ],
                      );
                    case ConnectionState.waiting:
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Loading(),
                          Text('Aguardando informações...', style: textStyle),
                        ],
                      );
                    case ConnectionState.active:
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Loading(),
                          Text(value, style: textStyle),
                        ],
                      );
                    case ConnectionState.done:
                      return Text('Pronto!', style: textStyle);
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
