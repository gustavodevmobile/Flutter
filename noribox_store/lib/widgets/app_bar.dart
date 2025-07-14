import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noribox_store/themes/themes.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  String busca = '';
  @override
  Widget build(BuildContext context) {
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
                      color:Themes.redSecondary,
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
                    './assets/images/logo_pequena.png',
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
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined,
                          color: Colors.redAccent),
                      onPressed: () {
                        // TODO: Navegar para carrinho
                      },
                    ),
                  ).animate().scale(delay: 400.ms),

                  const SizedBox(width: 8),

                  // Entrar
                  TextButton(
                    onPressed: () {
                      // TODO: Navegar para login
                    },
                    child: const Text('Entrar',
                        style: TextStyle(color: Colors.redAccent)),
                  ).animate().fadeIn(delay: 500.ms),

                  // Cadastrar
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navegar para cadastro
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
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
