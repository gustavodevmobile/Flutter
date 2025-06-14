import 'package:flutter/material.dart';
import 'package:blurt/core/services/busca_cidades.dart';

class StateCityDropdown extends StatefulWidget {
  final Function(String, String) onSelectionChanged;

  const StateCityDropdown({super.key, required this.onSelectionChanged});
      

  @override
  StateCityDropdownState createState() => StateCityDropdownState();
}

class StateCityDropdownState extends State<StateCityDropdown> {
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
        cidadeSelecionada = null;
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
        DropdownButtonFormField<String>(
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
        const SizedBox(height: 16),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (estadoSelecionado == null || cidades.isEmpty) {
              return const Iterable<String>.empty();
            }
            if (textEditingValue.text.isEmpty) {
              return cidades;
            }
            return cidades.where((c) => c
                .toLowerCase()
                .startsWith(textEditingValue.text.toLowerCase()));
          },
          displayStringForOption: (option) => option,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            controller.text = cidadeSelecionada ?? '';
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: const InputDecoration(
                labelText: 'Cidade',
                prefixIcon: Icon(Icons.location_city_outlined),
              ),
              enabled: estadoSelecionado != null && cidades.isNotEmpty,
              validator: (value) {
                if (estadoSelecionado == null || cidades.isEmpty) {
                  return 'Selecione um estado';
                }
                if (value == null || value.isEmpty) {
                  return 'Selecione ou digite uma cidade';
                }
                if (!cidades.contains(value)) {
                  return 'Cidade inválida';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  cidadeSelecionada = value;
                });
                if (estadoSelecionado != null &&
                    cidadeSelecionada != null &&
                    cidades.contains(cidadeSelecionada)) {
                  widget.onSelectionChanged(
                      estadoSelecionado!, cidadeSelecionada!);
                }
              },
            );
          },
          onSelected: (value) {
            setState(() {
              cidadeSelecionada = value;
            });
            if (estadoSelecionado != null && cidadeSelecionada != null) {
              widget.onSelectionChanged(estadoSelecionado!, cidadeSelecionada!);
            }
          },
        ),
      ],
    );
  }
}
