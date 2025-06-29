import 'package:blurt/core/utils/app_life_cyrcle_provider.dart';
import 'package:blurt/core/utils/global_snackbars.dart';
import 'package:blurt/core/utils/overlay_solicitacao.dart';
import 'package:blurt/core/websocket/websocket_provider.dart';
import 'package:blurt/features/abordagem_principal/data/abordagem_principal_datasource.dart';
import 'package:blurt/features/abordagem_principal/presentation/abordagem_principal_controller.dart';
import 'package:blurt/features/abordagens_utilizadas/data/abordagens_utilizadas_datasource.dart';
import 'package:blurt/features/abordagens_utilizadas/presentation/abordagens_utilizadas_controller.dart';
import 'package:blurt/features/autenticacao/data/datasources/profissional/login_profissional_remote_datasource_impl.dart';
import 'package:blurt/features/autenticacao/data/datasources/usuario/login_remote_datasource_impl.dart';
import 'package:blurt/features/autenticacao/data/repositories/login_profissional_repository_impl.dart';
import 'package:blurt/features/autenticacao/data/repositories/login_repository_impl.dart';
import 'package:blurt/features/autenticacao/domain/usecases/login_profissional_usecase.dart';
import 'package:blurt/features/autenticacao/domain/usecases/login_usuario_usecase.dart';
import 'package:blurt/features/autenticacao/presentation/controllers/login_controller.dart';
import 'package:blurt/features/autenticacao/presentation/controllers/login_profissional_controller.dart';
import 'package:blurt/features/autenticacao/presentation/pages/login_profissional_screen.dart';
import 'package:blurt/features/cadastro/data/datasources/profissional/cadastro_profissional_datasource_impl.dart';
import 'package:blurt/features/cadastro/data/datasources/usuario/cadastro_usuario_datasource_impl.dart';
import 'package:blurt/features/cadastro/data/repositories/cadastro_profissional_repository_impl.dart';
import 'package:blurt/features/cadastro/data/repositories/cadastro_usuario_repository_impl.dart';
import 'package:blurt/features/cadastro/domain/usecases/cadastrar_profissional_usecase.dart';
import 'package:blurt/features/cadastro/domain/usecases/cadastro_usuario_usecase.dart';
import 'package:blurt/features/cadastro/presentation/controllers/cadastro_profissional_controller.dart';
import 'package:blurt/features/cadastro/presentation/controllers/cadastro_usuario_controller.dart';
import 'package:blurt/features/cadastro/presentation/pages/cadastro_psicanalista_screen.dart';
import 'package:blurt/features/cadastro/presentation/pages/cadastro_psicologo_screen.dart';
import 'package:blurt/features/cadastro/presentation/pages/cadastro_usuario_screen.dart';
import 'package:blurt/features/dashboards/profissional/data/datasources/dashbord_profissional_datasource_impl.dart';
import 'package:blurt/features/dashboards/profissional/presentation/controllers/dashboard_profissional_controller.dart';
import 'package:blurt/features/dashboards/profissional/presentation/pages/dashboard_profissional_screen.dart';
import 'package:blurt/features/dashboards/profissional/presentation/pages/dashboard_usuario_screen.dart';
import 'package:blurt/features/especialidade_principal/data/especialidade_principal_datasource.dart';
import 'package:blurt/features/especialidade_principal/presentation/especialidade_principal_controller.dart';
import 'package:blurt/features/profissionais_online/controllers/profissionais_online_controller.dart';
import 'package:blurt/features/profissionais_online/data/datasources/profissional_online_datasource_impl.dart';
import 'package:blurt/features/profissionais_online/data/repositories/profissionais_online_impl.dart';
import 'package:blurt/features/profissionais_online/domain/usecases/profissionais_online_usecases.dart';
import 'package:blurt/features/tela_inical/presentation/initial_screen.dart';
import 'package:blurt/features/temas_clinicos/data/temas_clinicos_datasource.dart';
import 'package:blurt/features/temas_clinicos/presentation/temas_clinicos_controller.dart';
import 'package:blurt/provider/provider_controller.dart';
import 'package:blurt/theme/themes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:blurt/features/autenticacao/presentation/pages/login_usuario_screen.dart';
import 'package:blurt/screens/atendimentos_profissional.dart';
import 'package:blurt/screens/perfil_profissional.dart';
import 'package:blurt/screens/editar_perfil_profissional.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';

late AppLifecycleProvider appLifecycleProvider;
late WebSocketProvider globalWebSocketProvider;

//@pragma("vm:entry-point")
// void overlayMain() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     const OverlayEntryPoint(),
//   );
// }

