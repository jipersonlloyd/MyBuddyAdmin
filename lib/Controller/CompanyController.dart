// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:sample/Database/DatabaseTables/dbHelper.dart';
import 'package:sample/Database/Local/LCompany.dart';
import 'package:sqflite/sqflite.dart';
import '../Model/CompanyModel.dart';

class CompanyController extends GetxController{
  Company? company;
  Database? dbase;

  @override
   onInit(){
    super.onInit();
    initialize();
  }

  initialize() async{
    dbase = await MybuddyDatabase.instance.database;
    await LCompany.getLocalCompany(dbase!).then((value) {
      company ??= value;
      update();
    });
  }
}