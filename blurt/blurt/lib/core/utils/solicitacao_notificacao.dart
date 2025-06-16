import 'package:blurt/core/widgets/card_solicitacao_ovelay.dart';
import 'package:blurt/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> mostrarNotificacaoSolicitacao(Map<String, dynamic> dados) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'solicitacao_channel',
    'Solicitações',
    channelDescription: 'Notificações de novas solicitações de atendimento',
    importance: Importance.max,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound('alert1'), // sem extensão
    playSound: true,
    enableVibration: true,
    timeoutAfter: 60000, // 1 minuto
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Nova Solicitação de Atendimento',
    'Nome: ${dados['nome']} - Cidade: ${dados['cidade']}',
    platformChannelSpecifics,
    payload: 'solicitacao',
  );
}

void onNovaSolicitacaoAtendimentoAvulso(Map<String, dynamic> conteudo,
    {bool foreground = true}) {
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
    mostrarNotificacaoSolicitacao(conteudo);
  }
}
