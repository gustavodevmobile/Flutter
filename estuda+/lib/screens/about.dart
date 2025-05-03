import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre o App', style: AppTheme.customTextStyle2(fontSize: 18)),
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Routes().popRoutes(context, const HomeScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lição em Casa',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Versão: 1.0.0',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Descrição:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'O Lição em Casa é um aplicativo desenvolvido para ajudar estudantes a melhorar seu desempenho escolar, aproveitando o que está sendo aprendido na escola e aplicando resolvendo questões. Ele oferece recursos como questões com imagens e sem imagens, resumos de desempenho e ferramentas de envio de desempenho em pdf, que poderão ser enviados para qualquer pessoa e também salvos no dispositivo. Através do aplicativo, os alunos podem gerar relatórios de desempenho que também poderão ser utilizados para compartilhar com professores e colegas, além de poder enviar para seus responsáveis visando algo determinado objetivo.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Contato:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'E-mail: suporte@estudamais.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Telefone: (11) 1234-5678',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Volta para a tela anterior
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                ),
                child: const Text(
                  'Voltar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

