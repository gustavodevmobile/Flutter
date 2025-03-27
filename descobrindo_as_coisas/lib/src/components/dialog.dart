import 'package:descobrindo_as_coisas/src/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

showDialogFeedBack(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer<Controller>(builder: (context, value, child) {
        return Dialog(
          insetAnimationDuration: Duration(seconds: 20),
          insetAnimationCurve: Curves.easeInExpo,
          child: SizedBox(
            width: 300,
            height: 400,
            // decoration: BoxDecoration(color: Colors.white24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Seu tempo foi:',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        spreadRadius: 2.0,
                        blurRadius: 3.0,
                      )
                    ],
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          '${value.hours} Horas',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Text(
                          '${value.minutes} Minutos',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Text(
                          '${value.seconds} Segundos',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Jogar novamente'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Sair'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
    },
  );
}
