import 'package:flutter/material.dart';
import '../controller/cadastro_controller.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UsuarioFormScreen extends StatefulWidget {
  const UsuarioFormScreen({super.key});

  @override
  State<UsuarioFormScreen> createState() => _UsuarioFormScreenState();
}

class _UsuarioFormScreenState extends State<UsuarioFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  String? _gender;
  final CadastroController _cadastroController = CadastroController();
  bool _loading = false;

  void showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  final _dataNascimentoFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final cpfFormater = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  bool isMaiorDeIdade(String dataNascimento) {
    try {
      // Extrai dia, mês e ano do formato dd/MM/yyyy
      final partes = dataNascimento.split('/');
      if (partes.length != 3) return false;
      final dia = int.parse(partes[0]);
      final mes = int.parse(partes[1]);
      final ano = int.parse(partes[2]);

      final nascimento = DateTime(ano, mes, dia);
      final hoje = DateTime.now();

      final idade = hoje.year -
          nascimento.year -
          ((hoje.month < nascimento.month ||
                  (hoje.month == nascimento.month && hoje.day < nascimento.day))
              ? 1
              : 0);

      return idade >= 18;
    } catch (e) {
      return false;
    }
  }

  // Função auxiliar para converter dd/MM/yyyy em DateTime
  DateTime? parseData(String data) {
    try {
      final partes = data.split('/');
      if (partes.length != 3) return null;
      final dia = int.parse(partes[0]);
      final mes = int.parse(partes[1]);
      final ano = int.parse(partes[2]);
      return DateTime(ano, mes, dia);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF7AB0A3);
    final blueColor = const Color(0xFF4F8FCB);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro Usuário'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
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
                color: Colors.white,
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
                          'assets/image/195e7eed-4690-470b-bddf-d91da4a7623f.png',
                          width: 70,
                          height: 70,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Crie sua conta',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: themeColor,
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
                        // Campo Data de Nascimento
                        TextFormField(
                          controller: _dataNascimentoController,
                          inputFormatters: [_dataNascimentoFormatter],
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
                            if (!isMaiorDeIdade(value)) {
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
                          controller: _cpfController,
                          inputFormatters: [cpfFormater],
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
                            DropdownMenuItem(
                                value: 'Masculino', child: Text('Masculino')),
                            DropdownMenuItem(
                                value: 'Feminino', child: Text('Feminino')),
                            DropdownMenuItem(
                                value: 'Não-binário',
                                child: Text('Não-binário')),
                            DropdownMenuItem(
                                value: 'Homem trans',
                                child: Text('Homem trans')),
                            DropdownMenuItem(
                                value: 'Mulher trans',
                                child: Text('Mulher trans')),
                            DropdownMenuItem(
                                value: 'Agênero', child: Text('Agênero')),
                            DropdownMenuItem(
                                value: 'Gênero fluido',
                                child: Text('Gênero fluido')),
                            DropdownMenuItem(
                                value: 'Bigênero', child: Text('Bigênero')),
                            DropdownMenuItem(
                                value: 'Prefiro não informar',
                                child: Text('Prefiro não informar')),
                            DropdownMenuItem(
                                value: 'Outro', child: Text('Outro')),
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
                                      setState(() => _loading = true);
                                      try {
                                        final response =
                                            await _cadastroController
                                                .cadastrarUsuario(
                                          nome: _nameController.text.trim(),
                                          dataNascimento: parseData(
                                              _dataNascimentoController.text
                                                  .trim())!,
                                          email: _emailController.text.trim(),
                                          senha: _passwordController.text,
                                          cpf: _cpfController.text.trim(),
                                          genero: _gender ?? '',
                                        );
                                        if (!mounted) return;
                                        if (response.statusCode == 200 ||
                                            response.statusCode == 201) {
                                          showSnackBar(
                                              'Usuário cadastrado com sucesso!',
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
