import 'dart:convert';

import 'package:blurt/controller/provider_controller.dart';
import 'package:blurt/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditarPerfilProfissionalScreen extends StatefulWidget {
  const EditarPerfilProfissionalScreen({super.key});

  @override
  State<EditarPerfilProfissionalScreen> createState() =>
      _EditarPerfilProfissionalScreenState();
}

class _EditarPerfilProfissionalScreenState
    extends State<EditarPerfilProfissionalScreen> {
  // Controladores de exemplo
  final _passwordController = TextEditingController();
  final _passwordConfController = TextEditingController();
  final _bioController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _diplomaPsicanalistaController = TextEditingController();
  final _declSupClinicaController = TextEditingController();
  final _declAnPessoalController = TextEditingController();
  final _tipoProfissionalController = TextEditingController();
  final _valorConsultaController = TextEditingController();
  final _chavePixController = TextEditingController();
  final _contaBancariaController = TextEditingController();
  final _agenciaController = TextEditingController();
  final _bancoController = TextEditingController();
  final _tipoContaController = TextEditingController();
  final _reportsController = TextEditingController();
  // Simulação de dados não editáveis
  final String nome = 'Fulano de Tal';
  final String email = 'fulano@email.com';
  final String cpf = '000.000.000-00';
  final String crp = '12/345678';
  final String genero = 'Masculino';
  final String abordagemPrincipal = 'TCC';
  final String profissional = 'Psicólogo';

  bool estaOnline = true;
  bool atendePlantao = false;
  String? especialidadePrincipal;
  List<String> abordagensUtilizadas = [];
  List<String> temasClinicos = [];
  // Simulação de foto
  String? fotoPerfil;
  // Simulação de certificados
  List<Map<String, String>> certificados = [];

  bool editandoSenha = false;
  bool editandoBio = false;
  bool editandoCnpj = false;
  bool editandoDiploma = false;
  bool editandoDeclSupClinica = false;
  bool editandoDeclAnPessoal = false;
  bool editandoTipoProfissional = false;
  bool editandoValorConsulta = false;
  bool editandoChavePix = false;
  bool editandoContaBancaria = false;
  bool editandoAgencia = false;
  bool editandoBanco = false;
  bool editandoTipoConta = false;
  bool editandoReports = false;
  bool editandoEspecialidadePrincipal = false;
  bool editandoAbordagensUtilizadas = false;
  bool editandoTemasClinicos = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderController>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil Profissional'),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppThemes.backgroundColor, AppThemes.primaryColor],
          )),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Theme.of(context).primaryColor,
                        backgroundImage: value.profissional?.foto != null
                            ? MemoryImage(
                                base64Decode(value.profissional!.foto))
                            : null,
                        child: value.profissional?.foto == null
                            ? const Icon(Icons.person, size: 48)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () {
                            // Implementar seleção de foto
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Align(
                    alignment: Alignment.center, child: Text('Dados Pessoais')),
                const SizedBox(height: 4.0),
                _buildInfoRow('Nome', value.profissional?.nome ?? '', null),
                _buildInfoRow('E-mail', value.profissional?.email ?? '', null),
                _buildEditableRow(
                    'Senha',
                    editandoSenha,
                    () => setState(() => editandoSenha = !editandoSenha),
                    editandoSenha
                        ? _buildPasswordField()
                        : const Text('********')),
                _buildEditableRow(
                    'Biografia',
                    value.profissional?.bio != null,
                    () => setState(() => editandoBio = !editandoBio),
                    editandoBio
                        ? _buildTextField('Biografia', _bioController,
                            maxLines: 2)
                        : Text(_bioController.text.isEmpty
                            ? 'Não informada'
                            : _bioController.text)),
                _buildInfoRow('CPF', value.profissional?.cpf ?? '', null),
                _buildEditableRow(
                    'CNPJ',
                    editandoCnpj,
                    () => setState(() => editandoCnpj = !editandoCnpj),
                    editandoCnpj
                        ? _buildTextField('CNPJ', _cnpjController)
                        : Text(_cnpjController.text.isEmpty
                            ? 'Não informado'
                            : _cnpjController.text)),
                _buildInfoRow(
                    'CRP', value.profissional?.crp ?? 'Não infomado', null),
                _buildInfoRow(
                    'Profissional',
                    value.profissional?.tipoProfissional ?? 'Não informado',
                    null),
                _buildEditableRow(
                  'Valor Consulta',
                  editandoValorConsulta,
                  () => setState(
                      () => editandoValorConsulta = !editandoValorConsulta),
                  editandoValorConsulta
                      ? _buildTextField(
                          'Valor Consulta', _valorConsultaController,
                          keyboardType: TextInputType.number)
                      : Text(value.profissional?.valorConsulta.toString() ??
                          'Não informado'),
                ),
                _buildInfoRow('Gênero',
                    value.profissional?.genero ?? 'Não informado', null),
                Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text('Métodos Clínicos',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                _buildInfoRow(
                    'Abordagem principal',
                    value.profissional?.abordagemPrincipal ?? 'Não informada',
                    null),
                _buildEditableRow(
                  'Abordagens utilizadas',
                  editandoAbordagensUtilizadas,
                  () => setState(() => editandoAbordagensUtilizadas =
                      !editandoAbordagensUtilizadas),
                  editandoAbordagensUtilizadas
                      ? _buildMultiSelectField(
                          'Temas clínicos',
                          value.profissional?.abordagensUtilizadas ??
                              ['Não informados'],
                          (list) => setState(() => temasClinicos = list))
                      : Text(
                          (value.profissional?.abordagensUtilizadas == null ||
                                  value.profissional!.abordagensUtilizadas!
                                      .isEmpty)
                              ? 'Não informados'
                              : value.profissional!.abordagensUtilizadas!
                                  .join(', '),
                        ),
                ),
                _buildInfoRow(
                    'Especialidade principal',
                    value.profissional?.especialidadePrincipal ??
                        'Não informada',
                    null),
                _buildEditableRow(
                  'Temas clínicos',
                  editandoTemasClinicos,
                  () => setState(
                      () => editandoTemasClinicos = !editandoTemasClinicos),
                  editandoTemasClinicos
                      ? _buildMultiSelectField(
                          'Temas clínicos',
                          value.profissional?.temasClinicos ??
                              ['Não informados'],
                          (list) => setState(() => temasClinicos = list))
                      : Text(
                          (value.profissional?.temasClinicos == null ||
                                  value.profissional!.temasClinicos!.isEmpty)
                              ? 'Não informados'
                              : value.profissional!.temasClinicos!.join(', '),
                        ),
                ),
                Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text('Dados Bancários',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                _buildEditableRow(
                    'Chave Pix',
                    editandoChavePix,
                    () => setState(() => editandoChavePix = !editandoChavePix),
                    editandoChavePix
                        ? _buildTextField('Chave Pix', _chavePixController)
                        : Text(_chavePixController.text.isEmpty
                            ? 'Não informada'
                            : _chavePixController.text)),
                _buildEditableRow(
                    'Conta Bancária',
                    editandoContaBancaria,
                    () => setState(
                        () => editandoContaBancaria = !editandoContaBancaria),
                    editandoContaBancaria
                        ? _buildTextField(
                            'Conta Bancária', _contaBancariaController)
                        : Text(_contaBancariaController.text.isEmpty
                            ? 'Não informada'
                            : _contaBancariaController.text)),
                _buildEditableRow(
                    'Agência',
                    editandoAgencia,
                    () => setState(() => editandoAgencia = !editandoAgencia),
                    editandoAgencia
                        ? _buildTextField('Agência', _agenciaController)
                        : Text(_agenciaController.text.isEmpty
                            ? 'Não informada'
                            : _agenciaController.text)),
                _buildEditableRow(
                    'Banco',
                    editandoBanco,
                    () => setState(() => editandoBanco = !editandoBanco),
                    editandoBanco
                        ? _buildTextField('Banco', _bancoController)
                        : Text(_bancoController.text.isEmpty
                            ? 'Não informado'
                            : _bancoController.text)),
                _buildEditableRow(
                    'Tipo de Conta',
                    editandoTipoConta,
                    () =>
                        setState(() => editandoTipoConta = !editandoTipoConta),
                    editandoTipoConta
                        ? _buildTextField('Tipo de Conta', _tipoContaController)
                        : Text(_tipoContaController.text.isEmpty
                            ? 'Não informada'
                            : _tipoContaController.text)),
                _buildEditableRow(
                    'Reports',
                    editandoReports,
                    () => setState(() => editandoReports = !editandoReports),
                    editandoReports
                        ? _buildTextField('Reports', _reportsController)
                        : Text(_reportsController.text.isEmpty
                            ? 'Não informado'
                            : _reportsController.text)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.file_present),
                  label: const Text('Gerenciar Certificados'),
                  onPressed: () {
                    // Implementar gerenciamento de certificados
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.backgroundColor,
                      foregroundColor: AppThemes.textLightColor,
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      // Salvar alterações
                      setState(() {
                        editandoSenha = false;
                        editandoBio = false;
                        editandoCnpj = false;
                        editandoDiploma = false;
                        editandoDeclSupClinica = false;
                        editandoDeclAnPessoal = false;
                        editandoTipoProfissional = false;
                        editandoValorConsulta = false;
                        editandoChavePix = false;
                        editandoContaBancaria = false;
                        editandoAgencia = false;
                        editandoBanco = false;
                        editandoTipoConta = false;
                        editandoReports = false;
                        editandoEspecialidadePrincipal = false;
                        editandoAbordagensUtilizadas = false;
                        editandoTemasClinicos = false;
                      });
                    },
                    child: const Text('Salvar Alterações'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildInfoRow(String label, String value, VoidCallback? onEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text(value.isEmpty ? 'Não informado' : value),
        ],
      ),
    );
  }

  Widget _buildEditableRow(
      String label, bool editando, VoidCallback onEdit, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          child,
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: onEdit,
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // Remove o padding do botão
                  minimumSize: Size(0, 0), // Remove restrição de tamanho mínimo
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: Colors.amber // Área de toque justa
                  ),
              child: Text(editando ? 'Cancelar' : 'Editar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        maxLines: maxLines,
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Nova Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordConfController,
              decoration: const InputDecoration(labelText: 'Confirmar Senha'),
              obscureText: true,
            ),
          ],
        ));
  }

  Widget _buildMultiSelectField(
      String label, List<String> values, ValueChanged<List<String>> onChanged) {
    // Exemplo de opções mockadas
    final opcoes = ['Opção 1', 'Opção 2', 'Opção 3'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Wrap(
          spacing: 8,
          children: opcoes.map((op) {
            final selecionado = values.contains(op);
            return FilterChip(
              label: Text(op),
              selected: selecionado,
              onSelected: (v) {
                final novaLista = List<String>.from(values);
                if (v) {
                  novaLista.add(op);
                } else {
                  novaLista.remove(op);
                }
                onChanged(novaLista);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
