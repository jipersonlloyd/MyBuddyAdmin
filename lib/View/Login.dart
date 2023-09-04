// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sample/API/ASyncData.dart';
import 'package:sample/Controller/APIDetailsController.dart';
import 'package:sample/Controller/ConnectionController.dart';
import 'package:sample/Controller/Constants/Routes.dart';
import 'package:sample/Controller/OTPController.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late OTPController otpController;
  late ConnectionController connectionController;
  late APIDetailsController apiDetailsController;
  bool isTextFieldEmpty = true;
  TextEditingController phonenumber = TextEditingController();
  bool isLoading = false;
  String prefixText = '+63';
  int randomNumber = 0;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() {
    apiDetailsController = Get.put(APIDetailsController());
    otpController = Get.put(OTPController());
    connectionController = Get.put(ConnectionController());
    randomGenerateNumbers();
  }

  void randomGenerateNumbers() {
    if (randomNumber == 0) {
      Random random = Random();
      int min = 100000;
      int max = 999999;
      randomNumber = min + random.nextInt(max - min + 1);
      otpController.otp = randomNumber.toString();
      otpController.update();
      debugPrint('random Number = ${otpController.otp}');
    } else {
      randomNumber = 0;
      Random random = Random();
      int min = 100000;
      int max = 999999;
      randomNumber = min + random.nextInt(max - min + 1);
      otpController.otp = randomNumber.toString();
      otpController.update();
      debugPrint('random Number = ${otpController.otp}');
    }
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
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 150, right: 15, left: 15),
              height: 500,
              width: 390,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white,
                      width: 0.5,
                      style: BorderStyle.solid)),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/MyBuddyLogo.png',
                            width: 70,
                            height: 70,
                          ),
                          const Text(
                            'MY BUDDY ADMIN',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 258,
                    width: 358,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10),
                              child: Form(
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp(r'[.-]')),
                                  ],
                                  maxLength: 10,
                                  controller: phonenumber,
                                  onChanged: (value) {
                                    setState(() {
                                      isTextFieldEmpty = value.isEmpty;
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      prefixText: prefixText,
                                      counterText: '',
                                      prefixIcon: const Icon(Icons.phone),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 0.5))),
                                ),
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: 285,
                                child: GetBuilder<OTPController>(
                                    builder: (controller) => ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          textStyle:
                                              const TextStyle(fontSize: 16),
                                          minimumSize:
                                              const Size.fromHeight(35),
                                        ),
                                        onPressed: isTextFieldEmpty
                                            ? null
                                            : () async {
                                              FocusScope.of(context).unfocus();
                                                String number = prefixText +
                                                    phonenumber.text;
                                                    otpController.phoneNumber = number;
                                                    otpController.update();
                                                debugPrint('number = ${otpController.phoneNumber}');
                                                debugPrint('random Number = ${otpController.otp}');
                                                if (isLoading) return;
                                                setState(
                                                    () => isLoading = true);
                                                await Future.delayed(
                                                        const Duration(
                                                            seconds: 3))
                                                    .whenComplete(() async {
                                                  await ASyncData.loginandOTP(
                                                          otpController.phoneNumber,
                                                          otpController.otp)
                                                      .then((value) {
                                                    debugPrint(
                                                        'value OTP = $value');
                                                    try {
                                                      if (value['Result'] ==
                                                          true && connectionController.hasInternet == true) {
                                                        Navigator.popAndPushNamed(
                                                            context,
                                                            Routes
                                                                .verificationotp);
                                                      } else {
                                                        showDialog(
                                                            context:
                                                                this.context,
                                                            builder:
                                                                ((context) {
                                                              return AlertDialog(
                                                                title: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                        margin: const EdgeInsets.only(
                                                                            right:
                                                                                5),
                                                                        height:
                                                                            25,
                                                                        width:
                                                                            25,
                                                                        color: Colors
                                                                            .red,
                                                                        child: const Center(
                                                                            child:
                                                                                Icon(Icons.close, color: Colors.white))),
                                                                    connectionController.hasInternet ? Text('${value['Status']}') : const Text('No Internet Connection')
                                                                  ],
                                                                ),
                                                                content: Text(
                                                                    '${value['Msg']}'),
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          'OK')),
                                                                ],
                                                              );
                                                            }));
                                                      }
                                                    } catch (e) {
                                                      showDialog(
                                                          context: this.context,
                                                          builder: ((context) {
                                                            return AlertDialog(
                                                              title: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              5),
                                                                      height:
                                                                          25,
                                                                      width: 25,
                                                                      color: Colors
                                                                          .red,
                                                                      child: const Center(
                                                                          child: Icon(
                                                                              Icons.close,
                                                                              color: Colors.white))),
                                                                  const Text(
                                                                      'Error!')
                                                                ],
                                                              ),
                                                              content: Text(
                                                        '${value['Msg']}'),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: const Text(
                                                                        'OK')),
                                                              ],
                                                            );
                                                          }));
                                                    }
                                                    if (value['Result'] ==
                                                        true) {
                                                      Navigator.popAndPushNamed(
                                                          context,
                                                          Routes
                                                              .verificationotp);
                                                    } else {}
                                                  });
                                                });
                                                setState(
                                                    () => isLoading = false);
                                              },
                                        child: isLoading
                                            ? const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                              color: Colors
                                                                  .white)),
                                                  SizedBox(width: 24),
                                                  Text('Please Wait...')
                                                ],
                                              )
                                            : const Text('Login')))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showIncorrectDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Incorrect'),
            content: const Text('This number is not registered'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }
}
