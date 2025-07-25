import 'package:admin_noribox_store/controllers/categoria_controller.dart';

import 'package:admin_noribox_store/controllers/clientes_controller.dart';
import 'package:admin_noribox_store/controllers/produto_controller.dart';
import 'package:admin_noribox_store/services/categoria_service.dart';
import 'package:admin_noribox_store/services/clientes_service.dart';

import 'package:admin_noribox_store/services/produto_service.dart';
import 'package:admin_noribox_store/views/admin_dashboard_page.dart';
import 'package:admin_noribox_store/views/cadastro_categoria_page.dart';
import 'package:admin_noribox_store/views/cadastro_produto_page.dart';
import 'package:admin_noribox_store/views/lista_clientes_page.dart';
import 'package:admin_noribox_store/views/lista_produtos_page.dart';
import 'package:admin_noribox_store/widgets/global_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // CARREGUE O DOTENV ANTES DE TUDO
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProdutoController(service: Service()),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoriaController(service: CategoriaService()),
        ),
        ChangeNotifierProvider(
          create: (_) => ClientesController(service: ClientesService()
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
      scaffoldMessengerKey: GlobalSnackbar.messengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Admin Noribox Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const AdminDashboardPage(),
        '/produtos': (context) => const ListaProdutosPage(),
        '/cadastrar-produto': (context) => const CadastroProdutoPage(),
        '/cadastrar-categoria': (context) => const CadastroCategoriaPage(),
        '/clientes': (context) => const ListaClientesPage(),
        
      },
    );
  }
}
