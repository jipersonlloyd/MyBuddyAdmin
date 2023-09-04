// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sample/Database/DatabaseTables/dbHelper.dart';
import 'package:sample/Database/Local/LConfig.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_conn/sql_conn.dart';

class ConnectionController extends GetxController {
  Database? dbase;
  late StreamSubscription internetSubscription;
  bool hasInternet = false;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  initialize() {
    sqlConnection();
    checkInternetConnection();
  }

  void checkInternetConnection() async {
    internetSubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      this.hasInternet = hasInternet;
      update();
    });
  }

  @override
  void dispose() {
    super.dispose();
    internetSubscription.cancel();
  }

  void sqlConnection() async {
    try {
      dbase = await MybuddyDatabase.instance.database;
      await LConfig.getLocalConfig(dbase!).then((value) async {
        await SqlConn.connect(
            ip: value.ip!,
            port: value.port!,
            databaseName: value.database!,
            username: value.username!,
            password: value.password!);
        if (SqlConn.isConnected == true) {
          debugPrint('SqlConnection has been initialized');
        } else {
          debugPrint('SqlConnection has not been established');
        }
      });
    } catch (e) {
      debugPrint('ServerController App error : ${e.toString()}');
    }
  }
  }
