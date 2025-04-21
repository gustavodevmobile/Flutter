import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/initial_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GlobalProviders(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      highContrastTheme: ThemeData(
        applyElevationOverlayColor: true,
      ),
      title: 'Estuda +',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
        ),
      ),
      home: const ScreenInitial(),
    );
  }
}
