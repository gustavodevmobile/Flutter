import 'package:admin_noribox_store/controllers/produto_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<ProdutoController>(context, listen: false)
            .buscarProdutosController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard Admin'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('Admin Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: const Text('Produtos'),
                onTap: () {
                  Navigator.pushNamed(context, '/produtos');
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Clientes'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text('Pedidos'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sair'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: Consumer<ProdutoController>(
            builder: (context, produtosController, child) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1100, // Defina o tamanho máximo desejado
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _DashboardCard(
                      icon: Icons.shopping_bag,
                      title: 'Produtos',
                      value: produtosController.produtos.length.toString(),
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pushNamed(context, '/produtos');
                      },
                    ),
                    _DashboardCard(
                      icon: Icons.shopping_bag,
                      title: 'Cadastrar Produto',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pushNamed(context, '/cadastrar-produto');
                      },
                    ),
                    _DashboardCard(
                      icon: Icons.category,
                      title: 'Cadastrar Categoria',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pushNamed(context, '/cadastrar-categoria');
                      },
                    ),
                    _DashboardCard(
                      icon: Icons.people,
                      title: 'Clientes',
                      value: '350',
                      color: Colors.green,
                      onTap: () {},
                    ),
                    _DashboardCard(
                      icon: Icons.receipt_long,
                      title: 'Pedidos',
                      value: '87',
                      color: Colors.orange,
                      onTap: () {},
                    ),
                    _DashboardCard(
                      icon: Icons.attach_money,
                      title: 'Faturamento',
                      value: 'R\$ 12.500',
                      color: Colors.purple,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Corrige overflow vertical
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: color),
                const SizedBox(height: 16),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(value ?? '',
                      style: TextStyle(
                          fontSize: 16,
                          color: color,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
