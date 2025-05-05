import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';

class ControllerInitialscreen {
  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();
// Método responsável por verificar se o usuário já está registrado
// e retorna um booleano para pagina inical.
  Future<void> isRegistered(BuildContext context, Function(bool?) hasStatus,
      Function(String) onError) async {
    try {
      hasStatus(await sharedPreferences.hasRegisteredUser((onError) {
        showSnackBarFeedback(context, onError, Colors.red);
      }));
    } catch (e) {
      onError('Erro ao buscar status do usuário: $e');
    }
  }
}
