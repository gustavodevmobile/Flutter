//  ESSA É A TELA INICIAL ONDE O USUARIO SE CADASTRA OU CHAMA A TELA PARA FAZER O LOGIN.
import 'package:estudamais/controller/connection.dart';
import 'package:estudamais/controller/controller_initialscreen.dart';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/register/register.dart';
import 'package:estudamais/screens/loading_next_page.dart';
import 'package:estudamais/widgets/button_next.dart';
import 'package:estudamais/widgets/alert_dialog.dart';
import 'package:estudamais/widgets/show_loading_dialog.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';

class ScreenInitial extends StatefulWidget {
  const ScreenInitial({super.key});

  @override
  State<ScreenInitial> createState() => _ScreenInitialState();
}

class _ScreenInitialState extends State<ScreenInitial> {
  Routes routes = Routes();
  ControllerInitialscreen controllerInitialscreen = ControllerInitialscreen();
  bool connectionInternet = false;
  AlertDialogUser alertDialogUser = AlertDialogUser();

  //StorageSharedPreferences sharedPreferences = StorageSharedPreferences();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('./assets/images/cubs.png'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GestureDetector(
                onTap: () {
                  controllerInitialscreen.isRegistered(context, (hasStatus) {
                    if (hasStatus != null) {
                      showLoadingDialog(context, 'Verificando conexão...');
                      Connection().hasConnectionInternet((isConnected) {
                        if (isConnected) {
                          if (!mounted) return;
                          Navigator.pop(context);
                          Routes().pushRoute(
                            context,
                            //const HomeScreen()
                            const LoadingNextPage(
                              msgFeedback: 'Carregando informações...',
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                          showSnackBarFeedback(
                              context, 'Sem conexão com internet', Colors.red);
                        }
                      }, (onError) {
                        showSnackBarFeedback(context, onError, Colors.red);
                      });
                    } else {
                      showSnackBarFeedback(
                          context, 'Usuário não inserido!', Colors.red);
                    }
                  }, (error) {
                    showSnackBarFeedback(context, error, Colors.red);
                  });
                },
                child: const ButtonNext(textContent: 'Entrar'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GestureDetector(
                onTap: () {
                  controllerInitialscreen.isRegistered(context, (hasStatus) {
                    if (hasStatus == true) {
                      showSnackBarFeedback(
                          context, 'Usuário já cadastrado!', Colors.orange);
                    } else if (hasStatus == false) {
                      alertDialogUser.showDialogUser(
                        context,
                        'Usuário não cadastrado!',
                        'Usuário não foi cadastrado.\nDeseja se cadastrar?',
                        TextButton(
                            onPressed: () {
                              Routes().pushRoute(context, const RegisterUser());
                            },
                            child: const Text('Sim')),
                        TextButton(
                          onPressed: () {
                            const LoadingNextPage(msgFeedback: 'Iniciando...');
                          },
                          child: const Text('Não'),
                        ),
                      );
                    } else {
                      Routes().pushRoute(context, const RegisterUser());
                    }
                  }, (onError) {});
                },
                child: const ButtonNext(
                  textContent: 'Cadastrar',
                  primary: Colors.yellow,
                  secundary: Colors.white,
                  terciary: Colors.amber,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
