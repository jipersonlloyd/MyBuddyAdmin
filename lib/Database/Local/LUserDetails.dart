// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:sample/Database/DatabaseTables/dbHelper.dart';
import 'package:sample/Database/DatabaseTables/tblUserDetails.dart';
import 'package:sample/ErrorLogger.dart';
import 'package:sample/Model/UserDetailsModel.dart';
import 'package:sqflite/sqflite.dart';

class LUserDetails {
  static Future<void> saveLocalUserDetails(UserDetails userDetails) async {
    final dbase = await MybuddyDatabase.instance.database;
    Map<String,dynamic> values = UserDetails.getUserDetailsMap(userDetails);
    await dbase.insert(TblUserDetails.tableUserDetails, values);
  }

  static Future<void> updateLocalUserDetails(UserDetails userDetails) async {
    final dbase = await MybuddyDatabase.instance.database;
    Map<String,dynamic> values = UserDetails.getUserDetailsMap(userDetails);
    await dbase.update(TblUserDetails.tableUserDetails, values);
  }

  static Future<void> deleteLocalUserDetails() async{
   final dbase = await MybuddyDatabase.instance.database;
    await dbase.delete(TblUserDetails.tableUserDetails); 
  }

  static Future<UserDetails> getLocalUserDetails(Database dbase) async {
    UserDetails? userDetails;
    try{
      List<Map<String, dynamic>> res = await dbase.query(TblUserDetails.tableUserDetails);
      debugPrint('local user details = $res');
      if(res.isNotEmpty){
        userDetails = UserDetails.getUserDetailsFromJson(res.first);
      }
    }
    catch(e){
      debugPrint(e.toString());
      ErrorLogger.write(e.toString());
    }
    return userDetails!;
  }
  
  static Future<bool> isExists() async {
    final dbase = await MybuddyDatabase.instance.database;
    bool isExists = false;
    List<Map<String, dynamic>> existingData =
        await dbase.query(TblUserDetails.tableUserDetails);
        isExists = existingData.isNotEmpty;
    return isExists;
  }
}