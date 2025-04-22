import 'package:estudamais/controller/controller_register.dart';
import 'package:estudamais/models/user.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/button_next.dart';
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
  //AlertDialogUser alertDialogUser = AlertDialogUser();
  ControllerRegister controllerRegister = ControllerRegister();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        controllerRegister.alertDialogUserInitial(context);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    birthDateController.dispose();
    schoolYearController.dispose();
    super.dispose();
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 225, 230, 255),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                  validator: controllerRegister.validateName,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: birthDateController,
                  decoration: const InputDecoration(
                      //hintText: 'Data de nascimento',
                      labelText: 'Data de nascimento',
                      border: OutlineInputBorder(),
                      helperText: ('Ex. dd/mm/aaaa')),
                  validator: controllerRegister.validateBirthDate,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: schoolYearController,
                  decoration: const InputDecoration(
                    labelText: 'Ano Escolar',
                    helperText: ('Ex. 1º ano, 2º ano, etc'),
                    border: OutlineInputBorder(),
                  ),
                  validator: controllerRegister.validateSchoolYear,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    User user = controllerRegister.toUser(nameController.text,
                        birthDateController.text, schoolYearController.text);
                    controllerRegister.saveData(formKey, context, user);
                  },
                  child: const ButtonNext(
                    textContent: 'Salvar',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
