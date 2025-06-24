// lib/core/widgets/card_solicitacao_overlay.dart
import 'package:blurt/widgets/pageview_pre_analise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
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

class _CardSolicitacaoOverlayState extends State<CardSolicitacaoOverlay>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _secondsLeft = 60;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    AlertaSonoro.tocar();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _closeOverlay();
      }
    });
  }

  void _closeOverlay() {
    if (_closing) return;
    _closing = true;
    _timer.cancel();
    AlertaSonoro.parar();
    widget.onRecusar();
  }

  @override
  void dispose() {
    _timer.cancel();
    AlertaSonoro.parar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    final cardWidth =
        isSmall ? MediaQuery.of(context).size.width * 0.95 : 350.0;
    final cardHeight = isSmall ? null : 540.0;
    final theme = Theme.of(context);
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
            color: theme.cardColor.withOpacity(0.98),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.notifications_active_rounded,
                          color: Colors.deepPurple, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Nova Solicitação de Atendimento',
                          style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ],
                  ).animate().fade(duration: 400.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 16),
                  _buildUserInfo(theme)
                      .animate()
                      .fade(duration: 400.ms, delay: 100.ms),
                  const SizedBox(height: 10),
                  _buildPreAnalise(theme)
                      .animate()
                      .fade(duration: 400.ms, delay: 200.ms),
                  const Spacer(),
                  _buildTimerBar(theme),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text('Aceitar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            _timer.cancel();
                            AlertaSonoro.parar();
                            widget.onAceitar();
                          },
                        ).animate().fade(duration: 300.ms, delay: 300.ms),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.close),
                          label: const Text('Recusar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _closeOverlay,
                        ).animate().fade(duration: 300.ms, delay: 350.ms),
                      ),
                    ],
                  ),
                ],
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

  Widget _buildUserInfo(ThemeData theme) {
    final d = widget.dadosUsuario;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nome: ${d['nome']}', style: theme.textTheme.bodyLarge),
        Text('Gênero: ${d['genero']}', style: theme.textTheme.bodyMedium),
        Text('Nascimento: ${d['dataNascimento']}',
            style: theme.textTheme.bodyMedium),
        Text('Estado: ${d['estado']}', style: theme.textTheme.bodyMedium),
        Text('Cidade: ${d['cidade']}', style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildPreAnalise(ThemeData theme) {
    final p = widget.preAnalise;
    if (p == null) {
      return const Text('Usuário não respondeu a pré-análise.',
          style: TextStyle(color: Colors.redAccent));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Desejou responder a pré-análise: Sim',
            style: theme.textTheme.bodyMedium),
        Text(
            'Se Dorme bem: ${p.dormeBem == true ? 'Dorme bem!' : p.dormeBem == false ? 'Não dorme bem' : 'Não informado'}',
            style: theme.textTheme.bodyMedium),
        Text(
            'Algo tira sua Paz: ${p.algoTiraPaz == true ? 'Sim' : p.algoTiraPaz == false ? 'Não' : 'Não informado'}',
            style: theme.textTheme.bodyMedium),
        Text(
            'Motivo da Ansiedade: ${p.motivoAnsiedade.isNotEmpty ? p.motivoAnsiedade : 'Não informado'}',
            style: theme.textTheme.bodyMedium),
        Text(
            'Algum acontecimento recente: ${p.querFalarAcontecimento == true ? 'Sim' : p.querFalarAcontecimento == false ? 'Não' : 'Não informado'}',
            style: theme.textTheme.bodyMedium),
        Text(
            'Acontecimento: ${p.acontecimento.isNotEmpty ? p.acontecimento : 'Não informado'}',
            style: theme.textTheme.bodyMedium),
        Text(
            'Pensamentos ruins: ${p.pensamentosRuins == true ? 'Sim' : p.pensamentosRuins == false ? 'Não' : 'Não informado'}',
            style: theme.textTheme.bodyMedium),
        if (p.pensamentosRuins == true)
          const Text('Risco de suicídio',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTimerBar(ThemeData theme) {
    final percent = _secondsLeft / 60.0;
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
                _secondsLeft.toString(),
                style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        percent > 0.2 ? Colors.deepPurple : Colors.redAccent),
              ).animate().fade(duration: 400.ms, delay: 100.ms),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text('Tempo restante',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
      ],
    );
  }
}


