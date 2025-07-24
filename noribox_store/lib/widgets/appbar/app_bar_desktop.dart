import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noribox_store/controllers/carrinho_controllers.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/views/cadastro_usuario.dart';
import 'package:noribox_store/widgets/box_carrinho.dart';
import 'package:noribox_store/widgets/custom_button.dart';
import 'package:noribox_store/widgets/drop_widgets_menu.dart';
import 'package:provider/provider.dart';

class AppBarWidgetDesktop extends StatefulWidget {
  final bool isMobile;
  const AppBarWidgetDesktop({this.isMobile = false, super.key});

  @override
  State<AppBarWidgetDesktop> createState() => _AppBarWidgetDesktopState();
}

class _AppBarWidgetDesktopState extends State<AppBarWidgetDesktop> {
  String busca = '';
  bool mostrarResumoCarrinho = false;
  bool isCarrinhoOverlayVisible = false;
  OverlayEntry? _overlayEntry;

  void showCarrinhoOverlay(BuildContext context) {
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
              child: BoxCarrinho()),
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

    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: Themes.redPrimary,
            ),
            padding: const EdgeInsets.only(left: 8),
          ).animate().fadeIn(delay: 100.ms),
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
                        prefixIcon: Icon(Icons.search, color: Colors.redAccent),
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
                    onPressed: () {},
                  ),
                ).animate().scale(delay: 400.ms),

                const SizedBox(width: 8),

                // Carrinho

                const SizedBox(width: 8),

                // Entrar
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/loginCliente');
                  },
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                      color: Themes.redPrimary,
                    ),
                  ),
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
              ],
            ),
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Themes.blackLight,
            ),
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                const SizedBox(width: 40),
                if (!widget.isMobile)
                  ...dropdownMenus
                else
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
              ],
            ),
          ).animate().fadeIn(delay: 100.ms)
        ],
      ),
    );
  }
}
