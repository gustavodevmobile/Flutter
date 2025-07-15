
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:noribox_store/controllers/calcular_frete.dart';
import 'package:noribox_store/controllers/produtos_controllers.dart';
import 'package:noribox_store/service/calcular_frete_service.dart';
import 'package:noribox_store/service/produtos_service.dart';
import 'package:noribox_store/views/cadastro_usuario.dart';
import 'package:noribox_store/views/home.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // CARREGUE O DOTENV ANTES DE TUDO
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProdutosController(service: ProdutosService()),
        ),
        ChangeNotifierProvider(
          create: (context) => CalcularFreteController(
            serviceFrete: CalcularFreteService(),
          ),
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
      debugShowCheckedModeBanner: false,
      title: 'Asatoma Store',
      // theme: ThemeData(
      //   primarySwatch: Colors.deepPurple,
      // ),
      home: const CadastroUsuarioScreen()
      //const EcommercePage(),
      // routes: {
      //   '/': (context) => const EcommercePage(),
      // },
    );
  }
}
