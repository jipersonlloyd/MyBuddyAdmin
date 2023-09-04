// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sample/ErrorLogger.dart';
import 'package:sample/Model/CompanyModel.dart';
import 'package:sql_conn/sql_conn.dart';

class SCompany{

    static Future<Company> getCompany() async {
    Company? company;
    try{
    String query = '''SELECT DIST_CD,
    SERVER_IP,
    DBNAME,
    LAST_UPDATED,
    logo,
    Notation,
    Company,
    ZIPCODE,
    longitude,
    latitude,
    center,
    officeaddress,
    tin,
    email,
    telephone,
    fax,
    OLAP_SVRNAME,
    hostname_api FROM tblCompany''';
    String resString = await SqlConn.readData(query);
    List<dynamic> response = await json.decode(resString);
    company = Company.getCompanyFromJson(response.first as Map<String,dynamic>);
    }catch(e){
      debugPrint('LCompany App error : ${e.toString()}');
      ErrorLogger.write(e.toString());
      //Location of Log: Android/data/com.android.mybuddysync/files/error.txt
      rethrow;
    }
    return company;
  }

}