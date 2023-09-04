// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:sample/ErrorLogger.dart';
import 'package:sample/Model/UserModel.dart';
import 'package:sqflite/sqflite.dart';
import '../DatabaseTables/dbHelper.dart';
import '../DatabaseTables/tblUser.dart';

class LUser {
  static Future<void> saveLocalUser(User user) async {
    final dbase = await MybuddyDatabase.instance.database;
    Map<String,dynamic> values = User.getUserMap(user);
    await dbase.insert(TblUser.tableUser, values);
  }

  static Future<void> updateLocalUser(User user) async {
    final dbase = await MybuddyDatabase.instance.database;
    Map<String,dynamic> values = User.getUserMap(user);
    await dbase.update(TblUser.tableUser, values);
  }

  static Future<User> getLocalUser(Database dbase) async {
    User? user;
    try{
      List<Map<String, dynamic>> res = await dbase.query(TblUser.tableUser);
      if(res.isNotEmpty){
        user = User.getUserFromJson(res.first);
      }
    }
    catch(e){
      debugPrint(e.toString());
      ErrorLogger.write(e.toString());
    }
    return user!;
  }
  
  static Future<bool> isExists() async {
    final dbase = await MybuddyDatabase.instance.database;
    bool isExists = false;
    List<Map<String, dynamic>> existingData =
        await dbase.query(TblUser.tableUser);
        isExists = existingData.isNotEmpty;
    return isExists;
  }
}