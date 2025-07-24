import 'package:flutter/material.dart';
import 'package:noribox_store/controllers/cliente_controllers.dart';
import 'package:noribox_store/models/endereco_usuario_,model.dart';
import 'package:noribox_store/models/usuario_model.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/utils/app_snackbar.dart';
import 'package:noribox_store/utils/formatters.dart';
import 'package:noribox_store/utils/validador.dart';
import 'package:noribox_store/widgets/appbar/app_bar_desktop.dart';
import 'package:noribox_store/widgets/appbar/app_bar_widget.dart';
import 'package:noribox_store/widgets/button_whatsapp.dart';
// import removido pois não está sendo utilizado
import 'package:noribox_store/widgets/cadastro_progress_indicator.dart';
import 'package:noribox_store/widgets/custom_button.dart';
import 'package:noribox_store/widgets/footer_widget.dart';
import 'package:provider/provider.dart';

class CadastroUsuarioScreen extends StatefulWidget {
  const CadastroUsuarioScreen({super.key});

  @override
  State<CadastroUsuarioScreen> createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  final PageController _pageController = PageController();
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyDados = GlobalKey<FormState>();
  final _formKeyEndereco = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _nomeCompletoController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _cpfCnpjController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _senhaConfirmacaoController =
      TextEditingController();

  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();

  int etapa = 0;
  bool loading = false;
  String? erroEmail;
  bool isCnpj = false;
  bool senhaOculta = true;
  bool senhaConfirmacaoOculta = true;
  bool confirmarSenhaOculta = true;
  String? genero;
  String? clienteId;

