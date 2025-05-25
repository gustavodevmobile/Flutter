import 'package:estudamais/models/model_questions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StorageSqflite {
  static Database? db;
  static String tableQuestionsCorrects = 'questions_corrects';
  static String tableQuestionsIncorrects = 'questions_incorrects';

  Future<Database> get database async {
    if (db != null) return db!;
    db = await _initDb();
    return db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'questions.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tabela de questões corretas
        await db.execute('''
        CREATE TABLE questions_corrects (
          id TEXT,
          elementarySchool TEXT,
          schoolYear TEXT,
          discipline TEXT,
          subject TEXT,
          question TEXT,
          image BLOB,
          answer TEXT,
          alternativeA TEXT,
          alternativeB TEXT,
          alternativeC TEXT,
          alternativeD TEXT,
          explanation TEXT,
          dateResponse TEXT,
          hourResponse TEXT,
          timeResponse TEXT
        )
      ''');
        // Tabela de questões incorretas
        await db.execute('''
        CREATE TABLE questions_incorrects (
          id TEXT,
          elementarySchool TEXT,
          schoolYear TEXT,
          discipline TEXT,
          subject TEXT,
          question TEXT,
          image BLOB,
          answer TEXT,
          alternativeA TEXT,
          alternativeB TEXT,
          alternativeC TEXT,
          alternativeD TEXT,
          explanation TEXT,
          dateResponse TEXT,
          hourResponse TEXT,
          timeResponse TEXT
        )
      ''');
      },
    );
  }

  Future<bool> existsQuestionById(String id) async {
    final db = await database;
    final mapsIncorrects = await db.query(
      tableQuestionsIncorrects,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (mapsIncorrects.isNotEmpty) return true;

    final mapsCorrects = await db.query(
      tableQuestionsCorrects,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return mapsCorrects.isNotEmpty;
  }

  Future<void> getQuestions(
      String nameTable, Function(List<ModelQuestions>) result) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(nameTable);
    print('Questões recuperadas: ${maps.length}');
    List<ModelQuestions> questions = [];
    for (var map in maps) {
      questions.add(ModelQuestions.toModelQuestions(map));
    }
    result(questions);
  }

  Future<void> insertQuestion(
      ModelQuestions question, String nameTable, String time) async {
    final db = await database;

    // Pega data e hora atuais
    final now = DateTime.now();
    final dateResponse =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
    final hourResponse =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        nameTable,
        where: 'id = ?',
        whereArgs: [question.id],
      );

      if (maps.isEmpty) {
        // Se a questão já existe, não insere novamente
        await db.insert(
          nameTable,
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
            'timeResponse': time,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print('Questão inserida com sucesso: ${question.id}');
      }
    } on Exception catch (e) {
      // Tratar o erro aqui, se necessário
      print('Erro ao inserir questão: $e');
    }
  }

  // Método para recuperar os IDs das questões salvas
  Future<List<String>> getSavedQuestionIds(String nameTable) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      nameTable,
      columns: ['id'],
    );
    // Retorna apenas os ids em uma lista de String
    return maps.map((map) => map['id'].toString()).toList();
  }

  Future<void> deleteQuestion(String id, String nameTable) async {
    final db = await database;
    try {
      await db.delete(
        nameTable,
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Questão deletada com sucesso: $id');
    } on Exception catch (e) {
      // Tratar o erro aqui, se necessário
      print('Erro ao deletar questão: $e');
    }
  }

  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'questions.db');
    try {
      await deleteDatabase(path);
      StorageSqflite.db = null; // Reseta a instância estática, se houver
      print('Banco de dados resetado com sucesso!');
    } catch (e) {
      print('Erro ao resetar banco de dados: $e');
    }
  }

  Future<void> clearTable(
      Function(String) onSuccess, Function(String) onError) async {
    final db = await database;
    try {
      await db.delete(
        tableQuestionsCorrects,
      );
      await db.delete(
        tableQuestionsIncorrects,
      );
      onSuccess('Usuário deletado com successo.');
    } catch (e) {
      onError('Erro ao limpar a tabela: $e');
    }
  }
}
