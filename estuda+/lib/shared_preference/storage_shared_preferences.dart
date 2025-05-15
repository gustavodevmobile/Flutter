import 'dart:convert';
import 'package:estudamais/models/user.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

// Classe responsável por faer o aramazenamento dos ids como base de consulta.
class StorageSharedPreferences {
  // Chave dos ids das questões respondidas.
  static const String keyIdsAnswereds = 'ids_Answereds';
  // Chave dos ids e data das questões respondidas.
  static const String keyIdsAndDateAnsweredsCorrectsResum =
      'ids_date_answereds_corrects_resum';
  // Chave dos ids e data das questões respondidas incorretamente.
  static const String keyIdsAndDateAnsweredsIncorrectsResum =
      'ids_date_answereds_incorrects_resum';
  // Chave do nome do usuário
  static const String user = 'user';
  // Chave de confirmação se esta registrado
  static const String isRegister = 'isRegister';

  static const String isAnsweredIncorrects = 'isAnsweredIncorrects';

  // instância de classe SharedPreferencesAsync
  SharedPreferencesAsync prefsAsync = SharedPreferencesAsync();
  final DateTime dateNow = DateTime.now();

  Future<void> saveUser(
      User user, Function(String) onSuccess, Function(String) onError) async {
    final userData = jsonEncode(user.toJson());
    try {
      await prefsAsync.setString('user', userData);
      onSuccess('Usuário inserido com sucesso');
    } catch (erro) {
      onError('Erro ao inserir usuário');
    }
  }

// Método responsável por recuperar o usuário cadastrado
  Future<Map<String, dynamic>> recoverUser(
      String keyUser, Function(String) onError) async {
    Map<String, dynamic> userMap = {};
    try {
      final user = await prefsAsync.getString(keyUser);

      if (user != null) {
        userMap = jsonDecode(user);
      } else {
        onError('Error: User == null');
      }
    } catch (e) {
      onError('Erro ao buscar usuário');
    }
    print(userMap);
    return userMap;
  }

  Future<bool?> hasRegisteredUser(Function(String) onError) async {
    //bool? status;
    try {
      return await prefsAsync.getBool(isRegister);
    } catch (e) {
      onError('Erro ao buscar status de usuário: $e');
    }
    return null;
  }

// Método responsável por recuperar o status do usuário.
  Future<void> isRegisterUser(bool value, Function(String) onError) async {
    try {
      await prefsAsync.setBool(isRegister, value);
    } catch (e) {
      onError('Erro ao salvar estado de cadastro: $e');
    }
// Armazena o valor
  }

// Método que salva os ids na forma de lista, utilizado para fazer a recuperação das questões respodidas incorretamente.
  Future<void> saveIdsList(
      String key, List<String> values, Function(String) onError) async {
    try {
      await prefsAsync.setStringList(key, values);
    } catch (e) {
      onError('Erro ao salvar lista de ids: $e');
    }
  }

