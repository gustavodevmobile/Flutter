import 'dart:convert';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter/material.dart';
import 'package:noribox_store/models/produtos_models.dart';
import 'package:noribox_store/widgets/contador_quantidade.dart';

class ProdutoDetalheScreen extends StatelessWidget {
  final Produto produto;
  const ProdutoDetalheScreen({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    final pastelBg = const Color(0xFFF8F6F1);
    final pastelCard = const Color(0xFFFFFFFF);
    final pastelPrimary = const Color(0xFF912A23);
    final pastelSecondary = const Color(0xFFB6AFA9);
    final pastelShadow = Colors.black12;
    return Scaffold(
      backgroundColor: pastelBg,
      appBar: AppBar(
        backgroundColor: pastelBg,
        elevation: 0,
        iconTheme: IconThemeData(color: pastelPrimary),
        title: Text(
          produto.nome,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: pastelCard,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: pastelShadow,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (produto.imagem.isNotEmpty)
                              CardImageProdutoWidget(
                                width: 100,
                                height: 100,
                                imagemBase64: produto.imagem,
                              ),
                            if (produto.imagem.isNotEmpty)
                              CardImageProdutoWidget(
                                imagemBase64: produto.imagem,
                              ),
                            if (produto.imagem.isNotEmpty)
                              CardImageProdutoWidget(
                                imagemBase64: produto.imagem,
                              ),
                            if (produto.imagem.isNotEmpty)
                              CardImageProdutoWidget(
                                imagemBase64: produto.imagem,
                              ),
                          ],
                        ),
                      ),
                      //const SizedBox(width: 16),
                      if (produto.imagem.isNotEmpty)
                        CardImageProdutoWidget(
                          imagemBase64: produto.imagem,
                          width: 500,
                          height: 500,
                        ),
                      //Spacer(),
                      // Nome animado
                      Flexible(
                        flex: 2,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Animate(
                              effects: [
                                FadeEffect(duration: 400.ms, delay: 200.ms),
                                SlideEffect(
                                    duration: 400.ms, begin: Offset(0, 0.2)),
                              ],
                              child: Text(
                                produto.nome,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            if (produto.descricao.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  produto.descricao,
                                  style: const TextStyle(
                                      fontSize: 16, fontFamily: 'Roboto'),
                                ),
                              ),
                            Text('Origem: ${produto.origem}'),
                            Text('ID Produto: 12345678'),
                            Text('Categoria: Utensílios'),
                            Text('Material: ${produto.material}'),
                            Text('Dimensões: ${produto.dimensoes}'),
                            Text('Peso: 1.2 kg'),
                            Text('Prazo de Entrega: ${produto.prazoEntrega}'),
                            SizedBox(
                              width: 100,
                              child: ContadorQuantidade()),
                            Animate(
                              effects: [
                                FadeEffect(duration: 400.ms, delay: 350.ms),
                                SlideEffect(
                                    duration: 400.ms, begin: Offset(0, 0.2)),
                              ],
                              child: Text(
                                'R\$ ${produto.valor.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: pastelPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'Adicionar ao Carrinho',
                                style: const TextStyle(fontFamily: 'Roboto'),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 8),
                  // Preço animado

                  // Categoria

                  // Card de detalhes
                  Animate(
                    effects: [
                      FadeEffect(duration: 500.ms, delay: 400.ms),
                      SlideEffect(duration: 500.ms, begin: Offset(0, 0.1)),
                    ],
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 18),
                      decoration: BoxDecoration(
                        color: pastelCard,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: pastelShadow,
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Descrição

                          _campo('Marca', produto.marca),
                          _campo('Cor', produto.cor),
                          _campo('Características', produto.caracteristicas),
                          _campo('Dimensões', produto.dimensoes),
                          _campo('Ocasião', produto.ocasiao),
                          _campo('Sobre', produto.sobre),
                          _campo('Prazo de Entrega', produto.prazoEntrega),
                          _campo('Frete', produto.frete),
                          _campo('Origem', produto.origem),
                          _campo('Frete Grátis',
                              produto.freteGratis ? 'Sim' : 'Não'),
                          _campo(
                              'Disponível', produto.disponivel ? 'Sim' : 'Não'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Botão comprar animado
                  Animate(
                    effects: [
                      FadeEffect(duration: 500.ms, delay: 600.ms),
                      SlideEffect(duration: 500.ms, begin: Offset(0, 0.2)),
                    ],
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pastelPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () {
                          // ação de compra
                        },
                        child: const Text(
                          'Comprar',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _campo(String label, String? valor) {
    if (valor == null || valor.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
          Expanded(
              child: Text(valor, style: const TextStyle(fontFamily: 'Roboto'))),
        ],
      ),
    );
  }
}

class CardImageProdutoWidget extends StatelessWidget {
  final String imagemBase64;
  final double? width;
  final double? height;

  const CardImageProdutoWidget(
      {this.height, this.width, required this.imagemBase64, super.key});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(duration: 600.ms),
        ScaleEffect(duration: 600.ms, curve: Curves.easeOutBack),
      ],
      child: Container(
        width: width ?? 100,
        height: height ?? 100,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black26,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.only(bottom: 24),
        child: Image.memory(
          base64Decode(imagemBase64),
          height: 210,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
