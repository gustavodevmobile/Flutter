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
import 'package:estudamais/widgets/show_snackBar.dart';
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
  // List<ModelQuestions>? corrects = questionsCorrects;
  bool? enable;

  @override
  void initState() {
    print(
        'disciplinas ${Provider.of<ModelPoints>(listen: false, context).listDisciplines}');
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Consumer3<ModelPoints, QuestionsCorrectsProvider,
            QuestionsIncorrectsProvider>(
        builder: (context, value1, corrects, incorrects, child) {
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
                      text: value1.answeredsCurrents,
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
                  showLoadingDialog(context, 'Buscando disciplinas...');
                  fetchDisciplines((disciplines) {
                    if (disciplines.isNotEmpty) {
                      Routes().popRoutes(
                        context,
                        Discipline(disciplines: disciplines),
                      );
                    } else {
                      showSnackBar(
                          context,
                          'Ops, algo deu errado em buscar disciplinas',
                          Colors.red);
                    }
                  }, (onError) {
                    showSnackBar(context, onError, Colors.red);
                  });
                  // fechao container onde mostra questão ja respondida
                  value1.actBoxAnswered(0);
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
                    BoxResum(
                      value1.correctsCurrents,
                      'Corretas',
                      Lottie.asset('./assets/lotties/Animation_correct.json'),
                      TextButton(
                        onPressed: () {
                          //print(value1.correctsCurrents);
                          if (corrects.resultQuestionsCorrects.isNotEmpty) {
                            value1.answered(false);
                            Routes()
                                .pushRoute(context, const AccumulatedRight());
                            questionsCorrects.getDisciplineOfQuestions(
                                corrects.resultQuestionsCorrects);
                            corrects.subjectsAndSchoolYearSelected.clear();
                            value1.showSubjects(false);
                          } else {
                            showSnackBar(
                                context,
                                'Ainda não temos nenhuma questão respondida.',
                                Colors.blue);
                          }
                        },
                        child: Text(
                          'Resumo',
                          style: GoogleFonts.roboto(color: Colors.amber),
                        ),
                      ),
                    ),
                    corrects.listDisciplinesAnswered.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: corrects.listDisciplinesAnswered.length,
                            itemBuilder: (context, int index) {
                              return DashbordDisplice(
                                corrects.listDisciplinesAnswered[index]
                                    ['discipline'],
                                Colors.green,
                                corrects.listDisciplinesAnswered[index]
                                        ['amount'] /
                                    100,
                                corrects.listDisciplinesAnswered[index]
                                        ['amount']
                                    .toString(),
                              );
                            })
                        : Container(
                            width: 200,
                            height: 200,
                            color: Colors.white,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: BoxResum(
                        value1.incorrectsCurrents,
                        'Incorretas',
                        Lottie.asset('./assets/lotties/alert.json'),
                        TextButton(
                            onPressed: () {
                              print(value1.correctsCurrents);
                              if (incorrects
                                  .resultQuestionsIncorrects.isNotEmpty) {
                                value1.answered(false);
                                Routes().pushRoute(
                                    context, const AccumulatedWrongs());
                                questionsIncorrects.getDisciplineOfQuestions(
                                    incorrects.resultQuestionsIncorrects);
                                incorrects.subjectsAndSchoolYearSelected
                                    .clear();
                                value1.showSubjects(false);
                              } else {
                                showSnackBar(
                                    context,
                                    'Ainda não temos nenhuma questão respondida.',
                                    Colors.blue);
                              }
                            },
                            child: Text(
                              'Resumo',
                              style: GoogleFonts.roboto(color: Colors.amber),
                            )),
                      ),
                    ),
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
              showLoadingDialog(context, 'Buscando disciplinas...');
              fetchDisciplines((disciplines) {
                if (disciplines.isNotEmpty) {
                  if (!mounted) return;
                  Routes().popRoutes(
                    context,
                    Discipline(disciplines: disciplines),
                  );
                } else {
                  showSnackBar(context,
                      'Ops, algo deu errado em buscar disciplinas', Colors.red);
                  Navigator.pop(context);
                }
              }, (onError) {
                showSnackBar(context, onError, Colors.red);
              });
            },
            child: const ButtonNext(
              textContent: 'Iniciar',
            )),
      );
    });
  }
}
