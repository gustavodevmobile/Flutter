import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noribox_store/components/confirma_pedido.dart';
import 'package:noribox_store/views/produto_detalher.dart';
import 'package:noribox_store/widgets/app_bar.dart';
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
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Widget _buildBase64Image(String base64String,
      {double? height, double? width, BoxFit? fit}) {
    try {
      Uint8List bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        height: height,
        width: width,
        fit: fit,
      );
    } catch (e) {
      return const Icon(Icons.broken_image, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProdutosController>(
      builder: (context, produtosController, child) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: const Color.fromARGB(255, 243, 243, 243),
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(140),
                child: AppBarWidget(),
              ),
              body: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
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
                        final categorias = [
                          {'nome': 'Eletrônicos', 'icone': Icons.devices},
                          {'nome': 'Roupas', 'icone': Icons.checkroom},
                          {'nome': 'Livros', 'icone': Icons.menu_book},
                          {'nome': 'Casa', 'icone': Icons.chair},
                          {'nome': 'Beleza', 'icone': Icons.spa},
                        ];
                        return ListView(
                          shrinkWrap: true,
                          children: [
                            // Categorias
                            Container(
                              height: 100,
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: categorias.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 16),
                                itemBuilder: (context, index) {
                                  final categoria = categorias[index];
                                  return GestureDetector(
                                    onTap: () {
                                      // TODO: Filtrar por categoria
                                    },
                                    child: Container(
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 3,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            categoria['icone'] as IconData,
                                            color: Colors.redAccent,
                                            size: 32,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            categoria['nome'] as String,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).animate().scale(delay: (index * 100).ms);
                                },
                              ),
                            ),

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
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 2,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: produto.imagem.isNotEmpty
                                          ? _buildBase64Image(produto.imagem,
                                              width: 180,
                                              height: 180,
                                              fit: BoxFit.contain)
                                          : const Icon(Icons.shopping_bag,
                                              size: 80, color: Colors.white24),
                                    );
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
                                          ? Colors.deepPurple
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

                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: produtosFiltrados.map((produto) {
                                    return SizedBox(
                                      width: 200, // largura fixa do card
                                      child: CardProduto(
                                        produto: produto,
                                        onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProdutoDetalheScreen(produto: produto)));
                                          //abrirTelaCheckout(context, produto);
                                        },
                                      ),
                                    );
                                  }).toList(),
                                )),
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
            Positioned(
              bottom: 32,
              right: 32,
              child: GestureDetector(
                onTap: (){
                  const url =
                      'https://wa.me/5513996252021?text=Olá! Preciso de ajuda com meu pedido.';
                  // Para web:
                  // ignore: undefined_prefixed_name
                  html.window.open(url, '_blank');
                },
                child: Image.asset('./assets/images/whatsapp_icon.png',
                      height: 45, width: 45),
              ),
              
              
            ),
          ],
        );
      },
    );
  }
}
