import 'dart:convert';
import 'package:blurt/core/utils/background.dart';
import 'package:blurt/core/utils/formatters.dart';
import 'package:blurt/provider/provider_controller.dart';
import 'package:blurt/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PerfilProfissionalScreen extends StatefulWidget {
  const PerfilProfissionalScreen({super.key});

  @override
  State<PerfilProfissionalScreen> createState() =>
      _PerfilProfissionalScreenState();
}

class _PerfilProfissionalScreenState extends State<PerfilProfissionalScreen> {
  initState() {
    super.initState();
    Formatters.formatarValor(123);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderController>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profissional'),
          centerTitle: true,
        ),
        body: Background(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: value.profissional?.foto != null
                        ? MemoryImage(base64Decode(value.profissional!.foto))
                        : null,
                    child: value.profissional?.foto == null
                        ? const Icon(Icons.person, size: 48)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    value.profissional?.nome ?? '',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    value.profissional?.tipoProfissional ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                value.profissional?.tipoProfissional == 'Psicólogo'
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text('CRP: ${value.profissional!.crp}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 16),
                Text(
                  'Biografia:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                if (value.profissional!.bio != null &&
                    value.profissional!.bio!.isNotEmpty)
                  Text(
                    value.profissional!.bio!,
                    style: const TextStyle(fontSize: 16),
                  )
                else
                  const Text(
                    'Nenhuma biografia informada',
                    style: TextStyle(fontSize: 16),
                  ),
                const SizedBox(height: 16),
                value.profissional!.tipoProfissional == 'Psicóloga' ||
                        value.profissional!.tipoProfissional == 'Psicólogo'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (value.profissional!.abordagemPrincipal != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Abordagem Principal:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(value.profissional!.abordagemPrincipal!,
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 12),
                              ],
                            ),
                          //const SizedBox(height: 12),
                          if (value.profissional!.abordagensUtilizadas !=
                                  null &&
                              value.profissional!.abordagensUtilizadas!
                                  .isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Abordagens Utilizadas:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 8,
                                  children: value
                                      .profissional!.abordagensUtilizadas!
                                      .map((abord) => Chip(
                                          label: Text(
                                              Formatters.capitalize(abord))))
                                      .toList(),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Especialização Principal:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              value.profissional?.especialidadePrincipal !=
                                          null &&
                                      value.profissional!
                                          .especialidadePrincipal!.isNotEmpty
                                  ? Text(
                                      value.profissional!
                                          .especialidadePrincipal!,
                                      style: const TextStyle(fontSize: 16),
                                    )
                                  : Text(
                                      'Nenhuma especialização informada',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                              const SizedBox(height: 12),
                            ],
                          ),
                          if (value.profissional!.temasClinicos!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Temas Clínicos:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 8,
                                  children: value.profissional!.temasClinicos!
                                      .map((tema) => Chip(
                                          label: Text(
                                              Formatters.capitalize(tema))))
                                      .toList(),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                        ],
                      )
                    : Column(
                        children: [
                          Text('Abodagem pricipal:',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Psicanalista',
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 16),
                          Center(
                            child: Card(
                              color: Colors.amber[100],
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Profissional formado em Psicanálise',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Atenção: Psicanalistas não são Psicólogos. '
                                      'Seus métodos clínicos são baseados na Psicanálise, '
                                      'que possui abordagem, formação e regulamentação diferentes da Psicologia.',
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                      'Valor da Consulta: R\$ ${Formatters.formatarValor(value.profissional!.valorConsulta)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Implementar solicitação de atendimento
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 48),
                        textStyle: const TextStyle(fontSize: 18),
                        backgroundColor: AppThemes.secondaryColor),
                    child: const Text('Solicitar Atendimento'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
