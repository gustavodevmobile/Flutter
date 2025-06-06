import 'package:blurt/features/autenticacao/presentation/widgets/login_form_profissional.dart';
import 'package:blurt/theme/themes.dart';
import 'package:flutter/material.dart';

// Importe o controller de login se necessário
// import 'package:t_acolhe/controller/login_controller.dart';

class LoginProfissionalScreen extends StatefulWidget {
  const LoginProfissionalScreen({super.key});

  @override
  State<LoginProfissionalScreen> createState() =>
      _LoginProfissionalScreenState();
}

class _LoginProfissionalScreenState extends State<LoginProfissionalScreen> {
  

  void showSnackBar(BuildContext context, String message,
      {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Profissional'),
        centerTitle: true,
        elevation: 3,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.popAndPushNamed(context, '/'),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [AppThemes.secondaryColor, AppThemes.primaryColor],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: LoginFormProfissional()
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
