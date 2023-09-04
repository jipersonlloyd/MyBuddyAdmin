// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:sample/ErrorLogger.dart';
import 'package:sample/Model/ProductModel.dart';
import 'package:sqflite/sqflite.dart';
import '../DatabaseTables/dbHelper.dart';
import '../DatabaseTables/tblProduct.dart';

class LProduct {
  static Future<void> saveProduct(Product product) async {
    final dbase = await MybuddyDatabase.instance.database;
    Map<String, dynamic> values = Product.getProductMap(product);
    await dbase.insert(TblProduct.tableProduct, values);
  }

  static Future<void> updateProduct(Product product) async {
    final dbase = await MybuddyDatabase.instance.database;
    Map<String, dynamic> values = Product.getProductMap(product);
    await dbase.update(TblProduct.tableProduct, values);
  }

  static Future<void> deleteProducts() async {
    final dbase = await MybuddyDatabase.instance.database;
    await dbase.delete(TblProduct.tableProduct);
  }

    static Future<List<Product>> getLocalProduct(Database dbase) async {
    List<Product> productList = [];
    try {
      List<Map<String,dynamic>> res = await dbase.query(TblProduct.tableProduct);
      if (res.isNotEmpty) {
        for(Map<String,dynamic> resMap in res){
          Product product = Product.getProductFromJson(resMap);
          productList.add(product);
        }
      }
    } catch (e) {
      debugPrint('LProduct App error = ${e.toString()}');
      ErrorLogger.write(e.toString());
    }
    return productList;
  }

  static Future<bool> isExists() async {
    bool isExists = false;
    final dbase = await MybuddyDatabase.instance.database;
    List<Map<String, dynamic>> existingData =
        await dbase.query(TblProduct.tableProduct);
    isExists = existingData.isNotEmpty;
    return isExists;
  }
}
