import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/discipline/discipline.dart';
import 'package:estudamais/service/service.dart';
import 'package:estudamais/widgets/show_loading_dialog.dart';
import 'package:flutter/material.dart';

class ControllerHome {
  Service service = Service();
  
  List<String> disciplines = [];

  void fetchDisciplines(Function(List<String> disciplines) onSuccess,
      Function(String) onError) async {
    try {
      disciplines = await service.getDisciplines((error){
        onError(error);
      });
      onSuccess(disciplines);
    } catch (e) {
      onError('Não foi possível buscar as Disciplinas: $e');
    }
  }

  void handleFetchDisciplines(BuildContext context, Function(String)onError) {
    showLoadingDialog(context, 'Buscando disciplinas...');
    fetchDisciplines((disciplines) {
      if (disciplines.isNotEmpty) {
        Navigator.pop(context);
        Routes().popRoutes(
          context,
          Discipline(disciplines: disciplines),
        );
      } else {
        Navigator.pop(context);
        onError('Ops, algo deu errado em buscar disciplinas');
      }
    }, (error) {
      Navigator.pop(context);
       onError(error);
    });
  }

  
}
