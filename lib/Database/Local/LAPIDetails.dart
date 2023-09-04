// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:sample/Database/DatabaseTables/dbHelper.dart';
import 'package:sample/Database/DatabaseTables/tblAPIDetails.dart';
import 'package:sample/ErrorLogger.dart';
import 'package:sample/Model/APIDetailsModel.dart';
import 'package:sqflite/sqflite.dart';

class LAPIDetails{
  static Future<void> saveLocalAPIDetails(APIDetails apiDetails) async {
    Database dbase = await MybuddyDatabase.instance.database;
    Map<String,dynamic> values = APIDetails.getAPIDetailsMap(apiDetails);
    await dbase.insert(TblAPIDetails.tableapiDomain, values);
  }

  static Future<void> updateLocalAPIDetails(APIDetails apiDetails) async {
    Database dbase = await MybuddyDatabase.instance.database;
    Map<String,dynamic> values = APIDetails.getAPIDetailsMap(apiDetails);
    await dbase.update(TblAPIDetails.tableapiDomain, values);
  }

  static Future<APIDetails> getLocalAPIDetails(Database dbase) async {
    APIDetails? apiDetails;
    try {
      List<Map<String, dynamic>> res = await dbase.query(TblAPIDetails.tableapiDomain);
      if (res.isNotEmpty) {
        apiDetails = APIDetails.getAPIDetailsFromJson(res.first);
      }
    } catch (e) {
      debugPrint('LAPIDetails App error = ${e.toString()}');
      ErrorLogger.write(e.toString());
    }
    return apiDetails!;
  }

  static Future<bool> isExists() async {
    Database dbase = await MybuddyDatabase.instance.database;
    bool isExists = false;
    List<Map<String, dynamic>> existingData =
        await dbase.query(TblAPIDetails.tableapiDomain);
        isExists = existingData.isNotEmpty;
        debugPrint('$isExists');
    return isExists;
  }
}