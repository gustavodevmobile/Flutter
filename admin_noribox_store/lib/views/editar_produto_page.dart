import 'dart:convert';
import 'dart:typed_data';

import 'package:admin_noribox_store/components/to_base64.dart';
import 'package:admin_noribox_store/controllers/produto_controller.dart';
import 'package:admin_noribox_store/models/categoria.dart';
import 'package:admin_noribox_store/models/produto.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditarProdutoPage extends StatefulWidget {
  final Produto produto;
  const EditarProdutoPage({required this.produto, super.key});

  @override
  State<EditarProdutoPage> createState() => _EditarProdutoPageState();
}

class _EditarProdutoPageState extends State<EditarProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  // Controllers para todos os campos
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late TextEditingController _valorVendaController;
  late TextEditingController _valorCompraController;
  late TextEditingController _valorNoPixController;
  late TextEditingController _valorComJurosController;
  late TextEditingController _valorSemJurosController;
  late TextEditingController _lucroSobreVendaController;
  late TextEditingController _materialController;
  late TextEditingController _marcaController;
  late TextEditingController _corController;
  late TextEditingController _caracteristicasController;
  late TextEditingController _dimensoesController;
  late TextEditingController _ocasiaoController;
  late TextEditingController _sobreController;
  late TextEditingController _prazoEntregaController;
  late TextEditingController _freteController;
  late TextEditingController _origemController;
  late TextEditingController _consumoEletricoController;
  late TextEditingController _pesoController;
  late TextEditingController _validadeController;
  late TextEditingController _informacoesAdicionaisController;
  late TextEditingController _sugestoesDeUsoController;
  late TextEditingController _urlFornecedorController;
  late TextEditingController _idFornecedorController;
  late TextEditingController _parcelamentoController;

  // Imagens
  String? _imagemPrincipalBase64;
  String? _imagem2Base64;
  String? _imagem3Base64;
  String? _imagem4Base64;
  Uint8List? _imagemPrincipalBytes;
  Uint8List? _imagem2Bytes;
  Uint8List? _imagem3Bytes;
  Uint8List? _imagem4Bytes;
  XFile? _imagemPrincipalFile;
  XFile? _imagem2File;
  XFile? _imagem3File;
  XFile? _imagem4File;

  // Switches e dropdowns
  bool _freteGratis = false;
  bool _disponivel = true;
  bool _isEletrico = false;
  String? _categoriaId;
  String? _categoriaNome;
  Categoria? _categoriaSelecionada;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.produto;
    _nomeController = TextEditingController(text: p.nome);
    _descricaoController = TextEditingController(text: p.descricao);
    _valorVendaController =
        TextEditingController(text: p.valorVenda.toString());
    _valorCompraController =
        TextEditingController(text: p.valorCompra?.toString() ?? '');
    _valorNoPixController =
        TextEditingController(text: p.valorNoPix?.toString() ?? '');
    _valorComJurosController =
        TextEditingController(text: p.valorComJuros?.toString() ?? '');
    _valorSemJurosController =
        TextEditingController(text: p.valorSemJuros?.toString() ?? '');
    _lucroSobreVendaController =
        TextEditingController(text: p.lucroSobreVenda?.toString() ?? '');
    _materialController = TextEditingController(text: p.material ?? '');
    _marcaController = TextEditingController(text: p.marca ?? '');
    _corController = TextEditingController(text: p.cor ?? '');
    _caracteristicasController =
        TextEditingController(text: p.caracteristicas ?? '');
    _dimensoesController = TextEditingController(text: p.dimensoes ?? '');
    _ocasiaoController = TextEditingController(text: p.ocasiao ?? '');
    _sobreController = TextEditingController(text: p.sobre ?? '');
    _prazoEntregaController = TextEditingController(text: p.prazoEntrega ?? '');
    _freteController = TextEditingController(text: p.frete ?? '');
    _origemController = TextEditingController(text: p.origem ?? '');
    _consumoEletricoController =
        TextEditingController(text: p.consumoEletrico ?? '');
    _pesoController = TextEditingController(text: p.peso ?? '');
    _validadeController = TextEditingController(text: p.validade ?? '');
    _informacoesAdicionaisController =
        TextEditingController(text: p.informacoesAdicionais ?? '');
    _sugestoesDeUsoController =
        TextEditingController(text: p.sugestoesDeUso ?? '');
    _urlFornecedorController =
        TextEditingController(text: p.urlFornecedor ?? '');
    _idFornecedorController = TextEditingController(text: p.idFornecedor ?? '');
    _parcelamentoController = TextEditingController(text: p.parcelamento ?? '');
    // Imagens
    _imagemPrincipalBase64 = p.imagemPrincipal;
    _imagem2Base64 = p.imagem2;
    _imagem3Base64 = p.imagem3;
    _imagem4Base64 = p.imagem4;
    try {
      if (_imagemPrincipalBase64 != null &&
          _imagemPrincipalBase64!.isNotEmpty) {
        _imagemPrincipalBytes = base64Decode(_imagemPrincipalBase64!);
      }
      if (_imagem2Base64 != null && _imagem2Base64!.isNotEmpty) {
        _imagem2Bytes = base64Decode(_imagem2Base64!);
      }
      if (_imagem3Base64 != null && _imagem3Base64!.isNotEmpty) {
        _imagem3Bytes = base64Decode(_imagem3Base64!);
      }
      if (_imagem4Base64 != null && _imagem4Base64!.isNotEmpty) {
        _imagem4Bytes = base64Decode(_imagem4Base64!);
      }
    } catch (_) {}
    _freteGratis = p.freteGratis;
    _disponivel = p.disponivel;
    _isEletrico = p.isEletrico;
    _categoriaId = p.categoriaId;
    _categoriaSelecionada = p.categoria;
    _categoriaNome = p.categoria?.nome;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _valorVendaController.dispose();
    _valorCompraController.dispose();
    _valorNoPixController.dispose();
    _valorComJurosController.dispose();
    _valorSemJurosController.dispose();
    _lucroSobreVendaController.dispose();
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
    _consumoEletricoController.dispose();
    _pesoController.dispose();
    _validadeController.dispose();
    _informacoesAdicionaisController.dispose();
    _sugestoesDeUsoController.dispose();
    _urlFornecedorController.dispose();
    _idFornecedorController.dispose();
    _parcelamentoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        switch (index) {
          case 0:
            _imagemPrincipalBytes = bytes;
            _imagemPrincipalBase64 = base64Encode(bytes);
            _imagemPrincipalFile = pickedFile;
            break;
          case 1:
            _imagem2Bytes = bytes;
            _imagem2Base64 = base64Encode(bytes);
            _imagem2File = pickedFile;
            break;
          case 2:
            _imagem3Bytes = bytes;
            _imagem3Base64 = base64Encode(bytes);
            _imagem3File = pickedFile;
            break;
          case 3:
            _imagem4Bytes = bytes;
            _imagem4Base64 = base64Encode(bytes);
            _imagem4File = pickedFile;
            break;
        }
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()){}
    setState(() => _loading = true);
    
    if (_imagemPrincipalFile != null) {
      _imagemPrincipalBase64 = await xFileToBase64(_imagemPrincipalFile!);
    }
    if (_imagem2File != null) {
      _imagem2Base64 = await xFileToBase64(_imagem2File!);
    }
    if (_imagem3File != null) {
      _imagem3Base64 = await xFileToBase64(_imagem3File!);
    }
    if (_imagem4File != null) {
      _imagem4Base64 = await xFileToBase64(_imagem4File!);
    }
    try {
      final produtoEditado = Produto(
        id: widget.produto.id,
        nome: _nomeController.text.trim(),
        valorCompra: double.tryParse(_valorCompraController.text.trim()),
        valorVenda: double.tryParse(_valorVendaController.text.trim()) ?? 0.0,
        valorNoPix: double.tryParse(_valorNoPixController.text.trim()),
        valorComJuros: double.tryParse(_valorComJurosController.text.trim()),
        valorSemJuros: double.tryParse(_valorSemJurosController.text.trim()),
        lucroSobreVenda:
            double.tryParse(_lucroSobreVendaController.text.trim()),
        descricao: _descricaoController.text.trim(),
        imagemPrincipal: _imagemPrincipalFile != null
            ? _imagemPrincipalBase64 ?? ''
            : widget.produto.imagemPrincipal,
        imagem2: _imagem2File != null ? _imagem2Base64 : widget.produto.imagem2,
        imagem3: _imagem3File != null ? _imagem3Base64 : widget.produto.imagem3,
        imagem4: _imagem4File != null ? _imagem4Base64 : widget.produto.imagem4,
        material: _materialController.text.trim(),
        marca: _marcaController.text.trim(),
        cor: _corController.text.trim(),
        caracteristicas: _caracteristicasController.text.trim(),
        dimensoes: _dimensoesController.text.trim(),
        ocasiao: _ocasiaoController.text.trim(),
        sobre: _sobreController.text.trim(),
        prazoEntrega: _prazoEntregaController.text.trim(),
        frete: _freteController.text.trim(),
        freteGratis: _freteGratis,
        origem: _origemController.text.trim(),
        disponivel: _disponivel,
        isEletrico: _isEletrico,
        consumoEletrico: _consumoEletricoController.text.trim(),
        peso: _pesoController.text.trim(),
        validade: _validadeController.text.trim(),
        informacoesAdicionais: _informacoesAdicionaisController.text.trim(),
        sugestoesDeUso: _sugestoesDeUsoController.text.trim(),
        urlFornecedor: _urlFornecedorController.text.trim(),
        idFornecedor: _idFornecedorController.text.trim(),
        parcelamento: _parcelamentoController.text.trim(),
        categoriaId: _categoriaId,
        categoria: _categoriaSelecionada,
      );
      await Provider.of<ProdutoController>(context, listen: false)
          .editarProdutoController(produtoEditado);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao editar produto: $e')),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Produto')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nomeController,
                          decoration: const InputDecoration(labelText: 'Nome'),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Informe o nome' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _descricaoController,
                          decoration:
                              const InputDecoration(labelText: 'Descrição'),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Informe a descrição'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _valorVendaController,
                          decoration:
                              const InputDecoration(labelText: 'Valor Venda'),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Informe o valor';
                            }
                            final valor = double.tryParse(v);
                            if (valor == null || valor <= 0) {
                              return 'Valor inválido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _valorCompraController,
                          decoration:
                              const InputDecoration(labelText: 'Valor Compra'),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _valorNoPixController,
                          decoration:
                              const InputDecoration(labelText: 'Valor Pix'),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
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
                          decoration: const InputDecoration(
                              labelText: 'Valor c/ Juros'),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _valorSemJurosController,
                          decoration: const InputDecoration(
                              labelText: 'Valor s/ Juros'),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _lucroSobreVendaController,
                          decoration:
                              const InputDecoration(labelText: 'Lucro Venda'),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _materialController,
                          decoration:
                              const InputDecoration(labelText: 'Material'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _marcaController,
                          decoration: const InputDecoration(labelText: 'Marca'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _corController,
                          decoration: const InputDecoration(labelText: 'Cor'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _caracteristicasController,
                    decoration:
                        const InputDecoration(labelText: 'Características'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _dimensoesController,
                          decoration:
                              const InputDecoration(labelText: 'Dimensões'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _ocasiaoController,
                          decoration:
                              const InputDecoration(labelText: 'Ocasião'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _sobreController,
                    decoration: const InputDecoration(labelText: 'Sobre'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _prazoEntregaController,
                          decoration:
                              const InputDecoration(labelText: 'Prazo Entrega'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _freteController,
                          decoration: const InputDecoration(labelText: 'Frete'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _origemController,
                          decoration:
                              const InputDecoration(labelText: 'Origem'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _consumoEletricoController,
                          decoration: const InputDecoration(
                              labelText: 'Consumo Elétrico'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _pesoController,
                          decoration: const InputDecoration(labelText: 'Peso'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _validadeController,
                          decoration:
                              const InputDecoration(labelText: 'Validade'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _informacoesAdicionaisController,
                    decoration:
                        const InputDecoration(labelText: 'Info. Adicionais'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _sugestoesDeUsoController,
                    decoration:
                        const InputDecoration(labelText: 'Sugestões de Uso'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _urlFornecedorController,
                          decoration: const InputDecoration(
                              labelText: 'URL Fornecedor'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _idFornecedorController,
                          decoration:
                              const InputDecoration(labelText: 'ID Fornecedor'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _parcelamentoController,
                    decoration:
                        const InputDecoration(labelText: 'Parcelamento'),
                  ),
                  const SizedBox(height: 16),
                  //Imagens
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                            onTap: () => _pickImage(0),
                            child: _imagemPrincipalBytes != null
                                ? Image.memory(_imagemPrincipalBytes!,
                                    height: 80)
                                : widget.produto.imagemPrincipal.isNotEmpty
                                    ? Image.network(
                                        widget.produto.imagemPrincipal,
                                        height: 80)
                                    : Container(
                                        height: 80,
                                        color: Colors.grey[200],
                                        child: const Center(
                                            child: Text('Imagem Principal')),
                                      )),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                          child: GestureDetector(
                        onTap: () => _pickImage(1),
                        child: _imagem2Bytes != null
                            ? Image.memory(_imagem2Bytes!, height: 80)
                            : (widget.produto.imagem2 ?? '').isNotEmpty
                                ? Image.network(widget.produto.imagem2!,
                                    height: 80)
                                : Container(
                                    height: 80,
                                    color: Colors.grey[200],
                                    child:
                                        const Center(child: Text('Imagem 2')),
                                  ),
                      )),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickImage(2),
                          child: _imagem3Bytes != null
                              ? Image.memory(_imagem3Bytes!, height: 80)
                              : (widget.produto.imagem3 ?? '').isNotEmpty
                                  ? Image.network(widget.produto.imagem3!,
                                      height: 80)
                                  : Container(
                                      height: 80,
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Text('Imagem 3'),
                                      ),
                                    ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickImage(3),
                          child: _imagem4Bytes != null
                              ? Image.memory(_imagem4Bytes!, height: 80)
                              : (widget.produto.imagem4 ?? '').isNotEmpty
                                  ? Image.network(widget.produto.imagem4!,
                                      height: 80)
                                  : Container(
                                      height: 80,
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Text('Imagem 4'),
                                      ),
                                    ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  //Switches
                  Row(
                    children: [
                      Expanded(
                        child: SwitchListTile(
                          title: const Text('Frete Grátis'),
                          value: _freteGratis,
                          onChanged: (v) => setState(() => _freteGratis = v),
                        ),
                      ),
                      Expanded(
                        child: SwitchListTile(
                          title: const Text('Disponível'),
                          value: _disponivel,
                          onChanged: (v) => setState(() => _disponivel = v),
                        ),
                      ),
                      Expanded(
                        child: SwitchListTile(
                          title: const Text('Elétrico'),
                          value: _isEletrico,
                          onChanged: (v) => setState(() => _isEletrico = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Categoria (dropdown)
                  _categoriaNome != null
                      ? Text('Categoria: $_categoriaNome')
                      : const Text('Categoria não definida'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loading ? null : _salvar,
                    child: _loading
                        ? const CircularProgressIndicator()
                        : const Text('Salvar Alterações'),
                  ),
                ], // Fim dos filhos do ListView
              ), // Fim do ListView
            ), // Fim do Form
          ), // Fim do Padding
        ), // Fim do ConstrainedBox
      ), // Fim do Center
    ); // Fim do Scaffold
  }
}
