// ignore_for_file: file_names


import 'package:get/get.dart';
import 'package:sample/Model/ConfigModel.dart';
import 'package:sqflite/sqflite.dart';
import '../Database/DatabaseTables/dbHelper.dart';
import '../Database/Local/LConfig.dart';


class ConfigController extends GetxController{
  Config? config;
  Database? dbase;
  bool isTested = false;
  bool testLoading = false;
  bool testSetupLoading = false;
  bool updateSetupLoading = false;
  bool obscureText = true;
  bool syncCustomerLoading = false;
  bool syncProductLoading = false;
  bool syncSFALoading = false;
  bool syncStockRequestLoading = false;
  bool syncDataReplicationLoading = false;
  bool syncIDeliverLoading = false;
  bool syncTaggingLoading = false;
  bool syncSweeperLoading = false;
  bool realignMCPLoading = false;
  bool hidecancelbutton = false;


  @override
  void onInit() {
    super.onInit();

    initialize();
  }
  
  initialize() async {
    dbase = await MybuddyDatabase.instance.database;
    await LConfig.getLocalConfig(dbase!).then((value) {
      config ??= value;
      update();
    });
  }
}