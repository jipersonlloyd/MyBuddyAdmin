// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'dbHelper.dart';

const String tableStockRequest = 'tblStockRequest';

class TblStockRequest{

  static const String cID = 'cID';
  static const String transDate = 'transDate';
  static const String mdCode = 'mdCode';
  static const String refNo = 'refNo';
  static const String stockCode = 'StockCode';
  static const String quantity = 'quantity';
  static const String approveStat = 'approveStat';
  static const String exportStat = 'exportStat';
  static const String source = 'source';
  static const String remarks = 'remarks';
  static const String transactionID = 'transactionID';


  static Future<void> create(Database db) async {
    bool isExists = await MybuddyDatabase.isTableExist(db, tableStockRequest);
    if (!isExists) {
      await db.execute(_createtblStockRequest());
    }
  }
    static String _createtblStockRequest(){
    return '''
CREATE TABLE $tableStockRequest(
  $cID INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
  $mdCode TEXT,
  $refNo TEXT,
  $stockCode TEXT,
  $quantity INTEGER,
  $approveStat INTEGER,
  $exportStat INTEGER,
  $source TEXT,
  $remarks TEXT,
  $transDate TEXT,
  $transactionID TEXT
)
''';
  }
}