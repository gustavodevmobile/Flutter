import 'package:blurt/core/widgets/card_solicitacao_ovelay.dart';
import 'package:blurt/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:convert';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Exibe uma notificação do sistema com BigText, som personalizado de até 1 minuto,
/// e envia os dados completos como payload para abrir o Card ao clicar.
Future<void> mostrarNotificacaoSolicitacao(Map<String, dynamic> dados) async {
  // Monta o texto grande da notificação
  final nome = dados['nome'] ?? '';
  final cidade = dados['cidade'] ?? '';
  final motivo = dados['preAnalise']?['motivoConsulta'] ?? '';
  final objetivo = dados['preAnalise']?['objetivo'] ?? '';
  final sintomas = dados['preAnalise']?['sintomas'] ?? '';
  final historico = dados['preAnalise']?['historicoClinico'] ?? '';

  final bigText = '''
Nome: $nome
Cidade: $cidade
Motivo: $motivo
Objetivo: $objetivo
Sintomas: $sintomas
Histórico: $historico
''';

  final androidDetails = AndroidNotificationDetails(
    'solicitacao_channel',
    'Solicitações',
    channelDescription: 'Notificações de novas solicitações de atendimento',
    importance: Importance.max,
    priority: Priority.high,
    styleInformation: BigTextStyleInformation(bigText), // Notificação expandida
    sound: RawResourceAndroidNotificationSound('alert1'),
    playSound: true,
    enableVibration: true,
    //timeoutAfter: 60000,
    ticker: 'Nova solicitação de atendimento',
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

/// Handler para quando o usuário clica na notificação do sistema
// Future<void> onSelectNotification(String? payload) async {
//   if (payload == null) return;
//   try {
//     final Map<String, dynamic> dados = jsonDecode(payload);
//     // Exibe o CardSolicitacaoOverlay ao clicar na notificação
//     showOverlayNotification(
//       (context) => CardSolicitacaoOverlay(
//         dados: dados,
//         onAceitar: () {},
//         onRecusar: () {},
//       ),
//       duration: const Duration(minutes: 1),
//       position: NotificationPosition.top,
//     );
//   } catch (e) {
//     // fallback: não faz nada
//   }
// }

Future<void> onDidReceiveNotificationResponse(NotificationResponse response) async {
  final payload = response.payload;
  if (payload == null) return;
  try {
    final Map<String, dynamic> dados = jsonDecode(payload);
    showOverlayNotification(
      (context) => CardSolicitacaoOverlay(
        dados: dados,
        onAceitar: () {},
        onRecusar: () {},
      ),
      duration: const Duration(minutes: 1),
      position: NotificationPosition.top,
    );
  } catch (e) {
    // fallback: não faz nada
  }
}

void onNovaSolicitacaoAtendimentoAvulso(Map<String, dynamic> conteudo,
    {bool foreground = true}) async {
  if (appLifecycleProvider.isInForeground) {
    showOverlayNotification(
      (context) => CardSolicitacaoOverlay(
        dados: conteudo,
        onAceitar: () {
          // TODO: implementar lógica de aceitar
        },
        onRecusar: () {
          // TODO: implementar lógica de recusar
        },
      ),
      duration: const Duration(minutes: 1),
      position: NotificationPosition.top,
    );
  } else {
    // Notificação em segundo plano
    if (!await FlutterOverlayWindow.isPermissionGranted()) {
      await FlutterOverlayWindow.requestPermission();
    }

    // Exibe o overlay
    await FlutterOverlayWindow.showOverlay(
      height: 400, 
      width: 350,
      enableDrag: true,
      alignment: OverlayAlignment.center,
      flag: OverlayFlag.defaultFlag,
      overlayTitle: "Nova Solicitação de Atendimento",
      positionGravity: PositionGravity.auto,
    );

    // Compartilha os dados com o overlay
    await FlutterOverlayWindow.shareData(jsonEncode(conteudo));
  }
}
