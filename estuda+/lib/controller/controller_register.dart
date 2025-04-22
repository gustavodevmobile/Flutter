import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/models/user.dart';
import 'package:estudamais/screens/loading_next_page.dart';
import 'package:estudamais/widgets/alert_dialog.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';

class ControllerRegister {
  StorageSharedPreferences storageSharedPreferences =
      StorageSharedPreferences();
  AlertDialogUser alertDialogUser = AlertDialogUser();

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu nome';
    }
    return null;
  }

  String? validateBirthDate(String? value) {
    print(value);
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua data de nascimento';
    }
    // Validação básica para formato de data
    RegExp regex =
        RegExp(r'^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[0-2])\/((19|20)\d{2})$');
    if (!regex.hasMatch(value)) {
      return 'Insira o formato válido: ex (DD/MM/AAAA)';
    }
    return null;
  }

  String? validateSchoolYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu ano escolar';
    }
    RegExp regex = RegExp(r'^[1-9]° ano$');
    if (!regex.hasMatch(value)) {
      return 'Insira um formato válido. Ex 1° ano, 2° ano, etc';
    }

    return null;
  }

  User toUser(String userName, String birthDate, String schoolYear) {
    User user;
    Map<String, dynamic> userMap = {
      'userName': userName,
      'birthDate': birthDate,
      'schoolYear': schoolYear
    };
    user = User.toUser(userMap);
    return user;
  }

  void saveData(
      GlobalKey<FormState> formKey, BuildContext context, User user) async {
    if (formKey.currentState!.validate()) {
      await storageSharedPreferences.isRegisterUser(true, (error) {
        showSnackBarError(context, error, Colors.red);
      });

      await storageSharedPreferences.saveUser(user, (onSuccess) {
        showSnackBarError(context, onSuccess, Colors.green);
        Routes().pushRoute(
            context, const LoadingNextPage(msgFeedbasck: 'Inserindo'));
      }, (onError) {
        showSnackBarError(context, onError, Colors.red);
      });
    }
  }

  void alertDialogUserInitial(BuildContext context) {
    alertDialogUser.showDialogUser(
      context,
      'Aviso!',
      "Este cadastro é necessário para compor a identificação do usuário na formatação do documento em pdf de resumo de desempenho que poderá ser enviado, caso não queira essa funcionalidade, clique em 'Sair', caso contrário, em 'Continuar.",
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(); // Fecha o diálogo
        },
        child: Text(
          "Continuar",
          style: AppTheme.customTextStyle2(color: Colors.black87, fontSize: 17),
        ),
      ),
      TextButton(
        onPressed: () {
          storageSharedPreferences.isRegisterUser(
            false,
            (error) {
              showSnackBarError(context, error, Colors.red);
            },
          );
          Routes().pushRoute(
            context,
            const LoadingNextPage(msgFeedbasck: 'Iniciando'),
          ); // Fecha o diálogo
          // Adicione a lógica para "Confirmar" aqui
        },
        child: Text(
          "Sair",
          style: AppTheme.customTextStyle2(color: Colors.black87, fontSize: 17),
        ),
      ),
    );
  }
}
