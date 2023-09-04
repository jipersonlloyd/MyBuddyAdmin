// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/Controller/CompanyController.dart';
import 'package:sample/Controller/ConfigController.dart';
import 'package:sample/Controller/ConnectionController.dart';
import 'package:sample/Controller/Constants/Routes.dart';
import 'package:sample/Database/Local/LCompany.dart';
import 'package:sample/Database/Local/LConfig.dart';
import 'package:sample/Model/CompanyModel.dart';
import 'package:sample/Model/ConfigModel.dart';
import 'package:sample/Server/SCompany.dart';
import 'package:sql_conn/sql_conn.dart';

class SetupConfiguration extends StatefulWidget {
  const SetupConfiguration({super.key});

  @override
  State<SetupConfiguration> createState() => _SetupConfigurationState();
}

class _SetupConfigurationState extends State<SetupConfiguration> {
  TextEditingController ipController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController dbController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  late ConfigController configController;
  late CompanyController companyController;
  late ConnectionController connectionController;
  FocusNode fnIP = FocusNode();
  FocusNode fnPort = FocusNode();
  FocusNode fndbase = FocusNode();
  FocusNode fnUsername = FocusNode();
  FocusNode fnPassword = FocusNode();
  bool testLoading = false;
  bool isSqlConnect = false;
  Color serverColorConn = Colors.orange;

  void toggleObscureText() {
    configController.obscureText = !configController.obscureText;
    configController.update();
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    configController = Get.put(ConfigController());
    companyController = Get.put(CompanyController());
    connectionController = Get.put(ConnectionController());
    ipController.text = configController.config!.ip!;
    portController.text = configController.config!.port!;
    dbController.text = configController.config!.database!;
    userController.text = configController.config!.username!;
    passController.text = configController.config!.password!;
    debugPrint('hasInternet = ${connectionController.hasInternet}');
    await sqlConn();
    isSqlConnectIcon();
  }

  void isSqlConnectIcon() {
    if (isSqlConnect == true && connectionController.hasInternet == true) {
      setState(() {
        serverColorConn = Colors.green;
      });
    } else if (isSqlConnect == false &&
        connectionController.hasInternet == true) {
      setState(() {
        serverColorConn = Colors.orange;
      });
    } else {
      setState(() {
        serverColorConn = Colors.red;
      });
    }
  }

  void unfocusNodes(){
    fnIP.unfocus();
    fnPort.unfocus();
    fndbase.unfocus();
    fnUsername.unfocus();
    fnPassword.unfocus();
  }

  Future<void> submitConfig(bool check) async {
    Config config = Config(
        ip: ipController.text,
        port: portController.text,
        database: dbController.text,
        username: userController.text,
        password: passController.text);
    if (check) {
      LConfig.updateLocalConfig(config);
    } else {
      LConfig.saveLocalConfig(config);
    }
    configController.config = config;
    configController.update();
  }

