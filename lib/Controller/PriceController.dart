// ignore_for_file: file_names

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:sample/Database/DatabaseTables/dbHelper.dart';
import 'package:sample/Database/Local/LPrice.dart';
import 'package:sample/Model/PriceModel.dart';
import 'package:sqflite/sqflite.dart';

class PriceController extends GetxController{
  List<Price> priceList = [];
  Price? price;
  Database? dbase;

  // @override
  // void onInit() {
  //   super.onInit();
  //   initialize();
  // }

  initialize() async {
    dbase = await MybuddyDatabase.instance.database;
    await LPrice.getLocalPrice(dbase!).then((value){
      if(priceList.isEmpty){
        priceList = value;
      }
      update();
    });
  }
}