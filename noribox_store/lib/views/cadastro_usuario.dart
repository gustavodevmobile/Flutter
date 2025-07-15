import 'package:flutter/material.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/utils/formatters.dart';
import 'package:noribox_store/widgets/app_bar.dart';
import 'package:noribox_store/widgets/button_whatsapp.dart';
// import removido pois não está sendo utilizado
import 'package:noribox_store/widgets/cadastro_progress_indicator.dart';
import 'package:noribox_store/widgets/footer_widget.dart';

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

  // Dados do usuário
  String? email;
  String? senha;
  String? nomeCompleto;
  String? cpfCnpj;
  String? celularTelefone;
  DateTime? dataNascimento;
  String? genero;

  // Endereço
  String? cep;
  String? logradouro;
  String? numero;
  String? complemento;
  String? bairro;
  String? cidade;
  String? estado;

  int etapa = 0;
  bool emailValidando = false;
  String? erroEmail;

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

  Future<void> _verificarEmail() async {
    setState(() {
      emailValidando = true;
      erroEmail = null;
    });
    // Simule uma chamada de API para verificar se o email existe
    await Future.delayed(const Duration(seconds: 1));
    if (email == "existe@email.com") {
      setState(() {
        erroEmail = "E-mail já cadastrado!";
        emailValidando = false;
      });
    } else {
      setState(() {
        emailValidando = false;
      });
      _proximaEtapa();
    }
  }

  void _finalizarCadastro() {
    if (_formKeyEndereco.currentState!.validate()) {
      _formKeyEndereco.currentState!.save();

      // Aqui você pode enviar o cliente para o backend
      // Exemplo: await usuarioService.cadastrar(cliente);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Cadastro realizado!'),
          content: const Text('Usuário cadastrado com sucesso.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  double getMaxWidth() {
    if (etapa == 0) return 300;
    return 600;
  }

  bool validarCPF(String cpf) {
    // Remove caracteres não numéricos
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    if (cpf.length != 11) return false;
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false; // Todos iguais

    // Validação do primeiro dígito
    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }
    int digito1 = 11 - (soma % 11);
    if (digito1 >= 10) digito1 = 0;
    if (digito1 != int.parse(cpf[9])) return false;

    // Validação do segundo dígito
    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }
    int digito2 = 11 - (soma % 11);
    if (digito2 >= 10) digito2 = 0;
    if (digito2 != int.parse(cpf[10])) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Themes.greyLight,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(140),
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
                                color: Colors.grey.shade300,
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
                                  Align(
                                    alignment: Alignment.center,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 300,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const Text(
                                            'Vamos começar! 👋',
                                            style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Informe seu e-mail para criar sua conta',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black54),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 32),
                                          Form(
                                            key: _formKeyEmail,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  decoration: InputDecoration(
                                                    labelText: 'E-mail',
                                                    prefixIcon: Icon(
                                                        Icons.email_outlined),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.emailAddress,
                                                  validator: (v) {
                                                    if (v == null || v.isEmpty) {
                                                      return 'Informe o e-mail';
                                                    }
                                                    if (!v.contains('@')) {
                                                      return 'E-mail inválido';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (v) => email = v,
                                                ),
                                                if (erroEmail != null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    child: Text(erroEmail!,
                                                        style: const TextStyle(
                                                            color: Colors.red)),
                                                  ),
                                                const SizedBox(height: 32),
                                                SizedBox(
                                                  width: double.infinity,
                                                  height: 48,
                                                  child: ElevatedButton(
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Themes.redPrimary,
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12),
                                                      ),
                                                    ),
                                                    onPressed: emailValidando
                                                        ? null
                                                        : () {
                                                            //   if (_formKeyEmail.currentState!
                                                            //       .validate()) {
                                                            //     _formKeyEmail.currentState!.save();
                                                            _verificarEmail();
                                                            //   }
                                                          },
                                                    child: emailValidando
                                                        ? const SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child:
                                                                CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2))
                                                        : const Text('Próximo',
                                                            style: TextStyle(
                                                                fontSize: 18)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Etapa 2: Dados pessoais
                                  SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const Text(
                                          'Seus dados',
                                          style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Preencha seus dados pessoais',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 32),
                                        Form(
                                          key: _formKeyDados,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Flexible(
                                                    flex: 2,
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                        labelText:
                                                            'Nome completo',
                                                        prefixIcon: Icon(
                                                            Icons.person_outline),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      validator: (v) =>
                                                          v == null || v.isEmpty
                                                              ? 'Informe o nome'
                                                              : null,
                                                      onSaved: (v) =>
                                                          nomeCompleto = v,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                        labelText:
                                                            'Data de nascimento (AAAA-MM-DD)',
                                                        prefixIcon: Icon(
                                                            Icons.cake_outlined),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      validator: (v) {
                                                        if (v == null ||
                                                            v.isEmpty) {
                                                          return 'Informe a data';
                                                        }
            
                                                        try {
                                                          DateTime.parse(v);
                                                          return null;
                                                        } catch (_) {
                                                          return 'Data inválida';
                                                        }
                                                      },
                                                      onSaved: (v) =>
                                                          dataNascimento =
                                                              DateTime.parse(v!),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                        labelText: 'CPF ou CNPJ',
                                                        prefixIcon: Icon(
                                                            Icons.badge_outlined),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      validator: (v) => v ==
                                                                  null ||
                                                              v.isEmpty
                                                          ? 'Informe o CPF/CNPJ'
                                                          : null,
                                                      onSaved: (v) => cpfCnpj = v,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                        labelText: 'Celular',
                                                        prefixIcon: Icon(
                                                            Icons.phone_outlined),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      validator: (v) => v ==
                                                                  null ||
                                                              v.isEmpty
                                                          ? 'Informe o telefone'
                                                          : null,
                                                      onSaved: (v) =>
                                                          celularTelefone = v,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      inputFormatters: [
                                                        Formatters
                                                            .celularFormatter
                                                      ],
                                                      decoration: InputDecoration(
                                                        labelText: 'Celular*',
                                                        prefixIcon: Icon(
                                                            Icons.phone_outlined),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      validator: (v) => v ==
                                                                  null ||
                                                              v.isEmpty
                                                          ? 'Informe o telefone'
                                                          : null,
                                                      onSaved: (v) =>
                                                          celularTelefone = v,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                        labelText: 'Telefone',
                                                        prefixIcon: Icon(
                                                            Icons.lock_outline),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      obscureText: true,
                                                      validator: (v) => v ==
                                                                  null ||
                                                              v.length < 6
                                                          ? 'Mínimo 6 caracteres'
                                                          : null,
                                                      onSaved: (v) => senha = v,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      decoration: InputDecoration(
                                                        labelText: 'Gênero',
                                                        prefixIcon: Icon(
                                                            Icons.wc_outlined),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      items: const [
                                                        DropdownMenuItem(
                                                            value: 'Masculino',
                                                            child: Text(
                                                                'Masculino')),
                                                        DropdownMenuItem(
                                                            value: 'Feminino',
                                                            child:
                                                                Text('Feminino')),
                                                        DropdownMenuItem(
                                                            value: 'Outro',
                                                            child: Text('Outro')),
                                                      ],
                                                      validator: (v) => v == null
                                                          ? 'Selecione o gênero'
                                                          : null,
                                                      onChanged: (v) =>
                                                          genero = v,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                        labelText: 'Senha',
                                                        prefixIcon: Icon(
                                                            Icons.lock_outline),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      obscureText: true,
                                                      validator: (v) => v ==
                                                                  null ||
                                                              v.length < 6
                                                          ? 'Mínimo 6 caracteres'
                                                          : null,
                                                      onSaved: (v) => senha = v,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                        labelText:
                                                            'Confirmar Senha',
                                                        prefixIcon: Icon(
                                                            Icons.lock_outline),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      obscureText: true,
                                                      validator: (v) => v ==
                                                                  null ||
                                                              v.length < 6
                                                          ? 'Mínimo 6 caracteres'
                                                          : null,
                                                      onSaved: (v) => senha = v,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 32),
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
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Themes.green,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        // if (_formKeyDados.currentState!
                                                        //     .validate()) {
                                                        //   _formKeyDados.currentState!.save();
                                                        _proximaEtapa();
                                                        // }
                                                      },
                                                      child: const Text('Próximo',
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Etapa 3: Endereço
                                  SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const Text(
                                          'Endereço de entrega',
                                          style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Preencha seu endereço para finalizar',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 32),
                                        Form(
                                          key: _formKeyEndereco,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                decoration: InputDecoration(
                                                  labelText: 'CEP',
                                                  prefixIcon: Icon(
                                                      Icons.location_on_outlined),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                  ),
                                                ),
                                                validator: (v) =>
                                                    v == null || v.isEmpty
                                                        ? 'Informe o CEP'
                                                        : null,
                                                onSaved: (v) => cep = v,
                                              ),
                                              const SizedBox(height: 12),
                                              TextFormField(
                                                decoration: InputDecoration(
                                                  labelText: 'Logradouro',
                                                  prefixIcon:
                                                      Icon(Icons.map_outlined),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                  ),
                                                ),
                                                validator: (v) =>
                                                    v == null || v.isEmpty
                                                        ? 'Informe o logradouro'
                                                        : null,
                                                onSaved: (v) => logradouro = v,
                                              ),
                                              const SizedBox(height: 12),
                                              TextFormField(
                                                decoration: InputDecoration(
                                                  labelText: 'Número',
                                                  prefixIcon: Icon(
                                                      Icons.numbers_outlined),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                  ),
                                                ),
                                                validator: (v) =>
                                                    v == null || v.isEmpty
                                                        ? 'Informe o número'
                                                        : null,
                                                onSaved: (v) => numero = v,
                                              ),
                                              const SizedBox(height: 12),
                                              TextFormField(
                                                decoration: InputDecoration(
                                                  labelText: 'Complemento',
                                                  prefixIcon: Icon(
                                                      Icons.add_box_outlined),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                  ),
                                                ),
                                                onSaved: (v) => complemento = v,
                                              ),
                                              const SizedBox(height: 12),
                                              TextFormField(
                                                decoration: InputDecoration(
                                                  labelText: 'Bairro',
                                                  prefixIcon: Icon(
                                                      Icons.home_work_outlined),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                  ),
                                                ),
                                                validator: (v) =>
                                                    v == null || v.isEmpty
                                                        ? 'Informe o bairro'
                                                        : null,
                                                onSaved: (v) => bairro = v,
                                              ),
                                              const SizedBox(height: 12),
                                              TextFormField(
                                                decoration: InputDecoration(
                                                  labelText: 'Cidade',
                                                  prefixIcon: Icon(Icons
                                                      .location_city_outlined),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                  ),
                                                ),
                                                validator: (v) =>
                                                    v == null || v.isEmpty
                                                        ? 'Informe a cidade'
                                                        : null,
                                                onSaved: (v) => cidade = v,
                                              ),
                                              const SizedBox(height: 12),
                                              TextFormField(
                                                decoration: InputDecoration(
                                                  labelText: 'Estado',
                                                  prefixIcon:
                                                      Icon(Icons.flag_outlined),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                  ),
                                                ),
                                                validator: (v) =>
                                                    v == null || v.isEmpty
                                                        ? 'Informe o estado'
                                                        : null,
                                                onSaved: (v) => estado = v,
                                              ),
                                              const SizedBox(height: 32),
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
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            theme.primaryColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      onPressed:
                                                          _finalizarCadastro,
                                                      child: const Text(
                                                          'Finalizar cadastro',
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
}
