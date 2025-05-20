// Importações necessárias para funcionamento do cadastro e seleção de imagem
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/cadastro_controller.dart';
import '../models/professional.dart';

class PsicologoFormScreen extends StatefulWidget {
  const PsicologoFormScreen({super.key});

  @override
  State<PsicologoFormScreen> createState() => _PsicologoFormScreenState();
}

class _PsicologoFormScreenState extends State<PsicologoFormScreen> {
  // Controladores de formulário e campos
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _registroProfissionalController =
      TextEditingController();
  final TextEditingController _valorConsultaController =
      TextEditingController();
  String? _tipoProfissional;
  String? _genero;
  final CadastroController _cadastroController = CadastroController();
  bool _loading = false;
  bool _showImagePicker = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? cnpj;

  // Exibe um SnackBar para feedback ao usuário
  void showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  // Função para selecionar imagem da galeria ou câmera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF7AB0A3);
    final blueColor = const Color(0xFF4F8FCB);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro Profissional'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [themeColor, blueColor],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                color: const Color.fromARGB(170, 255, 255, 255),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo do app
                        Image.asset(
                          'assets/image/195e7eed-4690-470b-bddf-d91da4a7623f.png',
                          width: 90,
                          height: 90,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),
                        // Título
                        Text(
                          'Profissional Psicólogo',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Campo Nome
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nome',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty)
                              return 'Nome obrigatório';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Campo E-mail
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty)
                              return 'E-mail obrigatório';
                            final emailRegex =
                                RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}");
                            if (!emailRegex.hasMatch(value))
                              return 'E-mail inválido';
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        // Campo Senha
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.length < 6)
                              return 'Senha deve ter pelo menos 6 caracteres';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Campo Bio
                        TextFormField(
                          controller: _bioController,
                          decoration: const InputDecoration(
                            labelText: 'Bio',
                            prefixIcon: Icon(Icons.info_outline),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),
                        // Campo CPF
                        TextFormField(
                          controller: _cpfController,
                          decoration: const InputDecoration(
                            labelText: 'CPF',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'CPF obrigatório';
                            final cpfRegex = RegExp(
                                r'^([0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}|[0-9]{11})$');
                            if (!cpfRegex.hasMatch(value))
                              return 'CPF inválido';
                            return null;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        // Campo CNPJ
                        TextFormField(
                          controller: _cnpjController,
                          decoration: const InputDecoration(
                            labelText: 'CNPJ',
                            prefixIcon: Icon(Icons.business_outlined),
                          ),
                          validator: (_) {
                            if (_cnpjController.text.isNotEmpty) {
                              final cnpj = RegExp(
                                  r'^([0-9]{2}\.[0-9]{3}\.[0-9]{3}/[0-9]{4}-[0-9]{2}|[0-9]{14})$');
                              if (!cnpj.hasMatch(_cnpjController.text)) {
                                return 'CNPJ inválido';
                              }
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        // const SizedBox(height: 16),
                        // // Campo Tipo Profissional
                        // DropdownButtonFormField<String>(
                        //   value: _tipoProfissional,
                        //   decoration: const InputDecoration(
                        //     labelText: 'Tipo Profissional',
                        //     prefixIcon: Icon(Icons.work_outline),
                        //   ),
                        //   items: const [
                        //     DropdownMenuItem(
                        //         value: 'Psicologia', child: Text('Psicologia')),
                        //     DropdownMenuItem(
                        //         value: 'Psicanálista',
                        //         child: Text('Psicanálista')),
                        //     DropdownMenuItem(
                        //         value: 'Outro', child: Text('Outro')),
                        //   ],
                        //   onChanged: (value) =>
                        //       setState(() => _tipoProfissional = value),
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty)
                        //       return 'Selecione o tipo profissional';
                        //     return null;
                        //   },
                        // ),
                        const SizedBox(height: 16),
                        // Campo Registro Profissional
                        TextFormField(
                          controller: _registroProfissionalController,
                          decoration: const InputDecoration(
                            labelText: 'Registro Profissional',
                            prefixIcon: Icon(Icons.assignment_ind_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Registro obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Campo Gênero
                        DropdownButtonFormField<String>(
                          value: _genero,
                          decoration: const InputDecoration(
                            labelText: 'Gênero',
                            prefixIcon: Icon(Icons.transgender),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'Masculino', child: Text('Masculino')),
                            DropdownMenuItem(
                                value: 'Feminino', child: Text('Feminino')),
                            DropdownMenuItem(
                                value: 'Outro', child: Text('Outro')),
                          ],
                          onChanged: (value) {
                            setState(() => _genero = value);
                            print('Gênero selecionado: $_genero');
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Selecione o gênero';
                            }

                            return null;
                          },
                        ),

                        // Botão para mostrar/esconder área de imagem
                        Row(
                          children: [
                            Icon(Icons.image, color: themeColor),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showImagePicker = !_showImagePicker;
                                  });
                                },
                                child: Text(_showImagePicker
                                    ? 'Ocultar imagem'
                                    : 'Enviar imagem'),
                              ),
                            ),
                          ],
                        ),
                        if (_showImagePicker)
                          Column(
                            children: [
                              _selectedImage != null
                                  ? CircleAvatar(
                                      radius: 40,
                                      backgroundImage:
                                          FileImage(_selectedImage!),
                                    )
                                  : const CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Color(0xFFE0E0E0),
                                      child: Icon(Icons.person,
                                          size: 40, color: Colors.grey),
                                    ),
                              //const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.photo_library,
                                        color: themeColor),
                                    tooltip: 'Selecionar da galeria',
                                    onPressed: () =>
                                        _pickImage(ImageSource.gallery),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.camera_alt,
                                        color: blueColor),
                                    tooltip: 'Tirar foto',
                                    onPressed: () =>
                                        _pickImage(ImageSource.camera),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        //const SizedBox(height: 16),
                        // Campo Valor da Consulta
                        //const SizedBox(height: 16),
                        TextFormField(
                          controller: _valorConsultaController,
                          decoration: const InputDecoration(
                            labelText: 'Valor da Consulta (R\$)',
                            prefixIcon: Icon(Icons.attach_money_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Informe o valor da consulta';
                            final valor =
                                double.tryParse(value.replaceAll(',', '.'));
                            if (valor == null || valor <= 0)
                              return 'Valor inválido';
                            return null;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 32),
                        // Botão de cadastro
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _loading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (!_showImagePicker ||
                                          _selectedImage == null) {
                                        showSnackBar(
                                            'Selecione uma imagem para o perfil!',
                                            backgroundColor: Colors.red);
                                        return;
                                      }
                                      setState(() => _loading = true);
                                      try {
                                        String fotoBase64 = '';
                                        if (_selectedImage != null) {
                                          final bytes = await _selectedImage!
                                              .readAsBytes();
                                          fotoBase64 = base64Encode(bytes);
                                        }
                                        final profissional = Professional(
                                          name: _nameController.text.trim(),
                                          email: _emailController.text.trim(),
                                          passwordHash:
                                              _passwordController.text,
                                          bio: _bioController.text.trim(),
                                          cpf: _cpfController.text.trim(),
                                          cnpj: _cnpjController.text
                                                  .trim()
                                                  .isEmpty
                                              ? null
                                              : _cnpjController.text.trim(),
                                          crp: _registroProfissionalController
                                              .text
                                              .trim(),
                                          tipoProfissional:
                                              'Psicólogo',
                                          estaOnline: false,
                                          atendePlantao: false,
                                          valorConsulta: double.tryParse(
                                                  _valorConsultaController.text
                                                      .replaceAll(',', '.')) ??
                                              0.0,
                                          genero: _genero ?? '',
                                          foto: fotoBase64,
                                        );
                                        final response =
                                            await _cadastroController
                                                .cadastrarProfissionalModel(
                                                    profissional);
                                        if (!mounted) return;
                                        if (response.statusCode == 200 ||
                                            response.statusCode == 201) {
                                          showSnackBar(
                                              'Profissional cadastrado com sucesso!',
                                              backgroundColor: Colors.green);
                                          Navigator.pop(context);
                                        } else {
                                          showSnackBar(
                                              'Erro ao cadastrar: \n${response.body}',
                                              backgroundColor: Colors.red);
                                        }
                                      } catch (e) {
                                        if (!mounted) return;
                                        showSnackBar('Erro de conexão: $e',
                                            backgroundColor: Colors.red);
                                      } finally {
                                        if (mounted) {
                                          setState(() => _loading = false);
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
                                : const Text('Cadastrar'),
                          ),
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
