import 'package:estudamais/controller/connection.dart';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/loading_next_page.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/widgets/show_loading_dialog.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';

class ControllerInitialscreen {
  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();

  Future<void> isRegistered(BuildContext context, Function(bool?) hasStatus,
      Function(String) onError) async {
    try {
      hasStatus(await sharedPreferences.hasRegisteredUser((onError) {
        showSnackBarError(context, onError, Colors.red);
      }));
    } catch (e) {
      onError('Erro ao buscar status do usuário: $e');
    }
  }
}
