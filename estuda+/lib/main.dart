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
  //StorageSharedPreferences sharedPreferences = StorageSharedPreferences();
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
        // useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(70)),
          // )
        ),
      ),
      home: const ScreenInitial(),
    );
  }
}
