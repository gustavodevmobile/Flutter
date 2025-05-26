import 'package:flutter/material.dart';

class DashboardUsuarioScreen extends StatelessWidget {
  const DashboardUsuarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF7AB0A3);
    final blueColor = const Color(0xFF4F8FCB);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Painel'),
        centerTitle: true,
        backgroundColor: themeColor,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [themeColor, blueColor],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: themeColor),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá, Usuário!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: themeColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bem-vindo ao seu painel',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[800]),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Minhas Sessões',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListTile(
                          leading:
                              Icon(Icons.calendar_today, color: themeColor),
                          title: Text('Nenhuma sessão agendada'),
                          subtitle:
                              Text('Agende uma sessão com um profissional.'),
                          trailing: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Agendar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Histórico de Sessões',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListTile(
                          leading: Icon(Icons.history, color: themeColor),
                          title: Text('Nenhum histórico disponível'),
                          subtitle:
                              Text('Suas sessões passadas aparecerão aqui.'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Meu Perfil',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListTile(
                          leading:
                              Icon(Icons.person_outline, color: themeColor),
                          title: Text('Ver ou editar perfil'),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 18, color: blueColor),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
