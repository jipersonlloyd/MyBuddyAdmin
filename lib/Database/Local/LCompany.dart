// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:sample/Database/DatabaseTables/tblCompany.dart';
import 'package:sample/ErrorLogger.dart';
import 'package:sample/Model/CompanyModel.dart';
import 'package:sqflite/sqlite_api.dart';
import '../DatabaseTables/dbHelper.dart';

class LCompany {
  static Future<void> saveLocalCompany(Company company) async {
    Database dbase = await MybuddyDatabase.instance.database;
    Map<String,dynamic> values = Company.getCompanyMap(company);
    await dbase.insert(TblCompany.tableCompany, values);
  }

  static Future<void> updateLocalCompany(Company company) async {
    Database dbase = await MybuddyDatabase.instance.database;
    Map<String,dynamic> values = Company.getCompanyMap(company);
    await dbase.update(TblCompany.tableCompany, values);
  }

  static Future<Company> getLocalCompany(Database dbase) async {
    Company? company;
    try {
      List<Map<String, dynamic>> res = await dbase.query(TblCompany.tableCompany);
      if (res.isNotEmpty) {
        company = Company.getCompanyFromJson(res.first);
      }
    } catch (e) {
      debugPrint('LCompany App error = ${e.toString()}');
      ErrorLogger.write(e.toString());
    }
    return company!;
  }

  static Future<bool> isExists() async {
    Database dbase = await MybuddyDatabase.instance.database;
    bool isExists = false;
    List<Map<String, dynamic>> existingData =
        await dbase.query(TblCompany.tableCompany);
        isExists = existingData.isNotEmpty;
        debugPrint('$isExists');
    return isExists;
  }
}