import 'dart:convert';
import 'dart:io';

import 'package:blurt/core/utils/formatters.dart';
import 'package:blurt/core/utils/snackbars_helpers.dart';
import 'package:blurt/features/cadastro/presentation/controllers/cadastro_profissional_controller.dart';
import 'package:blurt/models/profissional/profissional.dart';
import 'package:blurt/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CadastroPsicanalistaForm extends StatefulWidget {
  const CadastroPsicanalistaForm({super.key});

  @override
  State<CadastroPsicanalistaForm> createState() =>
      _CadastroPsicanalistaFormState();
}

class _CadastroPsicanalistaFormState extends State<CadastroPsicanalistaForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _valorConsultaController =
      TextEditingController();
  final TextEditingController _chavePixController = TextEditingController();
  final TextEditingController _contaBancariaController =
      TextEditingController();
  final TextEditingController _agenciaController = TextEditingController();
  final TextEditingController _bancoController = TextEditingController();
  final TextEditingController _tipoContaController = TextEditingController();

  String? _genero;

  bool _loading = false;

  File? _diplomaPsicanalistaImage;
  File? _declSupClinicaImage;
  File? _declAnPessoalImage;
  File? _profileImage;
  File? _imagemDocumento;
  File? _imagemSelfieComDoc;
  final ImagePicker _picker = ImagePicker();
  //bool showCheck = false;

  Future<void> _pickImage(
      ImageSource source, void Function(File) setter) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        setter(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CadastroProfissionalController>(
        builder: (context, controller, child) {
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
            //const SizedBox(height: 16),
            Text(
              'Profissional Psicanalista',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppThemes.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome Completo*',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nome obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail*',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
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
                labelText: 'Senha*',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Senha deve ter pelo menos 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: 'Biografia',
                prefixIcon: Icon(Icons.info_outline),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cpfController,
              inputFormatters: [Formatters.cpfFormater],
              decoration: const InputDecoration(
                labelText: 'CPF*',
                prefixIcon: Icon(Icons.badge_outlined),
                hintText: '000.000.000-00',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'CPF obrigatório';
                }

                final cpfRegex = RegExp(
                    r'^([0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}|[0-9]{11})$');
                if (!cpfRegex.hasMatch(value)) {
                  return 'CPF inválido';
                }
                return null;
              },
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cnpjController,
              inputFormatters: [Formatters.cnpjFormater],
              decoration: const InputDecoration(
                labelText: 'CNPJ',
                prefixIcon: Icon(Icons.business_outlined),
                hintText: '00.000.000/0000-00',
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

            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _genero,
              decoration: const InputDecoration(
                labelText: 'Gênero*',
                prefixIcon: Icon(Icons.transgender),
              ),
              items: const [
                DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                DropdownMenuItem(value: 'Feminino', child: Text('Feminino')),
              ],
              onChanged: (value) => setState(() => _genero = value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecione o gênero';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Campo Abordagem Principal
            Divider(
              color: AppThemes.secondaryColor,
              thickness: 2,
            ),

            const SizedBox(height: 16),
            // Campo obrigatório de imagem de perfil
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Foto de Perfil*',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _profileImage != null
                    ? CircleAvatar(
                        radius: 32, backgroundImage: FileImage(_profileImage!))
                    : const CircleAvatar(
                        radius: 32,
                        backgroundColor: Color(0xFFE0E0E0),
                        child: Icon(Icons.person, color: Colors.grey)),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  tooltip: 'Selecionar da galeria',
                  onPressed: () => _pickImage(
                      ImageSource.gallery, (file) => _profileImage = file),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  tooltip: 'Tirar foto',
                  onPressed: () => _pickImage(
                      ImageSource.camera, (file) => _profileImage = file),
                ),
                IconButton(
                  icon: Icon(Icons.clear, color: Colors.red),
                  tooltip: 'Limpar seleção',
                  onPressed: () {
                    setState(() {
                      _profileImage = null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Campo Imagem Documento
            _buildImagePickerField(
              label: 'Documento com foto*',
              image: _imagemDocumento,
              onPick: (source) =>
                  _pickImage(source, (file) => _imagemDocumento = file),
              showCheck: true,
              clearButton: IconButton(
                icon: Icon(Icons.clear, color: Colors.red),
                tooltip: 'Limpar seleção',
                onPressed: () {
                  setState(() {
                    _imagemDocumento = null;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            // Campo Imagem Selfie com Documento
            _buildImagePickerField(
              label: 'Selfie com Documento*',
              image: _imagemSelfieComDoc,
              onPick: (source) =>
                  _pickImage(source, (file) => _imagemSelfieComDoc = file),
              showCheck: true,
              clearButton: IconButton(
                icon: Icon(Icons.clear, color: Colors.red),
                tooltip: 'Limpar seleção',
                onPressed: () {
                  setState(() {
                    _imagemSelfieComDoc = null;
                  });
                },
              ),
            ),
            // Diploma Psicanalista

            _buildImagePickerField(
              label: 'Diploma de Psicanalista*',
              image: _diplomaPsicanalistaImage,
              onPick: (source) => _pickImage(
                  source, (file) => _diplomaPsicanalistaImage = file),
              showCheck: true,
              clearButton: IconButton(
                icon: Icon(Icons.clear, color: Colors.red),
                tooltip: 'Limpar seleção',
                onPressed: () {
                  setState(() {
                    _diplomaPsicanalistaImage = null;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            // Declaração Sup. Clínica
            _buildImagePickerField(
              label: 'Declaração Supervisão Clínica*',
              image: _declSupClinicaImage,
              onPick: (source) =>
                  _pickImage(source, (file) => _declSupClinicaImage = file),
              showCheck: true,
              clearButton: IconButton(
                icon: Icon(Icons.clear, color: Colors.red),
                tooltip: 'Limpar seleção',
                onPressed: () {
                  setState(() {
                    _declSupClinicaImage = null;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            // Declaração Análise Pessoal
            _buildImagePickerField(
              label: 'Declaração Análise Pessoal*',
              image: _declAnPessoalImage,
              onPick: (source) =>
                  _pickImage(source, (file) => _declAnPessoalImage = file),
              showCheck: true,
              clearButton: IconButton(
                icon: Icon(Icons.clear, color: Colors.red),
                tooltip: 'Limpar seleção',
                onPressed: () {
                  setState(() {
                    _declAnPessoalImage = null;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            // Campo Valor da Consulta
            TextFormField(
              controller: _valorConsultaController,
              decoration: const InputDecoration(
                labelText: 'Valor da Consulta (R\$)*',
                prefixIcon: Icon(Icons.attach_money_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o valor da consulta';
                }
                final valor = double.tryParse(value.replaceAll(',', '.'));
                if (valor == null || valor <= 0) {
                  return 'Valor inválido';
                }
                return null;
              },
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Divider(
              color: AppThemes.secondaryColor,
              thickness: 2,
            ),
            Text('Dados Bancários',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppThemes.secondaryColor)),
            // Campo Chave Pix
            TextFormField(
              controller: _chavePixController,
              decoration: const InputDecoration(
                labelText: 'Chave Pix',
                prefixIcon: Icon(Icons.pix),
              ),
            ),
            const SizedBox(height: 16),
            // Campo Conta Bancária
            TextFormField(
              controller: _contaBancariaController,
              decoration: const InputDecoration(
                labelText: 'Conta Bancária',
                prefixIcon: Icon(Icons.account_balance),
              ),
            ),
            const SizedBox(height: 16),
            // Campo Agência
            TextFormField(
              controller: _agenciaController,
              decoration: const InputDecoration(
                labelText: 'Agência',
                prefixIcon: Icon(Icons.confirmation_number),
              ),
            ),
            const SizedBox(height: 16),
            // Campo Banco
            TextFormField(
              controller: _bancoController,
              decoration: const InputDecoration(
                labelText: 'Banco',
                prefixIcon: Icon(Icons.account_balance_wallet),
              ),
            ),
            const SizedBox(height: 16),
            // Campo Tipo de Conta
            TextFormField(
              controller: _tipoContaController,
              decoration: const InputDecoration(
                labelText: 'Tipo de Conta',
                prefixIcon: Icon(Icons.credit_card),
              ),
            ),
            const SizedBox(height: 16),

            // Botão de cadastro
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemes.secondaryColor,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _loading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          if (_profileImage == null) {
                            SnackbarsHelpers.showSnackBar(
                                context, 'Selecione uma foto de perfil!',
                                backgroundColor: Colors.red);
                            return;
                          }
                          if (_diplomaPsicanalistaImage == null ||
                              _declSupClinicaImage == null ||
                              _declAnPessoalImage == null) {
                            SnackbarsHelpers.showSnackBar(
                                context, 'As declarações são obrigatórias!',
                                backgroundColor: Colors.red);
                            return;
                          }
                          setState(() => _loading = true);

                          // Cadastra o profissional
                          final profissional = {
                            'nome': _nameController.text.trim(),
                            'email': _emailController.text.trim(),
                            'senha': _passwordController.text,
                            'bio': _bioController.text.trim().isEmpty
                                ? null
                                : _bioController.text.trim(),
                            'cpf': _cpfController.text.trim(),
                            'cnpj': _cnpjController.text.trim().isEmpty
                                ? null
                                : _cnpjController.text.trim(),
                            'crp': null,
                            'diplomaPsicanalista': _diplomaPsicanalistaImage,
                            'declSupClinica': _declSupClinicaImage,
                            'declAnPessoal': _declAnPessoalImage,
                            'tipoProfissional': 'Psicanalista',
                            'estaOnline': false,
                            ' atendePlantao': false,
                            'emAtendimento': false,
                            'valorConsulta': double.tryParse(
                                    _valorConsultaController.text
                                        .replaceAll(',', '.')) ??
                                0.0,
                            'genero': _genero ?? '',
                            'foto': _profileImage,
                            'imagemDocumento': _imagemDocumento,
                            'imagemSelfieComDoc': _imagemSelfieComDoc,
                            'chavePix': _chavePixController.text.trim().isEmpty
                                ? null
                                : _chavePixController.text.trim(),
                            'contaBancaria':
                                _contaBancariaController.text.trim().isEmpty
                                    ? null
                                    : _contaBancariaController.text.trim(),
                            ' agencia': _agenciaController.text.trim().isEmpty
                                ? null
                                : _agenciaController.text.trim(),
                            'banco': _bancoController.text.trim().isEmpty
                                ? null
                                : _bancoController.text.trim(),
                            'tipoConta':
                                _tipoContaController.text.trim().isEmpty
                                    ? null
                                    : _tipoContaController.text.trim(),
                          };
                          try {
                            final result = await controller
                                .cadastrarProfissional(profissional);
                            if (result.isNotEmpty) {
                              setState(() => _loading = false);
                              if (context.mounted) {
                                SnackbarsHelpers.showSnackBar(context, result,
                                    backgroundColor: Colors.green);

                                Navigator.pop(context);
                              }
                            }
                          } catch (error) {
                            print('Erro ao cadastrar profissional: $error');
                            if (context.mounted) {
                              setState(() => _loading = false);
                              SnackbarsHelpers.showSnackBar(
                                  context, error.toString(),
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
                    : const Text('Cadastrar'),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildImagePickerField({
    required String label,
    required File? image,
    required void Function(ImageSource) onPick,
    bool showCheck = false,
    Widget? clearButton,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Row(
          children: [
            showCheck
                ? (image != null
                    ? const Icon(Icons.check_circle,
                        color: Colors.green, size: 32)
                    : const Icon(Icons.radio_button_unchecked,
                        color: Colors.grey, size: 32))
                : (image != null
                    ? CircleAvatar(
                        radius: 32, backgroundImage: FileImage(image))
                    : const CircleAvatar(
                        radius: 32,
                        backgroundColor: Color(0xFFE0E0E0),
                        child: Icon(Icons.image, color: Colors.grey))),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.photo_library),
              tooltip: 'Selecionar da galeria',
              onPressed: () => onPick(ImageSource.gallery),
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt),
              tooltip: 'Tirar foto',
              onPressed: () => onPick(ImageSource.camera),
            ),
            if (clearButton != null) clearButton,
          ],
        ),
      ],
    );
  }
}
