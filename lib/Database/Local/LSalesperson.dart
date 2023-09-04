// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:sample/Database/DatabaseTables/dbHelper.dart';
import 'package:sample/Database/DatabaseTables/tblSalesperson.dart';
import 'package:sample/ErrorLogger.dart';
import 'package:sample/Model/Salesperson.dart';
import 'package:sqflite/sqflite.dart';

class LSalesperson{

  static Future<void> saveSalesperson(Salesperson salesperson)async{
    Database dbase = await MybuddyDatabase.instance.database;
    Map<String,dynamic> values = Salesperson.getSalespersonMap(salesperson);
    await dbase.insert(TblSalesperson.tableSalesperson, values);
  }
  static Future<void> updateSalesperson(Salesperson salesperson)async{
    Database dbase = await MybuddyDatabase.instance.database;
    Map<String,dynamic> values = Salesperson.getSalespersonMap(salesperson);
    await dbase.update(TblSalesperson.tableSalesperson, values);
  }
  static Future<void> deleteSalesperson() async {
    Database dbase = await MybuddyDatabase.instance.database;
    await dbase.delete(TblSalesperson.tableSalesperson);
  }

  static Future<List<Salesperson>> getLocalSalesperson(Database dbase) async{
    List<Salesperson> salesPersonList = [];
    try{
      List<Map<String, dynamic>> res = await dbase.query(TblSalesperson.tableSalesperson);
      if(res.isNotEmpty){
        for(Map<String,dynamic> resMap in res) {
          Salesperson salesperson = Salesperson.getSalespersonFromJson(resMap);
          salesPersonList.add(salesperson);
        }
      }
    }catch(e){
      debugPrint('Salesperson App error = ${e.toString()}');
      ErrorLogger.write(e.toString());
    }
    return salesPersonList;
  }
  static Future<bool> isExists() async{
    bool isExists = false;
    Database dbase = await MybuddyDatabase.instance.database;
    List<Map<String,dynamic>> existingData =  await dbase.query(TblSalesperson.tableSalesperson);
    isExists = existingData.isNotEmpty;
    return isExists;
  }
}