  void _proximaEtapa() {
    setState(() {
      etapa++;
      _pageController.animateToPage(
        etapa,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  void _voltarEtapa() {
    setState(() {
      etapa--;
      _pageController.animateToPage(
        etapa,
        duration: const Duration(milliseconds: 400),
        curve: Curves.ease,
      );
    });
  }

  bool senhaConfirmada() {
    return _senhaController.text == _senhaConfirmacaoController.text;
  }

  final RegExp emailRegex =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

  final RegExp senhaForteRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

  // void finalizarCadastro() {
  //   if (_formKeyEndereco.currentState!.validate()) {
  //     _formKeyEndereco.currentState!.save();

  //     // Aqui você pode enviar o cliente para o backend
  //     // Exemplo: await usuarioService.cadastrar(cliente);

  //     showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //         title: const Text('Cadastro realizado!'),
  //         content: const Text('Usuário cadastrado com sucesso.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('OK'),
  //           )
  //         ],
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final clienteControllers =
        Provider.of<ClienteControllers>(context, listen: false);
    //final theme = Theme.of(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Themes.greyLight,
          appBar: PreferredSize(
            preferredSize: ThemesSize.heightAppBar,
            child: AppBarWidget(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1200,
                ),
                child: Container(
                  // padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      CadastroProgressIndicator(
                        etapa: etapa,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Center(
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: 600,
                            ),
                            decoration: BoxDecoration(
                              //color: Colors.white,
                              border: Border.all(
                                color: Themes.greyPrimary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PageView(
                                controller: _pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  // Etapa 1: Email
                                  buildEtapaEmail(context, clienteControllers),
                                  // Etapa 2: Dados pessoais
                                  buildEtapaDadosPessoais(
                                      context, clienteControllers),
                                  // Etapa 3: Endereço
                                  buildEtapaEndereco(
                                      context, clienteControllers),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FooterWidget()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        ButtonWhatsapp()
      ],
    );
  }

  Widget buildEtapaEmail(
      BuildContext context, ClienteControllers clienteControllers) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 300,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Vamos começar! 👋',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Informe seu e-mail para criar sua conta',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Formulário de email
            Form(
              key: _formKeyEmail,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'E-mail*',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Informe o e-mail';
                      }
                      if (!emailRegex.hasMatch(v)) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
                  ),
                  if (erroEmail != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(erroEmail!,
                          style: const TextStyle(color: Colors.red)),
                    ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: CustomButton(
                      backgroundColor: Themes.redPrimary,
                      foregroundColor: Themes.white,
                      onPressed: () async {
                        if (_formKeyEmail.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          try {
                            await clienteControllers.verificarEmailController(
                                _emailController.text);

                            if (clienteControllers.existsEmail) {
                              if (context.mounted) {
                                AppSnackbar.show(
                                    context, 'E-mail já cadastrado',
                                    backgroundColor: Colors.red);
                                setState(() {
                                  loading = false;
                                });
                              }
                            } else {
                              await Future.delayed(
                                const Duration(seconds: 2),
                              );
                              setState(() {
                                loading = false;
                              });
                              _proximaEtapa();
                            }
                          } catch (e) {
                            if (context.mounted) {
                              AppSnackbar.show(
                                context,
                                e.toString().replaceAll('Exception: ', ''),
                                backgroundColor: Themes.error,
                              );
                            }
                            setState(() {
                              loading = false;
                            });
                          }
                        }
                      },
                      child: loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Themes.white,
                              ))
                          : const Text('Próximo',
                              style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEtapaDadosPessoais(
    BuildContext context,
    ClienteControllers clienteControllers,
  ) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Seus dados',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Preencha seus dados pessoais',
            style: TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Form(
            key: _formKeyDados,
            child: Column(
              children: [
                // Linha nome e data de nascimento
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        controller: _nomeCompletoController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: 'Nome completo*',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Informe o nome';
                          }
                          if (RegExp(r'[0-9]').hasMatch(v)) {
                            return 'O nome não pode conter números';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                          controller: _dataNascimentoController,
                          inputFormatters: [Formatters.dataFormatter],
                          decoration: InputDecoration(
                            labelText: 'Data de nascimento',
                            prefixIcon: Icon(Icons.cake_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Informe a data';
                            }
                            return null;
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Linha CPF/CNPJ e celular/telefone
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cpfCnpjController,
                        inputFormatters: isCnpj
                            ? [Formatters.cnpjFormatter]
                            : [Formatters.cpfFormatter],
                        decoration: InputDecoration(
                          labelText: isCnpj ? 'CNPJ*' : 'CPF*',
                          prefixIcon: Icon(Icons.badge_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Informe o ${isCnpj ? 'CNPJ' : 'CPF'}';
                          }
                          if (isCnpj) {
                            if (!Validador.validarCNPJ(v)) {
                              return 'CNPJ inválido';
                            }
                          }
                          // else {
                          //   if (!Validador.validarCPF(v)) {
                          //     return 'CPF inválido';
                          //   }
                          // }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Checkbox(
                      activeColor: Themes.redPrimary,
                      checkColor: Colors.white,
                      value: !isCnpj,
                      onChanged: (val) {
                        setState(() {
                          isCnpj = false;
                          _cpfCnpjController.clear();
                        });
                      },
                    ),
                    const Text('CPF'),
                    Checkbox(
                      activeColor: Themes.redPrimary,
                      checkColor: Colors.white,
                      value: isCnpj,
                      onChanged: (val) {
                        setState(() {
                          isCnpj = true;
                          _cpfCnpjController.clear();
                        });
                      },
                    ),
                    const Text('CNPJ'),
                  ],
                ),
                const SizedBox(height: 12),
                // Linha celular e telefone
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _celularController,
                        inputFormatters: [Formatters.celularFormatter],
                        decoration: InputDecoration(
                          labelText: 'Celular*',
                          prefixIcon: Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? 'Informe o telefone'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _telefoneController,
                        inputFormatters: [Formatters.telefoneFormatter],
                        decoration: InputDecoration(
                          labelText: 'Telefone',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 12),
                // Linha gênero, senha e confirmação de senha
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Gênero',
                          prefixIcon: Icon(Icons.wc_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'Masculino', child: Text('Masculino')),
                          DropdownMenuItem(
                              value: 'Feminino', child: Text('Feminino')),
                          DropdownMenuItem(
                              value: 'Outro', child: Text('Outro')),
                        ],
                        validator: (v) =>
                            v == null ? 'Selecione o gênero' : null,
                        onChanged: (v) => genero = v,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _senhaController,
                        obscureText: senhaOculta,
                        decoration: InputDecoration(
                          labelText: 'Senha*',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              senhaOculta
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                senhaOculta = !senhaOculta;
                              });
                            },
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Informe a senha';
                          }
                          if (v.length < 8) {
                            return 'A senha deve ter pelo menos 8 caracteres';
                          }
                          // if (!senhaForteRegex.hasMatch(v)) {
                          //   return 'A senha deve conter pelo menos 1 letra maiúscula, 1 minúscula, 1 número e 1 caractere especial';
                          // }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _senhaConfirmacaoController,
                        obscureText: senhaConfirmacaoOculta,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Senha',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              senhaOculta
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                senhaConfirmacaoOculta =
                                    !senhaConfirmacaoOculta;
                              });
                            },
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Informe a senha';
                          }
                          if (v.length < 6) {
                            return 'A senha deve ter pelo menos 8 caracteres';
                          }
                          // if (!senhaForteRegex.hasMatch(v)) {
                          //   return 'A senha deve conter pelo menos 1 letra maiúscula, 1 minúscula, 1 número e 1 caractere especial';
                          // }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Botões de navegação
                Row(
                  children: [
                    TextButton(
                      onPressed: _voltarEtapa,
                      child: const Text('Voltar'),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 140,
                      height: 48,
                      child: CustomButton(
                        backgroundColor: Themes.redPrimary,
                        foregroundColor: Themes.white,
                        onPressed: () async {
                          try {
                            if (_formKeyDados.currentState!.validate()) {
                              final result = await clienteControllers
                                  .cadastrarClienteController(
                                ClienteModel(
                                  nomeCompleto: _nomeCompletoController.text,
                                  email: _emailController.text,
                                  senha: _senhaController.text,
                                  cpfCnpj: _cpfCnpjController.text,
                                  celular: _celularController.text,
                                  telefone: _telefoneController.text,
                                  dataNascimento:
                                      Formatters.parseDataNascimento(
                                              _dataNascimentoController.text) ??
                                          DateTime.now(),
                                  // DateTime.parse(
                                  //     _dataNascimentoController.text),
                                  genero: genero ?? 'indefinido',
                                ),
                              );
                              result['id'] != null
                                  ? clienteId = result['id'].toString()
                                  : clienteId = null;
                              print('Resultado do cadastro: $result');

                              _proximaEtapa();
                            }
                          } catch (e) {
                            if (context.mounted) {
                              AppSnackbar.show(
                                context,
                                e.toString().replaceAll('Exception: ', ''),
                                backgroundColor: Themes.error,
                              );
                            }
                          }
                        },
                        child: const Text('Próximo',
                            style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEtapaEndereco(
      BuildContext context, ClienteControllers clienteControllers) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Endereço de entrega',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Preencha seu endereço para finalizar',
            style: TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Form(
            key: _formKeyEndereco,
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    inputFormatters: [Formatters.cepFormatter],
                    controller: _cepController,
                    decoration: InputDecoration(
                      labelText: 'CEP',
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Informe o CEP' : null,
                    onChanged: (v) async {
                      final cepLimpo = v.replaceAll(RegExp(r'[^0-9]'), '');
                      if (cepLimpo.length == 8) {
                        try {
                          await clienteControllers
                              .buscarEnderecoPorCep(cepLimpo);
                          if (clienteControllers.enderecoUsuario != null) {
                            setState(
                              () {
                                _logradouroController.text = clienteControllers
                                        .enderecoUsuario!['rua'] ??
                                    '';
                                _bairroController.text = clienteControllers
                                        .enderecoUsuario!['bairro'] ??
                                    '';
                                _cidadeController.text = clienteControllers
                                        .enderecoUsuario!['cidade'] ??
                                    '';
                                _estadoController.text = clienteControllers
                                        .enderecoUsuario!['estado'] ??
                                    '';
                              },
                            );
                          }
                          if (clienteControllers.erroCep != null) {
                            if (context.mounted) {
                              AppSnackbar.show(
                                context,
                                ' ${clienteControllers.erroCep}',
                                backgroundColor: Themes.error,
                              );
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            AppSnackbar.show(
                              context,
                              'Erro ao buscar CEP: ${e.toString()}',
                              backgroundColor: Themes.error,
                            );
                          }
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(height: 12),
                // Linha rua e número
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        controller: _logradouroController,
                        decoration: InputDecoration(
                          labelText: 'Rua',
                          prefixIcon: Icon(Icons.map_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? 'Informe o logradouro'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _numeroController,
                        decoration: InputDecoration(
                          labelText: 'Número',
                          prefixIcon: Icon(Icons.numbers_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Informe o número' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Linha complemento e bairro
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _complementoController,
                        decoration: InputDecoration(
                          labelText: 'Complemento',
                          prefixIcon: Icon(Icons.add_box_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        controller: _bairroController,
                        decoration: InputDecoration(
                          labelText: 'Bairro',
                          prefixIcon: Icon(Icons.home_work_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Informe o bairro' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Linha cidade e estado
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        controller: _cidadeController,
                        decoration: InputDecoration(
                          labelText: 'Cidade',
                          prefixIcon: Icon(Icons.location_city_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Informe a cidade' : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _estadoController,
                        decoration: InputDecoration(
                          labelText: 'Estado',
                          prefixIcon: Icon(Icons.flag_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Informe o estado' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Botões de navegação
                Row(
                  children: [
                    TextButton(
                      onPressed: _voltarEtapa,
                      child: const Text('Voltar'),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 180,
                      height: 48,
                      child: CustomButton(
                        backgroundColor: Themes.redPrimary,
                        foregroundColor: Themes.white,
                        onPressed: () async {
                          if (_formKeyEndereco.currentState!.validate()) {
                            if (clienteId != null) {
                              final result = await clienteControllers
                                  .cadastrarEnderecoController(
                                EnderecoClienteModel(
                                  clienteId: clienteId!, // Use '0' if null
                                  cep: _cepController.text
                                      .replaceAll(RegExp(r'[^0-9]'), ''),
                                  rua: _logradouroController.text,
                                  numero: _numeroController.text,
                                  complemento: _complementoController.text,
                                  bairro: _bairroController.text,
                                  cidade: _cidadeController.text,
                                  estado: _estadoController.text,
                                ),
                              );
                              if (result.isNotEmpty) {
                                if (context.mounted) {
                                  AppSnackbar.show(
                                    context,
                                    result,
                                    backgroundColor: Themes.green,
                                  );
                                }
                              }
                            } else {
                              if (context.mounted) {
                                AppSnackbar.show(
                                  context,
                                  'Erro ao cadastrar endereço, tente novamente',
                                  backgroundColor: Themes.error,
                                );
                              }
                            }
                          }
                        },
                        child: Text(
                          'Finalizar',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
