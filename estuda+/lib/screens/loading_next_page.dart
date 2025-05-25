import 'dart:async';
import 'package:estudamais/controller/controller_loading_next_page.dart';
import 'package:estudamais/controller/controller_report_resum.dart';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/service/service.dart';
import 'package:estudamais/service/service_resum_questions.dart';
import 'package:estudamais/storage_sqllite/storage_sqflite.dart';
import 'package:estudamais/theme/app_theme.dart';
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

  TextStyle textStyle = AppTheme.customTextStyle(
      fontWeight: true, color: Colors.indigo, fontSize: 13.0);

  @override
  void initState() {
    // Carrega os dados de resposta
    loading();
    super.initState();
  }

  int amountAnswereds = 0;
  Future<void> loadingDatas() async {
    int amountCorrects = 0;
    int amountIncorrects = 0;

    await StorageSqflite().getQuestions(StorageSqflite.tableQuestionsCorrects,
        (result) {
      Provider.of<GlobalProviders>(listen: false, context)
          .disciplinesAnsweredsCorrects(
        questionsCorrectsAndIncorrects.counterDiscipline(result),
      );
      amountCorrects = result.length;
      // atualiza a quantidade de questões respondidas corretamente atraves do provider
      Provider.of<GlobalProviders>(listen: false, context)
          .answeredsCorrects(amountCorrects.toString());
    });

    await StorageSqflite().getQuestions(StorageSqflite.tableQuestionsIncorrects,
        (result) {
      Provider.of<GlobalProviders>(listen: false, context)
          .disciplinesAnsweredsIncorrects(
        questionsCorrectsAndIncorrects.counterDiscipline(result),
      );
      amountIncorrects = result.length;
      // atualiza a quantidade de questões respondidas incorretamente atraves do provider
      Provider.of<GlobalProviders>(listen: false, context)
          .answeredsIncorrects(amountIncorrects.toString());
    });
    // atualiza a quantidade de questões respondidas incorretamente atraves do provider
    amountAnswereds = amountCorrects + amountIncorrects;
    // Provider.of<GlobalProviders>(listen: false, context)
    //     .answeredsAmount(amountAnswereds.toString());
  }

  void loading() {
    loadingDatas();
    Future.delayed(const Duration(seconds: 4), () {
      Routes().pushFade(context, const HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Loading(),

      // ValueListenableBuilder(
      //   valueListenable: msgLoading,
      //   builder: (context, value, child) {
      //     return SizedBox(
      //       width: MediaQuery.of(context).size.width,
      //       child: StreamBuilder(
      //         stream: controller.stream,
      //         builder: (context, AsyncSnapshot snapshot) {
      //           if (snapshot.hasError) {
      //             // Navigator.pop(context);
      //             return const Text(
      //                 'Algo saiu errado, tente novamente mais tarde');
      //           } else {
      //             switch (snapshot.connectionState) {
      //               case ConnectionState.none:
      //                 //print('none');
      //                 return Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     const Loading(),
      //                     Text('Aguardando dados...', style: textStyle),
      //                   ],
      //                 );
      //               case ConnectionState.waiting:
      //                 //print('waiting');
      //                 return Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     const Loading(),
      //                     Text('Aguardando informações...', style: textStyle),
      //                   ],
      //                 );
      //               case ConnectionState.active:
      //                 //print('active');
      //                 return Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     const Loading(),
      //                     Text(value, style: textStyle),
      //                   ],
      //                 );
      //               case ConnectionState.done:
      //                 if (Provider.of<GlobalProviders>(listen: false, context)
      //                     .isTimeOut) {
      //                   return Column(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       const Loading(),
      //                       Text('Tempo excedido!', style: textStyle),
      //                     ],
      //                   );
      //                 } else {
      //                   return Column(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       const Loading(),
      //                       Text('Pronto!', style: textStyle),
      //                     ],
      //                   );
      //                 }
      //             }
      //           }
      //         },
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
