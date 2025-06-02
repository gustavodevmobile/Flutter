import 'package:blurt/controller/provider_controller.dart';
import 'package:blurt/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:blurt/controller/login_controller.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Importe o controller de login se necessário
// import 'package:t_acolhe/controller/login_controller.dart';

class LoginProfissionalScreen extends StatefulWidget {
  const LoginProfissionalScreen({super.key});

  @override
  State<LoginProfissionalScreen> createState() =>
      _LoginProfissionalScreenState();
}

class _LoginProfissionalScreenState extends State<LoginProfissionalScreen> {
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _showSelfieField = false;
  File? _selfieImage;
  String? _selfieBase64;
  final ImagePicker _picker = ImagePicker();

  void showSnackBar(BuildContext context, String message,
      {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  final cpfFormater = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  Future<void> _pickSelfie() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selfieImage = File(pickedFile.path);
      });
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selfieBase64 = base64Encode(bytes);
      });
    }
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
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/image/logotipoBlurt2.png',
                          width: 180,
                          height: 180,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          'Login Profissional',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppThemes.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _cpfController,
                          inputFormatters: [cpfFormater],
                          decoration: const InputDecoration(
                            labelText: 'CPF',
                            prefixIcon: Icon(Icons.badge_outlined),
                            hintText: '000.000.000-00',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'E-mail obrigatório';
                            }
                            final cpfRegex = RegExp(
                                r'^([0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}|[0-9]{11})$');
                            if (!cpfRegex.hasMatch(value)) {
                              return 'CPF inválido';
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
                              backgroundColor: const Color(0xFF7AB0A3),
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
                                      // await LoginController().loginProfissional(
                                      //   _cpfController.text,
                                      //   _passwordController.text,
                                      //   (onSuccess) {
                                      //     print('Login bem-sucedido: $onSuccess');
                                      //     Provider.of<ProviderController>(
                                      //             context,
                                      //             listen: false)
                                      //         .setProfissional(onSuccess);
                                      //     setState(() {
                                      //       _loading = false;
                                      //       _showSelfieField = true;
                                      //     });
                                      //   },
                                      //   (error) {
                                      //     setState(() => _loading = false);
                                      //     showSnackBar(context, error,
                                      //         backgroundColor: Colors.red);
                                      //   },
                                      // );
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
                                      context, '/cadastro_profissional');
                                },
                          child: const Text('Não tem conta? Cadastre-se'),
                        ),
                        if (_showSelfieField) ...[
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Selfie para validação:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _selfieImage != null
                                  ? CircleAvatar(
                                      radius: 32,
                                      backgroundImage: FileImage(_selfieImage!),
                                    )
                                  : const CircleAvatar(
                                      radius: 32,
                                      backgroundColor: Color(0xFFE0E0E0),
                                      child: Icon(Icons.person,
                                          size: 32, color: Colors.grey),
                                    ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: _loading
                                    ? null
                                    : () async {
                                        await _pickSelfie();
                                        if (_selfieImage != null) {
                                          if (context.mounted) {
                                            Navigator.pushNamed(context,
                                                '/dashboard_profissional');
                                          }
                                        } else {
                                          if (context.mounted) {
                                            showSnackBar(context,
                                                'Por favor, tire uma selfie.',
                                                backgroundColor: Colors.red);
                                          }
                                        }
                                      },
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: AppThemes.textLightColor,
                                ),
                                label: const Text('Tirar Selfie'),
                              ),
                            ],
                          ),
                        ],
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
