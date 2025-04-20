import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/initial_screen.dart';
import 'package:estudamais/screens/loading_next_page.dart';
import 'package:estudamais/screens/register/widgets/dialog.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final birthDateController = TextEditingController();
  final schoolYearController = TextEditingController();
  AlertDialogUser alertDialogUser = AlertDialogUser();
  StorageSharedPreferences storageSharedPreferences =
      StorageSharedPreferences();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      alertDialogUser.showDialogUser(context);
    });

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    birthDateController.dispose();
    schoolYearController.dispose();
    super.dispose();
  }

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
      return 'Formato inválido, insira o formato correto: ex (DD/MM/AAAA)';
    }
    return null;
  }

  String? validateSchoolYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu ano escolar';
    }
    RegExp regex = RegExp(r'^[1-9]° ano$');
    if (!regex.hasMatch(value)) {
      return 'Formato inválido! Insira um formato válido. Ex 1° ano, 2° ano, etc';
    }

    return null;
  }

  void saveData() {
    if (formKey.currentState!.validate()) {
      storageSharedPreferences.isRegisterUser(true, (error) {
        showSnackBarError(context, error, Colors.red);
      });

      showSnackBarError(context, 'Usuário inserido com sucesso!', Colors.green);
      Routes().pushRoute(
          context, const LoadingNextPage(msgFeedbasck: 'Inserindo usuário'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro de Usuário',
          style: AppTheme.customTextStyle(fontWeight: true, fontSize: 17),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: validateName,
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: birthDateController,
                decoration: const InputDecoration(
                    hintText: 'Data de nascimento',
                    //labelText: 'E-mail do destinatário',
                    border: OutlineInputBorder(),
                    helperText: ('Ex. dd/mm/aaaa')),
                validator: validateBirthDate,
                keyboardType: TextInputType.datetime,
              ),
              TextFormField(
                controller: schoolYearController,
                decoration: const InputDecoration(
                    labelText: 'Ano Escolar',
                    helperText: ('Ex. 1º ano, 2º ano, etc')),
                validator: validateSchoolYear,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  saveData();
                  print('nameController.text; ${nameController.text}');
                  print(
                      'birthDateController.text; ${birthDateController.text}');
                  print(
                      'schoolYearController.text; ${schoolYearController.text}');
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
