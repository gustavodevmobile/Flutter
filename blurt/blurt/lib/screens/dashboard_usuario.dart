import 'package:flutter/material.dart';

class DashboardUsuarioScreen extends StatelessWidget {
  const DashboardUsuarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF7AB0A3);
    final blueColor = const Color(0xFF4F8FCB);
    // Dados mockados para exemplo
    final sessoes = [
      {'data': '20/05/2025', 'profissional': 'Dra. Ana', 'tipo': 'Psicólogo'},
      {
        'data': '10/05/2025',
        'profissional': 'Dr. João',
        'tipo': 'Psicanalista'
      },
    ];
    final ultimaSessao = sessoes.isNotEmpty ? sessoes.first : null;
    final profissionaisOnline = [
      {
        'nome': 'Dra. Carla',
        'tipo': 'Psicólogo',
        'consulta': 'R\$ 120,00',
        'atendimento': true
      },
      {
        'nome': 'Dr. Lucas',
        'tipo': 'Psicólogo',
        'consulta': 'R\$ 150,00',
        'atendimento': true
      },
      {
        'nome': 'Dra. Sofia',
        'tipo': 'Psicanalista',
        'consulta': 'R\$ 200,00',
        'atendimento': false
      },
      {
        'nome': 'Dr. Pedro',
        'tipo': 'Psicólogo',
        'consulta': 'R\$ 130,00',
        'atendimento': true
      },
      {
        'nome': 'Dra. Maria',
        'tipo': 'Psicóloga',
        'consulta': 'R\$ 140,00',
        'atendimento': false
      },
      {
        'nome': 'Dr. Rafael',
        'tipo': 'Psicólogo',
        'consulta': 'R\$ 160,00',
        'atendimento': true
      },
      {
        'nome': 'Dra. Beatriz',
        'tipo': 'Psicóloga',
        'consulta': 'R\$ 170,00',
        'atendimento': false
      },
      {
        'nome': 'Dr. Felipe',
        'tipo': 'Psicanalista',
        'consulta': 'R\$ 180,00',
        'atendimento': true
      },
      {
        'nome': 'Dra. Laura',
        'tipo': 'Psicóloga',
        'consulta': 'R\$ 190,00',
        'atendimento': true
      },
      {
        'nome': 'Dr. Tiago',
        'tipo': 'Psicólogo',
        'consulta': 'R\$ 110,00',
        'atendimento': false
      },
      {
        'nome': 'Dra. Ana',
        'tipo': 'Psicóloga',
        'consulta': 'R\$ 125,00',
        'atendimento': false
      },
      {
        'nome': 'Dr. Bruno',
        'tipo': 'Psicólogo',
        'consulta': 'R\$ 135,00',
        'atendimento': false
      },
      {
        'nome': 'Dra. Fernanda',
        'tipo': 'Psicóloga',
        'consulta': 'R\$ 145,00',
        'atendimento': true
      },
      {
        'nome': 'Dr. Gustavo',
        'tipo': 'Psicanalista',
        'consulta': 'R\$ 155,00',
        'atendimento': true
      },
    ];

    return Scaffold(
      appBar: AppBar(
          title: const Text('Dashboard Usuário'),
          centerTitle: true,
          automaticallyImplyLeading: false, // Remove o ícone padrão do Drawer
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context); // Volta para a tela anterior
              },
              icon: Icon(Icons.arrow_back_ios)) // Ícone customizado

          ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(123, 255, 255, 255),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Profissionais Online',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CardProdissional(
                      profOnline: profissionaisOnline,
                      scrollDirection: Axis.vertical,
                      itemHeight: MediaQuery.of(context).size.height,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [themeColor, blueColor],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Bem-vindo!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    title: const Text('Última sessão'),
                    subtitle: Text(ultimaSessao != null
                        ? '${ultimaSessao['data']} com ${ultimaSessao['profissional']} (${ultimaSessao['tipo']})'
                        : 'Nenhuma sessão realizada'),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    title: const Text('Quantidade de sessões realizadas'),
                    trailing: Text('${sessoes.length}'),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Sessões realizadas:',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                sessoes.isEmpty
                    ? const Text('Nenhuma sessão realizada.')
                    : SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: sessoes.length,
                          itemBuilder: (context, index) {
                            final sessao = sessoes[index];
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.event_available),
                                title: Text(
                                    'Profissional: ${sessao['profissional']}'),
                                subtitle: Text(
                                    'Data: ${sessao['data']} - Tipo: ${sessao['tipo']}'),
                              ),
                            );
                          },
                        ),
                      ),
                //const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.flash_on),
                  label: const Text('Atendimento Agora'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    // Implementar lógica de atendimento imediato
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Profissionais Online:',
                        style: Theme.of(context).textTheme.titleMedium),
                    Builder(
                      builder: (context) => TextButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: const Text(
                          'Ver Todos',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CardProdissional(
                  profOnline: profissionaisOnline,
                  scrollDirection: Axis.horizontal,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CardProdissional extends StatelessWidget {
  final List<Map<String, dynamic>> profOnline;
  final Axis scrollDirection;
  final double? itemHeight;
  const CardProdissional(
      {required this.profOnline,
      required this.scrollDirection,
      this.itemHeight = 90,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight,
      child: ListView.separated(
        scrollDirection: scrollDirection,
        itemCount: profOnline.length,
        separatorBuilder: (_, __) => const SizedBox(width: 2),
        itemBuilder: (context, index) {
          final prof = profOnline[index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              '/perfil_profissional',
              arguments: profOnline[index],
            ),
            child: Card(
              elevation: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        CircleAvatar(
                          radius: 25,
                          child: Icon(Icons.person, size: 25),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              prof['nome'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(prof['tipo'].toString()),
                            Text(prof['consulta'].toString(),
                                style: TextStyle(fontSize: 13)),
                          ],
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                  //const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Icon(
                      Icons.circle,
                      color: profOnline[index]['atendimento'] == true
                          ? Colors.green
                          : Colors.amber,
                      size: 16,
                    ),
                  ),
                  //const SizedBox(width: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
