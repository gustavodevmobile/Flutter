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
  const LoadingNextPage({
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

    // if (corrects.isNotEmpty && incorrects.isNotEmpty) {
      
    // } else {
    //   showSnackBar(context, error, Colors.red);
    //   Navigator.pop(context);
    // }
  }

  Stream getDatas() async* {
    List<ModelQuestions> corrects = [];
    List<ModelQuestions> incorrects = [];
    List<String> amountAnswereds = [];
    List<String> amountCorrects = [];
    List<String> amountIncorrects = [];
    String error = '';

    // faz a busca dos ids das questões respondidas
    yield await sharedPreferences
        .recoverIds(StorageSharedPreferences.keyIdsAnswereds)
        .then((ids) {
      amountAnswereds = ids;
    });
    setState(() {
      msg = 'Ids das Respondidas ok!';
    });
    // faz a busca dos ids das questões respondidas corretamente
    yield await sharedPreferences
        .recoverIds(StorageSharedPreferences.keyIdsAnsweredsCorrects)
        .then((ids) {
      amountCorrects = ids;
    });
    setState(() {
      msg = 'Ids das Corretas ok!';
    });
    // faz a busca dos ids das questões respondidas incorretamente
    yield await sharedPreferences
        .recoverIds(StorageSharedPreferences.keyIdsAnsweredsIncorrects)
        .then((ids) {
      amountIncorrects = ids;
    });
    setState(() {
      msg = 'Ids das Incorretas ok!';
    });

    // //busca o nome das disciplinas.
    // yield await service.getDisciplines().then((disciplines) {
    //   listDisciplines = disciplines;
    // });

    // busca as questões pelos ids respondidas corretamente
    yield await questionsCorrectsAndIncorrects.getQuestions(amountCorrects,
        (questionsCorrects) {
      corrects = questionsCorrects;
    }, (error) {
      error = error;
      print('error1 $error');
    });

    setState(() {
      msg = 'Questões corretas ok!';
    });

    // busca as questões pelos ids respondidas incorretamente
    yield await questionsCorrectsAndIncorrects.getQuestions(amountIncorrects,
        (questionsIncorrects) {
      incorrects = questionsIncorrects;
    }, (error) {
      error = error;
      print('error2 $error');
    });

    setState(() {
      msg = 'Questões incorretas ok!';
    });
    // atualiza o progresso do usuario

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
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            Navigator.pop(context);
            return const Text('deu ruim');
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
                          Routes().pushRoute(context, const HomeScreen());
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
      ),
    );
  }
}
