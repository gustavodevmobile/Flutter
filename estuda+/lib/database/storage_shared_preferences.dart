import 'package:shared_preferences/shared_preferences.dart';

class StorageSharedPreferences {
  static const String keyIdsAnswereds = 'ids_Answereds';
  static const String keyIdsAnsweredsCorrects = 'ids_answereds_corrects';
  static const String keyIdsAnsweredsIncorrects = 'ids_answereds_incorrects';

  void saveIdsList(String key, List<String> values) async {
    SharedPreferencesAsync prefsAsync = SharedPreferencesAsync();
    await prefsAsync.setStringList(key, values);
    print('Dados salvo com sucesso');
  }

  Future<void> saveIds(String value, String key) async {
    SharedPreferencesAsync prefsAsync = SharedPreferencesAsync();
    List<String> idsAnswereds = [];
    //List<String>? idsCurrents = [];
    try {
      List<String>? resultIdsAnswereds = await prefsAsync.getStringList(key);
      if (resultIdsAnswereds == null) {
        idsAnswereds.add(value);
        await prefsAsync.setStringList(key, idsAnswereds);
        //idsCurrents = await prefsAsync.getStringList(key);
      } else {
        resultIdsAnswereds.add(value);
        await prefsAsync.setStringList(key, resultIdsAnswereds);
      }
      //idsCurrents = await prefsAsync.getStringList(key);
    } catch (erro) {
      print('Erro ao salvar id de questões respondidas: $erro');
    }
    //print('idsCurrents $idsCurrents');
    //return idsCurrents ?? [];
  }

  Future<List<String>> recoverIds(String key) async {
    SharedPreferencesAsync prefsAsync = SharedPreferencesAsync();
    List<String>? result = await prefsAsync.getStringList(key);
    if (result == null) {
      return [];
    }
    print('$key: $result');
    return result;
  }

  void removeIdsInList(String keyRemove, String id, String keyAdd) async {
    // pega a lista dos ids das incorretas
    List<String> listIds = await recoverIds(keyRemove);
    print('pega a lista dos ids das incorretas $listIds');
    // remove o id em questão
    listIds.remove(id);
    print('remove o id em questão $listIds');
    // salva os ids restantes como list nos ids incorretos
    saveIdsList(keyRemove, listIds);
    // salva o id da questão que acertou nos ids corretos
    List<String> newlistIdsInco = await recoverIds(keyRemove);
    print('nova lista ids incorretos $newlistIdsInco');
    saveIds(id, keyAdd);
    List<String> newlistIdsCo = await recoverIds(keyAdd);
    print('nova lista ids corretos $newlistIdsCo');
    //prefsAsync.getAll();
  }

  void deleta(String key) {
    SharedPreferencesAsync prefsAsync = SharedPreferencesAsync();
    prefsAsync.remove(key);
    print('$key deletados com sucesso');
  }

  void deleteListIds() {
    deleta(StorageSharedPreferences.keyIdsAnswereds);
    deleta(StorageSharedPreferences.keyIdsAnsweredsCorrects);
    deleta(StorageSharedPreferences.keyIdsAnsweredsIncorrects);
  }
}
