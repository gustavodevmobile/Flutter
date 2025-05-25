import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/storage_sqllite/storage_sqflite.dart';
import 'package:sqflite/sqflite.dart';
class StorageCorrects {
  

  Future<void> insertQuestionCorrects(ModelQuestions question) async {
    final db = await StorageSqflite().database;
    try {
      // Pega data e hora atuais
      final now = DateTime.now();
      final dateResponse =
          "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
      final hourResponse =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
      await db.insert(
        'questions_corrects',
        {
          'id': question.id,
          'elementarySchool': question.elementarySchool,
          'schoolYear': question.schoolYear,
          'discipline': question.discipline,
          'subject': question.subject,
          'question': question.question,
          'image': question.image, // Se for Uint8List
          'answer': question.answer,
          'alternativeA': question.alternativeA,
          'alternativeB': question.alternativeB,
          'alternativeC': question.alternativeC,
          'alternativeD': question.alternativeD,
          'explanation': question.explanation,
          'dateResponse': dateResponse,
          'hourResponse': hourResponse,
          'timeResponse': 'question.timeResponse',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Questão inserida com sucesso: ${question.id}');
    } on Exception catch (e) {
      // Tratar o erro aqui, se necessário
      print('Erro ao inserir questão: $e');
    }
  }

}