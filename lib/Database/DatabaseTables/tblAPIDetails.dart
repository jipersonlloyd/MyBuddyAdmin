// ignore_for_file: file_names

import 'package:sample/Database/DatabaseTables/dbHelper.dart';
import 'package:sqflite/sqflite.dart';

class TblAPIDetails{
  static const String tableapiDomain = 'tblAPIDetails';
  static const String id = 'id';
  static const String apiDomain = 'apiDomain';
  static const String apiUsername = 'apiUsername';
  static const String apiPassword = 'apiPassword';

  static Future<void> create(Database db) async {
    bool isExists = await MybuddyDatabase.isTableExist(db, tableapiDomain);

    if (!isExists) {
      await db.execute(_createtblConfig());
    }
  }

  static String _createtblConfig() {
    return '''
CREATE TABLE $tableapiDomain(
  $id INTEGER PRIMARY KEY AUTOINCREMENT,
  $apiDomain TEXT,
  $apiUsername TEXT,
  $apiPassword TEXT
)
''';
  }
}