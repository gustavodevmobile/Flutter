import 'dart:async';
import 'package:estudamais/database/storage_shared_preferences.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/models/models.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/service/questions_corrects_providers.dart';
import 'package:estudamais/service/questions_incorrects_providers.dart';
import 'package:estudamais/service/service.dart';
import 'package:estudamais/service/service_resum_questions.dart';
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
  //ServiceResumQuestions questionsIncorrects = ServiceResumQuestions();
  Service service = Service();
  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();
  ValueNotifier<String> msgLoading = ValueNotifier<String>('Buscando dados...');
  TextStyle textStyle = GoogleFonts.aboreto(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.indigo,
  );

// atualiza o progresso do usurario e chama a home
  void nextPage(
    List<ModelQuestions> corrects,
    List<ModelQuestions> incorrects,
    List<String> amountAnswereds,
    List<String> amountCorrects,
    List<String> amountIncorrects,
  ) {
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

// faz a busca dos ids de todas as questões respondidas
  List<String> idsAnswereds = [];
  Future fetchAnsweredsIds(
      Function(List<String>) answeredsIds, Function(String) onError) async {
    List<String> ids = [];
    msgLoading.value = '${widget.msgFeedbasck} respodidas...';
    try {
      ids = await sharedPreferences
          .recoverIds(StorageSharedPreferences.keyIdsAnswereds);
      answeredsIds(ids);
    } catch (e) {
      onError('Algo deu errado em buscas ids das questões respondidas: $e ');
    }
  }

// faz a busca dos ids das questões corretas
  List<String> idsCorrects = [];
  Future fetchCorrectsIds(
      Function(List<String>) correctsIds, Function(String) onError) async {
    msgLoading.value = '${widget.msgFeedbasck} ids corretas...';
    List<String> ids = [];
    try {
      ids = await sharedPreferences
          .recoverIds(StorageSharedPreferences.keyIdsAnsweredsCorrects);
      correctsIds(ids);
    } catch (e) {
      onError('Algo deu errado em buscar ids das questões corretas: $e ');
    }
  }

// faz a busca dos ids das questões incorretas
  List<String> idsIncorrects = [];
  Future fetchIncorrectsIds(
      Function(List<String>) incorrectsIds, Function(String) onError) async {
    msgLoading.value = '${widget.msgFeedbasck} ids incorretas...';
    List<String> ids = [];
    try {
      ids = await sharedPreferences
          .recoverIds(StorageSharedPreferences.keyIdsAnsweredsIncorrects);
      incorrectsIds(ids);
    } catch (e) {
      onError('Algo deu errado em buscar ids das questões incorretas: $e ');
    }
  }

// faz a busca das questões corretas atraves do ids delas
  List<ModelQuestions> corrects = [];
  Future fetchCorrectsQuestions(
      Function(List<ModelQuestions>) correctsQuestions,
      Function(String) onError) async {
    msgLoading.value = '${widget.msgFeedbasck} questões corretas...';
    List<ModelQuestions> questions = [];
    try {
      questions =
          await questionsCorrectsAndIncorrects.getQuestions(idsCorrects);
      correctsQuestions(questions);
    } catch (e) {
      onError('Algo deu errado em buscar questões corretas: $e ');
    }
  }

//faz a busca das questões incorretas atraves dos ids delas
  List<ModelQuestions> incorrects = [];
  Future fetchIncorrectsQuestions(
      Function(List<ModelQuestions>) incorrectsQuestions,
      Function(String) onError) async {
    msgLoading.value = '${widget.msgFeedbasck} questões incorretas...';
    List<ModelQuestions> questions = [];
    try {
      questions =
          await questionsCorrectsAndIncorrects.getQuestions(idsIncorrects);
      incorrectsQuestions(questions);
    } catch (e) {
      onError('Algo deu errado em buscar questões incorretas: $e ');
    }
  }

  Stream getDatas() async* {
    yield await fetchAnsweredsIds((answeredsIds) {
      idsAnswereds = answeredsIds;
    }, (onError) {
      msgLoading.value = onError;
    });

    yield await fetchCorrectsIds((correctsIds) {
      idsCorrects = correctsIds;
    }, (onError) {
      msgLoading.value = onError;
    });

    yield await fetchIncorrectsIds((incorrectsIds) {
      idsIncorrects = incorrectsIds;
    }, (onError) {
      msgLoading.value = onError;
    });

    yield await fetchCorrectsQuestions((correctsQuestions) {
      corrects = correctsQuestions;
    }, (onError) {
      msgLoading.value = onError;
    });

    yield await fetchIncorrectsQuestions((incorrectsQuestions) {
      incorrects = incorrectsQuestions;
    }, (onError) {
      msgLoading.value = onError;
    });

    // atualiza o progresso do usuario
    msgLoading.value = 'Atualizando informações...';
    nextPage(
        corrects, incorrects, idsAnswereds, idsCorrects, idsIncorrects);
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
            builder: (context, value, child) {
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
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Loading(),
                            Text(
                              'Aguardando dados...',
                              style: textStyle
                            ),
                          ],
                        );
                      case ConnectionState.waiting:
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Loading(),
                            Text(
                              'Aguardando informações...',
                              style: textStyle
                            ),
                          ],
                        );
                      case ConnectionState.active:
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Loading(),
                            Text(
                              value,
                              style: textStyle
                            ),
                          ],
                        );
                      case ConnectionState.done:
                        return Text(
                          'Pronto!',
                          style: textStyle
                        );
                    }
                  }
                },
              );
            }));
  }
}
