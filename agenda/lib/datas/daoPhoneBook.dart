import 'package:sqflite/sqflite.dart';
import 'package:agenda/models/models_phoneBook.dart';
import 'package:agenda/datas/database.dart';
import 'package:path/path.dart';

class Daophonebook {
  static const String _tablename = 'phonebookTable';
  // static const String _id = 'id';
  static const String _name = 'name';
  static const String _number = 'number';

  static const String tableSql = 'CREATE TABLE $_tablename('
      // '$_id PRIMARY KEY AUTO INCREMENT'
      '$_name TEXT,'
      '$_number TEXT)';

  save(PhoneBook contact) async {
    print('Salvando contato...');
    final Database database = await getDatabase();
    // var ifExists = await find(contact.name, contact.number);
    final Map<String, dynamic> contactMap = toMap(contact);
    try {
      await database.insert(_tablename, contactMap);
      print('Contato salvo com sucesso!');
    } catch (e) {
      print('Erro ao salvar contato: $e');
    }
  }

  Map<String, dynamic> toMap(PhoneBook contact) {
    // print('Convertendo para Map');
    final Map<String, dynamic> mapContact = {};
    mapContact[_name] = contact.name;
    mapContact[_number] = contact.number;
    // print('Map do Contato: $mapContact');
    return mapContact;
  }

  List<PhoneBook> toList(List<Map<String, dynamic>> mapContact) {
    print('Convertendo para List');
    final List<PhoneBook> contacts = [];
    for (Map<String, dynamic> row in mapContact) {
      final PhoneBook contact = PhoneBook(
        row[_name],
        row[_number],
      );
      print(row);
      contacts.add(contact);
    }
    print('List do contact $contacts');
    return contacts;
  }

  Future<List<PhoneBook>> findAll() async {
    // print('Buscando todos os contatos...');
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> mapContacts =
        await database.query(_tablename);
    print('Map dos contatos: $mapContacts');

    return toList(mapContacts);
  }

  Future<List<PhoneBook>> find(String name) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database
        .query(_tablename, where: '$_name = ?', whereArgs: [name]);
    print('Procurando dados no banco de dados... encontrado: $result');
    return toList(result);
  }

  Future deleteTable() async {
    String path = join(await getDatabasesPath(), 'phoneBookDb');
    try {
      await deleteDatabase(path);
      print('Tabela de contatos excluída com sucesso!');
    } catch (e) {
      print('Erro ao excluir a tabela de contatos: $e');
    }
  }

  Future update(String updateName, String updateNumber, String findName) async {
    final Database database = await getDatabase();
    int count = await database.rawUpdate(
        'UPDATE $_tablename SET $_name = ?, $_number = ? WHERE $_name = ?',
        [updateName, updateNumber, findName]);
    return count;
  }

  Future delete(String name) async {
    print('Deletando contato...');
    final Database database = await getDatabase();
    return database.delete(
      _tablename,
      where: '$_name = ?',
      whereArgs: [name],
    );
  }
}
