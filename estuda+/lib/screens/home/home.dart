import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/database/storage_shared_preferences.dart';
import 'package:estudamais/screens/accumulated_corrects/accumulated_right.dart';
import 'package:estudamais/screens/accumulated_incorrects/accumulated_wrongs.dart';
import 'package:estudamais/screens/discipline/discipline.dart';
import 'package:estudamais/screens/home/widgets/dashbord_displice.dart';
import 'package:estudamais/screens/initial_screen.dart';
import 'package:estudamais/service/questions_corrects_providers.dart';
import 'package:estudamais/service/questions_incorrects_providers.dart';
import 'package:estudamais/service/service.dart';
import 'package:estudamais/service/service_resum_questions.dart';
import 'package:estudamais/widgets/background.dart';
import 'package:estudamais/widgets/button_next.dart';
import 'package:estudamais/widgets/listTile_drawer.dart';
import 'package:estudamais/widgets/show_loading_dialog.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:estudamais/models/models.dart';
import 'package:estudamais/screens/home/widgets/box_resum.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double shadowBox = 10;
  Service service = Service();
  ServiceResumQuestions questionsCorrects = ServiceResumQuestions();
  ServiceResumQuestions questionsIncorrects = ServiceResumQuestions();
  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();
  List<String> listIdsAnswereds = [];
  List<String> listIdsCorrects = [];
  List<String> listIdsIncorrects = [];
  List<String> disciplines = [];
  bool? enable;

  void fetchDisciplines(Function(List<String> disciplies) onSuccess,
      Function(String) onError) async {
    try {
      disciplines = await service.getDisciplines();
      if (!mounted) return;
      onSuccess(disciplines);
    } catch (e) {
      if (!mounted) return;
      onError('Não foi possível buscar as Disciplinas.');
    }
  }

  void handleFetchDisciplines(
      BuildContext context, Function(List<String>) onSuccess) {
    showLoadingDialog(context, 'Buscando disciplinas...');
    fetchDisciplines((disciplines) {
      if (disciplines.isNotEmpty) {
        if (!mounted) return;
        Navigator.pop(context);
        onSuccess(disciplines);
      } else {
        Navigator.pop(context);
        showSnackBarError(
            context, 'Ops, algo deu errado em buscar disciplinas', Colors.red);
      }
    }, (onError) {
      Navigator.pop(context);
      showSnackBarError(context, onError, Colors.red);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ModelPoints, QuestionsCorrectsProvider,
            QuestionsIncorrectsProvider>(
        builder: (context, value, corrects, incorrects, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            );
          }),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.topRight,
              child: RichText(
                text: TextSpan(
                  text: 'Total de questões respondidas: ',
                  style: GoogleFonts.aboreto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  children: [
                    TextSpan(
                      text: value.answeredsCurrents,
                      style: GoogleFonts.aboreto(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 209, 209, 209),
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('Header'),
              ),
              ListTileDrawer(
                contextText: 'Responder questões',
                onTap: () {
                  handleFetchDisciplines(context, (disciplines) {
                    Routes().popRoutes(
                      context,
                      Discipline(disciplines: disciplines),
                    );
                  });
                  //Atualiza o método responsável por abrir o container caso a questão já tenha sido respondida, recebe0 para retornar ao estado fechado.
                  value.openBoxAlreadyAnswereds(false);
                },
                icon: const Icon(Icons.auto_stories_rounded),
              ),
              ListTileDrawer(
                contextText: 'Resumo Corretas',
                onTap: () {},
                icon: const Icon(Icons.list),
              ),
              ListTileDrawer(
                contextText: 'Resumo Incorretas',
                onTap: () {},
                icon: const Icon(Icons.list),
              ),
              ListTileDrawer(
                contextText: 'Sobre',
                onTap: () {},
                icon: const Icon(Icons.help),
              ),
              ListTileDrawer(
                contextText: 'Excluir respostas',
                onTap: () {},
                icon: const Icon(Icons.delete),
              ),
              ListTileDrawer(
                contextText: 'Sair',
                onTap: () {},
                icon: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            Background(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    // WIDGET BOXRESUM DAS QUANTIDAS DE QUESTÕES RESPODIDAS CORRETAMENTE
                    BoxResum(
                      value.correctsCurrents,
                      'Corretas',
                      Lottie.asset('./assets/lotties/Animation_correct.json'),
                      TextButton(
                        onPressed: () {
                          //print(value1.correctsCurrents);
                          if (corrects.resultQuestionsCorrects.isNotEmpty) {
                            Routes()
                                .pushRoute(context, const AccumulatedRight());
                            questionsCorrects.getDisciplineOfQuestions(
                                corrects.resultQuestionsCorrects);
                            corrects.subjectsAndSchoolYearSelected.clear();
                            //fecha onde mostra os assuntos selecionados
                            value.showSubjects(false);
                          } else {
                            showSnackBarError(
                              context,
                              'Não temos nenhuma questão correta.',
                              Colors.blue,
                            );
                          }
                        },
                        child: Text(
                          'Resumo',
                          style: GoogleFonts.roboto(color: Colors.amber),
                        ),
                      ),
                    ),
                    // DASHBORD DAS DISCIPLINAS RESPONDIDAS CORRETAMENTE
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: corrects.listDisciplinesAnswered.length,
                      itemBuilder: (context, int index) {
                        return DashbordDisplice(
                          corrects.listDisciplinesAnswered[index]['discipline'],
                          Colors.green,
                          corrects.listDisciplinesAnswered[index]['amount'] /
                              100,
                          corrects.listDisciplinesAnswered[index]['amount']
                              .toString(),
                        );
                      },
                    ),
                    // WIDGET BOXRESUM DAS QUANTIDAS DE QUESTÕES RESPODIDAS INCORRETAMENTE
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: BoxResum(
                        value.incorrectsCurrents,
                        'Incorretas',
                        Lottie.asset('./assets/lotties/alert.json'),
                        TextButton(
                            onPressed: () {
                              // print(value1.correctsCurrents);
                              if (incorrects
                                  .resultQuestionsIncorrects.isNotEmpty) {
                                value.answered(false);
                                Routes().pushRoute(
                                    context, const AccumulatedWrongs());
                                questionsIncorrects.getDisciplineOfQuestions(
                                    incorrects.resultQuestionsIncorrects);
                                incorrects.subjectsAndSchoolYearSelected
                                    .clear();
                                value.showSubjects(false);
                              } else {
                                showSnackBarError(
                                    context,
                                    'Não temos nenhuma questão incorreta.',
                                    Colors.blue);
                              }
                            },
                            child: Text(
                              'Resumo',
                              style: GoogleFonts.roboto(color: Colors.amber),
                            )),
                      ),
                    ),
                    // WIDGET DASHBORD DISCIPLINAS RESPONDIDAS INCORRETAMENTE
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: incorrects.listDisciplinesAnswered.length,
                        itemBuilder: (context, int index) {
                          return DashbordDisplice(
                              incorrects.listDisciplinesAnswered[index]
                                  ['discipline'],
                              Colors.red,
                              incorrects.listDisciplinesAnswered[index]
                                      ['amount'] /
                                  100,
                              incorrects.listDisciplinesAnswered[index]
                                      ['amount']
                                  .toString());
                        }),
                    TextButton(
                      onPressed: () {
                        Routes().pushRoute(context, const ScreenInitial());
                      },
                      child: const Text(
                        'Sair',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
            onTap: () {
              handleFetchDisciplines(context, (disciplines) {
                Routes().popRoutes(
                  context,
                  Discipline(disciplines: disciplines),
                );
              });
            },
            child: const ButtonNext(
              textContent: 'Iniciar',
            )),
      );
    });
  }
}
