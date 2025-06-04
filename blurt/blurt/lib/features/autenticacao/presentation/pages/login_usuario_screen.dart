import 'package:blurt/core/utils/background.dart';
import 'package:blurt/features/autenticacao/presentation/widgets/login_form_usuario.dart';
import 'package:flutter/material.dart';
import 'package:blurt/features/autenticacao/presentation/controllers/login_controller.dart';
import 'package:blurt/features/autenticacao/domain/usecases/login_usuario_usecase.dart';
import 'package:blurt/features/autenticacao/data/repositories/login_repository_impl.dart';
import 'package:blurt/features/autenticacao/data/datasources/login_remote_datasource_impl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginUsuarioScreen extends StatelessWidget {
  const LoginUsuarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginUsuarioController>(
      create: (_) => LoginUsuarioController(
        loginUsuarioUseCase: LoginUsuarioUseCase(
          LoginRepositoryImpl(
            LoginRemoteDatasourceImpl(http.Client()),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login Usuário'),
          centerTitle: true,
          elevation: 3,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Background(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      child: const LoginFormUsuario()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
