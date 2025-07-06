import 'package:admin_noribox_store/components/to_base64.dart';
import 'package:admin_noribox_store/models/produto.dart';
import 'package:admin_noribox_store/widgets/global_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../controllers/produto_controller.dart';

class CadastroProdutoPage extends StatefulWidget {
  const CadastroProdutoPage({super.key});

  @override
  State<CadastroProdutoPage> createState() => _CadastroProdutoPageState();
}

class _CadastroProdutoPageState extends State<CadastroProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  XFile? _imagemProduto;
  //late final CadastroProdutoController _controller;

  Future<void> _selecionarImagem() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagemProduto = pickedFile;
      });
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProdutoController>(
        builder: (context, cadastroController, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro de Produto'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () async {
              await cadastroController.buscarProdutosController();
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _selecionarImagem,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _imagemProduto != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Center(
                                child: kIsWeb
                                    ? Image.network(
                                        _imagemProduto!.path,
                                        fit: BoxFit.contain,
                                        // width: 150,
                                        // height: 150,
                                      )
                                    : Image.file(
                                        File(_imagemProduto!.path),
                                        fit: BoxFit.contain,
                                        // width: 150,
                                        // height: 150,
                                      ),
                              ),
                            )
                          : const Center(
                              child: Text('Clique para selecionar uma imagem')),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nomeController,
                    decoration:
                        const InputDecoration(labelText: 'Nome do Produto'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o nome do produto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descricaoController,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a descrição';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _precoController,
                    decoration: const InputDecoration(labelText: 'Preço'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o preço';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Informe um valor válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      String image = '';
                      try {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        if (_imagemProduto == null) {
                          GlobalSnackbar.show(
                              'Selecione uma imagem do produto');
                          return;
                        } else {
                          image = await xFileToBase64(_imagemProduto!);
                        }

                        await cadastroController
                            .cadastrarProdutoController(Produto(
                          nome: _nomeController.text,
                          descricao: _descricaoController.text,
                          valor: double.parse(_precoController.text),
                          imagem: image,
                        ));

                        GlobalSnackbar.show('Produto cadastrado com sucesso!');
                        _nomeController.clear();
                        _descricaoController.clear();
                        _precoController.clear();
                        setState(() {
                          _imagemProduto = null;
                        });
                      } catch (error) {
                        print('Erro ao cadastrar produto: $error');
                        GlobalSnackbar.show(
                          'Erro ao cadastrar produto: ${error.toString()}',
                        );
                      }
                    },
                    child: const Text('Cadastrar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
