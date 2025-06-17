import 'dart:io';
import 'package:blurt/core/utils/formatters.dart';
import 'package:blurt/core/utils/global_snackbars.dart';
import 'package:blurt/core/utils/state_city_dropdown.dart';
import 'package:blurt/core/utils/validators.dart';
import 'package:blurt/features/abordagem_principal/presentation/abordagem_principal_controller.dart';
import 'package:blurt/features/abordagens_utilizadas/presentation/abordagens_utilizadas_controller.dart';
import 'package:blurt/features/cadastro/presentation/controllers/cadastro_profissional_controller.dart';
import 'package:blurt/features/especialidade_principal/presentation/especialidade_principal_controller.dart';
import 'package:blurt/features/temas_clinicos/presentation/temas_clinicos_controller.dart';
import 'package:blurt/models/abordagem_principal/aboradagem_principal.dart';
import 'package:blurt/models/abordagens_utilizadas/abordagens_utilizadas.dart';
import 'package:blurt/models/especialidade_principal/especialidade_principal.dart';
import 'package:blurt/models/temas_clinicos/temas_clinicos_models.dart';
import 'package:blurt/theme/themes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CadastroPsicologoForm extends StatefulWidget {
  const CadastroPsicologoForm({super.key});

  @override
  State<CadastroPsicologoForm> createState() => _CadastroPsicologoFormState();
}

class _CadastroPsicologoFormState extends State<CadastroPsicologoForm> {
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

  final TextEditingController _temaClinicoController = TextEditingController();
  final TextEditingController _chavePixController = TextEditingController();
  final TextEditingController _contaBancariaController =
      TextEditingController();
  final TextEditingController _agenciaController = TextEditingController();
  final TextEditingController _bancoController = TextEditingController();
  final TextEditingController _tipoContaController = TextEditingController();

