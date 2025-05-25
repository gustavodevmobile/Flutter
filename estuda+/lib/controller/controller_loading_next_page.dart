import 'package:estudamais/controller/controller_report_resum.dart';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/service/service_resum_questions.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/storage_sqllite/storage_sqflite.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

ServiceResumQuestions questionsCorrectsAndIncorrects = ServiceResumQuestions();
StorageSharedPreferences sharedPreferences = StorageSharedPreferences();

class ControllerLoadingNextPage {
  Future<void> updateDatas(BuildContext context) async {
    int amountCorrects = 0;
    int amountIncorrects = 0;
    int amountAnswereds = 0;

    await StorageSqflite().getQuestions(StorageSqflite.tableQuestionsCorrects,
        (resultCorrects) {
      // passa o returno do método counterDiscipline para atualizar na home as disciplinas respondidas corretamente
      Provider.of<GlobalProviders>(listen: false, context)
          .disciplinesAnsweredsCorrects(
        questionsCorrectsAndIncorrects.counterDiscipline(resultCorrects),
      );
      amountCorrects = resultCorrects.length;

      // atualiza a quantidade de questões respondidas corretamente atraves do provider
      Provider.of<GlobalProviders>(listen: false, context)
          .answeredsCorrects(amountCorrects.toString());

      Provider.of<GlobalProviders>(listen: false, context)
          .questionsCorrects(resultCorrects);

      // obtém todas as questões respondidas corretamente
      Provider.of<GlobalProviders>(listen: false, context)
          .questionsCorrects(resultCorrects);

      // cria a lista de resumo das questões corretas, para envio ao backend.
      ControllerReportResum().reportPerformance(resultCorrects, context,
          (resultReport) {
        Provider.of<GlobalProviders>(listen: false, context)
            .reportResumCorrects(resultReport);
      }, (error) {
        showSnackBarFeedback(context, error, Colors.red);
      });
    });

    await StorageSqflite().getQuestions(StorageSqflite.tableQuestionsIncorrects,
        (resultIncorrects) {
      Provider.of<GlobalProviders>(listen: false, context)
          .disciplinesAnsweredsIncorrects(
        questionsCorrectsAndIncorrects.counterDiscipline(resultIncorrects),
      );
      amountIncorrects = resultIncorrects.length;
      // atualiza a quantidade de questões respondidas incorretamente atraves do provider
      Provider.of<GlobalProviders>(listen: false, context)
          .answeredsIncorrects(amountIncorrects.toString());

      // obtém todas as questões respondidas incorretamente
      Provider.of<GlobalProviders>(listen: false, context)
          .questionsIncorrects(resultIncorrects);

      // cria a lista de resumo das questões incorretas, para envio ao backend.
      ControllerReportResum().reportPerformance(resultIncorrects, context,
          (resultReport) {
        Provider.of<GlobalProviders>(listen: false, context)
            .reportResumIncorrects(resultReport);
      }, (error) {
        showSnackBarFeedback(context, error, Colors.red);
      });
    });
    // atualiza a quantidade de questões respondidas incorretamente atraves do provider
    amountAnswereds = amountCorrects + amountIncorrects;
    if (context.mounted) {
      Provider.of<GlobalProviders>(listen: false, context)
          .answeredsAmount(amountAnswereds.toString());
    }
  }

  void loadingNextPage(BuildContext context){
    updateDatas(context);
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Routes().pushFade(context, const HomeScreen());
      }
    });
  }
}
