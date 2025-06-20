import 'package:flutter/material.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  int _expanded = 0; // 0: nenhum, 1: usuario, 2: profissional

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // @override
  // void initState() {
  //   super.initState();
  //    _requestNotificationPermission();
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');
  //   const InitializationSettings initializationSettings =
  //       InitializationSettings(android: initializationSettingsAndroid);
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings);

  //   // Solicitar permissão para notificações (Android 13+)
  //   // flutterLocalNotificationsPlugin
  //   //     .resolvePlatformSpecificImplementation<
  //   //         AndroidFlutterLocalNotificationsPlugin>()
  //   //     ?.requestPermission(); // Remova esta linha se não estiver usando flutter_local_notifications >= 12.0.0

  //   // Se estiver usando flutter_local_notifications < 12.0.0, não há necessidade de solicitar permissão manualmente para Android.
  //   // Para Android 13+ (API 33+), use o package permission_handler para solicitar a permissão POST_NOTIFICATIONS, se necessário.
  // }

  // Future<void> _requestNotificationPermission() async {
  // // Só é necessário para Android 13+ (API 33+)
  // if (await Permission.notification.isDenied) {
  //   await Permission.notification.request();
  // }
//}

  void _toggle(int value) {
    setState(() {
      _expanded = _expanded == value ? 0 : value;
      //showTestNotification();
      print('Botão $value pressionado');
    });
  }

  // Future<void> showTestNotification() async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'test_channel',
  //     'Test Channel',
  //     channelDescription: 'Canal de teste',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'Notificação de Teste',
  //     'Esta é uma notificação local!',
  //     platformChannelSpecifics,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF7AB0A3); // cor do tema
    final blueColor = const Color(0xFF4F8FCB); // azul suave
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo!'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [themeColor, blueColor],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Substituir o ícone pelo logo
                  Image.asset(
                    'assets/image/logotipoBlurt2.png', // Certifique-se de que o caminho está correto
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                  ),

                  Text(
                    'Bem-vindo ao seu espaço de acolhimento e terapia!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Card(
                    elevation: 8,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 32),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => _toggle(1),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              textStyle: const TextStyle(fontSize: 18),
                              backgroundColor: themeColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Sou Usuário'),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            height: _expanded == 1 ? 50 : 0,
                            child: _expanded == 1
                                ? Row(
                                    key: const ValueKey('usuario'),
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //const SizedBox(width: 6),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/login_usuario');
                                        },
                                        child: const Text('Entrar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/cadastro_usuario');
                                        },
                                        child: const Text('Cadastrar'),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _toggle(2),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              textStyle: const TextStyle(fontSize: 18),
                              backgroundColor: blueColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Sou Psicólogo(a)'),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            height: _expanded == 2 ? 50 : 0,
                            child: _expanded == 2
                                ? Row(
                                    key: const ValueKey('profissional'),
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 8),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/login_profissional');
                                        },
                                        child: const Text('Entrar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/cadastro_psicologo');
                                        },
                                        child: const Text('Cadastrar'),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _toggle(3),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              textStyle: const TextStyle(fontSize: 18),
                              backgroundColor:
                                  const Color.fromARGB(255, 98, 143, 185),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Sou Psicanalista'),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            height: _expanded == 3 ? 50 : 0,
                            child: _expanded == 3
                                ? Row(
                                    key: const ValueKey('profissional'),
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 8),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pushNamed(
                                              context, '/login_profissional');
                                        },
                                        child: const Text('Entrar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              '/cadastro_psicanalista');
                                        },
                                        child: const Text('Cadastrar'),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
