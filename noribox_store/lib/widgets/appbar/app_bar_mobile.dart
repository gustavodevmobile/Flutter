import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noribox_store/controllers/carrinho_controllers.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/views/cadastro_usuario.dart';
import 'package:noribox_store/widgets/custom_button.dart';
import 'package:noribox_store/widgets/custom_dropdown_menu.dart';
import 'package:provider/provider.dart';

class AppBarWidgetMobile extends StatefulWidget {
  final bool isMobile;
  const AppBarWidgetMobile({this.isMobile = false, super.key});

  @override
  State<AppBarWidgetMobile> createState() => _AppBarWidgetMobileState();
}

class _AppBarWidgetMobileState extends State<AppBarWidgetMobile> {
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
              if (context.mounted) {
                setState(() {
                  mostrarResumoCarrinho = true;
                });
              }
            },
            onExit: (_) {
              if (context.mounted) {
                setState(() {
                  mostrarResumoCarrinho = false;
                });
                Future.delayed(const Duration(milliseconds: 100), () {
                  removeCarrinhoOverlay();
                });
              }
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
                                          imageUrl: produtoCarrinho
                                              .produtosId[index]['imagem']),
                                    ),
                                    title: Text(produtoCarrinho
                                        .produtosId[index]['nome']),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${produtoCarrinho.produtosId[index]['descricao']}'),
                                        Text(
                                          'Quantidade: ${produtoCarrinho.produtosId[index]['quantidade']}',
                                        ),
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
    final double widthScreen = MediaQuery.of(context).size.width;
    return SafeArea(
      child: widthScreen < 1100 && widthScreen > 700
          ? buildScreenTablet(context, widthScreen)
          : buildScreenMobile(context, widthScreen),
    );
  }

  Widget buildScreenTablet(BuildContext context, double widthScreen) {
    final carrinhoController = Provider.of<CarrinhoController>(context);
    return Column(
      children: [
        Container(
          height: 30,
          decoration: BoxDecoration(
            color: Themes.redPrimary,
          ),
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 4),
              VerticalDivider(),
              const SizedBox(width: 4),
              Text(
                'Quem somos',
                style: GoogleFonts.aboreto(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              VerticalDivider(),
              const SizedBox(width: 4),
              Text(
                'Contato',
                style: GoogleFonts.aboreto(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              VerticalDivider(),
              const SizedBox(width: 4),
              Text(
                'Sugestões',
                style: GoogleFonts.aboreto(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ).animate().fadeIn(delay: 100.ms),
        Row(
          children: [
            const SizedBox(width: 16),
            Image.asset(
              './assets/images/logoAsatomaPeq.png',
              height: 90,
              width: 90,
              fit: BoxFit.contain,
            ).animate().scale(delay: 200.ms),

            // Carrinho
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: TextButton(
            //     child: Text(
            //       'Pedidos',
            //       style: GoogleFonts.aboreto(),
            //     ),
            //     onPressed: () {},
            //   ),
            // ).animate().scale(delay: 400.ms),

            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/loginCliente');
              },
              child: Text(
                'Entrar',
                style: GoogleFonts.aboreto(
                  color: Themes.redPrimary,
                  fontSize: 16,
                ),
              ),
            ).animate().fadeIn(delay: 500.ms),

            // Cadastrar
            CustomButton(
              backgroundColor: Themes.redPrimary,
              child: Text('Cadastrar'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CadastroUsuarioScreen(),
                  ),
                );
              },
            ).animate().fadeIn(delay: 600.ms),
            const SizedBox(width: 8),

            MouseRegion(
              onEnter: (_) => setState(() {
                //Scaffold.of(context).openEndDrawer();
                // mostrarResumoCarrinho = true;
                showCarrinhoOverlay(context);
              }),
              onExit: (_) {
                if (context.mounted) {
                  if (!mostrarResumoCarrinho) {
                    setState(() {
                      removeCarrinhoOverlay();
                    });
                  }
                }
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Themes.redPrimary,
                      size: 30,
                    ),
                    onPressed: () {
                      // TODO: Navegar para carrinho
                    },
                  ),
                  if (carrinhoController.produtosId.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Consumer<CarrinhoController>(
                        builder: (context, qtd, child) {
                          return Text(
                            '${qtd.produtosId.length}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ).animate().scale(delay: 400.ms),
            ),
            const SizedBox(width: 24),

            // Entrar
          ],
        ),
        Spacer(),
        Container(
            height: 60,
            decoration: BoxDecoration(
              color: Themes.blackLight,
            ),
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                ),
                const SizedBox(width: 20),
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
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.redAccent,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          busca = value;
                        });
                      },
                    ),
                  ).animate().slideX(delay: 300.ms),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  child: Row(
                    children: [
                      CustomDropdownMenu(
                        menuIndex: 0,
                        dxOffset: -20,
                        categoria: 'Cozinha',
                        subCategorias: ['Folha inteira', 'Meia folha'],
                        onSelected: (sub) {
                          // ação ao selecionar subcategoria
                        },
                        //backgroundColor: Themes.white,
                        textColorSubCategoria: Themes.blackLight,
                        textColorCategoria: Themes.white,

                        //icon: Icon(Icons.shopping_bag, color: Colors.white),
                      ),
                      const SizedBox(width: 24),
                      CustomDropdownMenu(
                        menuIndex: 1,
                        dxOffset: -8,
                        categoria: 'SushiBar',
                        subCategorias: ['Folha inteira', 'Meia folha'],
                        onSelected: (sub) {
                          // ação ao selecionar subcategoria
                        },
                        //backgroundColor: Themes.white,
                        textColorSubCategoria: Themes.blackLight,
                        textColorCategoria: Themes.white,

                        //icon: Icon(Icons.shopping_bag, color: Colors.white),
                      ),
                      const SizedBox(width: 24),
                      CustomDropdownMenu(
                        menuIndex: 2,
                        dxOffset: -20,
                        categoria: 'Salão',
                        subCategorias: ['Folha inteira', 'Meia folha'],
                        onSelected: (sub) {
                          // ação ao selecionar subcategoria
                        },
                        //backgroundColor: Themes.white,
                        textColorSubCategoria: Themes.blackLight,
                        textColorCategoria: Themes.white,

                        //icon: Icon(Icons.shopping_bag, color: Colors.white),
                      ),
                      const SizedBox(width: 24),
                      CustomDropdownMenu(
                        menuIndex: 3,
                        dxOffset: -20,
                        categoria: 'Caixa',
                        subCategorias: ['Folha inteira', 'Meia folha'],
                        onSelected: (sub) {
                          // ação ao selecionar subcategoria
                        },
                        //backgroundColor: Themes.white,
                        textColorSubCategoria: Themes.blackLight,
                        textColorCategoria: Themes.white,

                        //icon: Icon(Icons.shopping_bag, color: Colors.white),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                )
              ],
            )).animate().fadeIn(delay: 100.ms)
      ],
    );
  }

  Widget buildScreenMobile(BuildContext context, double widthScreen) {
    final carrinhoController = Provider.of<CarrinhoController>(context);
    return Column(
      children: [
        Container(
          height: 30,
          decoration: BoxDecoration(
            color: Themes.redPrimary,
          ),
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 4),
              VerticalDivider(),
              const SizedBox(width: 4),
              Text(
                'Quem somos',
                style: GoogleFonts.aboreto(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              VerticalDivider(),
              const SizedBox(width: 4),
              Text(
                'Contato',
                style: GoogleFonts.aboreto(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              VerticalDivider(),
              const SizedBox(width: 4),
              Text(
                'Sugestões',
                style: GoogleFonts.aboreto(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ).animate().fadeIn(delay: 100.ms),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Themes.blackLight,
                  size: 30,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                  print('Abrindo menu');
                },
              ).animate().fadeIn(delay: 300.ms),

              Image.asset(
                './assets/images/logoAsatomaPeq.png',
                height: 90,
                width: 90,
                fit: BoxFit.contain,
              ).animate().scale(delay: 200.ms),

              Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Themes.redPrimary,
                      size: 30,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                      print('Abrindo carrinho');
                    },
                  ),
                  if (carrinhoController.produtosId.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Consumer<CarrinhoController>(
                        builder: (context, qtd, child) {
                          return Text(
                            '${qtd.produtosId.length}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ).animate().scale(delay: 400.ms),

              // Entrar
            ],
          ),
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Themes.blackLight,
          ),
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
              const SizedBox(width: 16),
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
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.redAccent,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        busca = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ).animate().fadeIn(delay: 100.ms),
      ],
    );
  }
}
