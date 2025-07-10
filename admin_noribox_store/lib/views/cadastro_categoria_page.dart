import 'package:admin_noribox_store/controllers/categoria_controller.dart';
import 'package:admin_noribox_store/widgets/global_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CadastroCategoriaPage extends StatefulWidget {
  const CadastroCategoriaPage({super.key});

  @override
  State<CadastroCategoriaPage> createState() => _CadastroCategoriaPageState();
}

class _CadastroCategoriaPageState extends State<CadastroCategoriaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriaController>(
        builder: (context, categoriaController, child) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cadastrar Categoria')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome da Categoria',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Informe o nome' : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Text('Cadastrar'),
                        onPressed: () async {
                          if (_formKey.currentState == null ||
                              !_formKey.currentState!.validate()) {
                            return;
                          }
                          setState(() {
                            loading = true;
                          });
                          try {
                            final result = await categoriaController
                                .cadastrarCategoriaController(
                              _nomeController.text.trim(),
                            );
                            print('Categoria cadastrada: $result');
                            GlobalSnackbar.show(
                                'Categoria cadastrada com sucesso!');
                            _nomeController.clear();
                            setState(() {
                              loading = false;
                            });
                          } catch (e) {
                            GlobalSnackbar.show(
                                'Erro ao cadastrar categoria: $e');
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
