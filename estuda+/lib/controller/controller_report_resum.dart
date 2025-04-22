import 'dart:convert';

import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/models/report_resum.dart';
import 'package:estudamais/models/user.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/service/report_service.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ControllerReportResum {
  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();

  Future<void> reportCorrectsQuestions(
      List<ModelQuestions> questions,
      String key,
      BuildContext context,
      Function(List<ReportResum>) reportCorrects,
      Function(String) onError) async {
    List<ReportResum> listReportResum = [];
    try {
      List<String> listDateAndHours =
          await sharedPreferences.recoverIds(key, (error) {
        showSnackBarError(context, error, Colors.red);
      });
      List<Map<String, dynamic>> listMapIdsAndDates = [];
      for (var elements in listDateAndHours) {
        listMapIdsAndDates.add(jsonDecode(elements));
      }

      for (var dates in listMapIdsAndDates) {
        for (var question in questions) {
          if (dates['id'] == question.id) {
            listReportResum.add(ReportResum(
              schoolYear: question.schoolYear,
              discipline: question.discipline,
              subject: question.subject,
              date: dates['date'],
              hours: dates['hours'],
            ));
          }
        }
      }
      reportCorrects(listReportResum);
    } on Exception {
      onError('Erro ao criar resumo de questões para envio de relatório');
    }
  }

  List<Map<String, dynamic>> convertReportResumToMap(
      List<ReportResum> reportResumList) {
    return reportResumList.map((report) {
      return {
        'schoolYear': report.schoolYear,
        'discipline': report.discipline,
        'subject': report.subject,
        'date': report.date,
        'hours': report.hours,
      };
    }).toList();
  }

  Future<User> getUser(BuildContext context, Function(String) onError) async {
    Map<String, dynamic> userMap = {};
    try {
      userMap = await sharedPreferences
          .recoverUser(StorageSharedPreferences.user, (onError) {
        showSnackBarError(context, onError, Colors.red);
      });
    } catch (e) {
      onError('Erro ao buscar usuário para envio de relatório: $e');
    }
    return User.toUser(userMap);
  }

  Future<void> sendReportToBackend(
      List<ReportResum> listReportResumCorrects,
      String amountCorrects,
      List<ReportResum> listReportResumIncorrects,
      String amountIncorrects,
      String email,
      BuildContext context,
      Function(String) onError, String amountAnswered) async {
    ReportService reportService = ReportService();
    final List<Map<String, dynamic>> reportDataCorrects =
        convertReportResumToMap(listReportResumCorrects);

    final List<Map<String, dynamic>> reportDataIncorrects =
        convertReportResumToMap(listReportResumIncorrects);

    User user = await getUser(context, (onError) {
      showSnackBarError(context, onError, Colors.red);
    });

    
    try {
      await reportService.sendReport(user, amountAnswered,reportDataCorrects, amountCorrects,
          reportDataIncorrects, amountIncorrects, email, (onSuccess) {
        showSnackBarError(context, onSuccess, Colors.green);
        Routes().pushRoute(context, const HomeScreen());
      }, (onError) {
        showSnackBarError(context, onError, Colors.red);
      });
    } catch (e) {
      onError('Erro ao enviar relatório ao servidor: $e');
    }
  }
}
