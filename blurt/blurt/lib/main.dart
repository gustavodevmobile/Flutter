import 'package:blurt/controller/provider_controller.dart';
import 'package:blurt/screens/atendimentos_profissional.dart';
import 'package:blurt/screens/dashboard_profissional.dart';
import 'package:blurt/screens/perfil_profissional.dart';
import 'package:blurt/screens/editar_perfil_profissional.dart';
import 'package:flutter/material.dart';
import 'package:blurt/screens/cadastro_psicanalista.dart';
import 'package:blurt/screens/login_profissional.dart';
import 'package:blurt/screens/login_usuario.dart';
import 'package:blurt/screens/cadastro_usuario.dart';
import 'package:blurt/screens/cadastro_psicologo.dart';
import 'screens/initial_screen.dart';
import 'package:blurt/screens/dashboard_usuario.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProviderController(),
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
        '/cadastro_usuario': (context) => const UsuarioFormScreen(),
        '/cadastro_psicologo': (context) => const PsicologoFormScreen(),
        '/cadastro_psicanalista': (context) => const PsicanalistaFormScreen(),
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
