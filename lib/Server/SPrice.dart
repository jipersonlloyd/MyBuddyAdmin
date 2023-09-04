// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sample/ErrorLogger.dart';
import 'package:sample/Model/PriceModel.dart';
import 'package:sql_conn/sql_conn.dart';

class SPrice {
  static Future<List<Price>> getPrice() async {
    List<Price>? priceList = [];
     try{
    String query = 'SELECT * FROM tblPrice';
    String resString = await SqlConn.readData(query);
    List<dynamic> response = json.decode(resString);
    for(dynamic res in response){
    Price price = Price.getPricefromJson(res as Map<String,dynamic>);
    priceList.add(price);
    }
    }catch(e){
      debugPrint('App error : ${e.toString()}');
      ErrorLogger.write(e.toString());
      rethrow;
    }
    return priceList;
  }
}