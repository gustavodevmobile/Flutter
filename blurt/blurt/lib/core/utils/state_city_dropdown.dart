import 'package:flutter/material.dart';
import 'package:blurt/core/services/busca_cidades.dart';

class StateCityDropdown extends StatefulWidget {
  final Function(String, String) onSelectionChanged;

  const StateCityDropdown({Key? key, required this.onSelectionChanged})
      : super(key: key);

  @override
  _StateCityDropdownState createState() => _StateCityDropdownState();
}

class _StateCityDropdownState extends State<StateCityDropdown> {
  final List<String> estados = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
  ];

  String? estadoSelecionado;
  String? cidadeSelecionada;
  List<String> cidades = [];

  void buscarCidades(String estado) async {
    try {
      final localidadesService = LocalidadesService();
      final cidadesResult =
          await localidadesService.buscarCidadesPorEstado(estado);
      setState(() {
        cidades = cidadesResult;
        cidadeSelecionada = null; // Resetar cidade ao mudar estado
      });
    } catch (e) {
      print('Erro ao buscar cidades: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Estado',
              prefixIcon: Icon(Icons.map_outlined),
            ),
            value: estadoSelecionado,
            items: estados.map((estado) {
              return DropdownMenuItem(
                value: estado,
                child: Text(estado),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                estadoSelecionado = value;
              });
              if (value != null) {
                buscarCidades(value);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Selecione um estado';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),
        if (cidades.isNotEmpty)
          Flexible(
            fit: FlexFit.loose,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Cidade',
                prefixIcon: Icon(Icons.location_city_outlined),
              ),
              value: cidadeSelecionada,
              items: cidades.map((cidade) {
                return DropdownMenuItem(
                  value: cidade,
                  child: Text(
                    cidade.length > 20
                        ? '${cidade.substring(0, 20)}...'
                        : cidade,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  cidadeSelecionada = value;
                });
                if (estadoSelecionado != null && cidadeSelecionada != null) {
                  widget.onSelectionChanged(
                      estadoSelecionado!, cidadeSelecionada!);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecione uma cidade';
                }
                return null;
              },
            ),
          ),
      ],
    );
  }
}