  //Método que salva ids das questões respondidas .
  Future<void> saveIds(
      String value, String key, Function(String) onError) async {
    List<String> listId = [];

    try {
      // Faz a busca dos ids salvos localmente
      List<String>? resultIdsAnswereds = await prefsAsync.getStringList(key);
      // Se não foi salvo nada ainda, add uma nova lista com o valor recebido
      //add na lista recebida
      if (resultIdsAnswereds == null) {
        listId.add(value);
        await prefsAsync.setStringList(key, listId);
      } else {
        resultIdsAnswereds.add(value);
        await prefsAsync.setStringList(key, resultIdsAnswereds);
      }
    } catch (erro) {
      onError('Erro ao salvar id de questões respondidas: $erro');
    }
  }

// Método responsável por ler os ids salvos localmente.
  Future<List<String>> recoverIds(String key, Function(String) onError) async {
    List<String>? result = [];
    try {
      result = await prefsAsync.getStringList(key);
    } catch (e) {
      onError('Erro ao buscar ids localmente:$e');
    }

    if (result == null) {
      return [];
      //onError('Erro ao buscar ids. O resultado retornou nulo');
    }
    //print('Ids recuperados: $result');
    return result;
  }

// Método responsável por remover id da lista salva localmente.
  Future<void> removeIdsInList(String keyRemove, String id, String keyAdd,
      BuildContext context, Function(String) onError) async {
    List<Map<String, dynamic>> listMap = [];
    List<String> listIds = [];
    try {
      // Pega a lista dos ids das incorretas.
      List<String> listJson = await recoverIds(keyRemove,
          (error) => showSnackBarFeedback(context, error, Colors.red));

      for (var id in listJson) {
        listMap.add(jsonDecode(id));
      }
      // Remove o id em questão
      listMap.removeWhere((el) => el['id'] == id);

      for (var map in listMap) {
        listIds.add(jsonEncode(map));
      }

      // Salva os ids restantes como list nos ids incorretos.
      saveIdsList(keyRemove, listIds, (error) {
        showSnackBarFeedback(context, error, Colors.red);
      });

      // Salva o id da questão que acertou nos ids corretos.
      await saveIdsAndDateResum(id, keyAdd,
          (error) => showSnackBarFeedback(context, error, Colors.red));
    } catch (e) {
      onError('Erro ao salvar id questão incorreta em ids corretos: $e');
    }
  }

  Future<void> deleta(String key) async {
    //SharedPreferencesAsync prefsAsync = SharedPreferencesAsync();
    await prefsAsync.remove(key);
    //print('$key deletados com sucesso');
  }

  Future<void> removeId(String key, List<String> idsToRemove,
      {required bool isDecode, Function(bool)? onSuccess}) async {
    List<Map<String, dynamic>> listMapToRemove = [];
    List<String> listIds = [];

    try {
      if (!isDecode) {
        final storedIds = await prefsAsync.getStringList(key) ?? [];
        storedIds.removeWhere((storedId) => idsToRemove.contains(storedId));
        //print('ids removidos: $storedIds');
        await prefsAsync.setStringList(key, storedIds);
        onSuccess?.call(true);
      }
      if (isDecode) {
        // Recupera a lista de IDs armazenada no SharedPreferences
        final storedIds = await prefsAsync.getStringList(key) ?? [];

        // Decodifica os IDs armazenados e e salva em uma lista de mapas
        for (var ids in storedIds) {
          listMapToRemove.add(jsonDecode(ids));
        }
        // Remove os IDs que estão na lista de map
        for (var id in idsToRemove) {
          listMapToRemove.removeWhere((el) => el['id'] == id);
        }
        // Converte os mapas restantes de volta para JSON
        for (var map in listMapToRemove) {
          listIds.add(jsonEncode(map));
        }
        // Salva os IDs restantes de volta no SharedPreferences
        await prefsAsync.setStringList(key, listIds);
        onSuccess?.call(true);
      }
    } catch (e) {
      print('Erro ao remover IDs do SharedPreferences: $e');
    }

    // Retorna a lista atualizada
  }

  void deleteListIds(Function(String) onSuccess, Function(String) onError) {
    try {
      deleta(keyIdsAnswereds);
      deleta(keyIdsAndDateAnsweredsCorrectsResum);
      deleta(keyIdsAndDateAnsweredsIncorrectsResum);
      deleta(user);
      deleta(isRegister);
      deleta('reportHistory');
      deleta('savedEmail');
      onSuccess('Usuário resetado com sucesso!');
    } catch (e) {
      onError('Erro ao resetar usuário: $e');
    }
  }

