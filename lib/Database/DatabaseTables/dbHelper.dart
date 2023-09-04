// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sample/Database/DatabaseTables/tblAPIDetails.dart';
import 'package:sample/Database/DatabaseTables/tblConfig.dart';
import 'package:sample/Database/DatabaseTables/tblPrice.dart';
import 'package:sample/Database/DatabaseTables/tblProduct.dart';
import 'package:sample/Database/DatabaseTables/tblSalesperson.dart';
import 'package:sample/Database/DatabaseTables/tblStockRequest.dart';
import 'package:sample/Database/DatabaseTables/tblUser.dart';
import 'package:sample/Database/DatabaseTables/tblUserDetails.dart';
import 'package:sample/Database/DatabaseTables/tblcompany.dart';
import 'package:sample/ErrorLogger.dart';
import 'package:sqflite/sqflite.dart';

class MybuddyDatabase {
  static final MybuddyDatabase instance = MybuddyDatabase._init();
  static Database? _database;

  MybuddyDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('mybuddy.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path,
        version: 1, onOpen: (db) => _createDB(db, 1), onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await TblUser.create(db);
    await TblProduct.create(db);
    await TblStockRequest.create(db);
    await TblConfig.create(db);
    await TblCompany.create(db);
    await TblPrice.create(db);
    await TblSalesperson.create(db);
    await TblUserDetails.create(db);
    await TblAPIDetails.create(db);
  }

  static Future<bool> isTableExist(Database database, String tableName) async {
    try {
      bool result = false;
      String query = "SELECT name FROM sqlite_master WHERE type ='table'";
      List<Map> resultSet = await database.rawQuery(query);
      for (Map map in resultSet) {
        if (tableName == map['name']) {
          result = true;
          break;
        }
      }
      return result;
    } catch (e) {
      debugPrint('dbhelper App error : ${e.toString()}');
      ErrorLogger.write(e.toString());
    }
    return false;
  }
}
