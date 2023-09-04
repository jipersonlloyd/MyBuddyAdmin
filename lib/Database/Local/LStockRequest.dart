// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sample/ErrorLogger.dart';
import 'package:sample/model/StockRequestModel.dart';
import 'package:sql_conn/sql_conn.dart';
import '../DatabaseTables/dbHelper.dart';
import '../DatabaseTables/tblStockRequest.dart';

class LStockRequest {
  static Future<void> saveStockRequest(StockRequest stockRequest) async {
    final dbase = await MybuddyDatabase.instance.database;
    Map<String, dynamic> values = StockRequest.getStockRequestMap(stockRequest);
    await dbase.insert(tableStockRequest, values);
  }

  static Future<void> updateStockRequest(StockRequest stockRequest) async {
    final dbase = await MybuddyDatabase.instance.database;
    Map<String, dynamic> values = StockRequest.getStockRequestMap(stockRequest);
    await dbase.update(tableStockRequest, values);
  }

  static Future<StockRequest> getStockRequest() async {
    StockRequest stockRequest;
     try{
    String query = 'SELECT * FROM tblStockRequest';
    String resString = await SqlConn.readData(query);
    List<dynamic> response = json.decode(resString);
    stockRequest = StockRequest.getStockRequestFromJson(response.first as Map<String,dynamic>);
    }catch(e){
      debugPrint('LStockRequest App error : ${e.toString()}');
      ErrorLogger.write(e.toString());
      rethrow;
    }
    return stockRequest;
  }

  static Future<bool> isExists() async {
    bool isExists = false;
    final dbase = await MybuddyDatabase.instance.database;
    List<Map<String, dynamic>> existingData =
        await dbase.query(tableStockRequest);
    isExists = existingData.isNotEmpty;
    return isExists;
  }
}
