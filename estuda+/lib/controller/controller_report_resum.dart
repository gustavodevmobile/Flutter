import 'dart:convert';

import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/models/report_resum.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';

class ControllerReportResum {
  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();

  Future<List<ReportResum>> getQuestionsCorrects(
      List<ModelQuestions> questions, String key, BuildContext context) async {
    List<ReportResum> listReportResum = [];
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
        listReportResum.add(ReportResum(
          schoolYear: question.schoolYear,
          discipline: question.discipline,
          subject: question.subject,
          date: dates['date'],
          hours: dates['hours'],
        ));
      }
    }

    return listReportResum;
  }
}
