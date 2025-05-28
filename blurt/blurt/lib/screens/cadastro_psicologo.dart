// Importações necessárias para funcionamento do cadastro e seleção de imagem
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blurt/controller/abordagem_especialidade_controller.dart';
import 'package:blurt/models/especialidade_abordagem.dart';
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
  final TextEditingController _novaAbordagemPrincipalController =
      TextEditingController();
  final TextEditingController _novaAbordagemUtilizadaController =
      TextEditingController();
  final TextEditingController _novaEspecialidadePrincipalController =
      TextEditingController();
  final TextEditingController _novaOutrasEspecialidadesController =
      TextEditingController();

  final TextEditingController _temaClinicoController = TextEditingController();
  final TextEditingController _chavePixController = TextEditingController();
  final TextEditingController _contaBancariaController =
      TextEditingController();
  final TextEditingController _agenciaController = TextEditingController();
  final TextEditingController _bancoController = TextEditingController();
  final TextEditingController _tipoContaController = TextEditingController();
  final List<Especialidade> _especialidades = [];
  final List<TemasClinicos> _temas = [];
  List<Abordagem> _abordagens = [];
  //List<Abordagem> _abordagemPrincipalSelecionada = [];
  List<Abordagem> _abordagensUtilizadasSelecionada = [];
  List<TemasClinicos> _temasClinicos = [];
  List<Especialidade> _especialidadesDisponiveis = [];
  String? cnpj;
  String? _genero;
  Abordagem? _abordagemSelecionada;
  Especialidade? _especialidadeSelecionada;
  // TemasClinicos? _temaClinicoSelecionado;
  final CadastroController _cadastroController = CadastroController();
  final AbordagemEspecialidadeTemasController
      _abordagemEspecialidadeController =
      AbordagemEspecialidadeTemasController();
  bool _loading = false;
  bool _showImagePicker = false;
  bool _showNovaAbordagemPrincipal = false;
  bool _showNovaAbordagemUtilizada = false;
  final bool _showNovaOutraEspecialidade = false;
  bool _showNovaEspecialidadePrincipal = false;
  bool _showTemasClinicos = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final List<Especialidade> _especialidadesSelecionadas = [];
  List<TemasClinicos> _temasClinicosSelecionados = [];

  // Adicione variáveis para armazenar os arquivos de certificado
  File? _certificadoEspecialidadePrincipal;
  File? _certificadoOutraEspecialidade;

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

  // Função para selecionar certificado
  Future<void> _pickCertificadoEspecialidadePrincipal() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _certificadoEspecialidadePrincipal = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarAbordagensEspecialidades();
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  Future<void> _carregarAbordagensEspecialidades() async {
    try {
      final abordagens =
          await _abordagemEspecialidadeController.buscarAbordagemPrincipal();
      final especialidades = await _abordagemEspecialidadeController
          .buscarEspecialidadePrincipal();
      final temasClinicos =
          await _abordagemEspecialidadeController.buscarTemasClinicos();
      setState(() {
        _abordagens = abordagens
            .map((a) => Abordagem(id: a.id, nome: capitalize(a.nome)))
            .toList();
        _especialidadesDisponiveis = especialidades
            .map((e) => Especialidade(id: e.id, nome: capitalize(e.nome)))
            .toList();
        _temasClinicos = temasClinicos
            .map((t) => TemasClinicos(id: t.id, nome: capitalize(t.nome)))
            .toList();
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
        title: const Text('Cadastro Psicólogo'),
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
            colors: [themeColor, blueColor],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Card(
                elevation: 8,
                color: const Color.fromARGB(170, 255, 255, 255),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo do app
                        Image.asset(
                          'assets/image/logotipoBlurt2.png',
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                        //const SizedBox(height: 16),
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
                          'Abordagem, Especialidade e Temas Clínicos',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),

                        // Campo Abordagem Principal
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: DropdownButtonFormField<Abordagem>(
                            value: _abordagemSelecionada,
                            isExpanded: true,
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
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text(
                                'Adicionar nova abordagem principal'),
                            onPressed: () => setState(() =>
                                _showNovaAbordagemPrincipal =
                                    !_showNovaAbordagemPrincipal),
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
                          height: _showNovaAbordagemPrincipal ? 70 : 0,
                          child: _showNovaAbordagemPrincipal
                              ? TextFormField(
                                  controller: _novaAbordagemPrincipalController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nova abordagem principal',
                                    prefixIcon: Icon(
                                      Icons.psychology_alt_outlined,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        // Campo de abordagens utilizadas
                        const SizedBox(height: 24),
                        InkWell(
                          onTap: () async {
                            await showMultiSelectDialog<Abordagem>(
                              context: context,
                              title: 'Selecione as abordagens utilizadas',
                              items: _abordagens,
                              selectedItems: _abordagensUtilizadasSelecionada,
                              itemLabel: (t) => t.nome,
                              onConfirm: (selecionados) {
                                setState(() {
                                  _abordagensUtilizadasSelecionada =
                                      selecionados;
                                });
                              },
                            );
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Abordagens Utilizadas',
                              prefixIcon: Icon(Icons.psychology_alt_outlined),
                            ),
                            child: Text(
                              _abordagensUtilizadasSelecionada.isEmpty
                                  ? 'Selecione as abordagens utilizadas'
                                  : _abordagensUtilizadasSelecionada
                                      .map((t) => t.nome)
                                      .join(', '),
                              style: TextStyle(
                                color: _abordagensUtilizadasSelecionada.isEmpty
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text(
                                'Adicionar nova abordagem utilizada'),
                            onPressed: () => setState(() =>
                                _showNovaAbordagemUtilizada =
                                    !_showNovaAbordagemUtilizada),
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
                          height: _showNovaAbordagemUtilizada ? 70 : 0,
                          child: _showNovaAbordagemUtilizada
                              ? TextFormField(
                                  controller: _novaAbordagemUtilizadaController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nova Abordagem utilizada',
                                    prefixIcon: Icon(Icons.star_outline),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        // Campo de Temas clínicos
                        const SizedBox(height: 24),
                        InkWell(
                          onTap: () async {
                            await showMultiSelectDialog<TemasClinicos>(
                              context: context,
                              title: 'Selecione os temas clínicos',
                              items: _temasClinicos,
                              selectedItems: _temasClinicosSelecionados,
                              itemLabel: (t) => t.nome,
                              onConfirm: (selecionados) {
                                setState(() {
                                  _temasClinicosSelecionados = selecionados;
                                });
                              },
                            );
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Temas Clínicos',
                              prefixIcon: Icon(Icons.psychology_alt_outlined),
                            ),
                            child: Text(
                              _temasClinicosSelecionados.isEmpty
                                  ? 'Selecione os temas clínicos'
                                  : _temasClinicosSelecionados
                                      .map((t) => t.nome)
                                      .join(', '),
                              style: TextStyle(
                                color: _temasClinicosSelecionados.isEmpty
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('Adicionar novo Tema Clínico'),
                            onPressed: () => setState(
                                () => _showTemasClinicos = !_showTemasClinicos),
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
                          height: _showTemasClinicos ? 70 : 0,
                          child: _showTemasClinicos
                              ? TextFormField(
                                  controller: _temaClinicoController,
                                  decoration: const InputDecoration(
                                    labelText: 'Novo Tema Clínico',
                                    prefixIcon: Icon(Icons.star_outline),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        // Campo de especialidade Principal
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<Especialidade>(
                                  value: _especialidadeSelecionada,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: 'Especialidade Principal*',
                                    prefixIcon:
                                        Icon(Icons.psychology_alt_outlined),
                                  ),
                                  items: _especialidadesDisponiveis
                                      .map((esp) => DropdownMenuItem(
                                            value: esp,
                                            child: Text(esp.nome),
                                          ))
                                      .toList(),
                                  onChanged: (value) => setState(
                                      () => _especialidadeSelecionada = value),
                                ),
                              ),
                              _especialidadeSelecionada == null
                                  ? const SizedBox.shrink()
                                  : IconButton(
                                      icon: Icon(Icons.clear),
                                      tooltip: 'Limpar seleção',
                                      onPressed: () {
                                        setState(() {
                                          _especialidadeSelecionada = null;
                                          _novaEspecialidadePrincipalController
                                              .clear();
                                          _certificadoEspecialidadePrincipal =
                                              null;
                                        });
                                      },
                                    ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('Adicionar nova especialidade'),
                            onPressed: () => setState(() =>
                                _showNovaEspecialidadePrincipal =
                                    !_showNovaEspecialidadePrincipal),
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
                          height: _showNovaEspecialidadePrincipal ? 70 : 0,
                          child: _showNovaEspecialidadePrincipal
                              ? TextFormField(
                                  controller:
                                      _novaEspecialidadePrincipalController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nova abordagem',
                                    prefixIcon: Icon(
                                      Icons.psychology_alt_outlined,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        if (_especialidadeSelecionada != null ||
                            _novaEspecialidadePrincipalController
                                .text.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.file_present,
                                  color: Colors.blueGrey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _certificadoEspecialidadePrincipal != null
                                      ? 'Certificado selecionado: ${_certificadoEspecialidadePrincipal!.path.split('/').last}'
                                      : 'Anexe o certificado da especialidade principal',
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.attach_file),
                                onPressed:
                                    _pickCertificadoEspecialidadePrincipal,
                                tooltip: 'Anexar certificado',
                              ),
                            ],
                          ),
                        ],

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
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    tooltip: 'Remover imagem',
                                    onPressed: () {
                                      setState(() {
                                        _selectedImage = null;
                                        _showImagePicker = false;
                                      });
                                    },
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
                                      // Validação dos certificados obrigatórios
                                      if (_showNovaEspecialidadePrincipal &&
                                          _novaEspecialidadePrincipalController
                                              .text.isNotEmpty &&
                                          _certificadoEspecialidadePrincipal ==
                                              null) {
                                        showSnackBar(
                                            'Anexe o certificado da nova especialidade principal!',
                                            backgroundColor: Colors.red);
                                        return;
                                      }
                                      if (_showNovaOutraEspecialidade &&
                                          _novaOutrasEspecialidadesController
                                              .text.isNotEmpty &&
                                          _certificadoOutraEspecialidade ==
                                              null) {
                                        showSnackBar(
                                            'Anexe o certificado da nova outra especialidade!',
                                            backgroundColor: Colors.red);
                                        return;
                                      }
                                      if (!_showImagePicker ||
                                          _selectedImage == null) {
                                        showSnackBar(
                                            'Selecione uma imagem para o perfil!',
                                            backgroundColor: Colors.red);
                                        return;
                                      }
                                      setState(() => _loading = true);
                                      try {
                                        // 1. abordagem principal
                                        String? abordagemPrincipal;
                                        if (_novaAbordagemPrincipalController
                                            .text.isNotEmpty) {
                                          abordagemPrincipal =
                                              _novaAbordagemPrincipalController
                                                  .text;
                                        } else {
                                          if (_abordagemSelecionada != null) {
                                            abordagemPrincipal =
                                                _abordagemSelecionada!.nome;
                                          }
                                        }

                                        // 1. Cadastro da abordagens utilizadas

                                        List<String> abordagensUtilizadasIds =
                                            [];
                                        if (_novaAbordagemUtilizadaController
                                            .text.isNotEmpty) {
                                          abordagensUtilizadasIds.add(
                                              _novaAbordagemUtilizadaController
                                                  .text);
                                          if (_abordagensUtilizadasSelecionada
                                                  .isNotEmpty &&
                                              _novaAbordagemUtilizadaController
                                                  .text.isNotEmpty) {
                                            abordagensUtilizadasIds.add(
                                                _abordagensUtilizadasSelecionada
                                                    .map((e) => e.nome)
                                                    .join(','));
                                            abordagensUtilizadasIds.add(
                                                _novaAbordagemUtilizadaController
                                                    .text);
                                          }
                                        } else {
                                          abordagensUtilizadasIds.add(
                                              _abordagensUtilizadasSelecionada
                                                  .map((e) => e.nome)
                                                  .join(','));
                                        }
                                        // 2. Cadastro da especialidade principal
                                        String? especialidadePrincipalId;
                                        if (_novaEspecialidadePrincipalController
                                            .text.isNotEmpty) {
                                          especialidadePrincipalId =
                                              _novaEspecialidadePrincipalController
                                                  .text;
                                        } else {
                                          if (_especialidadeSelecionada !=
                                              null) {
                                            especialidadePrincipalId =
                                                _especialidadeSelecionada!.nome;
                                          }
                                        }

                                        // 3. Cadastro dos temas clínicos
                                        List<String> temasClinicosIds = [];
                                        if (_temaClinicoController
                                            .text.isNotEmpty) {
                                          temasClinicosIds
                                              .add(_temaClinicoController.text);
                                        }
                                        if (_temasClinicosSelecionados
                                                .isNotEmpty &&
                                            _temaClinicoController
                                                .text.isNotEmpty) {
                                          temasClinicosIds.add(
                                              _temasClinicosSelecionados
                                                  .map((e) => e.nome)
                                                  .join(','));
                                          temasClinicosIds
                                              .add(_temaClinicoController.text);
                                        } else {
                                          temasClinicosIds.add(
                                              _temasClinicosSelecionados
                                                  .map((e) => e.nome)
                                                  .join(','));
                                        }

                                        if (_especialidadeSelecionada != null) {
                                          showSnackBar(
                                              'Anexe o certificado da especialidade principal!',
                                              backgroundColor: Colors.red);
                                          return;
                                        }

                                        String fotoBase64 = '';
                                        if (_selectedImage != null) {
                                          final bytes = await _selectedImage!
                                              .readAsBytes();
                                          fotoBase64 = base64Encode(bytes);
                                        }

                                        // Conversão para base64 do certificado da especialidade principal
                                        String certificadoEspPrincipalBase64 =
                                            '';
                                        if (_certificadoEspecialidadePrincipal !=
                                            null) {
                                          final bytes =
                                              await _certificadoEspecialidadePrincipal!
                                                  .readAsBytes();
                                          certificadoEspPrincipalBase64 =
                                              base64Encode(bytes);
                                        }

                                        // 4. Criação do objeto profissional
                                        final profissional = Professional(
                                            name: _nameController.text.trim(),
                                            email: _emailController.text.trim(),
                                            passwordHash:
                                                _passwordController.text,
                                            bio: _bioController.text.trim(),
                                            cpf: _cpfController.text.trim(),
                                            cnpj: _cnpjController.text.trim().isEmpty
                                                ? null
                                                : _cnpjController.text.trim(),
                                            crp: _registroProfissionalController.text
                                                .trim(),
                                            tipoProfissional: _genero == 'Masculino'
                                                ? 'Psicólogo'
                                                : 'Psicóloga',
                                            estaOnline: false,
                                            atendePlantao: false,
                                            valorConsulta:
                                                double.tryParse(_valorConsultaController.text.replaceAll(',', '.')) ??
                                                    0.0,
                                            genero: _genero ?? '',
                                            foto: fotoBase64,
                                            chavePix: _chavePixController.text.trim().isEmpty
                                                ? null
                                                : _chavePixController.text
                                                    .trim(),
                                            contaBancaria: _contaBancariaController.text.trim().isEmpty
                                                ? null
                                                : _contaBancariaController.text
                                                    .trim(),
                                            agencia: _agenciaController.text.trim().isEmpty
                                                ? null
                                                : _agenciaController.text
                                                    .trim(),
                                            banco: _bancoController.text.trim().isEmpty
                                                ? null
                                                : _bancoController.text.trim(),
                                            tipoConta: _tipoContaController.text.trim().isEmpty ? null : _tipoContaController.text.trim(),
                                            abordagemPrincipal: abordagemPrincipal,
                                            abordagensUtilizadas: abordagensUtilizadasIds,
                                            especialidadePrincipal: especialidadePrincipalId,
                                            temasClinicos: temasClinicosIds,
                                            certificadoEspecializacao: certificadoEspPrincipalBase64);
                                        final response =
                                            await _cadastroController
                                                .cadastrarProfissionalModel(
                                          profissional,
                                        );
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
                                        print(
                                            'Erro ao cadastrar: ${response.body}');
                                      } catch (e) {
                                        if (!mounted) return;
                                        print(e);
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

  Future<void> showMultiSelectDialog<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required List<T> selectedItems,
    required String Function(T) itemLabel,
    required void Function(List<T>) onConfirm,
  }) async {
    final tempSelected = List<T>.from(selectedItems);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (context, setStateDialog) {
                return ListView(
                  shrinkWrap: true,
                  children: items.map((item) {
                    return CheckboxListTile(
                      value: tempSelected.contains(item),
                      title: Text(itemLabel(item)),
                      onChanged: (checked) {
                        setStateDialog(() {
                          if (checked == true) {
                            tempSelected.add(item);
                          } else {
                            tempSelected.remove(item);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                onConfirm(List<T>.from(tempSelected));
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
