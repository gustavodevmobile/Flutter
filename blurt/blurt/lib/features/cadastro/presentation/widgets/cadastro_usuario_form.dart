import 'package:blurt/core/utils/formatters.dart';
import 'package:blurt/core/utils/global_snackbars.dart';
import 'package:blurt/core/utils/state_city_dropdown.dart';
import 'package:blurt/features/cadastro/presentation/controllers/cadastro_usuario_controller.dart';
import 'package:blurt/models/usuario/usuario.dart';
import 'package:blurt/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CadastroUsuarioForm extends StatefulWidget {
  const CadastroUsuarioForm({super.key});

  @override
  State<CadastroUsuarioForm> createState() => _CadastroUsuarioFormState();
}

class _CadastroUsuarioFormState extends State<CadastroUsuarioForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  String? _gender;
  bool _loading = false;
  String? _estadoSelecionado;
  String? _cidadeSelecionada;

  @override
  Widget build(BuildContext context) {
    return Consumer<CadastroUsuarioController>(
        builder: (context, controllerUsuario, child) {
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

            Text(
              'Crie sua conta',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppThemes.secondaryColor,
              ),
            ),
            const SizedBox(height: 24),
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
            StateCityDropdown(onSelectionChanged: (estado, cidade) {
              setState(() {
                _estadoSelecionado = estado;
                _cidadeSelecionada = cidade;
              });
            }),
            const SizedBox(height: 16),
            // Campo Data de Nascimento
            TextFormField(
              controller: _dataNascimentoController,
              inputFormatters: [Formatters.dataNascimentoFormatter],
              decoration: const InputDecoration(
                labelText: 'Data de Nascimento*',
                prefixIcon: Icon(Icons.cake_outlined),
                hintText: 'dd/mm/aaaa*',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Data de nascimento obrigatória';
                }
                final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                if (!regex.hasMatch(value)) {
                  return 'Formato inválido (ex:(dd/mm/aaaa)';
                }
                // Verifica se é maior de idade
                if (!Formatters.isMaiorDeIdade(value)) {
                  return 'É necessário ter 18 anos ou mais';
                }
                return null;
              },
              keyboardType: TextInputType.datetime,
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
              controller: _telefoneController,
              inputFormatters: [Formatters.telefoneFormatter],
              decoration: const InputDecoration(
                labelText: 'Telefone (opcional)',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.number,
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
              controller: _cpfController,
              inputFormatters: [Formatters.cpfFormater],
              decoration: const InputDecoration(
                labelText: 'CPF*',
                prefixIcon: Icon(Icons.badge_outlined),
                hintText: '000.000.000-00*',
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
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: const InputDecoration(
                labelText: 'Gênero*',
                prefixIcon: Icon(Icons.transgender),
              ),
              items: const [
                DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                DropdownMenuItem(value: 'Feminino', child: Text('Feminino')),
                DropdownMenuItem(
                    value: 'Não-binário', child: Text('Não-binário')),
                DropdownMenuItem(
                    value: 'Homem trans', child: Text('Homem trans')),
                DropdownMenuItem(
                    value: 'Mulher trans', child: Text('Mulher trans')),
                DropdownMenuItem(value: 'Agênero', child: Text('Agênero')),
                DropdownMenuItem(
                    value: 'Gênero fluido', child: Text('Gênero fluido')),
                DropdownMenuItem(value: 'Bigênero', child: Text('Bigênero')),
                DropdownMenuItem(
                    value: 'Prefiro não informar',
                    child: Text('Prefiro não informar')),
                DropdownMenuItem(value: 'Outro', child: Text('Outro')),
              ],
              onChanged: (value) => setState(() => _gender = value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecione o gênero';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _loading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _loading = true);

                          final usuario = Usuario(
                            nome: _nameController.text.trim(),
                            estado: _estadoSelecionado ?? '',
                            cidade: _cidadeSelecionada ?? '',
                            dataNascimento: Formatters.parseData(
                                _dataNascimentoController.text.trim()),
                            email: _emailController.text.trim(),
                            telefone: _telefoneController.text.trim(),
                            senha: _passwordController.text,
                            cpf: _cpfController.text.trim(),
                            genero: _gender ?? '',
                          );
                          print('Usuário a ser cadastrado: ${usuario.cidade}');

                          try {
                            final result = await controllerUsuario
                                .cadastrarUsuario(usuario);
                            if (result.isNotEmpty) {
                              if (context.mounted) {
                                GlobalSnackbars.showSnackBar(result,
                                    backgroundColor: Colors.green);
                              }
                            }
                          } catch (error) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(error.toString()),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } finally {
                            setState(() => _loading = false);
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
}
