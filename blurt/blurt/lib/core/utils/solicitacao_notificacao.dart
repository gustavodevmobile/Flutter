import 'dart:typed_data';

import 'package:blurt/core/utils/alerta_sonoro.dart';
import 'package:blurt/core/utils/overlay_card.dart';
import 'package:blurt/core/widgets/card_solicitacao_ovelay.dart';
import 'package:blurt/main.dart';
import 'package:blurt/widgets/pageview_pre_analise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    //sound: RawResourceAndroidNotificationSound('alert1'), // Som customizado
    enableVibration: true,
    vibrationPattern: Int64List.fromList([0, 500, 1000, 500, 2000]),
    ticker: 'Alerta de atendimento',
    icon: '@mipmap/ic_launcher', // Ícone customizado (deve estar no projeto)
    largeIcon: const DrawableResourceAndroidBitmap(
        '@mipmap/ic_launcher'), // Ícone grande
    timeoutAfter: 60000, // Some após 1 minuto
    category: AndroidNotificationCategory
        .call, // Categoria especial (call, message, etc)
    autoCancel: true,
    //visibility: NotificationVisibility.public,
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

void onNovaSolicitacaoAtendimentoAvulso(
  String usuarioId,
  Map<String, dynamic> usuario,
 {Map<String, dynamic>? preAnalise}
) async {
  RespostasPreAnalise? respostasPreAnalise;
  if (preAnalise != null) {
    respostasPreAnalise = RespostasPreAnalise.fromMap(preAnalise);
  }
  if (appLifecycleProvider.isInForeground) {
    AlertaSonoro.tocar();
    showOverlayNotification(
      (context) => CardSolicitacaoOverlay(
        dadosUsuario: usuario,
        preAnalise: respostasPreAnalise,
        onAceitar: () async {
          AlertaSonoro.parar();
          OverlaySupportEntry.of(context)?.dismiss();
          Navigator.pushNamed(context, '/editar_perfil_profissional');
          //print('Aceitar solicitação: ${conteudo['nome']}');
        },
        onRecusar: () async {
          AlertaSonoro.parar();
          OverlaySupportEntry.of(context)?.dismiss();
          //await FlutterOverlayWindow.closeOverlay();
        },
      ),
      duration: const Duration(minutes: 1),
      position: NotificationPosition.top,
    );
  } else {
    AlertaSonoro.tocar();
    if (respostasPreAnalise != null) {
      showOverlayCard(usuario, preAnelise: respostasPreAnalise);
    } else {
      showOverlayCard(usuario);
    }
  }
}
