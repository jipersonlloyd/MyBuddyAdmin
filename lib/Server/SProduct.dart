// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sample/ErrorLogger.dart';
import 'package:sql_conn/sql_conn.dart';
import '../Model/ProductModel.dart';

class SProduct {
  static Future<List<Product>> getProducts() async {
    List<Product>? productList = [];
     try{
    String query = 'SELECT * FROM tblProduct where LEN(Description) > 1';
    String resString = await SqlConn.readData(query);
    List<dynamic> response = json.decode(resString);
    for(dynamic res in response){
    Product product = Product.getProductFromJson(res as Map<String,dynamic>);
    productList.add(product);  
    }
    }catch(e){
      debugPrint('SProduct App error = ${e.toString()}');
      ErrorLogger.write(e.toString());
    }
    return productList;
  }
}