import 'dart:async';

import 'package:blurt/core/utils/alerta_sonoro.dart';
import 'package:blurt/core/utils/global_snackbars.dart';
import 'package:blurt/core/widgets/card_feedback_overlay.dart';
import 'package:blurt/core/widgets/card_solicitacao_ovelay.dart';
import 'package:blurt/main.dart';
import 'package:blurt/provider/provider_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showSolicitacaoDialog(BuildContext context, Map<String, dynamic> event) {
  final isShowingDialog =
      Provider.of<ProviderController>(context, listen: false);
  isShowingDialog.setIsShowDialog(true);
  try {
    AlertaSonoro.tocar(
      onTimeout: () {
        if (event['tipoAtendimento'] == 'atendimento_avulso') {
          globalWebSocketProvider.respostaAtendimentoAvulso(
              event['usuarioId'], event['profissionalId'], false);
        } else if (event['tipoAtendimento'] == 'atendimento_imediato') {
          globalWebSocketProvider.respostaAtendimentoImediato(
              event['usuarioId'], event['profissionalId'], false);
        }
        //Navigator.of(dialogContext).pop();
      },
    );

    late BuildContext dialogContext;

    double valorConsulta = 0.0;
    if (event['valorConsulta'] != null) {
      if (event['valorConsulta'] is int) {
        valorConsulta = (event['valorConsulta'] as int).toDouble();
      } else if (event['valorConsulta'] is double) {
        valorConsulta = event['valorConsulta'];
      } else if (event['valorConsulta'] is String) {
        valorConsulta = double.tryParse(event['valorConsulta']) ?? 0.0;
      }
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          dialogContext = ctx;
          return CardSolicitacaoOverlay(
            tipoSolicitacao: event['tipoAtendimento'],
            valorConsulta: event['valorConsulta'] != null
                ? (event['valorConsulta'] as int).toDouble()
                : 0.0,
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
                    event['usuarioId'], event['profissionalId'], false);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(dialogContext);
                });
              }
            },
          );
        }).then((_) {
      print('Dialog closed');
      isShowingDialog.setIsShowDialog(false);
    });
    // FECHA AUTOMATICAMENTE APÓS 1 MINUTO
    Future.delayed(const Duration(minutes: 1), () {
      if (dialogContext.mounted) {
        if (Navigator.of(dialogContext).canPop()) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(dialogContext);
          });
        }
      }
    });
  } catch (e) {
    GlobalSnackbars.showSnackBar(e.toString());
    print('Erro ao exibir solicitação: $e');
  }
}

late BuildContext dialogContextAguardando;
void showFeedbackDialogAguardando(
  BuildContext context,
  String estado, {
  String? mensagem,
  String? linkSala,
  VoidCallback? recusada,
  VoidCallback? onClose,
}) {
  final isShowingDialog =
      Provider.of<ProviderController>(context, listen: false);
  isShowingDialog.setIsShowDialog(true);
  print('isShowingDialog: ${isShowingDialog.isShowDialog}');
  try {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (ctx) {
          print('Dialog context: $ctx');
          dialogContextAguardando = ctx;
          return CardFeedbackSolicitacaoWidget(
              estado: estado,
              mensagem: mensagem,
              linkSala: linkSala,
              // onTimeout: () {
              //   WidgetsBinding.instance.addPostFrameCallback((_) {
              //     // Navigator.pop(dialogContextAguardando);
              //   });
              // },
              onClose: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(dialogContextAguardando);
                });
                if (recusada != null) {
                  recusada();
                }
              });
        }).then((_) {
      isShowingDialog.setIsShowDialog(false);
    });
  } catch (e) {
    GlobalSnackbars.showSnackBar(e.toString());
    print('Erro ao exibir feedback: $e');
  }
}

void showFeedbackDialogAceitaOuRecusa(BuildContext context, String estado,
    {String? mensagem,
    String? linkSala,
    VoidCallback? recusada,
    VoidCallback? onClose}) {
  try {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (dialogContext) => CardFeedbackSolicitacaoWidget(
          estado: estado,
          mensagem: mensagem,
          linkSala: linkSala,
          // onTimeout: () {
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     Navigator.pop(dialogContext);
          //   });
          // },
          onClose: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(dialogContext);
            });
            if (recusada != null) {
              recusada();
            }
            //solicitacaoSubscription.cancel();
          }),
    );
  } catch (e) {
    GlobalSnackbars.showSnackBar(e.toString());
    print('Erro ao exibir feedback: $e');
  }
}

void closeDialogoAguardando() {
  print('Closing dialog: $dialogContextAguardando');
  Navigator.pop(dialogContextAguardando);
}
