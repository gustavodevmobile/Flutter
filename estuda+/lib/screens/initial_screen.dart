//  ESSA É A TELA INICIAL ONDE O USUARIO SE CADASTRA OU CHAMA A TELA PARA FAZER O LOGIN.
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/database/storage_shared_preferences.dart';

import 'package:estudamais/screens/loading_next_page.dart';
import 'package:estudamais/widgets/button_next.dart';
import 'package:flutter/material.dart';

class ScreenInitial extends StatefulWidget {
  const ScreenInitial({super.key});

  @override
  State<ScreenInitial> createState() => _ScreenInitialState();
}

class _ScreenInitialState extends State<ScreenInitial> {
  Routes routes = Routes();
  //List<String> idsAnswereds = [];

  // @override
  // void initState() {
  //   sharedPreferences
  //       .recoverIds(StorageSharedPreferences.keyIdsAnswereds)
  //       .then((id) {
  //     idsAnswereds = id;
  //   });
  //   super.initState();
  // }

  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();

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
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () {
                  Routes().pushRouteFade(
                      context,
                      const LoadingNextPage(),
                    );
                  // if (idsAnswereds.isEmpty) {
                  //   Routes().pushRoute(context, const HomeScreen());
                  // } else {
                  //   Routes().pushRouteFade(
                  //     context,
                  //     const LoadingNextPage(),
                  //   );
                  // }
                },
                child: const ButtonNext(
                  textContent: 'Entrar',
                  height: 70,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                sharedPreferences.deleteListIds();
              },
              child: const Text('deletar Ids'),
            ),
          ],
        ),
      ),
    );
  }
}
