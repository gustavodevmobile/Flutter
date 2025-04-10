import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Classe responsável por faer o aramazenamento dos ids como base de consulta.
class StorageSharedPreferences {
  // Chave dos ids das questões respondidas.
  static const String keyIdsAnswereds = 'ids_Answereds';
  // Chave dos ids das questões respondidas corretamente.
  static const String keyIdsAnsweredsCorrects = 'ids_answereds_corrects';
  // Chave dos ids das questões respondidas incorretamente.
  static const String keyIdsAnsweredsIncorrects = 'ids_answereds_incorrects';
  // instância de classe SharedPreferencesAsync
  SharedPreferencesAsync prefsAsync = SharedPreferencesAsync();

// Método que salva os ids na forma de lista, utilizado para fazer a recuperação das questões respodidas incorretamente.
  Future<void> saveIdsList(
      String key, List<String> values, Function(String) onError) async {
    try {
      await prefsAsync.setStringList(key, values);
    } catch (e) {
      onError('Erro ao salvar lista de ids: $e');
    }
  }

  // Método que salva os ids das questões.
  Future<void> saveIds(
      String value, String key, Function(String) onError) async {
    List<String> idsAnswereds = [];

    try {
      // Faz a busca dos ids salvos localmente
      List<String>? resultIdsAnswereds = await prefsAsync.getStringList(key);
      // Se não foi salvo nada ainda, add uma nova lista com o valor recebido
      if (resultIdsAnswereds == null) {
        idsAnswereds.add(value);
        await prefsAsync.setStringList(key, idsAnswereds);

        // Caso contrário,
      } else {
        //add na lista recebida
        resultIdsAnswereds.add(value);
        //e salva a lista atualizada
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
    try {
      // Pega a lista dos ids das incorretas.
      List<String> listIds = await recoverIds(
          keyRemove, (error) => showSnackBarError(context, error, Colors.red));

      // Remove o id em questão
      listIds.remove(id);

      // Salva os ids restantes como list nos ids incorretos.
      saveIdsList(keyRemove, listIds, (error) {
        showSnackBarError(context, error, Colors.red);
      });

      // Salva o id da questão que acertou nos ids corretos.
      await saveIds(
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

  void deleteListIds() {
    deleta(StorageSharedPreferences.keyIdsAnswereds);
    deleta(StorageSharedPreferences.keyIdsAnsweredsCorrects);
    deleta(StorageSharedPreferences.keyIdsAnsweredsIncorrects);
  }
}
