// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'dbHelper.dart';

class TblConfig {
  static const String tableConfig = 'tblConfig';
  static const String cID = 'cID';
  static const String ip = 'ip';
  static const String port = 'port';
  static const String database = 'database';
  static const String username = 'username';
  static const String password = 'password';

  static Future<void> create(Database db) async {
    bool isExists = await MybuddyDatabase.isTableExist(db, tableConfig);

    if (!isExists) {
      await db.execute(_createtblConfig());
    }
  }

  static String _createtblConfig() {
    return '''
CREATE TABLE $tableConfig(
  $cID INTEGER PRIMARY KEY AUTOINCREMENT,
  $ip TEXT,
  $port TEXT,
  $database TEXT,
  $username TEXT,
  $password TEXT
)
''';
  }
}
