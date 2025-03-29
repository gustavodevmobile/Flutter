import 'dart:async';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/database/storage_shared_preferences.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/models/models.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/service/questions_corrects_providers.dart';
import 'package:estudamais/service/questions_incorrects_providers.dart';
import 'package:estudamais/service/service.dart';
import 'package:estudamais/service/service_resum_questions.dart';
import 'package:estudamais/widgets/show_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:estudamais/widgets/loading.dart';
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
  //ServiceResumQuestions questionsIncorrects = ServiceResumQuestions();
  Service service = Service();
  String msg = 'Buscando informações...';
  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();
  ValueNotifier<String> msgLoading = ValueNotifier<String>('Buscando dados...');

  nextPage(
      List<ModelQuestions> corrects,
      List<ModelQuestions> incorrects,
      List<String> amountAnswereds,
      List<String> amountCorrects,
      List<String> amountIncorrects,
      String error) {
    // atualiza a quantidade de questões respondidas atraves do provider
    Provider.of<ModelPoints>(listen: false, context)
        .answeredsAmount(amountAnswereds.length.toString());

    // atualiza a quantidade de questões respondidas corretamente atraves do provider
    Provider.of<ModelPoints>(listen: false, context)
        .answeredsCorrects(amountCorrects.length.toString());

    // atualiza a quantidade de questões respondidas incorretamente atraves do provider
    Provider.of<ModelPoints>(listen: false, context)
        .answeredsIncorrects(amountIncorrects.length.toString());

    // passa o returno do método counterDisciplineIncorrects para atualizar na home as disciplinas respondidas corretamente
    Provider.of<QuestionsCorrectsProvider>(listen: false, context)
        .disciplinesAnswereds(
            questionsCorrectsAndIncorrects.counterDiscipline(corrects));

    // passa o returno do método counterDisciplineIncorrects para atualizar na home as disciplinas respondidas incorretamente
    Provider.of<QuestionsIncorrectsProvider>(listen: false, context)
        .disciplinesAnswereds(
            questionsCorrectsAndIncorrects.counterDiscipline(incorrects));

    // obtém todas as questões respondidas corretamente
    Provider.of<QuestionsCorrectsProvider>(listen: false, context)
        .questionsCorrects(corrects);

    // obtém todas as questões respondidas incorretamente
    Provider.of<QuestionsIncorrectsProvider>(listen: false, context)
        .questionsIncorrects(incorrects);

    // pega o nome das disiciplinas
    // Provider.of<ModelPoints>(listen: false, context)
    //     .getListDisciplines(disciplines);

    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        duration: const Duration(seconds: 1),
        child: const HomeScreen(),
      ),
    );
  }

  List<String> amountAnswereds = [];
  Future fetchAnsweredsIds(
      Function(List<String>) answeredsIds, Function(String) onError) async {
    List<String> amountAnswereds = [];
    msgLoading.value = '${widget.msgFeedbasck} respodidas...';
    try {
      amountAnswereds = await sharedPreferences
          .recoverIds(StorageSharedPreferences.keyIdsAnswereds);
      answeredsIds(amountAnswereds);
    } catch (e) {
      onError('Algo deu errado em buscas ids das questões respondidas: $e ');
    }
  }

  List<String> amountCorrects = [];
  Future fetchCorrectsIds(
      Function(List<String>) correctsIds, Function(String) onError) async {
    msgLoading.value = '${widget.msgFeedbasck} ids corretas...';
    try {
      amountCorrects = await sharedPreferences
          .recoverIds(StorageSharedPreferences.keyIdsAnsweredsCorrects);
    } catch (e) {
      onError('Algo deu errado em buscas ids das questões respondidas: $e ');
    }
  }

  Stream getDatas() async* {
    List<ModelQuestions> incorrects = [];
    List<ModelQuestions> corrects = [];

    List<String> amountIncorrects = [];
    String error = '';

    // faz a busca dos ids das questões respondidas
    yield await fetchAnsweredsIds((answeredsIds) {
      amountAnswereds = answeredsIds;
    }, (onError) {
      msgLoading.value = onError;
    });
    // faz a busca dos ids das questões respondidas corretamente

    yield await fetchCorrectsIds((correctsIds) {
      amountCorrects = correctsIds;
    }, (onError) {
      msgLoading.value = onError;
    });

    // faz a busca dos ids das questões respondidas incorretamente
    msgLoading.value = '${widget.msgFeedbasck} ids incorretas...';
    yield await sharedPreferences
        .recoverIds(StorageSharedPreferences.keyIdsAnsweredsIncorrects)
        .then((ids) {
      amountIncorrects = ids;
    });

    // busca as questões pelos ids respondidas corretamente
    msgLoading.value = '${widget.msgFeedbasck} questões corretas...';
    yield await questionsCorrectsAndIncorrects.getQuestions(amountCorrects,
        (questionsCorrects) {
      corrects = questionsCorrects;
    }, (error) {
      error = error;
      print('error1 $error');
    });

    // busca as questões pelos ids respondidas incorretamente
    msgLoading.value = '${widget.msgFeedbasck} questões incorretas...';
    yield await questionsCorrectsAndIncorrects.getQuestions(amountIncorrects,
        (questionsIncorrects) {
      incorrects = questionsIncorrects;
    }, (error) {
      error = error;
      //print('error2 $error');
    });

    // atualiza o progresso do usuario
    msgLoading.value = 'Atualizando informações...';
    yield nextPage(corrects, incorrects, amountAnswereds, amountCorrects,
        amountIncorrects, error);
  }

  late final StreamController _controller = StreamController(
    onListen: () {
      _controller.addStream(getDatas());
    },
    onCancel: () {
      _controller.close();
    },
  );

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ValueListenableBuilder(
            valueListenable: msgLoading,
            builder: (context, msg, child) {
              return StreamBuilder(
                stream: _controller.stream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    Navigator.pop(context);
                    return const Text(
                        'Algo saiu errado, tente novamente mais tarde');
                    //showSnackBar(context, 'deu ruim', Colors.red);
                  } else {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Loading(),
                            Text(
                              'Aguardando dados...',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo),
                            ),
                          ],
                        );
                      case ConnectionState.waiting:
                        return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Loading(),
                            Text(
                              'Aguardando informações...',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo),
                            ),
                          ],
                        );
                      case ConnectionState.active:
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Loading(),
                            Text(
                              msg,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo),
                            ),
                          ],
                        );
                      case ConnectionState.done:
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Routes()
                                      .pushRoute(context, const HomeScreen());
                                },
                                child: const Text('Ir para Home')),
                            const Text(
                              'Pronto!',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo),
                            ),
                          ],
                        );
                    }
                  }
                },
              );
            }));
  }
}
