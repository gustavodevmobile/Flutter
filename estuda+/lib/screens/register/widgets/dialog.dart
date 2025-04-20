import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/loading_next_page.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';

class AlertDialogUser {
  StorageSharedPreferences storageSharedPreferences =
      StorageSharedPreferences();
  void showDialogUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmação"),
          content: const Text(
              "Este cadastro é necessário para compor a identificação do usuário, na formatação dos documentos em pdf de resumo de desempenho que poderão ser enviados, caso não queira, clique em 'Sair', caso contrário, em 'Continuar"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text("Continuar",
                  style: AppTheme.customTextStyle2(
                      color: Colors.black87, fontSize: 17)),
            ),
            TextButton(
              onPressed: () {
                storageSharedPreferences.isRegisterUser(false, (error) {
                  showSnackBarError(context, error, Colors.red);
                });
                Routes().pushRoute(
                  context,
                  const LoadingNextPage(msgFeedbasck: 'Iniciando'),
                ); // Fecha o diálogo
                // Adicione a lógica para "Confirmar" aqui
              },
              child: Text(
                "Sair",
                style: AppTheme.customTextStyle2(
                    color: Colors.black87, fontSize: 17),
              ),
            ),
          ],
        );
      },
    );
  }
}
