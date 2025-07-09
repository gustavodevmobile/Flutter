import 'package:admin_noribox_store/components/to_base64.dart';
import 'package:admin_noribox_store/controllers/categoria_controller.dart';
import 'package:admin_noribox_store/models/categoria.dart';
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
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _corController = TextEditingController();
  final TextEditingController _caracteristicasController =
      TextEditingController();
  final TextEditingController _dimensoesController = TextEditingController();
  final TextEditingController _ocasiaoController = TextEditingController();
  final TextEditingController _sobreController = TextEditingController();
  final TextEditingController _prazoEntregaController = TextEditingController();
  final TextEditingController _freteController = TextEditingController();
  final TextEditingController _origemController = TextEditingController();
  final TextEditingController _categoriaIdController = TextEditingController();

  // Lista de categorias exemplo (substitua pelo seu backend se necessário)
  final List<Categoria> _categorias = [];
  @override
  void initState() {
    Future.microtask(() async {
      if (mounted) {
        final categorias =
            Provider.of<CategoriaController>(context, listen: false);
        await categorias.buscarCategoriaController();
      }
    });
    super.initState();
  }

  String? _categoriaSelecionada;

  bool _freteGratis = false;
  bool _disponivel = true;
  XFile? _imagemProduto;
  int _parcelamentoSelecionado = 1;

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
    _materialController.dispose();
    _marcaController.dispose();
    _corController.dispose();
    _caracteristicasController.dispose();
    _dimensoesController.dispose();
    _ocasiaoController.dispose();
    _sobreController.dispose();
    _prazoEntregaController.dispose();
    _freteController.dispose();
    _origemController.dispose();
    _categoriaIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProdutoController, CategoriaController>(
      builder: (context, cadastroController, categoriaController, child) {
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
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _nomeController,
                                    decoration: InputDecoration(
                                      labelText: 'Nome do Produto',
                                      prefixIcon:
                                          const Icon(Icons.label_outline),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Informe o nome do produto';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _precoController,
                                    decoration: InputDecoration(
                                      labelText: 'Preço',
                                      prefixIcon:
                                          const Icon(Icons.attach_money),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
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
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _descricaoController,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                      labelText: 'Descrição',
                                      prefixIcon: const Icon(
                                          Icons.description_outlined),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Informe a descrição';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // imagem do produto
                            Expanded(
                              child: GestureDetector(
                                onTap: _selecionarImagem,
                                child: Container(
                                  height: 180, // Imagem menor
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border: Border.all(
                                        color: Colors.blueAccent, width: 1.5),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue,
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: _imagemProduto != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: kIsWeb
                                              ? Image.network(
                                                  _imagemProduto!.path,
                                                  fit: BoxFit.cover)
                                              : Image.file(
                                                  File(_imagemProduto!.path),
                                                  fit: BoxFit.cover),
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.add_a_photo,
                                                size: 32,
                                                color: Colors.blueAccent),
                                            SizedBox(height: 6),
                                            Text(
                                              'Imagem',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.blueAccent),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const SizedBox(width: 12),
                            Expanded(
                              child: Row(
                                children: [
                                  Text('Frete Grátis'),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: _freteGratis,
                                      onChanged: (value) {
                                        setState(() {
                                          _freteGratis = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Row(
                                children: [
                                  Text('Disponível'),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: _disponivel,
                                      onChanged: (value) {
                                        setState(() {
                                          _disponivel = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _freteController,
                                decoration: InputDecoration(
                                  labelText: 'Frete',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _origemController,
                                decoration: InputDecoration(
                                  labelText: 'Origem',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                width: 220,
                                child: TextFormField(
                                  controller: _corController,
                                  decoration: InputDecoration(
                                    labelText: 'Cor',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _categoriaSelecionada,
                                decoration: InputDecoration(
                                  labelText: 'Categoria',
                                  prefixIcon:
                                      const Icon(Icons.category_outlined),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                items:categoriaController.categorias
                                    .map((cat) => DropdownMenuItem(
                                          value: cat.id,
                                          child: Text(cat.nome),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _categoriaSelecionada = value;
                                    _categoriaIdController.text = value ?? '';
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Selecione uma categoria';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                value: _parcelamentoSelecionado,
                                decoration: InputDecoration(
                                  labelText: 'Parcelamento',
                                  prefixIcon:
                                      const Icon(Icons.payments_outlined),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                items: List.generate(12, (i) => i + 1)
                                    .map((num) => DropdownMenuItem<int>(
                                          value: num,
                                          child: Text('$num x'),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _parcelamentoSelecionado = value ?? 1;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _dimensoesController,
                                decoration: InputDecoration(
                                  labelText: 'Dimensões',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _prazoEntregaController,
                                decoration: InputDecoration(
                                  labelText: 'Prazo de Entrega',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _sobreController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: 'Sobre o produto',
                                  prefixIcon:
                                      const Icon(Icons.description_outlined),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Informe a descrição';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _ocasiaoController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: 'Ocasião',
                                  prefixIcon:
                                      const Icon(Icons.description_outlined),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Informe a descrição';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _materialController,
                                    decoration: InputDecoration(
                                      labelText: 'Material',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _marcaController,
                                    decoration: InputDecoration(
                                      labelText: 'Marca',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _caracteristicasController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: 'Características',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            textStyle: const TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          label: const Text('Cadastrar Produto'),
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
                                  .cadastrarProdutoController(
                                Produto(
                                  nome: _nomeController.text,
                                  descricao: _descricaoController.text,
                                  valor: double.parse(_precoController.text),
                                  imagem: image,
                                  material: _materialController.text.isNotEmpty
                                      ? _materialController.text
                                      : null,
                                  marca: _marcaController.text.isNotEmpty
                                      ? _marcaController.text
                                      : null,
                                  cor: _corController.text.isNotEmpty
                                      ? _corController.text
                                      : null,
                                  caracteristicas:
                                      _caracteristicasController.text.isNotEmpty
                                          ? _caracteristicasController.text
                                          : null,
                                  dimensoes:
                                      _dimensoesController.text.isNotEmpty
                                          ? _dimensoesController.text
                                          : null,
                                  ocasiao: _ocasiaoController.text.isNotEmpty
                                      ? _ocasiaoController.text
                                      : null,
                                  sobre: _sobreController.text.isNotEmpty
                                      ? _sobreController.text
                                      : null,
                                  prazoEntrega:
                                      _prazoEntregaController.text.isNotEmpty
                                          ? _prazoEntregaController.text
                                          : null,
                                  frete: _freteController.text.isNotEmpty
                                      ? _freteController.text
                                      : null,
                                  freteGratis: _freteGratis,
                                  origem: _origemController.text.isNotEmpty
                                      ? _origemController.text
                                      : null,
                                  disponivel: _disponivel,
                                  categoriaId:
                                      _categoriaIdController.text.isNotEmpty
                                          ? _categoriaIdController.text
                                          : null,
                                  parcelamento:
                                      _parcelamentoSelecionado.toString(),
                                ),
                              );
                              GlobalSnackbar.show(
                                  'Produto cadastrado com sucesso!');
                              _nomeController.clear();
                              _descricaoController.clear();
                              _precoController.clear();
                              _materialController.clear();
                              _marcaController.clear();
                              _corController.clear();
                              _caracteristicasController.clear();
                              _dimensoesController.clear();
                              _ocasiaoController.clear();
                              _sobreController.clear();
                              _prazoEntregaController.clear();
                              _freteController.clear();
                              _origemController.clear();
                              _categoriaIdController.clear();
                              setState(() {
                                _imagemProduto = null;
                                _freteGratis = false;
                                _disponivel = true;
                                _categoriaSelecionada = null;
                              });
                            } catch (error) {
                              print('Erro ao cadastrar produto: $error');
                              GlobalSnackbar.show(
                                'Erro ao cadastrar produto: ${error.toString()}',
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