  List<AbordagensUtilizadas> _abordagensUtilizadasSelecionada = [];
  //List<TemasClinicos> _temasClinicos = [];
  //final List<EspecialidadePrincipal> _especialidadesDisponiveis = [];
  String? cnpj;
  String? _genero;
  String? _estadoSelecionado;
  String? _cidadeSelecionada;
  AbordagemPrincipal? _abordagemSelecionada;
  EspecialidadePrincipal? _especialidadeSelecionada;
  bool _loading = false;
  bool _showImagePicker = false;
  bool _showImageDoc = false;
  bool _showImageSelfieComDoc = false;
  bool _showNovaAbordagemPrincipal = false;
  bool _showNovaAbordagemUtilizada = false;
  bool _showEspecialidadePrincipal = false;
  bool _showCertificadoEspecialidade = false;
  bool _showTemasClinicos = false;
  File? _selectedImage;
  File? _selectedImageDoc;
  File? _selectedImageSelfieComDoc;
  final ImagePicker _picker = ImagePicker();
  List<TemasClinicos> _temasClinicosSelecionados = [];
  File? _certificadoEspecialidadePrincipal;

  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
  }

  void _carregarDadosIniciais() {
    Future.microtask(() =>
        Provider.of<AbordagemPrincipalController>(context, listen: false)
            .buscarAbordagensPrincipais());

    Future.microtask(() =>
        Provider.of<AbordagensUtilizadasController>(context, listen: false)
            .buscarAbordagensUtilizadas());

    Future.microtask(() =>
        Provider.of<EspecialidadePrincipalController>(context, listen: false)
            .buscarEspecialidadesPrincipais());
    Future.microtask(() =>
        Provider.of<TemasClinicosController>(context, listen: false)
            .buscarTemasClinicos());
  }

  Future<void> _pickImage(ImageSource source, String tipo) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        if (tipo == 'perfil') {
          _selectedImage = File(pickedFile.path);
        } else if (tipo == 'doc') {
          _selectedImageDoc = File(pickedFile.path);
        } else if (tipo == 'selfie') {
          _selectedImageSelfieComDoc = File(pickedFile.path);
        }
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

  // Adicione variáveis para armazenar os arquivos de certificado

  @override
  Widget build(BuildContext context) {
    return Consumer5<
            CadastroProfissionalController,
            AbordagemPrincipalController,
            EspecialidadePrincipalController,
            TemasClinicosController,
            AbordagensUtilizadasController>(
        builder: (context,
            controllerCadastro,
            controllerAbordagens,
            controllerEspecialidades,
            controllerTemas,
            controllerAbordagensUtiliadas,
            child) {
      return Form(
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
                color: AppThemes.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Dados Pessoais',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppThemes.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            // Campo Nome
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome*',
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
            // Campo Estado e Cidade
            StateCityDropdown(
              onSelectionChanged: (estado, cidade) {
                setState(() {
                  _estadoSelecionado = estado;
                  _cidadeSelecionada = cidade;
                });
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
                final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}");
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
                DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                DropdownMenuItem(value: 'Feminino', child: Text('Feminino')),
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
            Text(
              'Documentos Pessoais',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppThemes.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            // Campo CPF
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
                final cpfValidator = Validators.isCpf(value);
                if (!cpfValidator) {
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
            // Campo Registro Profissional
            TextFormField(
              controller: _registroProfissionalController,
              inputFormatters: [Formatters.crpFormater],
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
              color: AppThemes.secondaryColor,
              thickness: 2,
            ),
            Text(
              'Abordagem, Especialidade e Temas Clínicos',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppThemes.primaryColor,
              ),
            ),

            // Campo Abordagem Principal
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: DropdownButtonFormField<AbordagemPrincipal>(
                value: _abordagemSelecionada,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Abordagem Principal*',
                  prefixIcon: Icon(Icons.psychology_alt_outlined),
                ),
                items: controllerAbordagens.abordagensPrincipais
                    .map((abord) => DropdownMenuItem<AbordagemPrincipal>(
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
                icon: _showNovaAbordagemPrincipal
                    ? const Icon(Icons.remove_circle_outline)
                    : const Icon(Icons.add_circle_outline),
                label: const Text('Nova abordagem principal'),
                onPressed: () => setState(() =>
                    _showNovaAbordagemPrincipal = !_showNovaAbordagemPrincipal),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  minimumSize:
                      Size(0, 0), // opcional, para remover restrições mínimas
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
                await showMultiSelectDialog<AbordagensUtilizadas>(
                  context: context,
                  title: 'Selecione as abordagens utilizadas',
                  items: controllerAbordagensUtiliadas.abordagensUtilizadas,
                  selectedItems: _abordagensUtilizadasSelecionada,
                  itemLabel: (t) => t.nome,
                  onConfirm: (selecionados) {
                    setState(() {
                      _abordagensUtilizadasSelecionada = selecionados;
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
                icon: _showNovaAbordagemUtilizada
                    ? const Icon(Icons.remove_circle_outline)
                    : const Icon(Icons.add_circle_outline),
                label: const Text('Nova abordagem utilizada'),
                onPressed: () => setState(() =>
                    _showNovaAbordagemUtilizada = !_showNovaAbordagemUtilizada),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  minimumSize:
                      Size(0, 0), // opcional, para remover restrições mínimas
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
                await showMultiSelectDialog(
                  context: context,
                  title: 'Selecione os temas clínicos',
                  items: controllerTemas.temasClinicos,
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
                icon: _showTemasClinicos
                    ? const Icon(Icons.remove_circle_outline)
                    : const Icon(Icons.add_circle_outline),
                label: const Text('Novo tema clínico'),
                onPressed: () =>
                    setState(() => _showTemasClinicos = !_showTemasClinicos),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  minimumSize:
                      Size(0, 0), // opcional, para remover restrições mínimas
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
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<EspecialidadePrincipal>(
                      value: _especialidadeSelecionada,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Especialidade Principal',
                        prefixIcon: Icon(Icons.psychology_alt_outlined),
                      ),
                      items: controllerEspecialidades.especialidadesPrincipais
                          .map((esp) => DropdownMenuItem(
                                value: esp,
                                child: Text(esp.nome),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _especialidadeSelecionada = value),
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
                              _novaEspecialidadePrincipalController.clear();
                              _certificadoEspecialidadePrincipal = null;
                            });
                          },
                        ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: _showEspecialidadePrincipal
                    ? const Icon(Icons.remove_circle_outline)
                    : const Icon(Icons.add_circle_outline),
                label: const Text('Nova especialidade'),
                onPressed: () {
                  setState(() {
                    _showEspecialidadePrincipal = !_showEspecialidadePrincipal;
                    if (!_showEspecialidadePrincipal) {
                      _showCertificadoEspecialidade = false;
                    }
                  });
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  minimumSize:
                      Size(0, 0), // opcional, para remover restrições mínimas
                  tapTargetSize: MaterialTapTargetSize
                      .shrinkWrap, // opcional, para reduzir área de toque
                ),
              ),
            ),
            ClipRect(
              child: AnimatedAlign(
                alignment: Alignment.center,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                heightFactor: _showEspecialidadePrincipal ? 1 : 0,
                child: _showEspecialidadePrincipal
                    ? TextFormField(
                        controller: _novaEspecialidadePrincipalController,
                        decoration: const InputDecoration(
                          labelText: 'Nova especialidade principal',
                          prefixIcon: Icon(
                            Icons.psychology_alt_outlined,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _showCertificadoEspecialidade = true;
                          });
                        },
                      )
                    : const SizedBox.shrink(),
              ),
            ),

            _showCertificadoEspecialidade || _especialidadeSelecionada != null
                ? Row(
                    children: [
                      const Icon(Icons.file_present, color: Colors.blueGrey),
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
                        onPressed: _pickCertificadoEspecialidadePrincipal,
                        tooltip: 'Anexar certificado',
                      ),
                    ],
                  )
                : const SizedBox.shrink(),

            const SizedBox(height: 16),
            Divider(
              color: AppThemes.secondaryColor,
              thickness: 1,
            ),
            Text(
              'Dados Bancários (opcional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppThemes.primaryColor,
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
                Icon(Icons.image, color: AppThemes.secondaryColor),
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
                          backgroundImage: FileImage(_selectedImage!),
                        )
                      : const CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xFFE0E0E0),
                          child:
                              Icon(Icons.person, size: 40, color: Colors.grey),
                        ),
                  //const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.photo_library,
                            color: AppThemes.secondaryColor),
                        tooltip: 'Selecionar da galeria',
                        onPressed: () =>
                            _pickImage(ImageSource.gallery, 'perfil'),
                      ),
                      IconButton(
                        icon: Icon(Icons.camera_alt,
                            color: AppThemes.primaryColor),
                        tooltip: 'Tirar foto',
                        onPressed: () =>
                            _pickImage(ImageSource.camera, 'perfil'),
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
            Row(
              children: [
                Icon(Icons.image, color: AppThemes.secondaryColor),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _showImageDoc = !_showImageDoc;
                      });
                    },
                    child: Text(_showImageDoc
                        ? 'Ocultar imagem'
                        : 'Enviar documento com foto*'),
                  ),
                ),
              ],
            ),
            if (_showImageDoc)
              Column(
                children: [
                  _selectedImageDoc != null
                      ? CircleAvatar(
                          radius: 40,
                          backgroundImage: FileImage(_selectedImageDoc!),
                        )
                      : const CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xFFE0E0E0),
                          child:
                              Icon(Icons.person, size: 40, color: Colors.grey),
                        ),
                  //const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.photo_library,
                            color: AppThemes.secondaryColor),
                        tooltip: 'Selecionar da galeria',
                        onPressed: () => _pickImage(ImageSource.gallery, 'doc'),
                      ),
                      IconButton(
                        icon: Icon(Icons.camera_alt,
                            color: AppThemes.primaryColor),
                        tooltip: 'Tirar foto',
                        onPressed: () => _pickImage(ImageSource.camera, 'doc'),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Remover imagem',
                        onPressed: () {
                          setState(() {
                            _selectedImageDoc = null;
                            _showImageDoc = false;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            Row(
              children: [
                Icon(Icons.image, color: AppThemes.secondaryColor),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _showImageSelfieComDoc = !_showImageSelfieComDoc;
                      });
                    },
                    child: Text(_showImageSelfieComDoc
                        ? 'Ocultar imagem'
                        : 'Enviar selfie com documento*'),
                  ),
                ),
              ],
            ),
            if (_showImageSelfieComDoc)
              Column(
                children: [
                  _selectedImageSelfieComDoc != null
                      ? CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              FileImage(_selectedImageSelfieComDoc!),
                        )
                      : const CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xFFE0E0E0),
                          child:
                              Icon(Icons.person, size: 40, color: Colors.grey),
                        ),
                  //const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.photo_library,
                            color: AppThemes.secondaryColor),
                        tooltip: 'Selecionar da galeria',
                        onPressed: () =>
                            _pickImage(ImageSource.gallery, 'selfie'),
                      ),
                      IconButton(
                        icon: Icon(Icons.camera_alt,
                            color: AppThemes.primaryColor),
                        tooltip: 'Tirar foto',
                        onPressed: () =>
                            _pickImage(ImageSource.camera, 'selfie'),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Remover imagem',
                        onPressed: () {
                          setState(() {
                            _selectedImageSelfieComDoc = null;
                            _showImageSelfieComDoc = false;
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
                        if (_formKey.currentState!.validate()) {
                          // Validação dos certificados obrigatórios
                          if (_showEspecialidadePrincipal &&
                              _novaEspecialidadePrincipalController
                                  .text.isNotEmpty &&
                              _certificadoEspecialidadePrincipal == null) {
                            GlobalSnackbars.showSnackBar(
                                'Anexe o certificado especialidade principal!',
                                backgroundColor: Colors.red);
                            return;
                          }
                          if (_especialidadeSelecionada != null) {
                            GlobalSnackbars.showSnackBar(
                                'Anexe o certificado da especialidade principal!',
                                backgroundColor: Colors.red);
                            return;
                          }

                          if (!_showImagePicker || _selectedImage == null) {
                            GlobalSnackbars.showSnackBar(
                                'Selecione ou tire uma foto para o perfil!',
                                backgroundColor: Colors.red);
                            return;
                          }
                          if (!_showImageDoc || _selectedImageDoc == null) {
                            GlobalSnackbars.showSnackBar(
                                'Documento com foto é obrigatória!',
                                backgroundColor: Colors.red);
                            return;
                          }
                          if (!_showImageSelfieComDoc ||
                              _selectedImageSelfieComDoc == null) {
                            GlobalSnackbars.showSnackBar(
                                'Selfie com documento com foto é obrigatória!',
                                backgroundColor: Colors.red);
                            return;
                          }
                          setState(() => _loading = true);

                          // 1. abordagem principal
                          String? abordagemPrincipal;
                          if (_novaAbordagemPrincipalController
                              .text.isNotEmpty) {
                            abordagemPrincipal =
                                _novaAbordagemPrincipalController.text;
                          } else {
                            if (_abordagemSelecionada != null) {
                              abordagemPrincipal = _abordagemSelecionada!.nome;
                            }
                          }

                          // 1. Cadastro da abordagens utilizadas
                          List<String> abordagensUtilizadasIds = [];
                          if (_novaAbordagemUtilizadaController
                              .text.isNotEmpty) {
                            abordagensUtilizadasIds
                                .add(_novaAbordagemUtilizadaController.text);
                            if (_abordagensUtilizadasSelecionada.isNotEmpty &&
                                _novaAbordagemUtilizadaController
                                    .text.isNotEmpty) {
                              abordagensUtilizadasIds.add(
                                  _abordagensUtilizadasSelecionada
                                      .map((e) => e.nome)
                                      .join(','));
                              abordagensUtilizadasIds
                                  .add(_novaAbordagemUtilizadaController.text);
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
                                _novaEspecialidadePrincipalController.text;
                          } else {
                            if (_especialidadeSelecionada != null) {
                              especialidadePrincipalId =
                                  _especialidadeSelecionada!.nome;
                            }
                          }

                          // 3. Cadastro dos temas clínicos
                          List<String> temasClinicosIds = [];
                          if (_temaClinicoController.text.isNotEmpty) {
                            temasClinicosIds.add(_temaClinicoController.text);
                          }
                          if (_temasClinicosSelecionados.isNotEmpty &&
                              _temaClinicoController.text.isNotEmpty) {
                            temasClinicosIds.add(_temasClinicosSelecionados
                                .map((e) => e.nome)
                                .join(','));
                            temasClinicosIds.add(_temaClinicoController.text);
                          } else {
                            temasClinicosIds.add(_temasClinicosSelecionados
                                .map((e) => e.nome)
                                .join(','));
                          }
                          String? tokenFcm =
                              await FirebaseMessaging.instance.getToken();
                          print('Token FCM gerado: $tokenFcm');

                          final profissional = {
                            'tokenFcm': tokenFcm,
                            'nome': _nameController.text.trim(),
                            'estado': _estadoSelecionado,
                            'cidade': _cidadeSelecionada,
                            'email': _emailController.text.trim(),
                            'senha': _passwordController.text,
                            'bio': _bioController.text.trim(),
                            'cpf': _cpfController.text.trim(),
                            'cnpj': _cnpjController.text.trim(),
                            'crp': _registroProfissionalController.text.trim(),
                            'tipoProfissional': 'Psicólogo',
                            'estaOnline': false,
                            'atendePlantao': false,
                            'emAtendimento': false,
                            'logado': false,
                            'valorConsulta':
                                double.parse(_valorConsultaController.text),
                            'genero': _genero,
                            'foto': _selectedImage,
                            'imagemDocumento': _selectedImageDoc,
                            'imagemSelfieComDoc': _selectedImageSelfieComDoc,
                            'chavePix': _chavePixController.text.trim(),
                            'contaBancaria':
                                _contaBancariaController.text.trim(),
                            'agencia': _agenciaController.text.trim(),
                            'banco': _bancoController.text.trim(),
                            'tipoConta': _tipoContaController.text.trim(),
                            'abordagemPrincipal': abordagemPrincipal,
                            'abordagensUtilizadas': abordagensUtilizadasIds,
                            'especialidadePrincipal': especialidadePrincipalId,
                            'temasClinicos': temasClinicosIds,
                            'certificadoEspecializacao':
                                _certificadoEspecialidadePrincipal
                          };
                          //print('Profissional: $profissional');
                          try {
                            final result = await controllerCadastro
                                .cadastrarProfissional(profissional);
                            if (result.isNotEmpty) {
                              setState(() {
                                _loading = false;
                              });
                              if (context.mounted) {
                                GlobalSnackbars.showSnackBar(result,
                                    backgroundColor: Colors.green);
                              }
                            }
                          } catch (e) {
                            setState(() {
                              _loading = false;
                            });
                            print('Erro ao cadastrar profissional: $e');
                            if (context.mounted) {
                              GlobalSnackbars.showSnackBar(e.toString(),
                                  backgroundColor: Colors.red);
                            }
                          }
                        }
                      },
                child: _loading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: AppThemes.primaryColor,
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
