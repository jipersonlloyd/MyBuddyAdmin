// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sample/Controller/ConnectionController.dart';
import 'package:sample/Controller/Constants/Routes.dart';
import 'package:sample/Controller/UserDetailsController.dart';
import 'package:sample/Database/Local/LUserDetails.dart';
import 'package:sample/Model/UserDetailsModel.dart';
import 'package:sqflite/sqflite.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  late ConnectionController connectionController;
  late UserDetailsController userDetailsController;
  bool isExists = false;
  Database? dbase;
  UserDetails? userDetails;
  

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    connectionController = Get.put(ConnectionController());
    userDetailsController = Get.put(UserDetailsController());
    await Future.delayed(const Duration(seconds: 3)).whenComplete(() => checkInternetConnection());
  }

  Future<void> check() async{
    if(await LUserDetails.isExists() == true){
      isExists = true;
    }
    else{
      isExists = false;
    }
  }
  void checkInternetConnection() async {
    await check().whenComplete(() {
      if (connectionController.hasInternet == true && isExists == true) {
     Navigator.popAndPushNamed(context, Routes.firstpage);
    }
     else if(connectionController.hasInternet == true && isExists == false){
      Navigator.popAndPushNamed(context, Routes.login);
     }
    else {
      showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text('Connection Error'),
                    content: const Text('Please check your internet connection'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: const Text('OK'))
                    ],
                  ));
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 220),
                width: 80,
                height: 80,
                child: Image.asset('assets/MyBuddyLogo.png')),
            const Text(
              'MY BUDDY ADMIN',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
