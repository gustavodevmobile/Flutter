import 'package:flutter/material.dart';

class DashboardUsuarioScreen extends StatelessWidget {
  const DashboardUsuarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Usuário')),
      body: Center(child: Text('Tela de Dashboard Usuário')),
    );
  }
}
