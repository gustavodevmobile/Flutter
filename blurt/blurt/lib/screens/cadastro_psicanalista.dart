import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blurt/controller/abordagem_especialidade_controller.dart';
import '../controller/cadastro_controller.dart';
import '../models/professional.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PsicanalistaFormScreen extends StatefulWidget {
  const PsicanalistaFormScreen({super.key});

  @override
  State<PsicanalistaFormScreen> createState() => _PsicanalistaFormScreenState();
}

class _PsicanalistaFormScreenState extends State<PsicanalistaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
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
  final AbordagemEspecialidadeTemasController _abordagemEspecialidadeController =
      AbordagemEspecialidadeTemasController();

  String? _genero;
  final CadastroController _cadastroController = CadastroController();
  bool _loading = false;

  File? _diplomaPsicanalistaImage;
  File? _declSupClinicaImage;
  File? _declAnPessoalImage;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool showCheck = false;
  final List<String> _especialidadesDisponiveis = [];
  final List<String> _abordagens = [];
  String? _abordagemSelecionada;
  String? _especialidadeSelecionada;
  final bool _showNovaAbordagem = false;
  final bool _showNovaEspecialidade = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _carregarAbordagensEspecialidades();
  // }

  // Future<void> _carregarAbordagensEspecialidades() async {
  //   try {
  //     final abordagens =
  //         await _abordagemEspecialidadeController.buscarAbordagens();
  //     final especialidades =
  //         await _abordagemEspecialidadeController.buscarEspecialidades();
  //     setState(() {
  //       //_abordagens = abordagens;
  //       //_especialidadesDisponiveis = especialidades;
  //     });
  //   } catch (e) {
  //     showSnackBar('Erro ao carregar abordagens/especialidades',
  //         backgroundColor: Colors.red);
  //   }
  // }

  void showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  final cpfFormater = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final cnpjFormater = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

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
    final themeColor = const Color(0xFF7AB0A3);
    final blueColor = const Color(0xFF4F8FCB);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro Psicanalista'),
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
                            color: blueColor,
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
                          color: themeColor,
                          thickness: 2,
                        ),
                        // Text(
                        //   'Abordagem e Especialidade',
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.bold,
                        //     color: blueColor,
                        //   ),
                        // ),
                        // const SizedBox(height: 8),
                        // // Campo Abordagem Principal
                        // DropdownButtonFormField<String>(
                        //   value: _abordagemSelecionada,
                        //   decoration: const InputDecoration(
                        //     labelText: 'Abordagem Principal*',
                        //     prefixIcon: Icon(Icons.psychology_alt_outlined),
                        //   ),
                        //   items: _abordagens
                        //       .map((abord) => DropdownMenuItem(
                        //             value: abord,
                        //             child: Text(abord),
                        //           ))
                        //       .toList(),
                        //   onChanged: (value) =>
                        //       setState(() => _abordagemSelecionada = value),
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Abordagem obrigatória';
                        //     }
                        //     return null;
                        //   },
                        // ),

                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: TextButton.icon(
                        //     icon: const Icon(Icons.add_circle_outline),
                        //     label: const Text('Adicionar nova abordagem'),
                        //     onPressed: () => setState(
                        //         () => _showNovaAbordagem = !_showNovaAbordagem),
                        //     style: TextButton.styleFrom(
                        //       padding: EdgeInsets.symmetric(vertical: 4),
                        //       minimumSize: Size(0,
                        //           0), // opcional, para remover restrições mínimas
                        //       tapTargetSize: MaterialTapTargetSize
                        //           .shrinkWrap, // opcional, para reduzir área de toque
                        //     ),
                        //   ),
                        // ),
                        // AnimatedContainer(
                        //   duration: const Duration(milliseconds: 300),
                        //   curve: Curves.easeIn,
                        //   height: _showNovaAbordagem ? 70 : 0,
                        //   child: _showNovaAbordagem
                        //       ? Row(
                        //           key: const ValueKey('novaAbordagem'),
                        //           children: [
                        //             Expanded(
                        //               child: TextFormField(
                        //                 controller: _abordagemController,
                        //                 decoration: const InputDecoration(
                        //                   labelText: 'Nova abordagem',
                        //                   prefixIcon: Icon(
                        //                     Icons.psychology_alt_outlined,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         )
                        //       : const SizedBox.shrink(),
                        // ),
                        // const SizedBox(height: 8),
                        // // Campo Especialidade (adiciona à lista)
                        // DropdownButtonFormField<String>(
                        //   value: _especialidadeSelecionada,
                        //   decoration: const InputDecoration(
                        //     labelText: 'Especialidade(s)',
                        //     prefixIcon: Icon(Icons.star_outline),
                        //   ),
                        //   items: _especialidadesDisponiveis
                        //       .map((esp) => DropdownMenuItem(
                        //             value: esp,
                        //             child: Text(esp),
                        //           ))
                        //       .toList(),
                        //   onChanged: (value) =>
                        //       setState(() => _especialidadeSelecionada = value),
                        // ),
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: TextButton.icon(
                        //     icon: const Icon(Icons.add_circle_outline),
                        //     label: const Text('Adicionar nova especialidade'),
                        //     onPressed: () => setState(() =>
                        //         _showNovaEspecialidade =
                        //             !_showNovaEspecialidade),
                        //     style: TextButton.styleFrom(
                        //       padding: EdgeInsets.symmetric(vertical: 4),
                        //       minimumSize: Size(0,
                        //           0), // opcional, para remover restrições mínimas
                        //       tapTargetSize: MaterialTapTargetSize
                        //           .shrinkWrap, // opcional, para reduzir área de toque
                        //     ),
                        //   ),
                        // ),
                        // AnimatedContainer(
                        //   duration: const Duration(milliseconds: 300),
                        //   curve: Curves.easeIn,
                        //   height: _showNovaEspecialidade ? 70 : 0,
                        //   child: _showNovaEspecialidade
                        //       ? Row(
                        //           key: const ValueKey('novaEspecialidade'),
                        //           children: [
                        //             Expanded(
                        //               child: TextFormField(
                        //                 controller: _especialidadeController,
                        //                 decoration: const InputDecoration(
                        //                   labelText: 'Nova especialidade',
                        //                   prefixIcon: Icon(Icons.star_outline),
                        //                 ),
                        //               ),
                        //             ),
                        //             IconButton(
                        //               icon: const Icon(Icons.add),
                        //               tooltip: 'Adicionar Especialidade',
                        //               onPressed: () {
                        //                 FocusScope.of(context).unfocus();
                        //                 final text =
                        //                     _especialidadeController.text;
                        //                 if (text.isNotEmpty &&
                        //                     !_especialidades.contains(text)) {
                        //                   setState(() {
                        //                     _especialidades.add(text);
                        //                     _especialidadeSelecionada = null;
                        //                   });
                        //                 }
                        //                 _especialidadeController.clear();
                        //               },
                        //             ),
                        //           ],
                        //         )
                        //       : const SizedBox.shrink(),
                        // ),
                        // // Lista de especialidades adicionadas
                        // if (_especialidades.isNotEmpty)
                        //   Text('Especialidades adicionadas:',
                        //       style: TextStyle(fontSize: 16, color: blueColor)),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: _especialidades
                        //       .map((esp) => Row(
                        //             children: [
                        //               const Icon(Icons.check,
                        //                   color: Colors.green, size: 20),
                        //               const SizedBox(width: 6),
                        //               Expanded(child: Text(esp)),
                        //               IconButton(
                        //                 icon: const Icon(Icons.close,
                        //                     color: Colors.red, size: 20),
                        //                 tooltip: 'Remover',
                        //                 onPressed: () {
                        //                   setState(() {
                        //                     _especialidades.remove(esp);
                        //                   });
                        //                 },
                        //               ),
                        //             ],
                        //           ))
                        //       .toList(),
                        // ),
                        const SizedBox(height: 16),
                        // Campo obrigatório de imagem de perfil
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Foto de Perfil*',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _profileImage != null
                                ? CircleAvatar(
                                    radius: 32,
                                    backgroundImage: FileImage(_profileImage!))
                                : const CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Color(0xFFE0E0E0),
                                    child:
                                        Icon(Icons.person, color: Colors.grey)),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.photo_library),
                              tooltip: 'Selecionar da galeria',
                              onPressed: () => _pickImage(ImageSource.gallery,
                                  (file) => _profileImage = file),
                            ),
                            IconButton(
                              icon: const Icon(Icons.camera_alt),
                              tooltip: 'Tirar foto',
                              onPressed: () => _pickImage(ImageSource.camera,
                                  (file) => _profileImage = file),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Diploma Psicanalista

                        _buildImagePickerField(
                          label: 'Diploma de Psicanalista*',
                          image: _diplomaPsicanalistaImage,
                          onPick: (source) => _pickImage(source,
                              (file) => _diplomaPsicanalistaImage = file),
                          showCheck: true,
                        ),
                        const SizedBox(height: 16),
                        // Declaração Sup. Clínica
                        _buildImagePickerField(
                          label: 'Declaração Supervisão Clínica*',
                          image: _declSupClinicaImage,
                          onPick: (source) => _pickImage(
                              source, (file) => _declSupClinicaImage = file),
                          showCheck: true,
                        ),
                        const SizedBox(height: 16),
                        // Declaração Análise Pessoal
                        _buildImagePickerField(
                          label: 'Declaração Análise Pessoal*',
                          image: _declAnPessoalImage,
                          onPick: (source) => _pickImage(
                              source, (file) => _declAnPessoalImage = file),
                          showCheck: true,
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
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState!.validate()) {
                                      if (_profileImage == null) {
                                        showSnackBar(
                                            'Selecione uma foto de perfil!',
                                            backgroundColor: Colors.red);
                                        return;
                                      }
                                      if (_diplomaPsicanalistaImage == null ||
                                          _declSupClinicaImage == null ||
                                          _declAnPessoalImage == null) {
                                        showSnackBar(
                                            'As declarações são obrigatórias!',
                                            backgroundColor: Colors.red);
                                        return;
                                      }
                                      setState(() => _loading = true);
                                      print('_passwordController.text');
                                      print(_valorConsultaController.text);
                                      try {
                                        String fotoBase64 = '';
                                        String diplomaBase64 = '';
                                        String declSupClinicaBase64 = '';
                                        String declAnPessoalBase64 = '';
                                        if (_profileImage != null) {
                                          final bytes = await _profileImage!
                                              .readAsBytes();
                                          fotoBase64 = base64Encode(bytes);
                                        }

                                        if (_diplomaPsicanalistaImage != null) {
                                          final bytes =
                                              await _diplomaPsicanalistaImage!
                                                  .readAsBytes();
                                          diplomaBase64 = base64Encode(bytes);
                                        }
                                        if (_declSupClinicaImage != null) {
                                          final bytes =
                                              await _declSupClinicaImage!
                                                  .readAsBytes();
                                          declSupClinicaBase64 =
                                              base64Encode(bytes);
                                        }
                                        if (_declAnPessoalImage != null) {
                                          final bytes =
                                              await _declAnPessoalImage!
                                                  .readAsBytes();
                                          declAnPessoalBase64 =
                                              base64Encode(bytes);
                                        }
                                        // Cadastra a abordagem

                                        // Cadastra o profissional
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
                                          crp: null,
                                          diplomaPsicanalista: diplomaBase64,
                                          declSupClinica: declSupClinicaBase64,
                                          declAnPessoal: declAnPessoalBase64,
                                          tipoProfissional: 'Psicanalista',
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
                                        // final response =
                                        //     await _cadastroController
                                        //         .cadastrarProfissionalModel(
                                        //             profissional);
                                        // if (!mounted) return;
                                        // if (response.statusCode == 200 ||
                                        //     response.statusCode == 201) {
                                        //   showSnackBar(
                                        //       'Psicanalista cadastrado com sucesso!',
                                        //       backgroundColor: Colors.green);

                                          
                                        // } else {
                                        //   showSnackBar(
                                        //       'Erro ao cadastrar: \n${response.body}',
                                        //       backgroundColor: Colors.red);
                                        // }
                                      } catch (e) {
                                        if (!mounted) return;
                                        showSnackBar('Erro de conexão: $e',
                                            backgroundColor: Colors.red);
                                        print(e);
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

  Widget _buildImagePickerField({
    required String label,
    required File? image,
    required void Function(ImageSource) onPick,
    bool showCheck = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
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
            const SizedBox(width: 16),
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
          ],
        ),
      ],
    );
  }
}
