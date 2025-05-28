import 'package:flutter/material.dart';

class PerfilProfissionalScreen extends StatelessWidget {
  final Map<String, dynamic> profissional;
  const PerfilProfissionalScreen({super.key, required this.profissional});

  @override
  Widget build(BuildContext context) {
    final bool isPsicologo = profissional['tipo'] == 'Psicólogo';
    final fotoPerfil = profissional['fotoPerfil'];
    final List<String> abordagensUtilizadas =
        profissional['abordagensUtilizadas'] ?? [];
    final List<String> especializacoes = profissional['especializacoes'] ?? [];
    final List<String> temasClinicos = profissional['temasClinicos'] ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profissional'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundImage:
                    fotoPerfil != null ? NetworkImage(fotoPerfil) : null,
                child: fotoPerfil == null
                    ? const Icon(Icons.person, size: 48)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                profissional['nome'] ?? '',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                profissional['abordagem'] ?? '',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 16),
            if (abordagensUtilizadas.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Abordagens Utilizadas:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: abordagensUtilizadas
                        .map((abord) => Chip(label: Text(abord)))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            if (especializacoes.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Especializações:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: especializacoes
                        .map((esp) => Chip(label: Text(esp)))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            if (temasClinicos.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Temas Clínicos:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: temasClinicos
                        .map((tema) => Chip(label: Text(tema)))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            if (isPsicologo)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('CRP: ${profissional['crp'] ?? '---'}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            if (!isPsicologo)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Profissional Psicanalista'),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                  'Valor da Consulta: R\$ ${profissional['valorConsulta'] ?? '--'}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implementar solicitação de atendimento
                },
                child: const Text('Solicitar Atendimento'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 48),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
