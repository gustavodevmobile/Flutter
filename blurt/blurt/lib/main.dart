import 'package:blurt/features/autenticacao/data/datasources/login_remote_datasource.dart';
import 'package:blurt/features/autenticacao/data/datasources/login_remote_datasource_impl.dart';
import 'package:blurt/features/autenticacao/data/repositories/login_repository_impl.dart';
import 'package:blurt/features/autenticacao/domain/repositories/login_repository.dart';
import 'package:blurt/features/autenticacao/domain/usecases/login_usuario_usecase.dart';
import 'package:blurt/features/autenticacao/presentation/controllers/login_controller.dart';
import 'package:blurt/features/profissionais_online/controllers/profissionais_online_controller.dart';
import 'package:blurt/features/profissionais_online/data/datasources/profissional_online_datasource_impl.dart';
import 'package:blurt/features/profissionais_online/data/repositories/profissionais_online_impl.dart';
import 'package:blurt/features/profissionais_online/domain/repositories/profissionais_online.dart';
import 'package:blurt/features/profissionais_online/domain/usecases/profissionais_online_usecases.dart';
import 'package:blurt/provider/provider_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:blurt/features/autenticacao/presentation/pages/login_usuario_screen.dart';
import 'package:blurt/screens/atendimentos_profissional.dart';
import 'package:blurt/screens/dashboard_profissional.dart';
import 'package:blurt/screens/perfil_profissional.dart';
import 'package:blurt/screens/editar_perfil_profissional.dart';
import 'package:flutter/material.dart';
import 'package:blurt/screens/cadastro_psicanalista.dart';
import 'package:blurt/screens/login_profissional.dart';
import 'package:blurt/screens/cadastro_usuario.dart';
import 'package:blurt/screens/cadastro_psicologo.dart';
import 'screens/initial_screen.dart';
import 'package:blurt/screens/dashboard_usuario.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() async {
  await dotenv.load();

  runApp(
    MultiProvider(
      providers: [
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
          create: (_) => LoginUsuarioController(
            loginUsuarioUseCase: LoginUsuarioUseCase(
              LoginRepositoryImpl(
                LoginRemoteDatasourceImpl(http.Client()),
              ),
            ),
          ),
        ),
        // Adicione outros providers globais aqui
      ],
      child: const MyApp(),
    ),
  );
  //ApiService().getAbordagens();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blurt - Acolhimento e Terapia Online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7AB0A3),
          primary: Color(0xFF4F8FCB),
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
        // '/cadastro_usuario': (context) => const UsuarioFormScreen(),
        // '/cadastro_psicologo': (context) => const PsicologoFormScreen(),
        // '/cadastro_psicanalista': (context) => const PsicanalistaFormScreen(),
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
