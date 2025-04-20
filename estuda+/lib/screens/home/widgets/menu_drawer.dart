import 'package:estudamais/controller/controller_home.dart';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/initial_screen.dart';
import 'package:estudamais/screens/send_report_screen.dart';
import 'package:estudamais/widgets/listTile_drawer.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  MenuDrawer({super.key});

  final ControllerHome controllerHome = ControllerHome();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text('Header'),
        ),
        ListTileDrawer(
          contextText: 'Responder questões',
          onTap: () {
            // Chama o método no controller que manipula e busca as disciplinas na api.
            controllerHome.handleFetchDisciplines(context);
            //value.openBoxAlreadyAnswereds(false);
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
          contextText: 'Enviar relatório de questões',
          onTap: () {
            Routes().pushRoute(context, const SendReportScreen());
          },
          icon: const Icon(
            Icons.list,
          ),
        ),
        ListTileDrawer(
          contextText: 'Enviar Feedback',
          onTap: () {},
          icon: const Icon(Icons.report),
        ),
        ListTileDrawer(
          contextText: 'Sobre',
          onTap: () {},
          icon: const Icon(Icons.help),
        ),
        ListTileDrawer(
          contextText: 'Sair',
          onTap: () {
             Routes().pushRoute(context, const ScreenInitial());
          },
          icon: const Icon(Icons.exit_to_app),
        ),
      ],
    );
  }
}
