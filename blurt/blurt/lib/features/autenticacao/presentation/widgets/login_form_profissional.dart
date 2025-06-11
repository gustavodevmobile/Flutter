import 'dart:convert';
import 'dart:io';

import 'package:blurt/core/utils/formatters.dart';
import 'package:blurt/core/utils/snackbars_helpers.dart';
import 'package:blurt/core/utils/validators.dart';
import 'package:blurt/core/websocket/websocket_provider.dart';
import 'package:blurt/features/autenticacao/presentation/controllers/login_profissional_controller.dart';
import 'package:blurt/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class LoginFormProfissional extends StatefulWidget {
  const LoginFormProfissional({super.key});

  @override
  State<LoginFormProfissional> createState() => _LoginFormProfissionalState();
}

class _LoginFormProfissionalState extends State<LoginFormProfissional> {
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  final bool _showSelfieField = false;
  File? _selfieImage;
  String? _selfieBase64;
  final ImagePicker _picker = ImagePicker();

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
    return Consumer2<LoginProfissionalController, WebSocketProvider>(builder:
        (context, controllerProfissionalLogin, webSocketController, child) {
      return Form(
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
              inputFormatters: [Formatters.cpfFormater],
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
                final cpfRegex = Validators.isCpf(value);
                if (!cpfRegex) {
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
                        if (_cpfController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty) {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _loading = true);

                            try {
                              final profissional =
                                  await controllerProfissionalLogin.login(
                                      _cpfController.text,
                                      _passwordController.text,
                                      context);
                              if (profissional != null) {
                                print('profissional: $profissional');
                                // controllerProfissionalLogin
                                //     .startPing(profissional.id!,
                                //         webSocketController.channel!);

                                if (context.mounted) {
                                  setState(() {
                                    _loading = false;
                                  });
                                  Navigator.pushNamed(
                                      context, '/dashboard_profissional');
                                }
                              }
                            } catch (error) {
                              if (context.mounted) {
                                setState(() {
                                  _loading = false;
                                });
                                print('Erro ao fazer login: $error');
                                SnackbarsHelpers.showSnackBar(
                                  context,
                                  error.toString(),
                                  backgroundColor: Colors.red,
                                );
                              }
                            }
                          }
                          //_showSelfieField = true;
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
                      Navigator.pushNamed(context, '/cadastro_profissional');
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
                      fontWeight: FontWeight.bold, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 8),
              // Row(
              //   children: [
              //     _selfieImage != null
              //         ? CircleAvatar(
              //             radius: 32,
              //             backgroundImage: FileImage(_selfieImage!),
              //           )
              //         : const CircleAvatar(
              //             radius: 32,
              //             backgroundColor: Color(0xFFE0E0E0),
              //             child:
              //                 Icon(Icons.person, size: 32, color: Colors.grey),
              //           ),
              //     const SizedBox(width: 16),
              //     ElevatedButton.icon(
              //       onPressed: _loading
              //           ? null
              //           : () async {
              //               await _pickSelfie();
              //               if (_selfieImage != null) {
              //                 if (context.mounted) {}
              //               } else {
              //                 if (context.mounted) {
              //                   SnackbarsHelpers.showSnackBar(context,
              //                       'Por favor, tire uma selfie para validar seu login.',
              //                       backgroundColor: Colors.red);
              //                 }
              //               }
              //             },
              //       icon: const Icon(
              //         Icons.camera_alt,
              //         color: AppThemes.textLightColor,
              //       ),
              //       label: const Text('Tirar Selfie'),
              //     ),
              //   ],
              // ),
            ],
          ],
        ),
      );
    });
  }
}
