// lib/core/widgets/card_solicitacao_overlay.dart
import 'package:blurt/widgets/pageview_pre_analise.dart';
import 'package:flutter/material.dart';
import '../utils/alerta_sonoro.dart';

class CardSolicitacaoOverlay extends StatefulWidget {
  final Map<String, dynamic> dadosUsuario;
  final RespostasPreAnalise? preAnalise;
  final VoidCallback onAceitar;
  final VoidCallback onRecusar;

  const CardSolicitacaoOverlay({
    required this.dadosUsuario,
    this.preAnalise,
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
    //final dados = widget.dadosUsuario;
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            height: 500,
            width: 300,
            child: widget.preAnalise != null
                ? Card(
                    // margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Nova Solicitação de Atendimento',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 12),
                            Text('Nome: ${widget.dadosUsuario['nome']}'),
                            Text('Gênero: ${widget.dadosUsuario['genero']}'),
                            Text(
                                'Nascimento: ${widget.dadosUsuario['dataNascimento']}'),
                            Text('Estado: ${widget.dadosUsuario['estado']}'),
                            Text('Cidade: ${widget.dadosUsuario['cidade']}'),
                            const SizedBox(height: 12),
                            widget.preAnalise != null
                                ? Text('Desejou responder a pré-análise: Sim')
                                : Text('Desejou responder a pré-análise: Não'),
                            widget.preAnalise!.dormeBem == true ||
                                    widget.preAnalise!.dormeBem == false
                                ? Text(' '
                                    'Se Dorme bem: ${widget.preAnalise!.dormeBem ? 'Dorme bem!' : 'Não dorme bem'}')
                                : Text('Se Dorme bem: Não informado'),
                            widget.preAnalise!.algoTiraPaz == true ||
                                    widget.preAnalise!.algoTiraPaz == false
                                ? Text(
                                    'Algo tira sua Paz: ${widget.preAnalise!.algoTiraPaz ? 'Sim' : 'Não'}')
                                : Text('Algo tira sua Paz: Não informado'),
                            widget.preAnalise!.motivoAnsiedade.isNotEmpty
                                ? Text(
                                    'Motivo da Ansiedade: ${widget.preAnalise!.motivoAnsiedade}')
                                : Text('Motivo da Ansiedade: Não informado'),
                            widget.preAnalise!.querFalarAcontecimento == true ||
                                    widget.preAnalise!.querFalarAcontecimento ==
                                        false
                                ? Text(
                                    'Algum acontecimento recente: ${widget.preAnalise!.querFalarAcontecimento ? 'Sim' : 'Não'}')
                                : Text(
                                    'Algum acontecimento recente: Não informado'),
                            widget.preAnalise!.acontecimento.isNotEmpty
                                ? Text(
                                    'Acontecimento: ${widget.preAnalise!.acontecimento}')
                                : Text('Acontecimento: Não informado'),
                            widget.preAnalise!.pensamentosRuins == true ||
                                    widget.preAnalise!.pensamentosRuins == false
                                ? Text(
                                    'Pensamentos ruins: ${widget.preAnalise!.pensamentosRuins ? 'Sim' : 'Não'}')
                                : Text('Pensamentos ruins: Não informado'),
                            if (widget.preAnalise!.pensamentosRuins)
                              Text('Risco de suicídio'),
                            const SizedBox(height: 16),
                            if (widget.preAnalise == null)
                              const Text(
                                'O usuário não respondeu a pré-análise.',
                                style: TextStyle(color: Colors.red),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.check),
                                    label: const Text('Aceitar'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    onPressed: () async {
                                      widget.onAceitar();
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.close),
                                    label: const Text('Recusar'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () async {
                                      widget.onRecusar();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Card(
                    // margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Nova Solicitação de Atendimento',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 12),
                            Text('Nome: ${widget.dadosUsuario['nome']}'),
                            Text('Gênero: ${widget.dadosUsuario['genero']}'),
                            Text(
                                'Nascimento: ${widget.dadosUsuario['dataNascimento']}'),
                            Text('Estado: ${widget.dadosUsuario['estado']}'),
                            Text('Cidade: ${widget.dadosUsuario['cidade']}'),
                            const SizedBox(height: 12),
                            const Text(
                              'Usuário não respondeu a pré-análise.',
                              style: TextStyle(color: Colors.red),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.check),
                                    label: const Text('Aceitar'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    onPressed: () async {
                                      widget.onAceitar();
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.close),
                                    label: const Text('Recusar'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () async {
                                      widget.onRecusar();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ));
  }
}
