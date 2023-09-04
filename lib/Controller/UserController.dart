// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:sample/Database/DatabaseTables/dbHelper.dart';
import 'package:sample/Database/Local/LUser.dart';
import 'package:sqflite/sqflite.dart';
import '../Model/UserModel.dart';

class UserController extends GetxController{
  User? user;
  Database? dbase;

  // @override
  // onInit(){
  //   super.onInit();
  //   initialize();
  // }

  initialize() async{
    dbase = await MybuddyDatabase.instance.database;
    await LUser.getLocalUser(dbase!).then((value) {
      user = value;
      update();
    });
  }
}