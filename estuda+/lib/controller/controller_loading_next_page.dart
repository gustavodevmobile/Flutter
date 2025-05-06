import 'dart:async';
import 'dart:convert';

import 'package:estudamais/controller/controller_report_resum.dart';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/initial_screen.dart';
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
  //ValueNotifier<String> msgLoading = ValueNotifier<String>('Buscando dados...');
  ControllerReportResum controllerReportResum = ControllerReportResum();
  List<String> idsAnswereds = [];
  List<String> idsCorrects = [];
  List<String> idsIncorrects = [];
  List<ModelQuestions> corrects = [];
  List<ModelQuestions> incorrects = [];
  bool shouldCancel = false; // Variável de controle para cancelar o fluxo

  toHomeScreen(
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
      questionsCorrectsAndIncorrects.counterDiscipline(
        corrects,
        (error) {
          showSnackBarFeedback(context, error, Colors.red);
        },
      ),
    );

    // passa o returno do método counterDisciplineIncorrects para atualizar na home as disciplinas respondidas incorretamente
    Provider.of<GlobalProviders>(listen: false, context)
        .disciplinesAnsweredsIncorrects(
      questionsCorrectsAndIncorrects.counterDiscipline(
        incorrects,
        (error) {
          showSnackBarFeedback(context, error, Colors.red);
        },
      ),
    );

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

    return Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        duration: const Duration(seconds: 1),
        child: const HomeScreen(),
      ),
    );
  }

  //  Este médodo mostra o snackbar de erro quando o tempo de espera é excedido
  //  e o usuário não está mais na tela de loading.
  void timeOut(ScaffoldMessengerState scaffoldMessenger, String msg) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: AppTheme.customTextStyle2(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

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
    msgFeedback('$msg...');
    List<String> listJson = [];
    List<String> ids = [];
    try {
      listJson = await sharedPreferences
          .recoverIds(keyId, (error) => timeOut(scaffoldMessenger, error))
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
      print('listJson $listJson');
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
    String textFeedback, // 'corretas' ou 'incorretas'
    ScaffoldMessengerState scaffoldMessenger, //
    Function(String) msgFeedback, // mensagem de feedback
    List<String> listIds, // lista de ids das questões corretas ou incorretas
    Function(List<ModelQuestions>)
        questionsResult, // função que recebe as questões corretas ou incorretas
    Function(String) onError, // função de erro
    Function(bool) isExpired, // função que indica se a requisição expirou
  ) async {
    msgFeedback('$textFeedback...');
    List<ModelQuestions> questions = [];
    try {
      questions = await questionsCorrectsAndIncorrects
          .getQuestionsAnswereds(listIds, (error) {
        timeOut(scaffoldMessenger, error);
      }, (timeExpired) {
        isExpired(timeExpired);
      });
      questionsResult(questions);
    } catch (e) {
      onError('Algo deu errado em buscar questões corretas: $e ');
    }
  }

  Stream processDatas(BuildContext context, String textFeedback, bool mounted,
      Function(String) msgFeedback, StreamController streamController) async* {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Provider.of<GlobalProviders>(context, listen: false).timeOut(false);

    yield await fetchAnsweredsIds(
      scaffoldMessenger,
      (msgFeedbasck) {
        msgFeedback(msgFeedbasck);
      },
      (answeredsIds) {
        idsAnswereds = answeredsIds;
      },
      (onError) {
        msgFeedback(onError);
      },
      (isExpired) {
        if (mounted) {
          Navigator.pop(context);
        }
        shouldCancel = true; // Define que o fluxo deve ser cancelado
        //streamController.close();
      },
    );
    if (shouldCancel) {
      print(
          'cancelou o fluxo 0'); // Fecha o StreamController se o fluxo foi cancelado
      streamController.close();
      return;
    }

    yield await fetchIds(
      '$textFeedback ids corretas',
      StorageSharedPreferences.keyIdsAndDateAnsweredsCorrectsResum,
      scaffoldMessenger,
      (feedback) {
        msgFeedback(feedback);
      },
      (listIds) {
        idsCorrects = listIds;
      },
      (onError) {
        msgFeedback(onError);
      },
      (isExpired) {
        if (mounted) {
          Navigator.pop(context);
        }
        shouldCancel = true; // Define que o fluxo deve ser cancelado
      },
    );
    if (shouldCancel) {
      print(
          'cancelou o fluxo'); // Fecha o StreamController se o fluxo foi cancelado
      streamController.close();
      return;
    }

    yield await fetchIds(
      '$textFeedback ids incorretas',
      StorageSharedPreferences.keyIdsAndDateAnsweredsIncorrectsResum,
      scaffoldMessenger,
      (feedback) {
        msgFeedback(feedback);
      },
      (listIds) {
        idsIncorrects = listIds;
      },
      (onError) {
        msgFeedback(onError);
      },
      (isExpired) {
        if (mounted) {
          Navigator.pop(context);
        }
        shouldCancel = true; // Define que o fluxo deve ser cancelado
      },
    );
    if (shouldCancel) {
      print(
          'cancelou o fluxo'); // Fecha o StreamController se o fluxo foi cancelado
      streamController.close();
      return;
    }

    yield await fetchQuestions(
      '$textFeedback questões corretas', // envia mensagem para ser mostrara no loading
      scaffoldMessenger,
      (feedback) {
        msgFeedback(
            feedback); // recebe a mensagem de feedback no loading e envia a ao fluxo para ser mostrada no loading.
      },
      idsCorrects,
      (questions) {
        corrects =
            questions; // atribui as questões corretas à variável corrects
      },
      (onError) {
        msgFeedback(onError);
      },
      (isExpired) {
        // Se a requisição expirar, mostra uma mensagem no loading Tempo Excedido.
        Provider.of<GlobalProviders>(context, listen: false).timeOut(true);
        // espera 2 segundos para ir para a tela ScreenInitial
        Future.delayed(
          const Duration(seconds: 2),
          () {
            if (context.mounted) {
              Routes().popRoutes(
                context,
                const ScreenInitial(),
              );
            }
          },
        );
        shouldCancel = true; // Define que o fluxo deve ser cancelado
      },
    );
    if (shouldCancel) {
      streamController.close(); // Fecha o StreamController
      return;
    }
    print('fluxo 4');
    yield await fetchQuestions(
      '$textFeedback questões incorretas',
      scaffoldMessenger,
      (feedback) {
        msgFeedback(feedback);
      },
      idsIncorrects,
      (questions) {
        incorrects = questions;
      },
      (onError) {
        msgFeedback(onError);
      },
      (isExpired) {
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
    print('concluiu os fluxos');
    streamController.close(); // Fecha o StreamController após o processamento
  }

  StreamController streamProccess(bool mounted, String textFeedback,
      BuildContext context, Function(String) msgFeedback) {
    final StreamController streamController = StreamController();

    streamController.onListen = () {
      processDatas(
        context,
        textFeedback,
        mounted,
        (msg) {
          msgFeedback(msg);
        },
        streamController,
      ).listen(
        (event) {
          streamController.add(event);
        },
        onError: (error) {
          print('Erro no fluxo: $error');
          streamController.addError(error);
          streamController.close(); // Fecha o fluxo em caso de erro
        },
        onDone: () {
          print(shouldCancel);
          print('Fluxo concluído');
          if (context.mounted && !shouldCancel) {
            toHomeScreen(context);
          }
          streamController.close();
        },
        cancelOnError: true,
      );
    };
    streamController.onCancel = () {
      streamController.close();
    };

    return streamController;
  }
}
