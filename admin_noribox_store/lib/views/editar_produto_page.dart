import 'dart:convert';
import 'dart:typed_data';

import 'package:admin_noribox_store/controllers/produto_controller.dart';
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
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late TextEditingController _valorController;
  String? _imagemBase64;
  Uint8List? _imagemBytes;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.produto.nome);
    _descricaoController =
        TextEditingController(text: widget.produto.descricao);
    _valorController =
        TextEditingController(text: widget.produto.valor.toString());
    _imagemBase64 = widget.produto.imagem;
    if (_imagemBase64 != null && _imagemBase64!.isNotEmpty) {
      try {
        _imagemBytes = base64Decode(_imagemBase64!);
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imagemBytes = bytes;
        _imagemBase64 = base64Encode(bytes);
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final produtoEditado = Produto(
        id: widget.produto.id,
        nome: _nomeController.text.trim(),
        descricao: _descricaoController.text.trim(),
        valor: double.tryParse(_valorController.text.trim()) ?? 0.0,
        imagem: _imagemBase64 ?? '',
      );
      // Aqui você pode criar um método editarProdutoController no seu controller
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
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Informe o nome' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descricaoController,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Informe a descrição' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _valorController,
                    decoration: const InputDecoration(labelText: 'Valor'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Informe o valor';
                      final valor = double.tryParse(v);
                      if (valor == null || valor <= 0) return 'Valor inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _pickImage,
                    child: _imagemBytes != null
                        ? Image.memory(_imagemBytes!, height: 120)
                        : Container(
                            height: 120,
                            color: Colors.grey[200],
                            child:
                                const Center(child: Text('Selecionar Imagem')),
                          ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loading ? null : _salvar,
                    child: _loading
                        ? const CircularProgressIndicator()
                        : const Text('Salvar Alterações'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
