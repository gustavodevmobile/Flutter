import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:noribox_store/controllers/calcular_frete.dart';
import 'package:noribox_store/controllers/carrinho_controllers.dart';
import 'package:noribox_store/controllers/produtos_controllers.dart';
import 'package:noribox_store/controllers/cliente_controllers.dart';
import 'package:noribox_store/service/calcular_frete_service.dart';
import 'package:noribox_store/service/produtos_service.dart';
import 'package:noribox_store/service/cliente_service.dart';
import 'package:noribox_store/views/carrinho_screen.dart';
import 'package:noribox_store/views/home.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // CARREGUE O DOTENV ANTES DE TUDO
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CarrinhoController(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProdutosController(service: ProdutosService()),
        ),
        ChangeNotifierProvider(
          create: (context) => CalcularFreteController(
            serviceFrete: CalcularFreteService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ClienteControllers(clienteService: ClienteService()),
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
      initialRoute: '/',
      routes: {
        '/': (context) => const EcommercePage(),
        '/carrinho': (context) => const CarrinhoScreen(),
      },
    );
  }
}
