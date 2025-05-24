// Importações necessárias para funcionamento do cadastro e seleção de imagem
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:t_acolhe/controller/abordagem_especialidade_controller.dart';
import 'package:t_acolhe/models/especialidade_abordagem.dart';
import '../controller/cadastro_controller.dart';
import '../models/professional.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  final TextEditingController _abordagemController = TextEditingController();
  final TextEditingController _especialidadeController =
      TextEditingController();
  final TextEditingController _chavePixController = TextEditingController();
  final TextEditingController _contaBancariaController =
      TextEditingController();
  final TextEditingController _agenciaController = TextEditingController();
  final TextEditingController _bancoController = TextEditingController();
  final TextEditingController _tipoContaController = TextEditingController();
  List<String> _especialidades = [];
  List<Abordagem> _abordagens = [];
  List<Especialidade> _especialidadesDisponiveis = [];
  String? cnpj;
  String? _genero;
  Abordagem? _abordagemSelecionada;
  Especialidade? _especialidadeSelecionada;
  final CadastroController _cadastroController = CadastroController();
  final AbordagemEspecialidadeController _abordagemEspecialidadeController =
      AbordagemEspecialidadeController();
  bool _loading = false;
  bool _showImagePicker = false;
  bool _showNovaAbordagem = false;
  bool _showNovaEspecialidade = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Exibe um SnackBar para feedback ao usuário
  void showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  final crpFormater = MaskTextInputFormatter(
    mask: '##/######',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final cpfFormater = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final cnpjFormater = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

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
  void initState() {
    super.initState();
    _carregarAbordagensEspecialidades();
  }

  Future<void> _carregarAbordagensEspecialidades() async {
    try {
      final abordagens =
          await _abordagemEspecialidadeController.buscarAbordagens();
      final especialidades =
          await _abordagemEspecialidadeController.buscarEspecialidades();
      setState(() {
        _abordagens = abordagens;
        _especialidadesDisponiveis = especialidades;
      });
    } catch (e) {
      showSnackBar('Erro ao carregar abordagens/especialidades',
          backgroundColor: Colors.red);
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
                        Text(
                          'Dados Pessoais',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Campo Nome
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nome',
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
                        // Campo E-mail
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
                        // Campo Senha
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
                        // Campo Bio
                        TextFormField(
                          controller: _bioController,
                          decoration: const InputDecoration(
                            labelText: 'Biografia',
                            prefixIcon: Icon(Icons.info_outline),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),
                        // Campo Gênero
                        DropdownButtonFormField<String>(
                          value: _genero,
                          decoration: const InputDecoration(
                            labelText: 'Gênero*',
                            prefixIcon: Icon(Icons.transgender),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'Masculino', child: Text('Masculino')),
                            DropdownMenuItem(
                                value: 'Feminino', child: Text('Feminino')),
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
                            final valor =
                                double.tryParse(value.replaceAll(',', '.'));
                            if (valor == null || valor <= 0) {
                              return 'Valor inválido';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        Divider(
                          color: themeColor,
                          thickness: 2,
                        ),
                        Text(
                          'Documentos Pessoais',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Campo CPF
                        TextFormField(
                          controller: _cpfController,
                          inputFormatters: [cpfFormater],
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
                        // Campo CNPJ
                        TextFormField(
                          controller: _cnpjController,
                          inputFormatters: [cnpjFormater],
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
                        // Campo Registro Profissional
                        TextFormField(
                          controller: _registroProfissionalController,
                          inputFormatters: [crpFormater],
                          decoration: const InputDecoration(
                            labelText: 'CRP*',
                            prefixIcon: Icon(Icons.assignment_ind_outlined),
                            hintText: '00/000000*',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Registro profissional é obrigatório.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Divider(
                          color: themeColor,
                          thickness: 2,
                        ),
                        Text(
                          'Abordagem e Especialidade',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Campo Abordagem Principal
                        DropdownButtonFormField<Abordagem>(
                          value: _abordagemSelecionada,
                          decoration: const InputDecoration(
                            labelText: 'Abordagem Principal*',
                            prefixIcon: Icon(Icons.psychology_alt_outlined),
                          ),
                          items: _abordagens
                              .map((abord) => DropdownMenuItem(
                                    value: abord,
                                    child: Text(abord.nome),
                                  ))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => _abordagemSelecionada = value),
                          validator: (value) {
                            if (value == null) {
                              return 'Abordagem obrigatória';
                            }
                            return null;
                          },
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('Adicionar nova abordagem'),
                            onPressed: () => setState(
                                () => _showNovaAbordagem = !_showNovaAbordagem),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              minimumSize: Size(0,
                                  0), // opcional, para remover restrições mínimas
                              tapTargetSize: MaterialTapTargetSize
                                  .shrinkWrap, // opcional, para reduzir área de toque
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                          height: _showNovaAbordagem ? 70 : 0,
                          child: _showNovaAbordagem
                              ? Row(
                                  key: const ValueKey('novaAbordagem'),
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _abordagemController,
                                        decoration: const InputDecoration(
                                          labelText: 'Nova abordagem',
                                          prefixIcon: Icon(
                                            Icons.psychology_alt_outlined,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 8),
                        // Campo Especialidade (adiciona à lista)
                        DropdownButtonFormField<Especialidade>(
                          value: _especialidadeSelecionada,
                          decoration: const InputDecoration(
                            labelText: 'Especialidade(s)',
                            prefixIcon: Icon(Icons.star_outline),
                          ),
                          items: _especialidadesDisponiveis
                              .map((esp) => DropdownMenuItem(
                                    value: esp,
                                    child: Text(esp.nome),
                                  ))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => _especialidadeSelecionada = value),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('Adicionar nova especialidade'),
                            onPressed: () => setState(() =>
                                _showNovaEspecialidade =
                                    !_showNovaEspecialidade),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              minimumSize: Size(0,
                                  0), // opcional, para remover restrições mínimas
                              tapTargetSize: MaterialTapTargetSize
                                  .shrinkWrap, // opcional, para reduzir área de toque
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                          height: _showNovaEspecialidade ? 70 : 0,
                          child: _showNovaEspecialidade
                              ? Row(
                                  key: const ValueKey('novaEspecialidade'),
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _especialidadeController,
                                        decoration: const InputDecoration(
                                          labelText: 'Nova especialidade',
                                          prefixIcon: Icon(Icons.star_outline),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      tooltip: 'Adicionar Especialidade',
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        final text =
                                            _especialidadeController.text;
                                        if (text.isNotEmpty &&
                                            !_especialidades.contains(text)) {
                                          setState(() {
                                            _especialidades.add(text);
                                            _especialidadeSelecionada = null;
                                          });
                                        }
                                        _especialidadeController.clear();
                                      },
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                        // Lista de especialidades adicionadas
                        if (_especialidades.isNotEmpty)
                          Text('Especialidades adicionadas:',
                              style: TextStyle(fontSize: 16, color: blueColor)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _especialidades
                              .map((esp) => Row(
                                    children: [
                                      const Icon(Icons.check,
                                          color: Colors.green, size: 20),
                                      const SizedBox(width: 6),
                                      Expanded(child: Text(esp)),
                                      IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.red, size: 20),
                                        tooltip: 'Remover',
                                        onPressed: () {
                                          setState(() {
                                            _especialidades.remove(esp);
                                          });
                                        },
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        Divider(
                          color: themeColor,
                          thickness: 1,
                        ),
                        Text(
                          'Dados Bancários (opcional)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                                    : 'Enviar foto para perfil*'),
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
                                        // Cadastro da abordagem principal
                                        if (_abordagemController
                                            .text.isNotEmpty) {
                                          await _cadastroController
                                              .cadastrarAbordagem(
                                                  _abordagemController.text
                                                      .trim());
                                        } else {
                                          await _cadastroController
                                              .cadastrarAbordagem(
                                                  _abordagemSelecionada!.id);
                                        }
                                        
                                        // Cadastro das especialidades
                                        if (_especialidades.isEmpty) {
                                          _especialidades = [];
                                          await _cadastroController
                                              .cadastrarEspecialidades(
                                                  _especialidades);
                                        } else {
                                          await _cadastroController
                                              .cadastrarEspecialidades(
                                                  _especialidades);
                                        }
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
                                          tipoProfissional: 'Psicólogo',
                                          estaOnline: false,
                                          atendePlantao: false,
                                          valorConsulta: double.tryParse(
                                                  _valorConsultaController.text
                                                      .replaceAll(',', '.')) ??
                                              0.0,
                                          genero: _genero ?? '',
                                          foto: fotoBase64,
                                          chavePix: _chavePixController.text
                                                  .trim()
                                                  .isEmpty
                                              ? null
                                              : _chavePixController.text.trim(),
                                          contaBancaria:
                                              _contaBancariaController.text
                                                      .trim()
                                                      .isEmpty
                                                  ? null
                                                  : _contaBancariaController
                                                      .text
                                                      .trim(),
                                          agencia: _agenciaController.text
                                                  .trim()
                                                  .isEmpty
                                              ? null
                                              : _agenciaController.text.trim(),
                                          banco: _bancoController.text
                                                  .trim()
                                                  .isEmpty
                                              ? null
                                              : _bancoController.text.trim(),
                                          tipoConta: _tipoContaController.text
                                                  .trim()
                                                  .isEmpty
                                              ? null
                                              : _tipoContaController.text
                                                  .trim(),
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
                                          //Navigator.pop(context);
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
