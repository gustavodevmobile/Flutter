import 'package:estudamais/controller/controller_home.dart';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/home/widgets/menu_drawer.dart';
import 'package:estudamais/screens/resum/corrects/accumulated_corrects.dart';
import 'package:estudamais/screens/resum/incorrects/accumulated_incorrects.dart';
import 'package:estudamais/screens/home/widgets/dashbord_displice.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;
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
                  text: 'Questões respondidas: ',
                  style: AppTheme.customTextStyle(fontSize: screenWidth * 0.04),
                  children: [
                    TextSpan(
                      text: valueProvider.answeredsCurrents,
                      style: AppTheme.customTextStyle(
                        fontSize: screenWidth * 0.07,
                        color: Colors.amber,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        drawer: const Drawer(
            backgroundColor: Color.fromARGB(255, 209, 209, 209),
            child: MenuDrawer()),
        body: Background(
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
                      if (valueProvider.resultQuestionsCorrects.isNotEmpty) {
                        routes.pushRoute(context, const AccumulatedCorrects());
                        //Limpa a lista que guarda os assuntos selecionados.
                        valueProvider.subjectsAndSchoolYearSelected.clear();
                        //Fecha onde mostra os assuntos selecionados.
                        valueProvider.showSubjects(false);
                      } else {
                        showSnackBarFeedback(
                          context,
                          'Ainda não temos nenhuma questão respondida.',
                          Colors.blue,
                        );
                      }
                    },
                    child: Text(
                      'Resumo',
                      style: AppTheme.customTextStyle(
                          fontSize: screenWidth * 0.03,
                          color: Colors.black,
                          underline: true),
                    ),
                  ),
                ),
                // DASHBORD DAS DISCIPLINAS RESPONDIDAS CORRETAMENTE
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
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
                      onPressed: () async {
                        if (valueProvider
                            .resultQuestionsIncorrects.isNotEmpty) {
                          routes.pushRoute(
                            context,
                            const AccumulatedIncorrects(),
                          );
                          //Limpa a lista que guarda os assuntos selecionados.
                          valueProvider.subjectsAndSchoolYearSelected.clear();
                          //Fecha onde mostra os assuntos selecionados.
                          valueProvider.showSubjects(false);

                          await StorageSharedPreferences().deleta(
                              StorageSharedPreferences.idsRecoveryIncorrects);
                        } else {
                          showSnackBarFeedback(
                            context,
                            'Ainda não temos nenhuma questão respondida.',
                            Colors.blue,
                          );
                        }
                      },
                      child: Text(
                        'Resumo',
                        style: AppTheme.customTextStyle(
                            fontSize: screenWidth * 0.03,
                            color: Colors.black,
                            underline: true),
                      ),
                    ),
                  ),
                ),
                // WIDGET DASHBORD DISCIPLINAS RESPONDIDAS INCORRETAMENTE
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      valueProvider.listDisciplinesAnsweredIncorrects.length,
                  itemBuilder: (context, int index) {
                    return DashbordDisplice(
                        valueProvider.listDisciplinesAnsweredIncorrects[index]
                            ['discipline'],
                        Colors.red,
                        valueProvider.listDisciplinesAnsweredIncorrects[index]
                                ['amount'] /
                            100,
                        valueProvider.listDisciplinesAnsweredIncorrects[index]
                                ['amount']
                            .toString());
                  },
                ),
                const SizedBox(height: 16),

                GestureDetector(
                    onTap: () {
                      // Chama o controller que manipula e busca as disciplinasna api
                      controllerHome.handleFetchDisciplines(context, (onError) {
                        showSnackBarFeedback(context, onError, Colors.red);
                      });
                    },
                    child: const ButtonNext(
                      textContent: 'Iniciar',
                    )),
              ],
            ),
          ),
        ),
      );
    });
  }
}
