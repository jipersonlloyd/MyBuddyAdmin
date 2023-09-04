// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sample/ErrorLogger.dart';
import 'package:sample/Model/UserModel.dart';
import 'package:sql_conn/sql_conn.dart';

class SUser{
  
    static Future<User> getUser() async {
    User? user;
    try{
    String query = 'SELECT * FROM tblUser';
    String resString = await SqlConn.readData(query);
    List<dynamic> response = await json.decode(resString);
    user = User.getUserFromJson(response.first as Map<String,dynamic>);
    }catch(e){
      debugPrint('SUser App error : ${e.toString()}');
      ErrorLogger.write(e.toString());
      rethrow;
    }
    return user;
  }
}