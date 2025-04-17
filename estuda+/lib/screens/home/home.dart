import 'package:estudamais/controller/controller_home.dart';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/home/widgets/menu_drawer.dart';
import 'package:estudamais/screens/resum/corrects/accumulated_corrects.dart';
import 'package:estudamais/screens/resum/incorrects/accumulated_incorrects.dart';
import 'package:estudamais/screens/home/widgets/dashbord_displice.dart';
import 'package:estudamais/screens/initial_screen.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/background.dart';
import 'package:estudamais/widgets/button_next.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/home/widgets/box_resum.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Routes routes = Routes();
  ControllerHome controllerHome = ControllerHome();

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProviders>(builder: (context, valueProvider, child) {
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
                  style: AppTheme.customTextStyle(fontSize: 13),
                  children: [
                    TextSpan(
                      text: valueProvider.answeredsCurrents,
                      style: AppTheme.customTextStyle(
                        fontSize: 20,
                        color: Colors.amber,
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
            child: MenuDrawer()),
        body: Stack(
          children: <Widget>[
            Background(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    // WIDGET BOXRESUM DAS QUANTIDAS DE QUESTÕES RESPODIDAS CORRETAMENTE
                    BoxResum(
                      valueProvider.correctsCurrents,
                      'Corretas',
                      Lottie.asset('./assets/lotties/Animation_correct.json'),
                      TextButton(
                        onPressed: () {
                          if (valueProvider
                              .resultQuestionsCorrects.isNotEmpty) {
                            Routes().pushRoute(
                                context, const AccumulatedCorrects());
                            //Limpa a lista que guarda os assuntos selecionados.
                            valueProvider.subjectsAndSchoolYearSelected.clear();
                            //Fecha onde mostra os assuntos selecionados.
                            valueProvider.showSubjects(false);
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
                          style: AppTheme.customTextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              underline: true),
                        ),
                      ),
                    ),
                    // DASHBORD DAS DISCIPLINAS RESPONDIDAS CORRETAMENTE
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          valueProvider.listDisciplinesAnsweredCorrects.length,
                      itemBuilder: (context, int index) {
                        return DashbordDisplice(
                          valueProvider.listDisciplinesAnsweredCorrects[index]
                              ['discipline'],
                          Colors.green,
                          valueProvider.listDisciplinesAnsweredCorrects[index]
                                  ['amount'] /
                              100,
                          valueProvider.listDisciplinesAnsweredCorrects[index]
                                  ['amount']
                              .toString(),
                        );
                      },
                    ),
                    // WIDGET BOXRESUM DAS QUANTIDAS DE QUESTÕES RESPODIDAS INCORRETAMENTE
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: BoxResum(
                        valueProvider.incorrectsCurrents,
                        'Incorretas',
                        Lottie.asset('./assets/lotties/alert.json'),
                        TextButton(
                          onPressed: () {
                            if (valueProvider
                                .resultQuestionsIncorrects.isNotEmpty) {
                              routes.pushRoute(
                                context,
                                const AccumulatedIncorrects(),
                              );
                              //Limpa a lista que guarda os assuntos selecionados.
                              valueProvider.subjectsAndSchoolYearSelected
                                  .clear();
                              //Fecha onde mostra os assuntos selecionados.
                              valueProvider.showSubjects(false);
                            } else {
                              showSnackBarError(
                                context,
                                'Não temos nenhuma questão incorreta.',
                                Colors.blue,
                              );
                            }
                          },
                          child: Text(
                            'Resumo',
                            style: AppTheme.customTextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                underline: true),
                          ),
                        ),
                      ),
                    ),
                    // WIDGET DASHBORD DISCIPLINAS RESPONDIDAS INCORRETAMENTE
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: valueProvider
                            .listDisciplinesAnsweredIncorrects.length,
                        itemBuilder: (context, int index) {
                          return DashbordDisplice(
                              valueProvider
                                      .listDisciplinesAnsweredIncorrects[index]
                                  ['discipline'],
                              Colors.red,
                              valueProvider.listDisciplinesAnsweredIncorrects[
                                      index]['amount'] /
                                  100,
                              valueProvider
                                  .listDisciplinesAnsweredIncorrects[index]
                                      ['amount']
                                  .toString());
                        }),
                    TextButton(
                      onPressed: () {
                        routes.pushRoute(context, const ScreenInitial());
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
              // Chama o controller que manipula e busca as disciplinasna api
              controllerHome.handleFetchDisciplines(context);
            },
            child: const ButtonNext(
              textContent: 'Iniciar',
            )),
      );
    });
  }
}
