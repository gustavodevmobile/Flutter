import 'package:blurt/core/utils/alerta_sonoro.dart';
import 'package:blurt/core/utils/global_snackbars.dart';
import 'package:blurt/core/widgets/card_feedback_overlay.dart';
import 'package:blurt/core/widgets/card_solicitacao_ovelay.dart';
import 'package:blurt/main.dart';
import 'package:flutter/material.dart';

void showSolicitacaoDialog(BuildContext context, Map<String, dynamic> event) {
  try {
    AlertaSonoro.tocar(
      onTimeout: () {
        if (event['tipoAtendimento'] == 'atendimento_avulso') {
          // implementar lógica de recusa para atendimento avulso
        } else if (event['tipoAtendimento'] == 'atendimento_imediato') {
          globalWebSocketProvider.respostaAtendimentoImediato(
              event['usuarioId'], event['profissionalId'], false, true);
        }
        //Navigator.of(dialogContext).pop();
      },
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => CardSolicitacaoOverlay(
        dadosUsuario: event['dadosUsuario'],
        preAnalise: event['preAnalise'],
        onAceitar: () async {
          AlertaSonoro.parar();
          if (event['tipoAtendimento'] == 'atendimento_avulso') {
            if (event['preAnalise'] != null) {
              globalWebSocketProvider.respostaAtendimentoAvulso(
                  event['usuarioId'], event['profissionalId'], true,
                  respostasPreAnalise: event['preAnalise']);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(dialogContext);
              });
            } else {
              globalWebSocketProvider.respostaAtendimentoAvulso(
                  event['usuarioId'], event['profissionalId'], true);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(dialogContext);
              });
            }
          } else if (event['tipoAtendimento'] == 'atendimento_imediato') {
            // implementar lógica de aceitação para atendimento imediato
          }
        },
        onRecusar: () async {
          AlertaSonoro.parar();
          if (event['tipoAtendimento'] == 'atendimento_avulso') {
            globalWebSocketProvider.respostaAtendimentoAvulso(
                event['usuarioId'], event['profissionalId'], false);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(dialogContext);
            });
          } else if (event['tipoAtendimento'] == 'atendimento_imediato') {
            globalWebSocketProvider.respostaAtendimentoImediato(
                event['usuarioId'], event['profissionalId'], false, true);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(dialogContext);
            });
          }
        },
      ),
    );
    // FECHA AUTOMATICAMENTE APÓS 1 MINUTO
    Future.delayed(const Duration(minutes: 1), () {
      if (context.mounted) {
        if (Navigator.of(context).canPop()) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          });
        }
      }
    });
  } catch (e) {
    GlobalSnackbars.showSnackBar(e.toString());
    print('Erro ao exibir solicitação: $e');
  }
}

void showFeedbackDialog(BuildContext context, String estado,
    {String? mensagem,
    String? linkSala,
    VoidCallback? recusada,
    VoidCallback? onClose}) {
  try {
    print(
        'showFeedbackDialog: $estado, mensagem: $mensagem, linkSala: $linkSala');
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) => CardFeedbackSolicitacaoWidget(
          estado: estado,
          mensagem: mensagem,
          linkSala: linkSala,
          onTimeout: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
            });
          },
          onClose: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
            });
            if (recusada != null) {
              recusada();
            }
          }),
    );
  } catch (e) {
    GlobalSnackbars.showSnackBar(e.toString());
    print('Erro ao exibir feedback: $e');
  }
}
