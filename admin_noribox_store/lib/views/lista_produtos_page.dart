import 'package:admin_noribox_store/controllers/produto_controller.dart';
import 'package:admin_noribox_store/views/editar_produto_page.dart';
//import 'package:admin_noribox_store/views/detalhe_produto_page.dart';
import 'package:admin_noribox_store/widgets/global_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListaProdutosPage extends StatefulWidget {
  const ListaProdutosPage({super.key});

  @override
  State<ListaProdutosPage> createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProdutoController>(
      builder: (context, produtosController, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Produtos Cadastrados'),
          ),
          body: Scrollbar(
            thumbVisibility: true,
            controller: _horizontalController,
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                controller: _verticalController,
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: DataTable(
                    dataRowMinHeight: 80,
                    dataRowMaxHeight: 100, 
                    columns: const [
                      DataColumn(label: Text('Imagem')),
                      DataColumn(label: Text('Nome')),
                      DataColumn(label: Text('Valor Compra')),
                      DataColumn(label: Text('Valor Venda')),
                      DataColumn(label: Text('Valor Pix')),
                      DataColumn(label: Text('Valor c/ Juros')),
                      DataColumn(label: Text('Valor s/ Juros')),
                      DataColumn(label: Text('Lucro Venda')),
                      DataColumn(label: Text('Descrição')),
                      DataColumn(label: Text('Material')),
                      DataColumn(label: Text('Marca')),
                      DataColumn(label: Text('Cor')),
                      DataColumn(label: Text('Características')),
                      DataColumn(label: Text('Dimensões')),
                      DataColumn(label: Text('Ocasião')),
                      DataColumn(label: Text('Sobre')),
                      DataColumn(label: Text('Prazo Entrega')),
                      DataColumn(label: Text('Frete')),
                      DataColumn(label: Text('Frete Grátis')),
                      DataColumn(label: Text('Origem')),
                      DataColumn(label: Text('Disponível')),
                      DataColumn(label: Text('Elétrico')),
                      DataColumn(label: Text('Consumo Elétrico')),
                      DataColumn(label: Text('Peso')),
                      DataColumn(label: Text('Validade')),
                      DataColumn(label: Text('Info. Adicionais')),
                      DataColumn(label: Text('Sugestões de Uso')),
                      DataColumn(label: Text('URL Fornecedor')),
                      DataColumn(label: Text('ID Fornecedor')),
                      DataColumn(label: Text('Parcelamento')),
                      DataColumn(label: Text('Categoria')),
                      DataColumn(label: Text('Editar')),
                      DataColumn(label: Text('Deletar')),
                    ],
                    rows: produtosController.produtos.map((produto) {
                      return DataRow(
                        onSelectChanged: (selected) {
                          if (selected == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditarProdutoPage(produto: produto),
                              ),
                            );
                          }
                        },
                        cells: [
                          DataCell(
                            produto.imagemPrincipal.isNotEmpty
                                ? SizedBox(
                                    child: Image.network(
                                      produto.imagemPrincipal,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                            Icons.image_not_supported);
                                      },
                                    ),
                                  )
                                : const Icon(Icons.image_not_supported),
                          ),
                          DataCell(Text(produto.nome)),
                          DataCell(Text(
                              produto.valorCompra?.toStringAsFixed(2) ?? '-')),
                          DataCell(Text(produto.valorVenda.toStringAsFixed(2))),
                          DataCell(Text(
                              produto.valorNoPix?.toStringAsFixed(2) ?? '-')),
                          DataCell(Text(
                              produto.valorComJuros?.toStringAsFixed(2) ??
                                  '-')),
                          DataCell(Text(
                              produto.valorSemJuros?.toStringAsFixed(2) ??
                                  '-')),
                          DataCell(Text(
                              produto.lucroSobreVenda?.toStringAsFixed(2) ??
                                  '-')),
                          DataCell(SizedBox(
                              width: 120,
                              child: Text(produto.descricao,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis))),
                          DataCell(Text(produto.material ?? '-')),
                          DataCell(Text(produto.marca ?? '-')),
                          DataCell(Text(produto.cor ?? '-')),
                          DataCell(Text(produto.caracteristicas ?? '-')),
                          DataCell(Text(produto.dimensoes ?? '-')),
                          DataCell(Text(produto.ocasiao ?? '-')),
                          DataCell(SizedBox(
                              width: 100,
                              child: Text(produto.sobre ?? '-',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis))),
                          DataCell(Text(produto.prazoEntrega ?? '-')),
                          DataCell(Text(produto.frete ?? '-')),
                          DataCell(Icon(
                              produto.freteGratis ? Icons.check : Icons.close,
                              color: produto.freteGratis
                                  ? Colors.green
                                  : Colors.red)),
                          DataCell(Text(produto.origem ?? '-')),
                          DataCell(Icon(
                              produto.disponivel ? Icons.check : Icons.close,
                              color: produto.disponivel
                                  ? Colors.green
                                  : Colors.red)),
                          DataCell(Icon(
                              produto.isEletrico
                                  ? Icons.electric_bolt
                                  : Icons.close,
                              color: produto.isEletrico
                                  ? Colors.amber
                                  : Colors.grey)),
                          DataCell(Text(produto.consumoEletrico ?? '-')),
                          DataCell(Text(produto.peso ?? '-')),
                          DataCell(Text(produto.validade ?? '-')),
                          DataCell(Text(produto.informacoesAdicionais ?? '-')),
                          DataCell(Text(produto.sugestoesDeUso ?? '-')),
                          DataCell(Text(produto.urlFornecedor ?? '-')),
                          DataCell(Text(produto.idFornecedor ?? '-')),
                          DataCell(Text(produto.parcelamento ?? '-')),
                          DataCell(Text(produto.categoria?.nome ?? '-')),
                          DataCell(IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditarProdutoPage(produto: produto),
                                ),
                              );
                            },
                          )),
                          DataCell(IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              try {
                                await produtosController
                                    .deletarProdutoController(produto.id!);
                                // Exibe Snackbar globalmente, sem depender do contexto local
                                GlobalSnackbar.show(
                                    'Produto ${produto.nome} deletado com sucesso');
                              } on Exception catch (e) {
                                print(e);
                                GlobalSnackbar.show(e.toString());
                              } catch (e) {
                                GlobalSnackbar.show('Erro: $e');
                              }
                            },
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }
}

// Noribox utilizada para garantir a qualidade do nori (alga marinha), deixando-as crocantes e realçando seu frescor e textura.

// Ao iniciar as atividades com o nori, passe as folhas de baixo para cima, assim você garante noris frescos e crocantes.
