// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:sample/Database/DatabaseTables/dbHelper.dart';
import 'package:sample/Database/Local/LUserDetails.dart';
import 'package:sample/Model/UserDetailsModel.dart';
import 'package:sqflite/sqflite.dart';

class UserDetailsController extends GetxController{
  UserDetails? userDetails;
  Database? dbase;

    @override
  void onInit() {
    super.onInit();
    initialize();
  }
  
  initialize() async {
    dbase = await MybuddyDatabase.instance.database;
    await LUserDetails.getLocalUserDetails(dbase!).then((value) {
      userDetails ??= value;
    });
    update();
  }
}