// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sample/ErrorLogger.dart';
import 'package:sample/Model/Salesperson.dart';
import 'package:sql_conn/sql_conn.dart';

class SSalesperson{

  static Future<List<Salesperson>> getSalesperson() async{
    List<Salesperson> salespersonList = [];
    try{
      String query = 'Select * from tblSalesperson';
      String resString = await SqlConn.readData(query);
      List<dynamic> response = json.decode(resString);
      for(dynamic res in response){
        Salesperson salesperson = Salesperson.getSalespersonFromJson(res as Map<String,dynamic>);
        salespersonList.add(salesperson);
      }
    }catch(e){
      debugPrint('App error = ${e.toString()}');
      ErrorLogger.write(e.toString());
    }
    return salespersonList;
  }
}