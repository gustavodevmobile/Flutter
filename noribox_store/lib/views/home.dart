import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noribox_store/controllers/carrinho_controllers.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/utils/app_snackbar.dart';
import 'package:noribox_store/views/produto_detalhe.dart';
import 'package:noribox_store/widgets/appbar/app_bar_desktop.dart';
import 'package:noribox_store/widgets/appbar/app_bar_mobile.dart';
import 'package:noribox_store/widgets/appbar/app_bar_widget.dart';
import 'package:noribox_store/widgets/box_carrinho.dart';
import 'package:noribox_store/widgets/button_whatsapp.dart';
import 'package:noribox_store/widgets/card_image_products.dart';
import 'package:noribox_store/widgets/card_produto.dart';
import 'package:noribox_store/widgets/footer_widget.dart';
import 'package:provider/provider.dart';
import 'package:noribox_store/controllers/produtos_controllers.dart';
import 'package:noribox_store/models/produtos_models.dart';

class EcommercePage extends StatefulWidget {
  const EcommercePage({super.key});

  @override
  State<EcommercePage> createState() => _EcommercePageState();
}

class _EcommercePageState extends State<EcommercePage> {
  String busca = '';
  int currentSlide = 0;
  bool isAddcarrinho = false;
  late PageController pageController;
  Map<String, int> quantidades = {};

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    // Carregar produtos do carrinho ao iniciar a página
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<CarrinhoController>(context, listen: false)
          .recuperarProdutos();
      // Inicializar quantidades com base nos produtos do carrinho
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    final produtosController =
        Provider.of<ProdutosController>(context, listen: false);
    final carrinhoController =
        Provider.of<CarrinhoController>(context, listen: false);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color.fromARGB(255, 225, 230, 233),
          appBar: PreferredSize(
            preferredSize: ThemesSize.heightAppBar,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: AppBarWidget()
            ),
          ),
          endDrawer: SizedBox(
            width: 300,
            child: const Drawer(
              backgroundColor:Colors.white10,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: BoxCarrinho(),
                ),
              ),
            ),
          ),
          drawer: const Drawer(
            child: BoxCarrinho(),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //   color: Colors.grey.shade300,
                    //   width: 1,
                    // ),
                    color: Themes.greyLight,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Themes.blackShadow,
                        blurRadius: 2,
                        spreadRadius: 0.3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: FutureBuilder<List<Produto>>(
                    future: produtosController.buscarProdutos(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erro: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('Nenhum produto encontrado'));
                      } else {
                        final produtos = snapshot.data!;
                        final produtosFiltrados = busca.isEmpty
                            ? produtos
                            : produtos
                                .where((p) => p.nome
                                    .toLowerCase()
                                    .contains(busca.toLowerCase()))
                                .toList();

                        return ListView(
                          shrinkWrap: true,
                          children: [
                            const SizedBox(height: 16),

                            // Slider de produtos em destaque
                            if (produtos.isNotEmpty) ...[
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Ofertas especiais',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ).animate().fadeIn(delay: 700.ms),
                              const SizedBox(height: 16),
                              Container(
                                height: 400,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 2,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: PageView.builder(
                                  controller: pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      currentSlide = index;
                                    });
                                  },
                                  itemCount: produtos.take(3).length,
                                  itemBuilder: (context, index) {
                                    final produto = produtos[index];
                                    return produto.imagemPrincipal.isNotEmpty
                                        ? CardImageProdutoWidget(
                                            imagemUrl: produto.imagemPrincipal,
                                            width: 300,
                                            height: 300,
                                            fit: BoxFit.contain,
                                          )
                                        : const Icon(Icons.shopping_bag,
                                            size: 80, color: Colors.white24);
                                  },
                                ),
                              ).animate().slideY(delay: 800.ms),
                              const SizedBox(height: 16),

                              // Indicador de slides
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  produtos.take(3).length,
                                  (index) => Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    width: currentSlide == index ? 24 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: currentSlide == index
                                          ? Themes.redPrimary
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  )
                                      .animate()
                                      .scale(delay: (900 + index * 50).ms),
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],

                            // Produtos
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                busca.isEmpty
                                    ? 'Todos os produtos'
                                    : 'Resultados da busca',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ).animate().fadeIn(delay: 1000.ms),
                            const SizedBox(height: 16),
                            buildCardProdutos(
                                    produtosFiltrados, carrinhoController)
                                .animate()
                                .fadeIn(delay: 1200.ms),

                            const SizedBox(height: 32),
                            FooterWidget()
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        ButtonWhatsapp(),
      ],
    );
  }

  Widget buildCardProdutos(
      List<Produto> produtosFiltrados, CarrinhoController carrinhoController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: produtosFiltrados.map((produto) {
          return SizedBox(
            //width: 200, // largura fixa do card
            child: CardProduto(
              produto: produto,
              onTapCard: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProdutoDetalheScreen(produto: produto),
                  ),
                );
                //abrirTelaCheckout(context, produto);
              },
              onQuantidadeChanged: (c) async {
                quantidades[produto.id] = c;
                await carrinhoController.atualizarQuantidade(
                  produto.id,
                  c,
                );
              },
              onTapAddCarinho: () async {
                await carrinhoController.buscarProdutos(produto.id);

                if (carrinhoController.produto == null) {
                  await carrinhoController.adicionarProduto({
                    'id': produto.id,
                    'nome': produto.nome,
                    'descricao': produto.descricao,
                    'preco': produto.valorComJuros,
                    'quantidade': quantidades[produto.id] ?? 1,
                    'peso': produto.peso,
                    'dimensoes': produto.dimensoes,
                    'imagem': produto.imagemPrincipal
                  });

                  if (mounted) {
                    AppSnackbar.show(
                      context,
                      backgroundColor: Themes.green,
                      '${produto.descricao} adicionado ao carrinho',
                      duration: const Duration(seconds: 2),
                    );
                  }
                } else {
                  if (mounted) {
                    AppSnackbar.show(
                      context,
                      backgroundColor: Themes.redTertiary,
                      'Produto já adicionado ao carrinho, ajuste a quantidade.',
                      duration: const Duration(seconds: 2),
                    );
                  }
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
