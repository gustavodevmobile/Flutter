import 'dart:convert';
import 'package:admin_noribox_store/controllers/produto_controller.dart';
import 'package:admin_noribox_store/views/editar_produto_page.dart';
import 'package:admin_noribox_store/widgets/global_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListaProdutosPage extends StatefulWidget {
  const ListaProdutosPage({super.key});

  @override
  State<ListaProdutosPage> createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProdutoController>(
      builder: (context, produtosController, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Produtos Cadastrados'),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Imagem')),
                DataColumn(label: Text('Nome')),
                DataColumn(label: Text('Preço')),
                DataColumn(label: Text('Descrição')),
                DataColumn(label: Text('Editar')),
                DataColumn(label: Text('Deletar')),
              ],
              rows: produtosController.produtos.map((produto) {
                return DataRow(cells: [
                  DataCell(
                    produto.imagem.isNotEmpty
                        ? SizedBox(
                            width: 40,
                            height: 40,
                            child: produto.imagem.startsWith('http')
                                ? Image.network(produto.imagem,
                                    fit: BoxFit.cover)
                                : Image.memory(
                                    // Se for base64, decodifique
                                    produto.imagem.contains(',')
                                        ? base64Decode(
                                            produto.imagem.split(',').last)
                                        : base64Decode(produto.imagem),
                                    fit: BoxFit.cover,
                                  ),
                          )
                        : const Icon(Icons.image_not_supported),
                  ),
                  DataCell(Text(produto.nome)),
                  DataCell(Text('R\$ ${produto.valor.toStringAsFixed(2)}')),
                  DataCell(Text(produto.descricao)),
                  DataCell(IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditarProdutoPage(produto: produto),
                          ));
                    },
                  )),
                  DataCell(IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      try {
                        await produtosController
                            .deletarProdutoController(produto.id!);
                        GlobalSnackbar.show(
                            'Produto ${produto.nome} deletado com sucesso');
                        //setState(() {});
                      } on Exception catch (e) {
                        print(e);
                        GlobalSnackbar.show(e.toString());
                      } catch (e) {
                        GlobalSnackbar.show('Erro: $e');
                      }
                    },
                  )),
                ]);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
