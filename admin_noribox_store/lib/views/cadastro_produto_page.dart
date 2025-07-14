import 'package:admin_noribox_store/components/to_base64.dart';
import 'package:admin_noribox_store/controllers/categoria_controller.dart';
import 'package:admin_noribox_store/models/categoria.dart';
import 'package:admin_noribox_store/models/produto.dart';
import 'package:admin_noribox_store/widgets/global_snackbar.dart';
import 'package:admin_noribox_store/widgets/image_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final TextEditingController _valorCompraController = TextEditingController();
  final TextEditingController _valorVendaController = TextEditingController();
  final TextEditingController _valorNoPixController = TextEditingController();
  final TextEditingController _valorComJurosController =
      TextEditingController();
  final TextEditingController _valorSemJurosController =
      TextEditingController();
  final TextEditingController _lucroSobreVendaController =
      TextEditingController();

  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _corController = TextEditingController();
  final TextEditingController _caracteristicasController =
      TextEditingController();
  final TextEditingController _pesoController = TextEditingController();

  final TextEditingController _validadeController = TextEditingController();
  final TextEditingController _informacoesAdicionaisController =
      TextEditingController();
  final TextEditingController _sugestoesDeUsoController =
      TextEditingController();
  final TextEditingController _urlFornecedorController =
      TextEditingController();
  final TextEditingController _idFornecedorController = TextEditingController();
  final TextEditingController _consumoEletricoController =
      TextEditingController();
  final TextEditingController _dimensoesController = TextEditingController();
  final TextEditingController _ocasiaoController = TextEditingController();
  final TextEditingController _sobreController = TextEditingController();
  final TextEditingController _prazoEntregaController = TextEditingController();
  final TextEditingController _freteController = TextEditingController();
  final TextEditingController _origemController = TextEditingController();
  final TextEditingController _categoriaIdController = TextEditingController();

  // Lista de categorias exemplo (substitua pelo seu backend se necessário)
  final List<Categoria> categorias = [];
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
  bool isLoading = false;
  bool freteGratis = false;
  bool disponivel = true;
  bool isEletrico = false;
  XFile? _imagemPrincipal;
  XFile? _imagem2;
  XFile? _imagem3;
  XFile? _imagem4;
  XFile? _videoProduto;
  int _parcelamentoSelecionado = 1;

  Future<void> selecionarImagem(Function(XFile?) setter) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        setter(pickedFile);
      });
    }
  }

  Future<void> cadastrarProduto() async {
    String imagePrincipal = '';
    final produtoController =
        Provider.of<ProdutoController>(context, listen: false);
    try {
      setState(() => isLoading = true);
      if (!_formKey.currentState!.validate()) {
        setState(() => isLoading = false);
        return;
      }
      if (_imagemPrincipal == null) {
        GlobalSnackbar.show('Selecione uma imagem do produto');
        return;
      } else {
        imagePrincipal = await xFileToBase64(_imagemPrincipal!);
      }

      await produtoController.cadastrarProdutoController(
        Produto(
            nome: _nomeController.text,
            descricao: _descricaoController.text,
            valorVenda: double.parse(_valorVendaController.text),
            valorCompra: double.tryParse(_valorCompraController.text),
            valorNoPix: double.tryParse(_valorNoPixController.text),
            valorComJuros: double.tryParse(_valorComJurosController.text),
            valorSemJuros: double.tryParse(_valorSemJurosController.text),
            lucroSobreVenda: double.tryParse(_lucroSobreVendaController.text),
            imagemPrincipal: imagePrincipal,
            imagem2: _imagem2 != null ? await xFileToBase64(_imagem2!) : null,
            imagem3: _imagem3 != null ? await xFileToBase64(_imagem3!) : null,
            imagem4: _imagem4 != null ? await xFileToBase64(_imagem4!) : null,
            videoProduto: _videoProduto != null
                ? await xFileToBase64(_videoProduto!)
                : null,
            material: _materialController.text.isNotEmpty
                ? _materialController.text
                : null,
            marca:
                _marcaController.text.isNotEmpty ? _marcaController.text : null,
            cor: _corController.text.isNotEmpty ? _corController.text : null,
            caracteristicas: _caracteristicasController.text.isNotEmpty
                ? _caracteristicasController.text
                : null,
            dimensoes: _dimensoesController.text.isNotEmpty
                ? _dimensoesController.text
                : null,
            ocasiao: _ocasiaoController.text.isNotEmpty
                ? _ocasiaoController.text
                : null,
            sobre:
                _sobreController.text.isNotEmpty ? _sobreController.text : null,
            prazoEntrega: _prazoEntregaController.text.isNotEmpty
                ? _prazoEntregaController.text
                : null,
            frete:
                _freteController.text.isNotEmpty ? _freteController.text : null,
            freteGratis: freteGratis,
            origem: _origemController.text.isNotEmpty
                ? _origemController.text
                : null,
            disponivel: disponivel,
            isEletrico: isEletrico,
            consumoEletrico: _consumoEletricoController.text.isNotEmpty
                ? _consumoEletricoController.text
                : null,
            peso: _pesoController.text.isNotEmpty ? _pesoController.text : null,
            validade: _validadeController.text.isNotEmpty
                ? _validadeController.text
                : null,
            informacoesAdicionais:
                _informacoesAdicionaisController.text.isNotEmpty
                    ? _informacoesAdicionaisController.text
                    : null,
            sugestoesDeUso: _sugestoesDeUsoController.text.isNotEmpty
                ? _sugestoesDeUsoController.text
                : null,
            urlFornecedor: _urlFornecedorController.text.isNotEmpty
                ? _urlFornecedorController.text
                : null,
            idFornecedor: _idFornecedorController.text.isNotEmpty
                ? _idFornecedorController.text
                : null,
            parcelamento: _parcelamentoSelecionado.toString(),
            categoriaId: _categoriaSelecionada),
      );

      setState(() => isLoading = false);

      GlobalSnackbar.show('Produto cadastrado com sucesso!');
      _nomeController.clear();
      _valorVendaController.clear();
      _valorCompraController.clear();
      _valorNoPixController.clear();
      _valorComJurosController.clear();
      _valorSemJurosController.clear();
      _lucroSobreVendaController.clear();
      _consumoEletricoController.clear();
      _sugestoesDeUsoController.clear();
      _descricaoController.clear();
      _valorVendaController.clear();
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
      _pesoController.clear();
      _validadeController.clear();
      _informacoesAdicionaisController.clear();
      _urlFornecedorController.clear();
      _idFornecedorController.clear();
      _imagemPrincipal = null;
      _imagem2 = null;
      _imagem3 = null;
      _imagem4 = null;
      _videoProduto = null;
      freteGratis = false;
      disponivel = true;
      _categoriaSelecionada = null;
    } catch (error) {
      setState(() => isLoading = false);
      print('Erro ao cadastrar produto: $error');
      GlobalSnackbar.show(
        'Erro ao cadastrar produto: ${error.toString()}',
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _valorCompraController.dispose();
    _valorNoPixController.dispose();
    _valorComJurosController.dispose();
    _valorSemJurosController.dispose();
    _lucroSobreVendaController.dispose();
    _pesoController.dispose();
    _validadeController.dispose();
    _informacoesAdicionaisController.dispose();
    _sugestoesDeUsoController.dispose();
    _urlFornecedorController.dispose();
    _idFornecedorController.dispose();
    _consumoEletricoController.dispose();
    _descricaoController.dispose();
    _valorVendaController.dispose();
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
    //_categoriaIdController.dispose();
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
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ImagemPickerWidget(
                                    imagem: _imagemPrincipal,
                                    onImagemSelecionada: (xFile) {
                                      setState(() {
                                        _imagemPrincipal = xFile;
                                      });
                                    },
                                    label: 'Imagem Principal',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ImagemPickerWidget(
                                    imagem: _imagem2,
                                    onImagemSelecionada: (xFile) {
                                      setState(() {
                                        _imagem2 = xFile;
                                      });
                                    },
                                    label: 'Imagem 2',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ImagemPickerWidget(
                                    imagem: _imagem3,
                                    onImagemSelecionada: (xFile) {
                                      setState(() {
                                        _imagem3 = xFile;
                                      });
                                    },
                                    label: 'Imagem 3',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ImagemPickerWidget(
                                    imagem: _imagem4,
                                    onImagemSelecionada: (xFile) {
                                      setState(() {
                                        _imagem4 = xFile;
                                      });
                                    },
                                    label: 'Imagem 4',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                'Identificação do produto',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  controller: _nomeController,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        'Nome do Produto',
                                                    prefixIcon: const Icon(
                                                        Icons.label_outline),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12)),
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Informe o nome do produto';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                const SizedBox(height: 8),
                                                DropdownButtonFormField<String>(
                                                  value: _categoriaSelecionada,
                                                  decoration: InputDecoration(
                                                    labelText: 'Categoria',
                                                    prefixIcon: const Icon(Icons
                                                        .category_outlined),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12)),
                                                  ),
                                                  items: categoriaController
                                                      .categorias
                                                      .map((cat) =>
                                                          DropdownMenuItem(
                                                            value: cat.id,
                                                            child:
                                                                Text(cat.nome),
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _categoriaSelecionada =
                                                          value;
                                                    });
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Selecione uma categoria';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _descricaoController,
                                              maxLines: 3,
                                              decoration: InputDecoration(
                                                labelText: 'Descrição',
                                                prefixIcon: const Icon(
                                                    Icons.description_outlined),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Informe a descrição';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Divider(),
                                      Text(
                                        'Fornecedor',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller:
                                                  _urlFornecedorController,
                                              decoration: InputDecoration(
                                                labelText: 'Url do Fornecedor',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: TextFormField(
                                              controller:
                                                  _idFornecedorController,
                                              decoration: InputDecoration(
                                                labelText: 'ID do Fornecedor',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Divider(),
                                      Text(
                                        'Valores',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: _valorVendaController,
                                              decoration: InputDecoration(
                                                labelText: 'Valor de Venda',
                                                prefixIcon: const Icon(Icons
                                                    .attach_money_outlined),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Informe o preço de venda';
                                                }
                                                if (double.tryParse(value) ==
                                                    null) {
                                                  return 'Informe um valor válido';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: TextFormField(
                                              controller:
                                                  _valorCompraController,
                                              decoration: InputDecoration(
                                                labelText: 'Valor de Compra',
                                                prefixIcon: const Icon(Icons
                                                    .monetization_on_outlined),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Informe o preço de compra';
                                                }
                                                if (double.tryParse(value) ==
                                                    null) {
                                                  return 'Informe um valor válido';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _valorNoPixController,
                                              decoration: InputDecoration(
                                                labelText: 'Valor no Pix',
                                                prefixIcon: const Icon(
                                                    Icons.payment_outlined),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Informe o preço no Pix';
                                                }
                                                if (double.tryParse(value) ==
                                                    null) {
                                                  return 'Informe um valor válido';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: TextFormField(
                                              controller:
                                                  _lucroSobreVendaController,
                                              decoration: InputDecoration(
                                                labelText: 'Lucro sobre Venda',
                                                prefixIcon: const Icon(
                                                    Icons.trending_up_outlined),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Informe o lucro sobre venda';
                                                }
                                                if (double.tryParse(value) ==
                                                    null) {
                                                  return 'Informe um valor válido';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _valorComJurosController,
                                    decoration: InputDecoration(
                                      labelText: 'Valor com Juros',
                                      prefixIcon: const Icon(
                                          Icons.money_off_csred_outlined),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Informe o preço com juros';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Informe um valor válido';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: TextFormField(
                                    controller: _valorSemJurosController,
                                    decoration: InputDecoration(
                                      labelText: 'Valor sem Juros',
                                      prefixIcon:
                                          const Icon(Icons.money_off_outlined),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Informe o preço sem juros';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Informe um valor válido';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: DropdownButtonFormField<int>(
                                    value: _parcelamentoSelecionado,
                                    decoration: InputDecoration(
                                      labelText: 'Parcelamento',
                                      prefixIcon:
                                          const Icon(Icons.payments_outlined),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
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
                              ],
                            ),
                            const SizedBox(height: 16),
                            Divider(),
                            Center(
                              child: Text(
                                'Frete e entrega',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 12),
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
                                          value: freteGratis,
                                          onChanged: (value) {
                                            setState(() {
                                              freteGratis = value;
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
                                          value: disponivel,
                                          onChanged: (value) {
                                            setState(() {
                                              disponivel = value;
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
                                          borderRadius:
                                              BorderRadius.circular(12)),
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
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Divider(),
                            Center(
                              child: Text(
                                'Caracteristias do Produto',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text('Elétrico'),
                                      Transform.scale(
                                        scale: 0.8,
                                        child: Switch(
                                          value: isEletrico,
                                          onChanged: (value) {
                                            setState(() {
                                              isEletrico = value;
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
                                    controller: _origemController,
                                    decoration: InputDecoration(
                                      labelText: 'Origem',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _pesoController,
                                    decoration: InputDecoration(
                                      labelText: 'Peso',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _validadeController,
                                    decoration: InputDecoration(
                                      labelText: 'Validade',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
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
                                  child: TextFormField(
                                    controller: _dimensoesController,
                                    decoration: InputDecoration(
                                      labelText: 'Dimensões',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _materialController,
                                    decoration: InputDecoration(
                                      labelText: 'Material',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _marcaController,
                                    decoration: InputDecoration(
                                      labelText: 'Marca',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _consumoEletricoController,
                                    decoration: InputDecoration(
                                      labelText: 'Consumo Elétrico',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
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
                                  child: TextFormField(
                                    controller: _sobreController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: 'Sobre o produto',
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
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _ocasiaoController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: 'Ocasião',
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
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _sugestoesDeUsoController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: 'Sugestões de Uso',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller:
                                        _informacoesAdicionaisController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: 'Informações Adicionais',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _caracteristicasController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: 'Outras Características',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                textStyle: const TextStyle(fontSize: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed:
                                  isLoading ? null : () => cadastrarProduto(),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('Cadastrar Produto'),
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
      },
    );
  }
}
