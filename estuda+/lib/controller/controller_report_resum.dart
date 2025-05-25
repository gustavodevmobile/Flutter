import 'dart:convert';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/models/report_resum.dart';
import 'package:estudamais/models/user.dart';
import 'package:estudamais/service/report_service.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';

class ControllerReportResum {
  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();

  Future<void> reportPerformance(
      List<ModelQuestions> questions,
      BuildContext context,
      Function(List<ReportResum>) report,
      Function(String) onError) async {
    List<ReportResum> listReportResum = [];
    try {
      for (var question in questions) {
        listReportResum.add(
          ReportResum(
            schoolYear: question.schoolYear,
            discipline: question.discipline,
            subject: question.subject,
            date: question.dateResponse!,
            hours: question.hourResponse!,
            timeResponse: question.timeResponse!,
          ),
        );
      }
      report(listReportResum);
    } catch (e) {
      onError('Erro ao criar resumo de questões para envio de relatório: $e');
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
        'timeResponse': report.timeResponse,
      };
    }).toList();
  }

  Future<User> getUser(BuildContext context, Function(String) onError) async {
    Map<String, dynamic> userMap = {};
    try {
      userMap = await sharedPreferences
          .recoverUser(StorageSharedPreferences.user, (onError) {
        showSnackBarFeedback(context, onError, Colors.red);
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
      BuildContext context,
      Function(String) onError,
      String amountAnswered) async {
    ReportService reportService = ReportService();

    final List<Map<String, dynamic>> reportDataCorrects =
        convertReportResumToMap(listReportResumCorrects);

    final List<Map<String, dynamic>> reportDataIncorrects =
        convertReportResumToMap(listReportResumIncorrects);

    User user = await getUser(context, (onError) {
      showSnackBarFeedback(context, onError, Colors.red);
    });

    try {
      await reportService.sendReport(user, amountAnswered, reportDataCorrects,
          amountCorrects, reportDataIncorrects, amountIncorrects, (onSuccess) {
        showSnackBarFeedback(context, onSuccess, Colors.green);
        Navigator.pop(context);
      }, (onError) {
        showSnackBarFeedback(context, onError, Colors.red);
        Navigator.pop(context);
      });
    } catch (e) {
      onError('Erro ao enviar relatório ao servidor: $e');
    }
  }
}
