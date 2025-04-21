import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:flutter/material.dart';

class AlertDialogUser {
  StorageSharedPreferences storageSharedPreferences =
      StorageSharedPreferences();

  void showDialogUser(BuildContext context,String title, String msgText, TextButton confirm, TextButton cancel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msgText),
          actions: [
            confirm, cancel
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop(); // Fecha o diálogo
            //   },
            //   child: Text(
            //     "Continuar",
            //     style: AppTheme.customTextStyle2(
            //         color: Colors.black87, fontSize: 17),
            //   ),
            // ),
            // TextButton(
            //   onPressed: () {
            //     storageSharedPreferences.isRegisterUser(
            //       false,
            //       (error) {
            //         showSnackBarError(context, error, Colors.red);
            //       },
            //     );
            //     Routes().pushRoute(
            //       context,
            //       const LoadingNextPage(msgFeedbasck: 'Iniciando'),
            //     ); // Fecha o diálogo
            //     // Adicione a lógica para "Confirmar" aqui
            //   },
            //   child: Text(
            //     "Sair",
            //     style: AppTheme.customTextStyle2(
            //         color: Colors.black87, fontSize: 17),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