  Future<void> saveIdsAndDateResum(
      String id, String key, Function(String) onError) async {
    List<String> idsAndDate = [];

    String date =
        '${dateNow.day.toString().padLeft(2, '0')}/${dateNow.month.toString().padLeft(2, '0')}/${dateNow.year}';
    String hours =
        '${dateNow.hour.toString().padLeft(2, '0')}:${dateNow.minute.toString().padLeft(2, '0')}';

    final Map<String, dynamic> answeredData = {
      "id": id,
      "date": date,
      "hours": hours
    };

    final String jsonString = jsonEncode(answeredData);

    try {
      // Faz a busca dos ids salvos localmente
      List<String>? resultIdsAndDate = await prefsAsync.getStringList(key);

      // Se não foi salvo nada ainda, add uma nova lista com o valor recebido
      if (resultIdsAndDate == null) {
        idsAndDate.add(jsonString);
        await prefsAsync.setStringList(key, idsAndDate);
      } else {
        //add na lista recebida
        resultIdsAndDate.add(jsonString);
        await prefsAsync.setStringList(key, resultIdsAndDate);
      }
    } catch (erro) {
      onError('Erro ao salvar id de questões respondidas: $erro');
    }
  }

  Future<void> saveReportToHistory(String filePath, String userName,
      Function(String) onSuccess, Function(String) onError) async {
    var uuid = const Uuid();
    // Gera um id único para cada questão respondida
    String uniqueId = uuid.v4();

    String date =
        '${dateNow.day.toString().padLeft(2, '0')}/${dateNow.month.toString().padLeft(2, '0')}/${dateNow.year}';
    String hours =
        '${dateNow.hour.toString().padLeft(2, '0')}:${dateNow.minute.toString().padLeft(2, '0')}';
    try {
      List<String> history =
          await prefsAsync.getStringList('reportHistory') ?? [];
      history.add(
        jsonEncode(
          {
            'id': uniqueId,
            'filePath': filePath,
            'userName': userName,
            'date': date,
            'hours': hours
          },
        ),
      );
      await prefsAsync.setStringList('reportHistory', history);
      onSuccess('Relatório salvo com sucesso!');
    } catch (e) {
      onError('Erro ao salvar histórico de relatórios: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getReportHistory() async {
    List<String> history = [];
    try {
      history = await prefsAsync.getStringList('reportHistory') ?? [];
      //print(history);
    } on Exception catch (e) {
      print('Erro ao recuperar histórico de relatórios: $e');
    }
    return history
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .toList();
  }

  void removeReportHistory(
      String id, Function(String) onSuccess, Function(String) onError) async {
    try {
      List<String> history =
          await prefsAsync.getStringList('reportHistory') ?? [];
      if (history.isNotEmpty) {
        history.removeWhere((item) => jsonDecode(item)['id'] == id);
      } else {
        onError('Erro ao remover relatório: lista vazia');
      }
      await prefsAsync.setStringList('reportHistory', history);
      onSuccess('Relatório removido com sucesso!');
    } catch (e) {
      onError('Erro ao remover relatório: $e');
    }
  }

  //Método que salva o email para envio de resumo
  void savedEmail(String email, Function(String) onError) async {
    try {
      List<String> emails = await prefsAsync.getStringList('savedEmail') ?? [];
      if (!emails.contains(email)) {
        emails.add(email);
        await prefsAsync.setStringList('savedEmail', emails);
      } else {
        onError('Email já salvo!');
      }
    } catch (e) {
      onError('Erro ao salvar email: $e');
    }
  }

  Future<List<String>> getSavedEmail(Function(String) onError) async {
    List<String> emails = [];
    try {
      emails = await prefsAsync.getStringList('savedEmail') ?? [];
      print(' emails: $emails');
    } catch (e) {
      onError('Erro ao buscar email: $e');
    }
    return emails;
  }

  Future<void> removeEmail(String email, Function(String) onError,
      Function(String) onSuccess) async {
    try {
      List<String> emails = await prefsAsync.getStringList('savedEmail') ?? [];
      if (emails.isNotEmpty) {
        emails.remove(email);
        prefsAsync.setStringList('savedEmail', emails);
        onSuccess('Email removido com sucesso!');
      } else {
        onError('Erro ao remover email: lista vazia');
      }
    } catch (e) {
      onError('Erro ao remover email: $e');
    }
  }
}
