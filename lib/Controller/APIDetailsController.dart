// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sample/Database/DatabaseTables/dbHelper.dart';
import 'package:sample/Database/Local/LAPIDetails.dart';
import 'package:sample/Model/APIDetailsModel.dart';
import 'package:sqflite/sqflite.dart';

class APIDetailsController extends GetxController {
  Database? dbase;
  APIDetails? apiDetails;

  @override
  onInit() {
    super.onInit();
    initialize();
  }

  initialize() async {
    dbase = await MybuddyDatabase.instance.database;
    await LAPIDetails.getLocalAPIDetails(dbase!).then((value) {
      debugPrint('apivalue = $value');
      apiDetails ??= value;
      debugPrint('apiDetails = $apiDetails');
      update();
    });
  }
}
