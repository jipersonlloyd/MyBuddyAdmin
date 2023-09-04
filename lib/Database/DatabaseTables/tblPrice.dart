// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'dbHelper.dart';

class TblPrice{
  static const String tablePrice = 'tblPrice';
  static const String cID = 'cID';
  static const String priceCode = 'priceCode';
  static const String stockCode = 'stockCode';
  static const String unitPrice = 'unitPrice';
  static const String lastUpdated = 'lastUpdated';

  static Future<void> create(Database db) async {
    bool isExists = await MybuddyDatabase.isTableExist(db, tablePrice);

    if (!isExists) {
      await db.execute(_createtblPrice());
    }
  }

  static String _createtblPrice(){
    return '''
CREATE TABLE $tablePrice(
  $cID INTEGER PRIMARY KEY AUTOINCREMENT,
  $priceCode TEXT,
  $stockCode TEXT,
  $unitPrice DOUBLE,
  $lastUpdated DATETIME
)
''';
  }
}