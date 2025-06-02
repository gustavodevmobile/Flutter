import 'package:blurt/controller/buscas_controller.dart';
import 'package:blurt/controller/provider_controller.dart';
import 'package:blurt/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:blurt/controller/login_controller.dart';
import 'package:provider/provider.dart';

class LoginUsuarioScreen extends StatefulWidget {
  const LoginUsuarioScreen({super.key});

  @override
  State<LoginUsuarioScreen> createState() => _LoginUsuarioScreenState();
}

class _LoginUsuarioScreenState extends State<LoginUsuarioScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final BuscasController _buscasController = BuscasController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Form(
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
                        //const SizedBox(height: 16),
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
                            final emailRegex =
                                RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}");
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
                              //backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            onPressed: _loading
                                ? null
                                : () async {
                                    ScaffoldMessengerState scaffoldMessenger =
                                        ScaffoldMessenger.of(context);
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => _loading = true);
                                      try {
                                        await LoginController().loginUsuario(
                                            _emailController.text,
                                            _passwordController.text,
                                            (usuario) {
                                              // Provider.of<ProviderController>(
                                              //   context,
                                              //   listen: false, 
                                              // ).setUsuario(usuario);
                                          _buscasController
                                              .getProfissionalOnline(
                                                  (profissionais) {
                                            Provider.of<ProviderController>(
                                              context,
                                              listen: false,
                                            ).setProfissionaisOnline(
                                                profissionais);
                                          }, (onError) {
                                            scaffoldMessenger.showSnackBar(
                                              SnackBar(
                                                content: Text(onError),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          });
                                          Navigator.pushNamed(
                                              context, '/dashboard_usuario');
                                          setState(() => _loading = false);
                                        }, (error) {
                                          scaffoldMessenger.showSnackBar(
                                            SnackBar(
                                              content: Text(error),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        });
                                      } catch (e) {
                                        scaffoldMessenger.showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('Erro de conexão: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } finally {
                                        setState(() => _loading = false);
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
                                  Navigator.pushNamed(
                                      context, '/cadastro_usuario');
                                },
                          child: const Text('Não tem conta? Cadastre-se'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
