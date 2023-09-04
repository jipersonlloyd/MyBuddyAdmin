// ignore_for_file: file_names

import 'package:sample/Database/DatabaseTables/dbHelper.dart';
import 'package:sqflite/sqflite.dart';


class TblSalesperson{
  static const String tableSalesperson = 'tblSalesperson';
  static const String id = 'id';
  static const String mdCode = 'mdCode';
  static const String mdSalesmanCode = 'mdSalesmancode';
  static const String mdName = 'mdName';
  static const String group3 = 'Group3';
  static const String type = 'Type';
  static const String mdColor = 'mdColor';

  static Future<void> create(Database db) async {
    bool isExists = await MybuddyDatabase.isTableExist(db, tableSalesperson);

    if(!isExists){
      await db.execute(_createtblSalesperson());
    }
  }
  static String _createtblSalesperson(){
        return '''
CREATE TABLE $tableSalesperson(
  $id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
  $mdCode INTEGER,
  $mdSalesmanCode TEXT,
  $mdName TEXT,
  $group3 TEXT,
  $type TEXT,
  $mdColor TEXT
)
''';
  }
}