import 'package:blurt/core/utils/snackbars_helpers.dart';
import 'package:blurt/core/websocket/websocket_provider.dart';
import 'package:blurt/features/profissionais_online/controllers/profissionais_online_controller.dart';
import 'package:blurt/provider/provider_controller.dart';
import 'package:blurt/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blurt/features/autenticacao/presentation/controllers/login_controller.dart';

class LoginFormUsuario extends StatefulWidget {
  const LoginFormUsuario({super.key});

  @override
  State<LoginFormUsuario> createState() => _LoginFormUsuarioState();
}

class _LoginFormUsuarioState extends State<LoginFormUsuario> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer4<LoginUsuarioController, ProfissionaisOnlineController,
        ProviderController, WebSocketProvider>(
      builder: (context, controllerUsuario, controllerProfissionaisOnline,
          providerController, webSocketProvider, child) {
        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/image/logotipoBlurt2.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              Text(
                'Bem-vindo de volta!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.secondaryColor,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'E-mail obrigatório';
                  }
                  final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}");
                  if (!emailRegex.hasMatch(value)) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: _loading
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            setState(() => _loading = true);

                            try {
                              final usuario = await controllerUsuario.login(
                                email: _emailController.text,
                                senha: _passwordController.text,
                              );
                              if (usuario != null) {
                                 webSocketProvider.connect();
                                //Faz a busca dos profissionais online
                                final profissionaisOnline =
                                    await controllerProfissionaisOnline
                                        .buscarProfissionaisOnline();

                                webSocketProvider.identifyConnection(
                                    usuario.id!, "usuario");
                                // Atualiza a lista de profissionais online no WebSocketProvider
                                webSocketProvider.setProfissionaisOnline(
                                    profissionaisOnline);

                                webSocketProvider.keepConnection();

                                // Atualiza a lista de profissionais online no ProviderController
                                providerController.setProfissionaisOnline(
                                    profissionaisOnline);
                              }

                              setState(() => _loading = false);
                              if (context.mounted) {
                                Navigator.pushNamed(
                                  context,
                                  '/dashboard_usuario',
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                print('Erro ao fazer login: $e');
                                // Exibe o erro usando o SnackBar
                                SnackbarsHelpers.showSnackBar(
                                    context, e.toString(),
                                    backgroundColor: Colors.red);
                              }
                            }
                          }
                        },
                  child: _loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text('Entrar'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _loading
                    ? null
                    : () {
                        Navigator.pushNamed(context, '/cadastro_usuario');
                      },
                child: const Text('Não tem conta? Cadastre-se'),
              ),
            ],
          ),
        );
      },
    );
  }
}
