import 'package:flutter/material.dart';

class AtendimentosProfissionalScreen extends StatefulWidget {
  const AtendimentosProfissionalScreen({super.key});

  @override
  State<AtendimentosProfissionalScreen> createState() =>
      _AtendimentosProfissionalScreenState();
}

class _AtendimentosProfissionalScreenState
    extends State<AtendimentosProfissionalScreen> {
  String? fotoPerfil;
  @override
  Widget build(BuildContext context) {
    // Lista mockada de atendimentos
    final atendimentos = [
      {
        'nome': 'João Silva',
        'idade': 28,
        'dataHora': DateTime(2025, 5, 20, 14, 30),
        'tipo': 'Plantão',
      },
      {
        'nome': 'Maria Souza',
        'idade': 34,
        'dataHora': DateTime(2025, 5, 18, 10, 0),
        'tipo': 'Avulso',
      },
      {
        'nome': 'Carlos Lima',
        'idade': 22,
        'dataHora': DateTime(2025, 5, 15, 16, 45),
        'tipo': 'Plantão',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Atendimentos Efetuados'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: atendimentos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final atendimento = atendimentos[index];
          final dataHora = atendimento['dataHora'] as DateTime;
          return Card(
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor,
                backgroundImage:
                    fotoPerfil != null ? NetworkImage(fotoPerfil!) : null,
                child: fotoPerfil == null
                    ? const Icon(Icons.person, size: 22)
                    : null,
              ),
              title: Text(atendimentos[index]['nome'].toString()),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Idade: ${atendimento['idade']}'),
                  Text('Data: ${dataHora.day.toString().padLeft(2, '0')}/'
                      '${dataHora.month.toString().padLeft(2, '0')}/'
                      '${dataHora.year}  Hora: ${dataHora.hour.toString().padLeft(2, '0')}:${dataHora.minute.toString().padLeft(2, '0')}'),
                  Row(
                    children: [
                      Text('Tipo: '),
                      Chip(
                        label: Text(atendimentos[index]['tipo'].toString()),
                        backgroundColor: atendimento['tipo'] == 'Plantão'
                            ? Colors.orange.shade100
                            : Colors.blue.shade100,
                        labelStyle: TextStyle(
                          color: atendimento['tipo'] == 'Plantão'
                              ? Colors.orange.shade800
                              : Colors.blue.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Icon(
                atendimento['tipo'] == 'Plantão' ? Icons.flash_on : Icons.event,
                color: atendimento['tipo'] == 'Plantão'
                    ? Colors.orange
                    : Colors.blue,
              ),
            ),
          );
        },
      ),
    );
  }
}