// Handler de background do FCM: exibe notificação local customizada
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await mostrarNotificacaoSolicitacao(message.data);
  print('Mensagem recebida em background: ${message.data}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp();
  appLifecycleProvider = AppLifecycleProvider();
  globalWebSocketProvider = WebSocketProvider();


// Permissão
  await FirebaseMessaging.instance.requestPermission();

  // Registra o handler de background do FCM
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Inicializa o plugin de notificações locais
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Cria o canal de notificação para Android
  const AndroidNotificationChannel solicitacaoChannel =
      AndroidNotificationChannel(
    'solicitacao_channel',
    'Solicitações',
    description: 'Notificações de solicitações de atendimento',
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('alert1'),
    playSound: true,
  );

  Future<void> setupNotifications() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(solicitacaoChannel);
  }

  await setupNotifications();

// Inicializa configurações do plugin de notificações
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Listener para mensagens recebidas em foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Mensagem recebida: ${message.data}');
  });
  const platform = MethodChannel('com.example.blurt/intent');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appLifecycleProvider),
        //ChangeNotifierProvider(create: (_) => WebSocketProvider()),
        ChangeNotifierProvider.value(value: globalWebSocketProvider),
        ChangeNotifierProvider(create: (_) => ProviderController()),
        ChangeNotifierProvider(
          create: (_) => ProfissionaisOnlineController(
            ProfissionaisOnlineUsecases(
              ProfissionaisOnLineImpl(
                ProfissionalOnlineDatasourceImpl(http.Client()),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
            create: (_) => AbordagemPrincipalController(
                AbordagemPrincipalDatasource(http.Client()))),
        ChangeNotifierProvider(
            create: (_) => EspecialidadePrincipalController(
                EspecialidadePrincipalDatasource(http.Client()))),
        ChangeNotifierProvider(
            create: (_) => TemasClinicosController(
                TemasClinicosDatasource(http.Client()))),
        ChangeNotifierProvider(
          create: (_) => AbordagensUtilizadasController(
            AbordagensUtilizadasDatasource(http.Client()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CadastroProfissionalController(
            CadastrarProfissionalUseCase(
              CadastroProfissionalRepositoriesImpl(
                CadastroProfissionalDatasourceImpl(http.Client()),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CadastroUsuarioController(
            CadastrarUsuarioUseCase(
              CadastroUsuarioRepositoriesImpl(
                CadastroUsuarioDatasourceImpl(http.Client()),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginProfissionalController(
            LoginProfissionalUseCase(
              LoginProfissionalRepositoryImpl(
                LoginProfissionalRemoteDatasourceImpl(http.Client()),
              ),
            ),
            // Provider.of<WebSocketProvider>(context, listen: false).channel!,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginUsuarioController(
            loginUsuarioUseCase: LoginUsuarioUseCase(
              LoginRepositoryImpl(
                LoginRemoteDatasourceImpl(http.Client()),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardProfissionalController(
            DashboardProfissionalDatasourceImpl(http.Client()),
          ),
        ),

        // Adicione outros providers globais aqui
      ],
      child: const MyApp(),
    ),
  );

  platform.setMethodCallHandler((call) async {
    if (call.method == 'abrir_dashboard') {
      //Verifica se deve abrir o dashboard
      final abrirDashboard = call.arguments?['abrir_dashboard'] ?? false;
      if (abrirDashboard == true) {
        navigatorKey.currentState
            ?.pushReplacementNamed('/dashboard_profissional');
      }
      // Se não for para abrir, apenas ignore ou faça outra ação
    }
  });

// Listener para quando o app é aberto pela notificação
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // App foi aberto pela notificação: navega para a tela de solicitações
    //onNovaSolicitacaoAtendimentoAvulso(message.data);
    Navigator.pushNamed(GlobalSnackbars.messengerKey.currentContext!,
        '/dashboard_profissional');
  });
}

// Global key para o Navigator
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: GlobalSnackbars.messengerKey,
      title: 'Blurt - Acolhimento e Terapia Online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppThemes.secondaryColor,
          primary: AppThemes.primaryColor,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Color.fromARGB(255, 117, 177, 163),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4F8FCB),
          foregroundColor: Colors.white,
          //surfaceTintColor: Color.fromARGB(0, 255, 255, 255),
          iconTheme: IconThemeData(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          elevation: 10,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4F8FCB),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF7AB0A3), width: 2),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const InitialScreen(),
        '/login_usuario': (context) => const LoginUsuarioScreen(),
        '/login_profissional': (context) => const LoginProfissionalScreen(),
        '/cadastro_usuario': (context) => const UsuarioFormScreen(),
        '/cadastro_psicologo': (context) => const CadastroPsicologoScreen(),
        '/cadastro_psicanalista': (context) =>
            const CadastroPsicanalistaFormScreen(),
        '/dashboard_usuario': (context) => const DashboardUsuarioScreen(),
        '/dashboard_profissional': (context) =>
            const DashboardProfissionalScreen(),
        '/editar_perfil_profissional': (context) =>
            const EditarPerfilProfissionalScreen(),
        '/atendimento_profissional': (context) =>
            const AtendimentosProfissionalScreen(),
        '/perfil_profissional': (context) => const PerfilProfissionalScreen(),
      },
    );
  }
}
