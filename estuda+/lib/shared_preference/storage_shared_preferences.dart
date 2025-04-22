import 'dart:convert';
import 'package:estudamais/models/user.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // instância de classe SharedPreferencesAsync
  SharedPreferencesAsync prefsAsync = SharedPreferencesAsync();
  final DateTime dateNow = DateTime.now().toUtc();

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
        //e salva a lista atualizada
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
    return result;
  }

// Método responsável por remover id da lista salva localmente.
  void removeIdsInList(String keyRemove, String id, String keyAdd,
      BuildContext context, Function(String) onError) async {
    List<Map<String, dynamic>> listMap = [];
    List<String> listIds = [];
    try {
      // Pega a lista dos ids das incorretas.
      List<String> listJson = await recoverIds(
          keyRemove, (error) => showSnackBarError(context, error, Colors.red));

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
        showSnackBarError(context, error, Colors.red);
      });

      // Salva o id da questão que acertou nos ids corretos.
      await saveIdsAndDateResum(
          id, keyAdd, (error) => showSnackBarError(context, error, Colors.red));
    } catch (e) {
      onError('Erro ao salvar id questão incorreta em ids corretos: $e');
    }
  }

  void deleta(String key) {
    //SharedPreferencesAsync prefsAsync = SharedPreferencesAsync();
    prefsAsync.remove(key);
    print('$key deletados com sucesso');
  }

  void deleteListIds(Function(String) onSuccess, Function(String) onError) {
    try {
      deleta(keyIdsAnswereds);
      deleta(keyIdsAndDateAnsweredsCorrectsResum);
      deleta(keyIdsAndDateAnsweredsIncorrectsResum);
      deleta(user);
      deleta(isRegister);
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
      print('resultIdsAndDate $resultIdsAndDate');
      //add na lista recebida
      if (resultIdsAndDate == null) {
        idsAndDate.add(jsonString);
        //e salva a lista atualizada
        await prefsAsync.setStringList(key, idsAndDate);
        print('id e data salvos com sucesso: $jsonString');
      } else {
        resultIdsAndDate.add(jsonString);
        await prefsAsync.setStringList(key, resultIdsAndDate);
      }
    } catch (erro) {
      onError('Erro ao salvar id de questões respondidas: $erro');
    }
  }
}
