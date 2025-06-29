import 'package:blurt/core/utils/alerta_sonoro.dart';
import 'package:blurt/core/utils/global_snackbars.dart';
import 'package:blurt/core/websocket/websocket_provider.dart';
import 'package:blurt/core/widgets/animated_cache_image.dart';
import 'package:blurt/core/widgets/card_solicitacao_ovelay.dart';
import 'package:blurt/features/autenticacao/presentation/controllers/login_profissional_controller.dart';
import 'package:blurt/features/dashboards/profissional/presentation/controllers/dashboard_profissional_controller.dart';
import 'package:blurt/main.dart';
import 'package:blurt/provider/provider_controller.dart';
import 'package:blurt/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
// import 'package:android_intent_plus/android_intent.dart';
// import 'package:android_intent_plus/flag.dart';

class DashboardProfissionalScreen extends StatefulWidget {
  const DashboardProfissionalScreen({super.key});

  @override
  State<DashboardProfissionalScreen> createState() =>
      _DashboardProfissionalScreenState();
}

class _DashboardProfissionalScreenState
    extends State<DashboardProfissionalScreen> {
  // bool online = false;
  // bool plantao = true;

  @override
  void initState() {
    globalWebSocketProvider.streamSolicitacao.listen((event) {
      AlertaSonoro.tocar();
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => CardSolicitacaoOverlay(
            dadosUsuario: event['dadosUsuario'],
            preAnalise: event['preAnalise'],
            onAceitar: () async {
              AlertaSonoro.parar();
              if (event['tipoAtendimento'] == 'atendimento_avulso') {
                if (event['preAnalise'] != null) {
                } else {}
              } else if (event['tipoAtendimento'] == 'atendimento_imediato') {}
            },
            onRecusar: () async {
              AlertaSonoro.parar();
              Navigator.pop(context);
              if (event['tipoAtendimento'] == 'atendimento_avulso') {
                // implementar lógica de recusa para atendimento avulso
              } else if (event['tipoAtendimento'] == 'atendimento_imediato') {}
            },
          ),
        );
      }
    });
    super.initState();
  }

  Future<void> verificarPermissoes() async {
    if (!await FlutterOverlayWindow.isPermissionGranted() &&
        !await Permission.notification.isDenied) {
      showPermissaoOverlayDialog();
    }
  }

  Future<void> showPermissaoOverlayDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.notifications_active, color: Colors.blue, size: 25),
              SizedBox(width: 8),
              Text('Permitir notificações', style: TextStyle(fontSize: 20)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Para receber alertas de atendimento mesmo quando estiver usando outros aplicativos, '
                'é necessário permitir a exibição de notificações sobre outros apps.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Icon(Icons.info_outline, color: Colors.blueAccent, size: 48),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Agora não'),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.check_circle),
              label: Text('Permitir'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                if (!await FlutterOverlayWindow.isPermissionGranted()) {
                  await FlutterOverlayWindow.requestPermission();
                }
                // Solicita permissão de notificação (Android 13+)
                if (await Permission.notification.isDenied) {
                  await Permission.notification.request();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int numeroAtendimentos = 42;
    final double ganhosEstimados = 3200.50;
    final double avaliacao = 4.8;
    final int sessoesRealizadas = 38;
    final int recibosEmitidos = 25;
    final double extratoGanhos = 2950.00;

    return Consumer3<LoginProfissionalController, ProviderController,
            DashboardProfissionalController>(
        builder: (context, controllerLogin, globalProvider, dashboardController,
            child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Olá, ${controllerLogin.profissional?.nome ?? ''}'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () async {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login_profissional', (route) => false);
                try {
                  String status = await dashboardController.logoutProfissional(
                      profissionalId: controllerLogin.profissional!.id!);
                  if (status.isNotEmpty) {
                    await dashboardController.alterarStatusAtendePlantao(
                        profissionalId: controllerLogin.profissional!.id!,
                        novoStatus: false);
                    globalProvider.setPlantao(false);
                    globalWebSocketProvider.disconnect();

                    if (context.mounted) {
                      GlobalSnackbars.showSnackBar(status,
                          backgroundColor: Colors.green);
                    }
                  }
                  // if (context.mounted) {
                  //   Navigator.pushNamedAndRemoveUntil(
                  //       context, '/login_profissional', (route) => false);
                  // }
                } catch (e) {
                  if (context.mounted) {
                    GlobalSnackbars.showSnackBar('Erro ao fazer logout: $e',
                        backgroundColor: Colors.red);
                  }
                }
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppThemes.secondaryColor,
                AppThemes.primaryColor,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //const SizedBox(width: 1),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                                radius: 48,
                                child: AnimatedCachedImage(
                                    imageUrl:
                                        controllerLogin.profissional!.foto)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/editar_perfil_profissional');
                                },
                                label: const Text(
                                  'Editar Perfil',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Colors.black54,
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets
                                      .zero, // Remove o padding do botão
                                  minimumSize: Size(0,
                                      0), // Remove restrição de tamanho mínimo
                                  tapTargetSize: MaterialTapTargetSize
                                      .shrinkWrap, // Área de toque justa
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Icon(
                                    globalProvider.online
                                        ? Icons.circle
                                        : Icons.circle_outlined,
                                    color: globalProvider.online
                                        ? AppThemes.online
                                        : AppThemes.offline,
                                    size: 16),
                                const SizedBox(width: 6),
                                Text(
                                    globalProvider.online
                                        ? 'Online'
                                        : 'Offline',
                                    style: TextStyle(
                                        color: globalProvider.online
                                            ? Colors.white
                                            : Colors.black)),
                                Switch(
                                  value: globalProvider.online,
                                  onChanged: (status) async {
                                    globalProvider.setOnline(status);
                                    // Verifica permissões antes de conectar
                                    verificarPermissoes();
                                    // Verifica se a permissão de notificação foi concedida
                                    if (await FlutterOverlayWindow
                                        .isPermissionGranted()) {
                                      // Conecta ao WebSocket se estiver online
                                      if (globalProvider.online) {
                                        globalWebSocketProvider.connect();
                                        // Envia a identificação do profissional
                                        globalWebSocketProvider
                                            .identifyConnection(
                                                controllerLogin
                                                    .profissional!.id!,
                                                'profissional');

                                        globalWebSocketProvider.startPing(
                                            controllerLogin.profissional!.id!);
                                        GlobalSnackbars.showSnackBar(
                                            'Você está conectado!',
                                            backgroundColor: Colors.green);
                                      } else {
                                        globalWebSocketProvider.disconnect();
                                        globalWebSocketProvider.stopPing();
                                        await dashboardController
                                            .alterarStatusAtendePlantao(
                                                profissionalId: controllerLogin
                                                    .profissional!.id!,
                                                novoStatus: status);
                                        globalProvider.setPlantao(false);
                                        GlobalSnackbars.showSnackBar(
                                            'Você está desconectado!',
                                            backgroundColor: Colors.amber);
                                      }
                                    } else {
                                      if (context.mounted) {
                                        GlobalSnackbars.showSnackBar(
                                            'Você precisa permitir as notificações para ficar online.',
                                            backgroundColor: Colors.orange,
                                            durationInSeconds: 5);
                                      }
                                      globalProvider.setOnline(false);
                                    }
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                    globalProvider.plantao
                                        ? Icons.circle
                                        : Icons.circle_outlined,
                                    color: globalProvider.plantao
                                        ? AppThemes.online
                                        : AppThemes.offline,
                                    size: 16),
                                const SizedBox(width: 6),
                                Text(
                                    globalProvider.plantao
                                        ? 'Atendimento\nimediato'
                                        : 'Não disponível\nacolhimento',
                                    style: TextStyle(
                                        color: globalProvider.plantao
                                            ? Colors.white
                                            : Colors.black)),
                                Switch(
                                  value: globalProvider.plantao,
                                  onChanged: (status) async {
                                    globalProvider.setPlantao(status);
                                    if (globalProvider.online) {
                                      verificarPermissoes();
                                      try {
                                        String statusAtual =
                                            await dashboardController
                                                .alterarStatusAtendePlantao(
                                                    profissionalId:
                                                        controllerLogin
                                                            .profissional!.id!,
                                                    novoStatus: status);
                                        if (statusAtual.isNotEmpty) {
                                          if (context.mounted) {
                                            GlobalSnackbars.showSnackBar(
                                                statusAtual,
                                                backgroundColor: Colors.green);
                                          }
                                        }
                                      } catch (error) {
                                        if (context.mounted) {
                                          GlobalSnackbars.showSnackBar(
                                              'Erro ao alterar status: $error',
                                              backgroundColor: Colors.red);
                                        }
                                        globalProvider.setPlantao(false);
                                      }
                                    } else {
                                      if (context.mounted) {
                                        GlobalSnackbars.showSnackBar(
                                            'Você precisa estar online para alterar o status de plantão.',
                                            backgroundColor: Colors.orange);
                                      }
                                      globalProvider.setPlantao(false);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/atendimento_profissional');
                        },
                        child: _InfoCard(
                            title: 'Sessões Realizadas',
                            value: '$sessoesRealizadas',
                            icon: Icons.event_available),
                      ),
                      _InfoCard(
                          title: 'Ganhos Estimados',
                          value: 'R\$ ${ganhosEstimados.toStringAsFixed(2)}',
                          icon: Icons.attach_money),
                      _InfoCard(
                          title: 'Avaliação',
                          value: '$avaliacao',
                          icon: Icons.star,
                          color: Colors.amber),
                      _InfoCard(
                          title: 'Moderações',
                          value: '$numeroAtendimentos',
                          icon: Icons.people_alt_outlined),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const SizedBox(height: 24),
                  Text('Finanças',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.receipt_long),
                      title: const Text('Recibos Emitidos'),
                      trailing: Text('$recibosEmitidos'),
                      onTap: () {
                        // Navegar para tela de recibos
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading:
                          const Icon(Icons.account_balance_wallet_outlined),
                      title: const Text('Extrato de Ganhos'),
                      trailing: Text('R\$ ${extratoGanhos.toStringAsFixed(2)}'),
                      onTap: () {
                        // Navegar para tela de extrato
                      },
                    ),
                  ),
                  //const SizedBox(height: 24),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.support_agent),
                      title: const Text('Suporte'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {
                        // Navegar para tela de suporte
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  const _InfoCard(
      {required this.title,
      required this.value,
      required this.icon,
      this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 24,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  color: color ?? Theme.of(context).primaryColor, size: 32),
              const SizedBox(height: 8),
              Text(value,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