  Future<bool> isSqlConnected() async {
    if (SqlConn.isConnected == true &&
        connectionController.hasInternet == true) {
      return true;
    } else if (SqlConn.isConnected == false &&
        connectionController.hasInternet == true) {
      await SqlConn.connect(
          ip: configController.config!.ip!,
          port: configController.config!.port!,
          databaseName: configController.config!.database!,
          username: configController.config!.username!,
          password: configController.config!.password!,
          timeout: 60);
      if (SqlConn.isConnected) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> isConnected() async {
    await SqlConn.disconnect();
    await isSqlConnected().then((value) {
      setState(() {
        isSqlConnect = value;
      });
    });
  }

  Future<void> sqlConn() async {
    await Future.delayed(const Duration(seconds: 1))
        .whenComplete(() => isConnected())
        .whenComplete(
            () => debugPrint('accountSQLConnected = ${SqlConn.isConnected}'));
  }

  void saveConfig() async {
    submitConfig(await LConfig.isExists())
        .whenComplete(() => debugPrint('FutureConfig Completed'));
  }

  Future<void> submitCompany(bool check) async {
    Company company = await SCompany.getCompany();
    if (check) {
      LCompany.updateLocalCompany(company);
    } else {
      LCompany.saveLocalCompany(company);
    }

    companyController.company = company;
    companyController.update();
  }

  void saveCompany() async {
    submitCompany(await LCompany.isExists());
  }

  Future<void> testConnectionwithDialog() async {
    try {
      await SqlConn.connect(
          ip: ipController.text,
          port: portController.text,
          databaseName: dbController.text,
          username: userController.text,
          password: passController.text);
      if (SqlConn.isConnected == true) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Connection Successful'),
                  content: const Text(
                      'The SQL connection was established successfully.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          configController.isTested = true;
                          configController.update();
                          Navigator.pop(context);
                        },
                        child: const Text('OK'))
                  ],
                ));
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Connection Failed'),
                  content: const Text('Failed to establish SQL Connection'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          configController.isTested = true;
                          configController.update();
                          Navigator.pop(context);
                        },
                        child: const Text('OK'))
                  ],
                ));
      }
    } catch (e) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Error'),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        configController.isTested = true;
                        configController.update();
                        Navigator.pop(context);
                      },
                      child: const Text('OK'))
                ],
              ));
    }
  }

  Future<void> handleRefresh() async {
    await Future.delayed(const Duration(seconds: 10)).whenComplete(
        () => Navigator.popAndPushNamed(context, Routes.setupConfiguration));
  }

  void setupDialog(BuildContext context) {
    double mQuerywidth = MediaQuery.of(context).size.width - 200;
    debugPrint('showDialogWidth = $mQuerywidth');
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: SizedBox(
              width: 300,
              height: 400,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      'Set Configuration',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: mQuerywidth,
                        child: GetBuilder<ConfigController>(
                          init: configController,
                          builder: (context) => TextFormField(
                            focusNode: fnIP,
                            controller: ipController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                labelText: 'IP Address'),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 60),
                        child: const Text(' : '),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: 61,
                        child: TextFormField(
                          focusNode: fnPort,
                          controller: portController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            labelText: 'Port',
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 250,
                    child: TextFormField(
                      focusNode: fndbase,
                      controller: dbController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        labelText: 'Database',
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: 250,
                    child: TextFormField(
                      focusNode: fnUsername,
                      controller: userController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        labelText: 'Username',
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: 250,
                      child: GetBuilder<ConfigController>(
                        builder: (controller) => TextFormField(
                          focusNode: fnPassword,
                          controller: passController,
                          obscureText: configController.obscureText,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: toggleObscureText,
                                icon: Icon(configController.obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                            contentPadding: EdgeInsets.zero,
                            labelText: 'Password',
                          ),
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          width: 100,
                          margin: const EdgeInsets.only(top: 30),
                          child: GetBuilder<ConfigController>(
                              builder: (context) => ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.green)),
                                  onPressed: () async {
                                    if (configController.testSetupLoading) return;
                                    configController.testSetupLoading = true;
                                    configController.update();
                                    await Future.delayed(
                                            const Duration(seconds: 3))
                                        .whenComplete(
                                            () {
                                              unfocusNodes();
                                              testConnectionwithDialog();
                                            });
                                    configController.testSetupLoading = false;
                                    configController.update();
                                  },
                                  child: configController.testSetupLoading
                                      ? const SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: CircularProgressIndicator(
                                              color: Colors.white))
                                      : const Text('Test')))),
                      Container(
                        width: 100,
                        margin: const EdgeInsets.only(top: 30),
                        child: GetBuilder<ConfigController>(
                          init: configController,
                          builder: (context) => ElevatedButton(
                            onPressed: configController.isTested
                                ? () {
                                    confirmDialog();
                                  }
                                : null,
                            child: const Text('Update'),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            connectionController.hasInternet ? Colors.green : Colors.red,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Set Configuration'),
            Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 5, right: 5)),
                Icon(connectionController.hasInternet
                    ? Icons.wifi
                    : Icons.wifi_off),
              ],
            )
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => handleRefresh(),
        child: ListView(
          children: [
            Container(
                height: 450,
                margin: const EdgeInsets.only(top: 70, left: 30, right: 30),
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        'Server Connection Status',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(right: 3),
                              width: 16,
                              height: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 10, color: Colors.green))),
                          const Text('Online'),
                          Container(
                              margin: const EdgeInsets.only(right: 3, left: 5),
                              width: 16,
                              height: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 15, color: Colors.red))),
                          const Text(' Offline '),
                          Container(
                              margin: const EdgeInsets.only(right: 3, left: 5),
                              width: 16,
                              height: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 15, color: Colors.orange))),
                          const Text(' Connecting')
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 16,
                              height: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 15, color: serverColorConn))),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GetBuilder<ConfigController>(
                                init: configController,
                                builder: (context) =>
                                    Text('  ${configController.config?.ip}'),
                              ),
                              const Text('Primary IP')
                            ],
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setupDialog(context);
                      },
                      child: const Text('Set Configuration'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.password1dns);
                      },
                      child: const Text('Change DNS'),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void confirmDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: SizedBox(
                width: 300,
                height: 145,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 280,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          'Confirm Action',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const Text(
                        'You will be logout after this action, would you like to continue?'),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.white)),
                                onPressed: () {
                                  configController.updateSetupLoading = false;
                                  configController.update();
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.black),
                                )),
                          ),
                          GetBuilder<ConfigController>(
                            builder: (controller) => ElevatedButton(
                                onPressed: () async {
                                  configController.isTested = false;
                                  if (configController.updateSetupLoading) return;
                                  configController.updateSetupLoading = true;
                                  configController.update();
                                  await Future.delayed(
                                          const Duration(seconds: 3))
                                      .whenComplete(() {
                                    saveConfig();
                                    saveCompany();
                                    Navigator.pushNamed(
                                        context, Routes.loadingscreen);
                                  });
                                  configController.updateSetupLoading = false;
                                  configController.update();
                                },
                                child: configController.updateSetupLoading
                                    ? const SizedBox(
                                        width: 23,
                                        height: 23,
                                        child: CircularProgressIndicator(
                                            color: Colors.white))
                                    : const Text('Proceed')),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
