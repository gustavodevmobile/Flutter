import 'dart:typed_data';

import 'package:blurt/core/utils/alerta_sonoro.dart';
import 'package:blurt/core/widgets/card_solicitacao_ovelay.dart';
import 'package:blurt/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:convert';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Exibe uma notificação do sistema com BigText, som personalizado de até 1 minuto,
/// e envia os dados completos como payload para abrir o Card ao clicar.
Future<void> mostrarNotificacaoSolicitacao(Map<String, dynamic> dados) async {
//   // Monta o texto grande da notificação
  final nome = dados['nome'] ?? '';
  final cidade = dados['cidade'] ?? '';
  final motivo = dados['preAnalise']?['motivoConsulta'] ?? '';
  final objetivo = dados['preAnalise']?['objetivo'] ?? '';
  final sintomas = dados['preAnalise']?['sintomas'] ?? '';
  final historico = dados['preAnalise']?['historicoClinico'] ?? '';

  final bigText = '''
Nome: Gustavo
Cidade: Santos
Motivo: Motivo da consulta
Objetivo: Objetivo da consulta
Sintomas: Sintomas relatados
Histórico: Histórico clínico
''';

  final androidDetails = AndroidNotificationDetails(
  'solicitacao_channel',
  'Solicitações',
  channelDescription: 'Notificações de novas solicitações de atendimento',
  importance: Importance.max,
  priority: Priority.high,
  styleInformation: BigTextStyleInformation(
    bigText,
    contentTitle: '🚨 Nova Solicitação de Atendimento!',
    summaryText: 'Toque para ver detalhes completos',
  ),
  color: Colors.deepPurple, // Cor da barra lateral da notificação
  playSound: true,
  sound: RawResourceAndroidNotificationSound('alert1'), // Som customizado
  enableVibration: true,
  vibrationPattern: Int64List.fromList([0, 500, 1000, 500, 2000]),
  ticker: 'Alerta de atendimento',
  icon: '@mipmap/ic_launcher', // Ícone customizado (deve estar no projeto)
  largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'), // Ícone grande
  timeoutAfter: 60000, // Some após 1 minuto
  category: AndroidNotificationCategory.call, // Categoria especial (call, message, etc)
  autoCancel: true,
  visibility: NotificationVisibility.public,
  actions: <AndroidNotificationAction>[
    AndroidNotificationAction(
      'aceitar',
      'Aceitar',
     // icon:,
    ),
    AndroidNotificationAction(
      'recusar',
      'Recusar',
      //icon: '@mipmap/ic_launcher',
      showsUserInterface: true,
      cancelNotification: true,
    ),
  ],
);

  final notificationDetails = NotificationDetails(android: androidDetails);

  // Exibe a notificação com os dados completos como payload
  await flutterLocalNotificationsPlugin.show(
    0,
    'Nova Solicitação de Atendimento',
    'Nome: $nome - Cidade: $cidade',
    notificationDetails,
    payload: jsonEncode(dados),
  );

  
}

// Future<void> onDidReceiveNotificationResponse(
//     NotificationResponse response) async {
//   final payload = response.payload;
//   if (payload == null) return;
//   try {
//     final Map<String, dynamic> dados = jsonDecode(payload);
//     showOverlayNotification(
//         (context) => CardSolicitacaoOverlay(
//               dados: dados,
//               onAceitar: () {},
//               onRecusar: () {},
//             ),
//         duration: const Duration(minutes: 1),
//         position: NotificationPosition.top);
//   } catch (e) {
//     // fallback: não faz nada
//   }
// }

void onNovaSolicitacaoAtendimentoAvulso(Map<String, dynamic> conteudo,
    {bool foreground = true}) async {
  if (appLifecycleProvider.isInForeground) {
    AlertaSonoro.tocar();
    showOverlayNotification(
      (context) => CardSolicitacaoOverlay(
        dados: conteudo,
        onAceitar: () {
          AlertaSonoro.parar();
          OverlaySupportEntry.of(context)?.dismiss();
        },
        onRecusar: () {
          AlertaSonoro.parar();
          OverlaySupportEntry.of(context)?.dismiss();
        },
      ),
      duration: const Duration(minutes: 1),
      position: NotificationPosition.top,
    );
  } else {
    mostrarNotificacaoSolicitacao(conteudo);
    // Exibe o overlay
    //AlertaSonoro.tocar();
    // await FlutterOverlayWindow.showOverlay(
    //   height: WindowSize.fullCover,
    //   width: WindowSize.fullCover,
    //   enableDrag: false,
    //   alignment: OverlayAlignment.center,
    //   flag: OverlayFlag.defaultFlag,
    //   overlayTitle: "Nova Solicitação de Atendimento",
    //   positionGravity: PositionGravity.auto,
    // );

    // // Compartilha os dados com o overlay
    // await FlutterOverlayWindow.shareData(jsonEncode(conteudo));
  }
}
