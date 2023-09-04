// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/Controller/CompanyController.dart';
import 'package:sample/Controller/Constants/Routes.dart';
import 'package:sample/Controller/UserDetailsController.dart';
import '../Controller/ConfigController.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late ConfigController configController;
  late CompanyController companyController;
  TextEditingController passController = TextEditingController();
  late UserDetailsController userDetailsController;
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    //Initializing the Local Database, ConfigController and CompanyController
    initialize();
  }

  initialize() async {
    configController = Get.put(ConfigController());
    companyController = Get.put(CompanyController());
    userDetailsController = Get.put(UserDetailsController());
    passController.text = configController.config!.password!;
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2))
        .whenComplete(() => Navigator.popAndPushNamed(context, Routes.account));
  }
  
  void _toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/MyBuddyLogo.png')),
              const SizedBox(width: 10),
              const Text('MY BUDDY')
            ],
          ),
          backgroundColor: Colors.grey,
        ),
        body: RefreshIndicator(
          onRefresh: () => _handleRefresh(),
          child: ListView(
            children: [
              Container(
                height: 505,
                margin: const EdgeInsets.only(top: 30, left: 15, right: 15),
                decoration: BoxDecoration(
                    border: Border.all(
                        style: BorderStyle.solid,
                        width: 0.5,
                        color: Colors.grey)),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      height: 50,
                      color: Colors.grey[700],
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              Text(
                                'USER',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
                        height: 410,
                        decoration: BoxDecoration(
                            border: Border.all(
                                style: BorderStyle.solid,
                                width: 0.5,
                                color: Colors.grey)),
                        child: Column(
                          children: [
                            titlegreyBackground(title: 'FULLNAME:'),
                            infoWhiteBackground(
                                info:
                                    '${userDetailsController.userDetails?.fullName}'),
                            titlegreyBackground(title: 'CONTACT NO.:'),
                            infoWhiteBackground(
                                info:
                                    '${userDetailsController.userDetails?.contactNumber}'),
                            titlegreyBackground(title: 'EMAIL:'),
                            infoWhiteBackground(
                                info:
                                    '${userDetailsController.userDetails?.email}'),
                            titlegreyBackground(title: 'ACCOUNT:'),
                            infoWhiteBackground(
                                info:
                                    '${userDetailsController.userDetails?.account}'),
                          ],
                        )),
                  ],
                ),
              ),
              Container(
                  height: 607,
                  margin: const EdgeInsets.only(
                      top: 30, left: 15, right: 15, bottom: 20),
                  decoration: BoxDecoration(
                      border: Border.all(
                          style: BorderStyle.solid,
                          width: 0.5,
                          color: Colors.grey)),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        height: 50,
                        color: Colors.grey[700],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.storage,
                                  color: Colors.white,
                                ),
                                Text(
                                  'SERVER',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.grey),
                                  minimumSize:
                                      MaterialStatePropertyAll(Size(10, 30)),
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.symmetric(horizontal: 10))),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, Routes.setupConfiguration);
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.settings),
                                  Text('SETUP'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
                        height: 512,
                        decoration: BoxDecoration(
                            border: Border.all(
                                style: BorderStyle.solid,
                                width: 0.5,
                                color: Colors.grey)),
                        child: Column(
                          children: [
                            titlegreyBackground(title: 'COMPANY:'),
                            SizedBox(
                                height: 51,
                                child: Center(
                                  child: GetBuilder<CompanyController>(
                                    builder: (context) => Text(
                                      '${companyController.company?.company}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                            titlegreyBackground(title: 'SERVER:'),
                            infoWhiteBackgroundCC(
                                info:
                                    '${configController.config?.ip},${configController.config?.port}'),
                            titlegreyBackground(title: 'DATABASE:'),
                            infoWhiteBackgroundCC(
                                info: '${configController.config?.database}'),
                            titlegreyBackground(title: 'USERNAME:'),
                            infoWhiteBackgroundCC(
                                info: '${configController.config?.username}'),
                            titlegreyBackground(title: 'PASSWORD:'),
                            Container(
                              margin: const EdgeInsets.only(left: 115),
                              height: 51,
                              child: Center(
                                child: GetBuilder<ConfigController>(
                                    builder: (controller) => TextFormField(
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                  onPressed: _toggleObscureText,
                                  icon: Icon(obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                                              border: InputBorder.none),
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 18),
                                          readOnly: true,
                                          obscureText: obscureText,
                                          controller: passController,
                                        )),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }

  SizedBox infoWhiteBackground({String info = ''}) {
    return SizedBox(
      height: 51,
      child: Center(
        child: GetBuilder<UserDetailsController>(
          builder: (context) => Text(
            info,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  SizedBox infoWhiteBackgroundCC({String info = ''}) {
    return SizedBox(
      height: 51,
      child: Center(
        child: GetBuilder<ConfigController>(
          builder: (context) => Text(
            info,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Container titlegreyBackground({String title = ''}) {
    return Container(
      width: 300,
      height: 51,
      color: Colors.grey[300],
      child: Container(
        padding: const EdgeInsets.only(top: 15, left: 10),
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
