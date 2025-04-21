import 'package:estudamais/controller/controller_home.dart';
import 'package:estudamais/controller/controller_initialscreen.dart';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/initial_screen.dart';
import 'package:estudamais/screens/register/register.dart';
import 'package:estudamais/screens/send_report_screen.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/widgets/alert_dialog.dart';
import 'package:estudamais/widgets/listTile_drawer.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatefulWidget {
  MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  final ControllerHome controllerHome = ControllerHome();

  final StorageSharedPreferences sharedPreferences = StorageSharedPreferences();

  final AlertDialogUser alertDialogUser = AlertDialogUser();

  final ControllerInitialscreen controllerInitialScreen =
      ControllerInitialscreen();

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
            controllerInitialScreen.isRegistered(context, (hasStatus) {
              if (hasStatus == false) {
                // Navigator.pop(context);
                AlertDialogUser().showDialogUser(
                  context,
                  'Usuário não cadastrado',
                  'Usuário deve ser registrado para compor as informações enviadas.\nDeseja se cadastrar?',
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Routes().pushFade(context, const RegisterUser());
                    },
                    child: const Text('Sim'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                );
              } else {
                Routes().pushRoute(context, const SendReportScreen());
              }
            }, (onError) {
              showSnackBarError(context, onError, Colors.red);
            });
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
          contextText: 'Resetar Usuário',
          onTap: () {
            alertDialogUser.showDialogUser(
              context,
              'Usuário será removido.!',
              'Deseja mesmo resetar usuário?\nIsso deletará todo o processo ja feito.',
              TextButton(
                onPressed: () {
                  sharedPreferences.deleteListIds(
                    (onSuccess) {
                      Routes().pushFade(context, const ScreenInitial());
                      showSnackBarError(context, onSuccess, Colors.green);
                    },
                    (onError) {
                      showSnackBarError(context, onError, Colors.red);
                    },
                  );
                },
                child: const Text('Sim'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            );
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
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
