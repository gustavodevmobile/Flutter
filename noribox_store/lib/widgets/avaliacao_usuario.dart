import 'package:flutter/material.dart';

class AvaliacaoUsuario {
  final String nome;
  final String comentario;
  final double nota;
  final DateTime data;

  AvaliacaoUsuario({
    required this.nome,
    required this.comentario,
    required this.nota,
    required this.data,
  });
}

class ListaAvaliacoesProduto extends StatelessWidget {
  final List<AvaliacaoUsuario> avaliacoes;

  const ListaAvaliacoesProduto({super.key, required this.avaliacoes});

  @override
  Widget build(BuildContext context) {
    if (avaliacoes.isEmpty) {
      return const Text('Nenhuma avaliação ainda.');
    }
    return Column(
      children: avaliacoes.map((a) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    a.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${a.data.day.toString().padLeft(2, '0')}/${a.data.month.toString().padLeft(2, '0')}/${a.data.year}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: List.generate(5, (i) {
                      return Icon(
                        i < a.nota.round()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 18,
                      );
                    }),
                  ),
                  
                ],
              ),
              const SizedBox(height: 8),
              Text(
                a.comentario,
                style: const TextStyle(fontSize: 15),
              ),
              Divider(
                color: Colors.grey.shade300,
                thickness: 1,
                height: 24,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}