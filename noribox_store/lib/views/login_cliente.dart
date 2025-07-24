import 'package:flutter/material.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/widgets/appbar/app_bar_desktop.dart';
import 'package:noribox_store/widgets/appbar/app_bar_widget.dart';
import 'package:noribox_store/widgets/button_whatsapp.dart';
import 'package:noribox_store/widgets/custom_button.dart';
import 'package:noribox_store/widgets/footer_widget.dart';

class LoginClienteScreen extends StatefulWidget {
  const LoginClienteScreen({super.key});

  @override
  State<LoginClienteScreen> createState() => _LoginClienteScreenState();
}

class _LoginClienteScreenState extends State<LoginClienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // Simulação de login
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);
      // Navegar ou mostrar erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.colorBackground,
      appBar: PreferredSize(
        preferredSize: ThemesSize.heightAppBar,
        child: AppBarWidget(),
      ),
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 2,
                        spreadRadius: 0.3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Spacer(),
                      Container(
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Themes.greyTertiary,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Text(
                                'Acesse sua conta',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        labelText: 'E-mail',
                                        border: OutlineInputBorder(),
                                        focusedBorder: ThemesTextStyle.outlineTextForm,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Informe o e-mail';
                                        }
                                        if (!value.contains('@')) {
                                          return 'E-mail inválido';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _senhaController,
                                      decoration: InputDecoration(
                                        labelText: 'Senha',
                                        border: OutlineInputBorder(),
                                        focusedBorder: ThemesTextStyle.outlineTextForm,
                                      ),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Informe a senha';
                                        }
                                        if (value.length < 6) {
                                          return 'Senha deve ter ao menos 6 caracteres';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 4.0),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        style:
                                            ThemesTextStyle.textButtonHoverNone,
                                        onPressed: () {},
                                        child: Text(
                                          'Esqueci minha senha',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    CustomButton(
                                      width: double.infinity,
                                      height: 50,
                                      backgroundColor: Themes.redPrimary,
                                      onPressed: _isLoading ? null : _login,
                                      child: _isLoading
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : const Text('Entrar'),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Não tem uma conta?',
                                          style: TextStyle(
                                            color: Themes.greyPrimary,
                                            fontSize: 12,
                                          ),
                                        ),
                                        TextButton(
                                          style: ThemesTextStyle
                                              .textButtonHoverNone,
                                          onPressed: () {},
                                          child: Text(
                                            'Cadastre-se',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      FooterWidget()
                    ],
                  ),
                ),
              ),
            ),
          ),
          ButtonWhatsapp()
        ],
      ),
    );
  }
}
