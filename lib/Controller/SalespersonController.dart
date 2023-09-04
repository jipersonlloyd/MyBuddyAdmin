// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:sample/Database/DatabaseTables/dbHelper.dart';
import 'package:sample/Database/Local/LSalesperson.dart';
import 'package:sample/Model/Salesperson.dart';
import 'package:sqflite/sqflite.dart';

class SalespersonController extends GetxController {
  List<Salesperson> salesPersonList = [];
  List<Salesperson> selectedSalesmenStockRequest = [];
  List<Salesperson> selectedSalesmenSFAQueuing = [];
  Salesperson? selectedDataReplication;
  List<dynamic> mdName = [];

  Database? dbase;
  Salesperson? salesperson;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  initialize() async {
    dbase = await MybuddyDatabase.instance.database;
    await LSalesperson.getLocalSalesperson(dbase!).then((value) {
      if(salesPersonList.isEmpty){
        salesPersonList = value;
      }
      update();
    });
  }
}
