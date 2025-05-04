import 'dart:async';
import 'dart:convert';

import 'package:estudamais/controller/controller_report_resum.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/service/service.dart';
import 'package:estudamais/service/service_resum_questions.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

/// This class is used to manage the loading state of the next page in the app.
/// It provides methods to show and hide a loading dialog, and to handle the navigation to the homescreen.
class ControllerLoadingNextPage {
  ServiceResumQuestions questionsCorrectsAndIncorrects =
      ServiceResumQuestions();
  Service service = Service();
  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();
  ValueNotifier<String> msgLoading = ValueNotifier<String>('Buscando dados...');
  ControllerReportResum controllerReportResum = ControllerReportResum();
  List<String> idsAnswereds = [];
  List<String> idsCorrects = [];
  List<String> idsIncorrects = [];
  List<ModelQuestions> corrects = [];
  List<ModelQuestions> incorrects = [];

  //final StreamController<String> _streamController = StreamController<String>();

  // Stream<String> get stream => _streamController.stream;
  // Sink<String> get sink => _streamController.sink;

  // void dispose() {
  //   _streamController.close();
  // }

  void toHomeScreen(
    BuildContext context,
  ) {
// atualiza a quantidade de questões respondidas atraves do provider
    Provider.of<GlobalProviders>(listen: false, context)
        .answeredsAmount(idsAnswereds.length.toString());

    // atualiza a quantidade de questões respondidas corretamente atraves do provider
    Provider.of<GlobalProviders>(listen: false, context)
        .answeredsCorrects(corrects.length.toString());

    // atualiza a quantidade de questões respondidas incorretamente atraves do provider
    Provider.of<GlobalProviders>(listen: false, context)
        .answeredsIncorrects(incorrects.length.toString());

    // passa o returno do método counterDisciplineIncorrects para atualizar na home as disciplinas respondidas corretamente
    Provider.of<GlobalProviders>(listen: false, context)
        .disciplinesAnsweredsCorrects(
            questionsCorrectsAndIncorrects.counterDiscipline(corrects));

    // passa o returno do método counterDisciplineIncorrects para atualizar na home as disciplinas respondidas incorretamente
    Provider.of<GlobalProviders>(listen: false, context)
        .disciplinesAnsweredsIncorrects(
            questionsCorrectsAndIncorrects.counterDiscipline(incorrects));

    // obtém todas as questões respondidas corretamente
    Provider.of<GlobalProviders>(listen: false, context)
        .questionsCorrects(corrects);

    // obtém todas as questões respondidas incorretamente
    Provider.of<GlobalProviders>(listen: false, context)
        .questionsIncorrects(incorrects);

    // cria a lista de resumo das questões corretas, para envio ao backend.
    controllerReportResum.reportCorrectsQuestions(
        corrects,
        StorageSharedPreferences.keyIdsAndDateAnsweredsCorrectsResum,
        context, (resultReport) {
      Provider.of<GlobalProviders>(listen: false, context)
          .reportResumCorrects(resultReport);
    }, (error) {
      showSnackBarFeedback(context, error, Colors.red);
    });

    // cria a lista de resumo das questões incorretas, para envio ao backend.
    controllerReportResum.reportCorrectsQuestions(
        incorrects,
        StorageSharedPreferences.keyIdsAndDateAnsweredsIncorrectsResum,
        context, (resultReport) {
      Provider.of<GlobalProviders>(listen: false, context)
          .reportResumIncorrects(resultReport);
    }, (error) {
      showSnackBarFeedback(context, error, Colors.red);
    });

    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        duration: const Duration(seconds: 1),
        child: const HomeScreen(),
      ),
    );
  }

  // void timeOut(BuildContext context, bool mounted) {
  //   final scaffoldMessenger = ScaffoldMessenger.of(context);
  //   scaffoldMessenger.showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         'Tempo de conexão excedido, tente novamente mais tarde',
  //         style: AppTheme.customTextStyle2(color: Colors.white),
  //       ),
  //       backgroundColor: Colors.red,
  //     ),
  //   );
  //   if (mounted) {
  //     Navigator.pop(context);
  //   }
  // }

  Future fetchAnsweredsIds(
      ScaffoldMessengerState scaffoldMessenger,
      Function(String) msgFeedback,
      Function(List<String>) answeredsIds,
      Function(String) onError,
      Function(bool) isExpired) async {
    List<String> ids = [];
    try {
      msgFeedback('questões respondidas...');
      ids = await sharedPreferences
          .recoverIds(
              StorageSharedPreferences.keyIdsAnswereds,
              (error) => print(
                  error) //showSnackBarFeedback(context, error, Colors.red),
              )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(
                'Tempo de conexão excedido, tente novamente mais tarde',
                style: AppTheme.customTextStyle2(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
          isExpired(true);
          return onError(
            'Tempo de espera excedido, tente novamente mais tarde',
          );
        },
      );
      //print('ids $ids');
      answeredsIds(ids);
    } catch (e) {
      onError('Algo deu errado em buscas ids das questões respondidas: $e ');
    }
  }

  Future fetchIds(
      String msg,
      String keyId,
      ScaffoldMessengerState scaffoldMessenger,
      Function(String) msgFeedback,
      Function(List<String>) listIds,
      Function(String) onError,
      Function(bool) isExpired) async {
    msgFeedback('questões $msg...');
    List<String> listJson = [];
    List<String> ids = [];
    try {
      listJson = await sharedPreferences
          .recoverIds(
              keyId,
              (error) => print(
                  error) //showSnackBarFeedback(context, error, Colors.red),
              )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(
                'Tempo de conexão excedido, tente novamente mais tarde',
                style: AppTheme.customTextStyle2(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
          isExpired(true);
          return onError(
            'Tempo de espera excedido, tente novamente mais tarde',
          );
        },
      );
      for (var json in listJson) {
        Map<String, dynamic> map = jsonDecode(json);
        ids.add(map['id']);
      }

      listIds(ids);
    } catch (e) {
      onError('Algo deu errado em buscar ids das questões corretas: $e ');
    }
  }

  Future fetchQuestions(
      ScaffoldMessengerState scaffoldMessenger,
      Function(String) msgFeedback,
      List<String> listIds,
      Function(List<ModelQuestions>) questionsResult,
      Function(String) onError,
      Function(bool) isExpired) async {
    msgFeedback('questões corretas...');
    List<ModelQuestions> questions = [];
    try {
      questions =
          await questionsCorrectsAndIncorrects.getQuestions(listIds, (error) {
        //showSnackBarFeedback(context, error, Colors.red);
      }).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(
                'Tempo de conexão excedido, tente novamente mais tarde',
                style: AppTheme.customTextStyle2(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
          isExpired(true);
          return onError(
            'Tempo de espera excedido, tente novamente mais tarde',
          );
        },
      );
      questionsResult(questions);
    } catch (e) {
      onError('Algo deu errado em buscar questões corretas: $e ');
    }
  }

  Stream processDatas(BuildContext context, String msgFeedbasck, bool mounted,
      Function(String) msgFeedback) async* {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    //final navigator = Navigator.of(context);
    yield await fetchAnsweredsIds(
      scaffoldMessenger,
      (msgFeedbasck) {
        msgFeedback(msgFeedbasck);
      },
      (answeredsIds) {
        idsAnswereds = answeredsIds;
      },
      (onError) {
        msgLoading.value = onError;
      },
      (isExpired) {
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
    yield await fetchIds(
      'corretas',
      StorageSharedPreferences.keyIdsAndDateAnsweredsCorrectsResum,
      scaffoldMessenger,
      (msgFeedbasck) {
        msgFeedback(msgFeedbasck);
      },
      (listIds) {
        idsCorrects = listIds;
      },
      (onError) {
        msgLoading.value = onError;
      },
      (isExpired) {
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
    yield await fetchIds(
      'incorretas',
      StorageSharedPreferences.keyIdsAndDateAnsweredsIncorrectsResum,
      scaffoldMessenger,
      (msgFeedbasck) {
        msgFeedback(msgFeedbasck);
      },
      (listIds) {
        idsIncorrects = listIds;
      },
      (onError) {
        msgLoading.value = onError;
      },
      (isExpired) {
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
    yield await fetchQuestions(
      scaffoldMessenger,
      (msgFeedbasck) {
        msgFeedback(msgFeedbasck);
      },
      idsCorrects,
      (questions) {
        corrects = questions;
      },
      (onError) {
        msgLoading.value = onError;
      },
      (isExpired) {
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
    yield await fetchQuestions(
      scaffoldMessenger,
      (msgFeedbasck) {
        msgFeedback(msgFeedbasck);
      },
      idsIncorrects,
      (questions) {
        incorrects = questions;
      },
      (onError) {
        msgLoading.value = onError;
      },
      (isExpired) {
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
  }

//  StreamController streamProccess(bool mounted, String msgFeedbasck, BuildContext context) {
//   late final StreamController streamController;
//   return streamController = StreamController(
//       onListen: () {
//         if (mounted) {
//           streamController.addStream(
//             processDatas(
//               context,
//               msgFeedbasck,
//               mounted,
//               (msgFeedback) {
//                 msgLoading.value = msgFeedback;
//               },
//             ),
//           );
//         }
//       },
//       onCancel: () {
//         streamController.close();
//       },
//     );
 //}
}
