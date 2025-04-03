import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/discipline/discipline.dart';
import 'package:estudamais/service/service.dart';
import 'package:estudamais/widgets/show_loading_dialog.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';

class ControllerHome {
  Service service = Service();
  List<String> disciplines = [];

  void fetchDisciplines(Function(List<String> disciplines) onSuccess,
      Function(String) onError) async {
    try {
      disciplines = await service.getDisciplines();
      onSuccess(disciplines);
    } catch (e) {
      onError('Não foi possível buscar as Disciplinas: $e');
    }
  }

  void handleFetchDisciplines(BuildContext context) {
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
        showSnackBarError(
            context, 'Ops, algo deu errado em buscar disciplinas', Colors.red);
      }
    }, (onError) {
      Navigator.pop(context);
      showSnackBarError(context, onError, Colors.red);
    });
  }
}
