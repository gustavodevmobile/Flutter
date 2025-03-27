import 'package:agenda/datas/daoPhoneBook.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:async/async.dart';

Future<Database> getDatabase() async {
  String path = join(await getDatabasesPath(), 'phoneBookDb');
  return await openDatabase(path, version: 1, onCreate: (db, version) {
    return db.execute(Daophonebook.tableSql);
  });
}
