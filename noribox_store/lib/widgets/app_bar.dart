import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noribox_store/controllers/carrinho_controllers.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/views/cadastro_usuario.dart';
import 'package:noribox_store/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  String busca = '';
  bool mostrarResumoCarrinho = false;
  bool isCarrinhoOverlayVisible = false;
  OverlayEntry? _overlayEntry;

  void showCarrinhoOverlay(BuildContext context) {
    final produtoCarrinho =
        Provider.of<CarrinhoController>(context, listen: false);
    if (_overlayEntry != null) return;
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100, // ajuste conforme necessário
        right: 60, // ajuste conforme necessário
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: MouseRegion(
            onEnter: (_) {
              setState(() {
                mostrarResumoCarrinho = true;
              });
            },
            onExit: (_) {
              setState(() {
                mostrarResumoCarrinho = false;
                Future.delayed(const Duration(milliseconds: 100), () {
                  removeCarrinhoOverlay();
                });
              });
            },
            child: Container(
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
                                    leading: CachedNetworkImage(
                                        imageUrl: produtoCarrinho
                                            .produtosId[index]['imagem']),
                                    title: Text(produtoCarrinho
                                        .produtosId[index]['nome']),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${produtoCarrinho.produtosId[index]['descricao']}'),
                                        Text('Quantidade: ${produtoCarrinho.produtosId[index]['quantidade']}'),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Themes.redPrimary,
                                      ),
                                      onPressed: () {
                                        Provider.of<CarrinhoController>(context,
                                                listen: false)
                                            .removerProduto(produtoCarrinho
                                                .produtosId[index]['id']);
                                        removeCarrinhoOverlay();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: CustomButton(
                                backgroundColor: Themes.greyLight,
                                foregroundColor: Colors.black,
                                child: Text('Ver carrinho'),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/carrinho');
                                  // removeCarrinhoOverlay();
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomButton(
                                child: Text('Finalizar'),
                                onPressed: () {},
                              ),
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
            ),
          ),
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void removeCarrinhoOverlay() {
    if (!mostrarResumoCarrinho) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final carrinhoController = Provider.of<CarrinhoController>(context);
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.blueGrey,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                // Título
                Expanded(
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Themes.redPrimary,
                    ),
                    padding: const EdgeInsets.only(left: 8),
                  ).animate().fadeIn(delay: 100.ms),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Logotipo da loja
                  Image.asset(
                    './assets/images/logoAsatomaPeq.png',
                    height: 70,
                    width: 70,
                    fit: BoxFit.contain,
                  ).animate().scale(delay: 200.ms),
                  const SizedBox(width: 16),

                  // Campo de busca
                  Expanded(
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar produtos...',
                          prefixIcon:
                              Icon(Icons.search, color: Colors.redAccent),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        onChanged: (value) {
                          setState(() {
                            busca = value;
                          });
                        },
                      ),
                    ).animate().slideX(delay: 300.ms),
                  ),

                  const SizedBox(width: 12),
                  // Carrinho
                  Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextButton(
                              child: Text(
                                'Pedidos',
                                style: GoogleFonts.aboreto(),
                              ),
                              onPressed: () {}))
                      .animate()
                      .scale(delay: 400.ms),

                  const SizedBox(width: 8),

                  // Carrinho
                  MouseRegion(
                    onEnter: (_) => setState(() {
                      mostrarResumoCarrinho = true;
                      showCarrinhoOverlay(context);
                    }),
                    onExit: (_) {
                      if (!mostrarResumoCarrinho) {
                        setState(() {
                          removeCarrinhoOverlay();
                        });
                      }
                    },
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined,
                              color: Themes.redPrimary),
                          onPressed: () {
                            // TODO: Navegar para carrinho
                          },
                        ),
                        if (carrinhoController.produtosId.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color:Colors.greenAccent,
                              shape: BoxShape.circle,
                            ),
                            child: Consumer<CarrinhoController>(
                                builder: (context, qtd, child) {
                              return Text(
                                '${qtd.produtosId.length}',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12),
                              );
                            }),
                          ),
                      ],
                    ).animate().scale(delay: 400.ms),
                  ),

                  const SizedBox(width: 8),

                  // Entrar
                  TextButton(
                    onPressed: () {
                      // TODO: Navegar para login
                    },
                    child: const Text('Entrar',
                        style: TextStyle(color: Themes.redPrimary)),
                  ).animate().fadeIn(delay: 500.ms),

                  // Cadastrar
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CadastroUsuarioScreen(),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Themes.redPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Cadastrar'),
                  ).animate().fadeIn(delay: 600.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
