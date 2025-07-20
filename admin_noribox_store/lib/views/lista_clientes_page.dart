import 'package:admin_noribox_store/widgets/global_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_noribox_store/controllers/clientes_controller.dart';
import 'detalhe_cliente_page.dart';

class ListaClientesPage extends StatefulWidget {
  const ListaClientesPage({super.key});

  @override
  State<ListaClientesPage> createState() => _ListaClientesPageState();
}

class _ListaClientesPageState extends State<ListaClientesPage> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final clientesController = Provider.of<ClientesController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Clientes Cadastrados')),
      body: Scrollbar(
        thumbVisibility: true,
        controller: _horizontalController,
        child: SingleChildScrollView(
          controller: _horizontalController,
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            controller: _verticalController,
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: DataTable(
                // dataRowMinHeight: 60,
                // dataRowMaxHeight: 80,
                columns: const [
                  DataColumn(label: Text('Nome')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Celular')),
                  DataColumn(label: Text('Telefone')),
                  DataColumn(label: Text('CPF/CNPJ')),
                  DataColumn(label: Text('Gênero')),
                  DataColumn(label: Text('Nascimento')),
                  DataColumn(label: Text('Editar')),
                  DataColumn(label: Text('Excluir')),
                ],
                rows: clientesController.clientes.map((cliente) {
                  return DataRow(
                    onSelectChanged: (selected) {
                      if (selected == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetalheClientePage(cliente: cliente),
                          ),
                        );
                      }
                    },
                    cells: [
                      DataCell(Text(cliente.nomeCompleto)),
                      DataCell(Text(cliente.email ?? '-')),
                      DataCell(Text(cliente.celular ?? '-')),
                      DataCell(Text(cliente.telefone ?? '-')),
                      DataCell(Text(cliente.cpfCnpj ?? '-')),
                      DataCell(Text(cliente.genero ?? '-')),
                      DataCell(Text(cliente.dataNascimento ?? '-')),
                      DataCell(IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {},
                      )),
                      DataCell(IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          print('Excluindo cliente: ${cliente.id}');
                          try {
                            if (cliente.id != null) {
                              await clientesController
                                  .deletarCliente(cliente.id!);
                            }
                            print('cliente excluído: ${clientesController.isDeletado}');
                            if(clientesController.isDeletado) {
                              clientesController.buscarClientesController();
                              GlobalSnackbar.show(
                                'Cliente excluído com sucesso!',
                                backgroundColor: Colors.green,
                              );
                            }
                          }catch (e) {
                            GlobalSnackbar.show(
                              'Erro ao excluir cliente: $e',
                              backgroundColor: Colors.red,
                            );
                          }
                        },
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }
}
