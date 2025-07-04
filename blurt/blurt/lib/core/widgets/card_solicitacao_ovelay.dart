// lib/core/widgets/card_solicitacao_overlay.dart
import 'package:blurt/theme/themes.dart';
import 'package:blurt/widgets/pageview_pre_analise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';

class CardSolicitacaoOverlay extends StatefulWidget {
  final String tipoSolicitacao;
  final double valorConsulta;
  final Map<String, dynamic> dadosUsuario;
  final RespostasPreAnalise? preAnalise;
  final VoidCallback onAceitar;
  final VoidCallback onRecusar;

  const CardSolicitacaoOverlay({
    required this.tipoSolicitacao,
    required this.valorConsulta,
    required this.dadosUsuario,
    this.preAnalise,
    required this.onAceitar,
    required this.onRecusar,
    super.key,
  });

  @override
  State<CardSolicitacaoOverlay> createState() => _CardSolicitacaoOverlayState();
}

class _CardSolicitacaoOverlayState extends State<CardSolicitacaoOverlay>
    with SingleTickerProviderStateMixin {
  late Timer timer;
  int secondsLeft = 60;
  bool closing = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft > 0) {
        setState(() {
          secondsLeft--;
        });
      } else {
        closeOverlay();
      }
    });
  }

  void closeOverlay() {
    if (closing) return;
    closing = true;
    timer.cancel();
  }

  @override
  void dispose() {
    if (!closing) {
      closing = true;
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    final cardWidth =
        isSmall ? MediaQuery.of(context).size.width * 0.95 : 350.0;
    final cardHeight = isSmall ? null : 540.0;
    //final theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Card(
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: const Color.fromARGB(223, 255, 255, 255),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.notifications_active_rounded,
                            color: Colors.deepPurple, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Solicitação de Atendimento',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 28),
                          onPressed: () {
                            widget.onRecusar();
                            closeOverlay();
                          },
                        ),
                      ],
                    )
                        .animate()
                        .fade(duration: 400.ms)
                        .slideY(begin: 0.2, end: 0),
                    widget.tipoSolicitacao == 'atendimento_avulso'
                        ? Container(
                            alignment: Alignment.center,
                            width: 150,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppThemes.secondaryColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Avulso',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            width: 150,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppThemes.primaryColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Imediato',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildRichInfo(
                          'R\$', widget.valorConsulta.toStringAsFixed(2),
                          fontSizeValor: 30),
                    ),
                    //const SizedBox(height: 16),
                    SizedBox(
                      width: cardWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          buildRichInfo('Nome', widget.dadosUsuario['nome']),
                          buildRichInfo(
                              'Gênero', widget.dadosUsuario['genero']),
                          buildRichInfo('Idade',
                              widget.dadosUsuario['dataNascimento'] ?? '39'),
                          buildRichInfo(
                              'Estado', widget.dadosUsuario['estado']),
                          buildRichInfo(
                              'Cidade', widget.dadosUsuario['cidade']),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    widget.tipoSolicitacao == 'atendimento_avulso'
                        ? _buildPreAnalise()
                            .animate()
                            .fade(duration: 400.ms, delay: 200.ms)
                        // Substitui Spacer()
                        : const SizedBox.shrink(),
                    _buildTimerBar(),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            label: const Text('Aceitar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              widget.onAceitar();
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
              .animate()
              .fade(duration: 500.ms)
              .scale(begin: const Offset(0.95, 0.95), end: Offset(1, 1)),
        ),
      ),
    );
  }

  // Widget _buildUserInfo() {
  //   final d = widget.dadosUsuario;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('Nome: ${widget.dadosUsuario['nome']}'),
  //       Text('Gênero: ${widget.dadosUsuario['genero']}'),
  //       Text(
  //         'Nascimento: ${widget.dadosUsuario['dataNascimento']}',
  //       ),
  //       Text('Estado: ${widget.dadosUsuario['estado']}'),
  //       Text('Cidade: ${widget.dadosUsuario['cidade']}'),
  //     ],
  //   );
  // }

  Widget buildRichInfo(String descricao, String valor,
      {Color? colorDesc = Colors.black38,
      Color? colorValor = Colors.indigo,
      double fontSizeDesc = 16,
      double fontSizeValor = 18}) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$descricao: ',
            style: TextStyle(
              color: colorDesc,
              fontWeight: FontWeight.w500,
              fontSize: fontSizeDesc,
            ),
          ),
          TextSpan(
            text: valor,
            style: TextStyle(
              color: colorValor,
              fontWeight: FontWeight.bold,
              fontSize: fontSizeValor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreAnalise() {
    final p = widget.preAnalise;
    if (p == null) {
      return const Text('Usuário não respondeu a pré-análise.',
          style: TextStyle(color: Colors.redAccent));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Desejou responder a pré-análise: Sim',
        ),
        Text(
          'Se Dorme bem: ${p.dormeBem == true ? 'Dorme bem!' : p.dormeBem == false ? 'Não dorme bem' : 'Não informado'}',
        ),
        Text(
          'Algo tira sua Paz: ${p.algoTiraPaz == true ? 'Sim' : p.algoTiraPaz == false ? 'Não' : 'Não informado'}',
        ),
        Text(
          'Motivo da Ansiedade: ${p.motivoAnsiedade.isNotEmpty ? p.motivoAnsiedade : 'Não informado'}',
        ),
        Text(
          'Algum acontecimento recente: ${p.querFalarAcontecimento == true ? 'Sim' : p.querFalarAcontecimento == false ? 'Não' : 'Não informado'}',
        ),
        Text(
          'Acontecimento: ${p.acontecimento.isNotEmpty ? p.acontecimento : 'Não informado'}',
        ),
        Text(
          'Pensamentos ruins: ${p.pensamentosRuins == true ? 'Sim' : p.pensamentosRuins == false ? 'Não' : 'Não informado'}',
        ),
        if (p.pensamentosRuins == true)
          const Text('Risco de suicídio',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTimerBar() {
    final percent = secondsLeft / 60.0;
    return Column(
      children: [
        SizedBox(
          height: 48,
          width: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percent,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                    percent > 0.2 ? Colors.deepPurple : Colors.redAccent),
                strokeWidth: 5,
              ).animate().fade(duration: 400.ms),
              Text(
                secondsLeft.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        percent > 0.2 ? Colors.deepPurple : Colors.redAccent),
              ).animate().fade(duration: 400.ms, delay: 100.ms),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text('Tempo restante', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
