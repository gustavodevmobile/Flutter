import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noribox_store/controllers/carrinho_controllers.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class BoxCarrinho extends StatelessWidget {
  const BoxCarrinho({super.key});

  @override
  Widget build(BuildContext context) {
    final produtoCarrinho =
        Provider.of<CarrinhoController>(context, listen: true);
    return Container(
      width: 390,
      //height: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),
      child: produtoCarrinho.produtosId.isNotEmpty
          ? Column(
              children: [
                Text(
                  'Seu carrinho',
                  style: GoogleFonts.aboreto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Themes.redPrimary),
                ),
                const Divider(),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: produtoCarrinho.produtosId.length,
                  itemBuilder: (context, index) {
                    produtoCarrinho.produtosId[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Themes.greyLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListTile(
                            leading: SizedBox(
                              width: 60,
                              height: 60,
                              child: CachedNetworkImage(
                                  imageUrl: produtoCarrinho.produtosId[index]
                                      ['imagem']),
                            ),
                            title:
                                Text(produtoCarrinho.produtosId[index]['nome']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${produtoCarrinho.produtosId[index]['descricao']}'),
                                Text(
                                    'Quantidade: ${produtoCarrinho.produtosId[index]['quantidade']}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                Provider.of<CarrinhoController>(context,
                                        listen: false)
                                    .removerProduto(produtoCarrinho
                                        .produtosId[index]['id']);
                                //removeCarrinhoOverlay();
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    CustomButton(
                      width: double.infinity,
                      backgroundColor: Themes.redPrimary,
                      foregroundColor: Colors.white,
                      child: Text('Ver carrinho'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/carrinho');
                        // removeCarrinhoOverlay();
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            child: Text('Finalizar'),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomButton(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            child: Text('Limpar'),
                            onPressed: () {
                              produtoCarrinho.limparCarrinho();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          : const Center(
              child: Text(
                'Carrinho vazio',
                style: TextStyle(color: Colors.grey),
              ),
            ),
    );
  }
}
