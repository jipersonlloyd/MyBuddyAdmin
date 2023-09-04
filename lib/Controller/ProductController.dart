// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:sample/Database/DatabaseTables/dbHelper.dart';
import 'package:sample/Database/Local/LProduct.dart';
import 'package:sample/Model/ProductModel.dart';
import 'package:sqflite/sqflite.dart';

class ProductController extends GetxController{
  List<Product> productList = [];
  Product? product;
  Database? dbase;

  // @override
  // onInit(){
  //   super.onInit();
  //   initialize();
  // }

  initialize() async {
    dbase = await MybuddyDatabase.instance.database;
    await LProduct.getLocalProduct(dbase!).then((value){
      if(productList.isEmpty){
        productList = value;
      }
      update();
    });
  }
}