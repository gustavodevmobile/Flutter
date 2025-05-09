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
  List<String> idsAnswereds = []; // Lista de ids das questões respondidas
  List<String> idsCorrects = []; // Lista de ids das questões corretas
  List<String> idsIncorrects = []; // Lista de ids das questões incorretas
  List<ModelQuestions> corrects = []; // Lista de questões corretas
  List<ModelQuestions> incorrects = []; // Lista de questões incorretas
  List<String> missingsIds = []; // Lista de ids que estão faltando no banco de dados
  bool shouldCancel = false; // Variável de controle para cancelar o fluxo
  
  // Método faz a atualização dos dados na homescreen como questões respondidas, corretas e incorretas.
  // e atualia o dashbord com as informações das questões respondidas corretamente  e incorretamente.
  // Ele também chama o método que atualiza os ids que estão faltando no banco de dados, caso alguma questão foi removida do banco de dados.
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
    updateIdsMissingsDb(context);
    return Routes().pushFade(context, const HomeScreen());
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

  /// Este método atualiza os ids que estão faltando no banco de dados, removendo-os
  /// e atualizando as quantidades de questões respondidas corretamente e incorretamente
  /// através do provider.
  Future<void> updateIdsMissingsDb(BuildContext context) async {
    print('missingsIds $missingsIds');
    if (missingsIds.isNotEmpty) {
      List<String> keysIds = [
        StorageSharedPreferences.keyIdsAndDateAnsweredsCorrectsResum,
        StorageSharedPreferences.keyIdsAndDateAnsweredsIncorrectsResum
      ];

      for (var key in keysIds) {
        await sharedPreferences.removeId(
          key,
          missingsIds,
          isDecode: true,
          onSuccess: (success) {
            if (success) {
              showSnackBarFeedback(
                  context,
                  'Houve questão que foi removida do banco de dados',
                  Colors.orange,
                  duration: const Duration(seconds: 8));
            }
          },
        );
      }
      await sharedPreferences.removeId(
        StorageSharedPreferences.keyIdsAnswereds,
        missingsIds,
        isDecode: false,
      );

      List<String> idsAnswerds = await sharedPreferences
          .recoverIds(StorageSharedPreferences.keyIdsAnswereds, (error) {
        print(error);
      });

      List<String> idsCorrects = await sharedPreferences.recoverIds(
          StorageSharedPreferences.keyIdsAndDateAnsweredsCorrectsResum,
          (error) {
        print(error);
      });

      List<String> idsIncorrects = await sharedPreferences.recoverIds(
          StorageSharedPreferences.keyIdsAndDateAnsweredsIncorrectsResum,
          (error) {
        print(error);
      });

      if (context.mounted) {
        // atualiza a quantidade de questões respondidas atraves do provider
        Provider.of<GlobalProviders>(listen: false, context)
            .answeredsAmount(idsAnswerds.length.toString());

        // atualiza a quantidade de questões respondidas corretamente atraves do provider
        Provider.of<GlobalProviders>(listen: false, context)
            .answeredsCorrects(idsCorrects.length.toString());

        // atualiza a quantidade de questões respondidas incorretamente atraves do provider
        Provider.of<GlobalProviders>(listen: false, context)
            .answeredsIncorrects(idsIncorrects.length.toString());
      }
    }
  }

  // Este método busca as questões corretas e incorretas atravesdos ids, utilizando o método getQuestionsAnswereds da classe ServiceResumQuestions.
  Future fetchQuestions(
    String textFeedback, // 'corretas' ou 'incorretas'
    ScaffoldMessengerState scaffoldMessenger, //
    Function(String) msgFeedback, // mensagem de feedback
    List<String>
        listIds, // recebe lista de ids das questões corretas ou incorretas
    Function(List<ModelQuestions>)
        questionsResult, // função que recebe as questões corretas ou incorretas
    Function(String) onError, // função de erro
    Function(bool) isExpired, // função que indica se a requisição expirou
  ) async {
    Map<String, dynamic> result = {};
    msgFeedback('$textFeedback...');

    try {
      result = await questionsCorrectsAndIncorrects
          .getQuestionsAnswereds(listIds, (error) {
        timeOut(scaffoldMessenger, error);
      }, (timeExpired) {
        isExpired(timeExpired);
      });

      if (result['missingIds'].isNotEmpty) {
        missingsIds = result['missingIds'];
      }

      questionsResult(result['questions']);
    } catch (e) {
      onError('Algo deu errado em buscar questões corretas: $e ');
    }
  }

  /// Este método busca os ids das questões respondidas, utilizando o método recoverIds da classe StorageSharedPreferences.
  /// Ele recebe uma função de feedback, uma função de erro e uma função que indica se a requisição expirou.
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

  /// Este método busca os ids das questões corretas e incorretas, utilizando o método recoverIds da classe StorageSharedPreferences.
  /// Ele recebe uma função de feedback, uma função de erro e uma função que indica se a requisição expirou.
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
      
      for (var json in listJson) {
        Map<String, dynamic> map = jsonDecode(json);
        ids.add(map['id']);
      }

      listIds(ids);
    } catch (e) {
      onError('Algo deu errado em buscar ids das questões corretas: $e ');
    }
  }

  /// Este método processa todos os métodos de buscas
  Stream processDatas(BuildContext context, String textFeedback, bool mounted,
      Function(String) msgFeedback, StreamController streamController) async* {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Provider.of<GlobalProviders>(context, listen: false).timeOut(false);

    // Busca os ids das questões respondidas
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

    //Busca os ids das questões corretas
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
    // Busca os ids das questões incorretas
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
// Busca as questões corretas atraves dos ids corretos
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
// Busca as questões incorretas atraves dos ids incorretos
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
      },
    );

    streamController.close(); // Fecha o StreamController após o processamento
  }
  // Este método cria um StreamController que gerencia o fluxo de dados
  /// e chama o método processDatas para processar os dados.
  /// Ele também lida com o cancelamento do fluxo em caso de erro.
  /// O método processDatas é responsável por buscar os dados necessários e emitir eventos para o StreamController.
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
          streamController.addError(error);
          streamController.close(); // Fecha o fluxo em caso de erro
        },
        onDone: () {
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
