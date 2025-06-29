import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// enum CardFeedbackSolicitacao { aguardando, aceita, recusada }



class CardFeedbackSolicitacaoWidget extends StatefulWidget {
  final String estado;
  final String? mensagem;
  final String? linkSala;
  final VoidCallback? onTimeout;
  final VoidCallback? onClose;

  const CardFeedbackSolicitacaoWidget({
    required this.estado,
    this.mensagem,
    this.linkSala,
    this.onTimeout,
    this.onClose,
    super.key
  });

  @override
  State<CardFeedbackSolicitacaoWidget> createState() =>
      CardFeedbackSolicitacaoWidgetState();
}

class CardFeedbackSolicitacaoWidgetState
    extends State<CardFeedbackSolicitacaoWidget> {
  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = 60;
    if (widget.estado == 'aguardando') {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant CardFeedbackSolicitacaoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.estado != oldWidget.estado) {
      if (widget.estado == 'aguardando') {
        _secondsLeft = 60;
        _startTimer();
      } else {
        _stopTimer();
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _stopTimer();
        widget.onTimeout?.call();
        widget.onClose?.call();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final isMobile = MediaQuery.of(context).size.width < 600;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildContent(),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.onClose,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (widget.estado) {
      case 'aguardando':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  //widget.mensagem ?? 'Aguarde a confirmação do profissional',
                  'Sua solicitação foi recebida.\nAguarde a confirmação do profissional',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(duration: 1200.ms),
              ],
            ),
            const SizedBox(height: 24),
            _AnimatedDots(),
            const SizedBox(height: 16),
            Text(
              'Tempo restante: ${_formatSeconds(_secondsLeft)}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.2, end: 0, duration: 500.ms),
          ],
        );
      case 'aceita':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 48)
                .animate()
                .scale(duration: 400.ms),
            const SizedBox(height: 16),
            Text(
              //widget.mensagem ?? 'Solicitação aceita!',
              'Solicitação, prossiga com o pagamento',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 16),
            if (widget.linkSala != null && widget.linkSala!.isNotEmpty)
              SelectableText(
                widget.linkSala!,
                style: const TextStyle(fontSize: 16, color: Colors.blue),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 600.ms),
          ],
        );
      case 'recusada':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cancel, color: Colors.red, size: 48)
                .animate()
                .scale(duration: 400.ms),
            const SizedBox(height: 16),
            Text(
              widget.mensagem ?? 'Profissional indisponível no momento',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 400.ms),
          ],
        );
    }
    // Adicionado return para evitar erro de retorno nulo
    return const SizedBox.shrink();
  }

  String _formatSeconds(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}

class _AnimatedDots extends StatefulWidget {
  @override
  State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
    _animation = Tween<double>(begin: 0, end: 3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        int dots = (_animation.value.floor() % 3) + 1;
        return Text(
          '.' * dots,
          style: const TextStyle(fontSize: 32, color: Colors.blueGrey),
        );
      },
    );
  }
}
