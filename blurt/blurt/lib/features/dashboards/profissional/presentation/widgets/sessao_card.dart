import 'package:flutter/material.dart';

class SessaoCard extends StatelessWidget {
  const SessaoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Sessão'),
      ),
    );
  }
}
