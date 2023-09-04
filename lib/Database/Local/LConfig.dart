// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:sample/Database/DatabaseTables/tblConfig.dart';
import 'package:sample/ErrorLogger.dart';
import 'package:sample/Model/ConfigModel.dart';
import 'package:sqflite/sqflite.dart';
import '../DatabaseTables/dbHelper.dart';


class LConfig {
  static Future<void> saveLocalConfig(Config config) async {
    Database dbase = await MybuddyDatabase.instance.database;
    Map<String, dynamic> values = Config.getConfigMap(config);
    await dbase.insert(TblConfig.tableConfig, values);
  }

  static Future<void> updateLocalConfig(Config config) async {
    Database dbase = await MybuddyDatabase.instance.database;
    Map<String, dynamic> values = Config.getConfigMap(config);
    await dbase.update(TblConfig.tableConfig, values);
  }

  static Future<Config> getLocalConfig(Database dbase) async {
    Config? config;
    try {
      List<Map<String, dynamic>> res = await dbase.query(TblConfig.tableConfig);
      if (res.isNotEmpty) {
        config = Config.getConfigFromJson(res.first);
      }
    } catch (e) {
      debugPrint('LConfig App error = ${e.toString()}');
      ErrorLogger.write(e.toString());
    }
    return config!;
  }

  static Future<bool> isExists() async {
    bool isExists = false;
    Database dbase = await MybuddyDatabase.instance.database;
    List<Map<String, dynamic>> existingData =
        await dbase.query(TblConfig.tableConfig);
    isExists = existingData.isNotEmpty;
    return isExists;
  }
}
