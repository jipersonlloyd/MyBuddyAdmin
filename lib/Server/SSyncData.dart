// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:sample/ErrorLogger.dart';
import 'package:sample/Model/Salesperson.dart';
import 'package:sql_conn/sql_conn.dart';

class SSyncData {

  static Future<dynamic> dataReplication(Salesperson salesperson) async {
    try{
      String query = "exec sp_dummy_account '${salesperson.mdName}'";
      return await SqlConn.writeData(query);
    }
    catch(e){
      debugPrint(e.toString());
      ErrorLogger.write(e.toString());
    }
  }
  static Future<dynamic> syncSFAQueuing(String date, List<Salesperson> salesPersonList) async {
    try{
      String query = "exec [dbo].[sp_trnverifier1] '$date', '${salesPersonList.map((e) => e.mdCode)}'";
      return await SqlConn.writeData(query);
    }
    catch(e){
      debugPrint(e.toString());
      ErrorLogger.write(e.toString());
    }
  }
  static Future<dynamic> syncstockRequest(String date, List<Salesperson> salesPersonList) async {
    try{
      String query = "exec [dbo].[sp_trnverifier2] '$date', '${salesPersonList.map((e) => e.mdCode)}'";
      return await SqlConn.writeData(query);
    }
    catch(e){
      debugPrint(e.toString());
      ErrorLogger.write(e.toString());
    }
  }
  static Future<dynamic> syncCustomer() async {
    try{
    String query = 'exec [dbo].[sp1_mcp_allignment]';
    return await SqlConn.writeData(query);
    }
    catch(e){
      debugPrint(e.toString());
      ErrorLogger.write(e.toString());
    }
  }

  static Future<dynamic> syncProduct() async {
    try{
      String query = 'exec [dbo].[sp1_itemdetails_sync]';
          return await SqlConn.writeData(query);
    }
    catch(e){
      debugPrint(e.toString());
      ErrorLogger.write(e.toString());
    }
  }
}
