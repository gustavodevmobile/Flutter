// lib/core/widgets/card_solicitacao_overlay.dart
import 'package:flutter/material.dart';
import '../utils/alerta_sonoro.dart';
import 'package:overlay_support/overlay_support.dart';

class CardSolicitacaoOverlay extends StatefulWidget {
  final Map<String, dynamic> dados;
  final VoidCallback onAceitar;
  final VoidCallback onRecusar;

  const CardSolicitacaoOverlay({
    required this.dados,
    required this.onAceitar,
    required this.onRecusar,
    super.key,
  });

  @override
  State<CardSolicitacaoOverlay> createState() => _CardSolicitacaoOverlayState();
}

class _CardSolicitacaoOverlayState extends State<CardSolicitacaoOverlay> {
  @override
  void initState() {
    super.initState();
    AlertaSonoro.tocar();
    Future.delayed(const Duration(minutes: 1), () {
      if (mounted) {
        AlertaSonoro.parar();
        OverlaySupportEntry.of(context)?.dismiss();
      }
    });
  }

  @override
  void dispose() {
    AlertaSonoro.parar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dados = widget.dados;
    return Material(
      color: Colors.transparent,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Nova Solicitação de Atendimento',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              Text('Nome: ${dados['nome']}'),
              Text('Gênero: ${dados['genero']}'),
              Text('Nascimento: ${dados['dataNascimento']}'),
              Text('Estado: ${dados['estado']}'),
              Text('Cidade: ${dados['cidade']}'),
              const SizedBox(height: 12),
              Text('Motivo: ${dados['preAnalise']['motivoConsulta']}'),
              Text('Objetivo: ${dados['preAnalise']['objetivo']}'),
              Text('Sintomas: ${dados['preAnalise']['sintomas']}'),
              Text('Histórico: ${dados['preAnalise']['historicoClinico']}'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Aceitar'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      AlertaSonoro.parar();
                      widget.onAceitar();
                      OverlaySupportEntry.of(context)?.dismiss();
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.close),
                    label: const Text('Recusar'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      AlertaSonoro.parar();
                      widget.onRecusar();
                      OverlaySupportEntry.of(context)?.dismiss();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}