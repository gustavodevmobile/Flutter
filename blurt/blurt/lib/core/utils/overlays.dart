import 'package:blurt/core/widgets/card_solicitacao_ovelay.dart';
import 'package:flutter/material.dart';

void showCardSolicitacaoOverl(
    BuildContext context, Map<String, dynamic> data) {
  showDialog(
    context: context,
    builder: (_) => CardSolicitacaoOverlay(
      dados: data,
      onAceitar: () {
        // TODO: implementar lógica de aceitar
      },
      onRecusar: () {
        // TODO: implementar lógica de recusar
      },
    ),
  );
}
