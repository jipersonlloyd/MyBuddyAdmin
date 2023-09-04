// ignore_for_file: file_names

import 'package:sample/ErrorLogger.dart';
import 'package:sqflite/sqflite.dart';

import '../../Model/PriceModel.dart';
import '../DatabaseTables/dbHelper.dart';
import '../DatabaseTables/tblPrice.dart';

class LPrice {
  static Future<void> savePrice(Price price) async {
    final dbase = await MybuddyDatabase.instance.database;
    Map<String, dynamic> values = Price.getPriceMap(price);
    await dbase.insert(TblPrice.tablePrice, values);
  }

  static Future<void> updatePrice(Price price) async {
    final dbase = await MybuddyDatabase.instance.database;
    Map<String, dynamic> values = Price.getPriceMap(price);
    await dbase.update(TblPrice.tablePrice, values);
  }

  static Future<void> deletePrice() async {
    final dbase = await MybuddyDatabase.instance.database;
    await dbase.delete(TblPrice.tablePrice);
  }

  static Future<List<Price>> getLocalPrice(Database dbase) async {
    List<Price> priceList = [];
    try{
      List<Map<String,dynamic>> res = await dbase.query(TblPrice.tablePrice);
      if(res.isNotEmpty){
        for(Map<String,dynamic> resMap in res){
          Price price = Price.getPricefromJson(resMap);
          priceList.add(price);
        }
      }
    }
    catch(e){
      ErrorLogger.write(e.toString());
    }
    return priceList;
  }

  static Future<bool> isExists() async {
    bool isExists = false;
    final dbase = await MybuddyDatabase.instance.database;
    List<Map<String, dynamic>> existingData =
        await dbase.query(TblPrice.tablePrice);
    isExists = existingData.isNotEmpty;
    return isExists;
  }
}