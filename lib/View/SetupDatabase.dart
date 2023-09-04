// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sample/Controller/CompanyController.dart';
import 'package:sample/Controller/ConfigController.dart';
import 'package:sample/Model/CompanyModel.dart';
import 'package:sample/Server/SCompany.dart';
import 'package:sql_conn/sql_conn.dart';
import '../Controller/Constants/Routes.dart';
import '../Database/Local/LCompany.dart';
import '../Database/Local/LConfig.dart';
import '../Model/ConfigModel.dart';

class SetupDatabase extends StatefulWidget {
  const SetupDatabase({super.key});

  @override
  State<SetupDatabase> createState() => _SetupDatabaseState();
}

class _SetupDatabaseState extends State<SetupDatabase> {
  TextEditingController ipController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController dbController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool obscureText = true;
  bool hidetestbutton = true;
  bool hideconnectbutton = true;
  bool isTested = false;
  bool isLoading = false;
  bool isLoading1 = false;
  bool ispassControllerEmpty = true;

  @override
  void initState() {
    super.initState();
    unhidebuttons();
  }

  void _toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void dispose() {
    ipController.dispose();
    dbController.dispose();
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> submitConfig(bool isExists) async {
    ConfigController configController = Get.put(ConfigController());
    Config config = Config(
        ip: ipController.text,
        port: portController.text,
        database: dbController.text,
        username: userController.text,
        password: passController.text);
    if (isExists) {
      LConfig.updateLocalConfig(config);
    } else {
      LConfig.saveLocalConfig(config);
    }
    configController.config = config;
    configController.update();
  }

  void saveConfig() async {
    submitConfig(await LConfig.isExists()).whenComplete(() => debugPrint('FutureConfig Completed'));
  }

  Future<void> submitCompany(bool check) async {
    CompanyController companyController = Get.put(CompanyController());
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
    submitCompany(await LCompany.isExists()).whenComplete(() => debugPrint('FutureCompany Completed'));
  }

  double unhidebuttons(){
    double height = 0;
    if(passController.text == '' || ipController.text == '' || portController.text == '' || dbController.text == '' || userController.text == ''){
      setState(() {
        height = 280;
        hideconnectbutton = true;
        hidetestbutton = true;
      });
    }
    else{
      setState(() {
        height = 380;
        hideconnectbutton = false;
        hidetestbutton = false;
      });
    }
    return height;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(
                title: const Text('Exit'),
                content: const Text('Do you want to exit?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('No')),
                  TextButton(
                      onPressed: () => SystemNavigator.pop(),
                      child: const Text('Exit')),
                ],
              );
            }));
        if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 80, left: 15, right: 15),
            child: Column(
              children: [
                Container(
                  color: Colors.grey[300],
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'MY BUDDY',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 26),
                            ),
                            Text(
                              'SIMPLE BUT NOT SIMPLER',
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Image.asset(
                          'assets/MyBuddyLogo.png',
                          width: 50,
                          height: 50,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: unhidebuttons(),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                      border: Border.all(
                        style: BorderStyle.solid,
                        width: 0.1,
                        color: Colors.black,
                      )),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 200,
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, top: 15),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.storage),
                                hintText: 'Server',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.5)),
                              ),
                              controller: ipController,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            width: 100,
                            child: TextFormField(
                              maxLength: 7,
                              controller: portController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                counterText: '',
                                prefixIcon: Icon(Icons.web),
                                hintText: 'Port',
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.stacked_bar_chart),
                              hintText: 'Database',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.5))),
                          controller: dbController,
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: 'Username',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.5))),
                          controller: userController,
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              ispassControllerEmpty = value.isEmpty;
                            });
                          },
                          textInputAction: TextInputAction.next,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: _toggleObscureText,
                                  icon: Icon(obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                              prefixIcon: const Icon(Icons.lock),
                              hintText: 'Password',
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.5))),
                          controller: passController,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 15),
                        width: 300,
                        child: Visibility(
                          visible: !hidetestbutton,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: ispassControllerEmpty
                                      ? MaterialStatePropertyAll(
                                          Colors.grey.shade300)
                                      : const MaterialStatePropertyAll(
                                          Colors.green)),
                              onPressed: ispassControllerEmpty
                                  ? null
                                  : () async {
                                    FocusScope.of(context).unfocus();
                                      // if (ipController.text == '' && portController.text == '' && dbController.text == '' && userController.text == '') {
                                        if (isLoading) return;
                                        setState(() => isLoading = true);
                                        await Future.delayed(
                                                const Duration(seconds: 3))
                                            .whenComplete(() =>
                                                testConnectionwithDialog(
                                                    context));
                                        setState(() => isLoading = false);
                                      // }
                                      //   else{
                                      //   showDialog(
                                      //             context: this.context,
                                      //             builder: ((context) {
                                      //               return AlertDialog(
                                      //                 title: Row(
                                      //                   mainAxisAlignment: MainAxisAlignment.start,
                                      //                   children: [
                                      //                     Container(
                                      //                       margin: const EdgeInsets.only(right: 5),
                                      //                       height: 25,
                                      //                       width: 25,
                                      //                       color: Colors.red,
                                      //                       child: const Center(child: Icon(Icons.close, color: Colors.white))
                                      //                     ),
                                      //                     const Text('Error!')
                                      //                   ],
                                      //                 ),
                                      //                 content: const Text(
                                      //                     'Credentials Required'),
                                      //                 actions: [
                                      //                   TextButton(
                                      //                       onPressed: () {
                                      //                         Navigator.of(
                                      //                                 context)
                                      //                             .pop();
                                      //                       },
                                      //                       child:
                                      //                           const Text('OK')),
                                      //                 ],
                                      //               );
                                      //             }));
                                      // }
                                    },
                              child: isLoading
                                  ? const SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                          color: Colors.white))
                                  : const Text('Test')),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: Visibility(
                          visible: !hideconnectbutton,
                          child: ElevatedButton(
                              onPressed: isTested
                                  ? () async {
                                      try {
                                        if (isLoading1) return;
                                        setState(() => isLoading1 = true);
                                        await Future.delayed(
                                                const Duration(seconds: 3))
                                            .whenComplete(() {
                                          saveConfig();
                                          saveCompany();
                                          Navigator.pushNamed(context, Routes.loadingscreen);
                                        });
                                        setState(() => isLoading1 = false);
                                      } catch (e) {
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                                  title: const Text('Error'),
                                                  content: Text(e.toString()),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text('OK'))
                                                  ],
                                                ));
                                      }
                                    }
                                  : null,
                              child: isLoading1
                                  ? const SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                          color: Colors.white))
                                  : const Text('Connect')),
                        ),
                      ),
                      // SizedBox(
                      //   width: 300,
                      //   child: ElevatedButton(
                      //       style: ButtonStyle(
                      //           backgroundColor:
                      //               MaterialStatePropertyAll(Colors.red[400])),
                      //       onPressed: () {
                      //         showDialog(
                      //           context: context,
                      //           builder: (BuildContext context) {
                      //             return AlertDialog(
                      //               title: const Text('Cancel Setup'),
                      //               content: const Text(
                      //                   'Are you sure you want to cancel setup and return to landing page?'),
                      //               actions: <Widget>[
                      //                 TextButton(
                      //                   child: const Text('Cancel'),
                      //                   onPressed: () {
                      //                     Navigator.of(context).pop();
                      //                   },
                      //                 ),
                      //                 TextButton(
                      //                   child: const Text('OK'),
                      //                   onPressed: () {
                      //                     Navigator.of(context)
                      //                         .pushNamedAndRemoveUntil(
                      //                             Routes.login,
                      //                             (route) => false);
                      //                   },
                      //                 ),
                      //               ],
                      //             );
                      //           },
                      //         );
                      //       },
                      //       child: const Text('Cancel')),
                      // )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> testConnectionwithDialog(BuildContext context) async {
    // try {
      await SqlConn.connect(
              ip: ipController.text,
              port: portController.text,
              databaseName: dbController.text,
              username: userController.text,
              password: passController.text)
          .whenComplete(() {
        if (SqlConn.isConnected == true) {
          setState(() => isLoading = false);
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
                            setState(() {
                              isTested = true;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('OK'))
                    ],
                  ));
        } else {
          setState(() => isLoading = false);
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text('Connection Error'),
                    content: const Text('Failed to establish SQL Connection'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'))
                    ],
                  ));
        }
      });
    // } catch (e) {
    //   showDialog(
    //       context: context,
    //       builder: (_) => AlertDialog(
    //             title: const Text('Error'),
    //             content: Text(e.toString()),
    //             actions: [
    //               TextButton(
    //                   onPressed: () {
    //                     Navigator.pop(context);
    //                   },
    //                   child: const Text('OK'))
    //             ],
    //           ));
    // }
  }
}
