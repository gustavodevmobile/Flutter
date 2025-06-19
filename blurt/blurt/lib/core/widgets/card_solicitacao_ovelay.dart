// lib/core/widgets/card_solicitacao_overlay.dart
import 'package:blurt/core/utils/app_life_cyrcle_provider.dart';
import 'package:blurt/core/utils/overlay_float_bubble.dart';
import 'package:blurt/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:provider/provider.dart';
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
    AlertaSonoro.tocar();
    super.initState();
  }

  @override
  void dispose() {
    AlertaSonoro.parar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dados = widget.dados;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: SizedBox(
          height: 500,
          width: 300,
          child: Card(
            // margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Nova Solicitação de Atendimento',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                    Text(
                        'Histórico: ${dados['preAnalise']['historicoClinico']}'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text('Aceitar'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () async {
                            widget.onAceitar();
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.close),
                          label: const Text('Recusar'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () async {
                            widget.onRecusar();
                            AlertaSonoro.parar();
                            //OverlaySupportEntry.of(context)?.dismiss();
                            await FlutterOverlayWindow.closeOverlay();
                            await Future.delayed(Duration(milliseconds: 300));
                            showOverlayFloatBubble();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
