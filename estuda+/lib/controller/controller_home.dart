import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/discipline/discipline.dart';
import 'package:estudamais/service/service.dart';
import 'package:estudamais/widgets/show_loading_dialog.dart';
import 'package:flutter/material.dart';

class ControllerHome {
  Service service = Service();
  List<String> disciplines = [];

// Método responsável por buscar as disciplinas
// e retorna uma lista de disciplinas
  void fetchDisciplines(Function(List<String> disciplines) onSuccess,
      Function(String) onError) async {
    try {
      disciplines = await service.getDisciplines((error) {
        onError(error);
      });
      //print('Disciplinas: $disciplines');
      onSuccess(disciplines);
    } catch (e) {
      onError('Não foi possível buscar as Disciplinas: $e');
    }
  }

// Método responsável por manipular o resultadosdo da busca das disciplinas
// e retorna uma lista de disciplinas para mostrar na tela de disciplinas
  void handleFetchDisciplines(BuildContext context, Function(String) onError) {
    showLoadingDialog(context, 'Buscando disciplinas...');
    fetchDisciplines(
      (disciplines) {
        if (disciplines.isNotEmpty) {
          Navigator.pop(context);
          Routes().pushRoute(
            context,
            Discipline(disciplines: disciplines),
          );
        } else {
          onError('Ops, algo deu errado.\nTente novamente mais tarde.');
        }
      },
      (error) {
        Navigator.pop(context);
        onError(error);
      },
    );
  }
}
