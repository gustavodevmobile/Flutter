import 'package:estudamais/database/storage_shared_preferences.dart';
import 'package:estudamais/service/questions_corrects_providers.dart';
import 'package:estudamais/service/questions_incorrects_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:estudamais/models/models.dart';
import 'package:estudamais/screens/initial_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => ModelPoints(),
      ),
      ChangeNotifierProvider(
        create: (_) => QuestionsCorrectsProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => QuestionsIncorrectsProvider(),
      ),
    ], child: const MyApp()),
  );
   StorageSharedPreferences sharedPreferences = StorageSharedPreferences();
  // sharedPreferences
  //     .recover(StorageSharedPreferences.keyIdsAnsweredsCorrects)
  //     .then((id) {
  //   print('id $id');
  // });

 
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
