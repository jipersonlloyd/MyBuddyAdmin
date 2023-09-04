// ignore_for_file: file_names
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sample/API/ASyncData.dart';
import 'package:sample/Controller/APIDetailsController.dart';
import 'package:sample/Controller/ConnectionController.dart';
import 'package:sample/Controller/Constants/Routes.dart';
import 'package:sample/Controller/OTPController.dart';
import 'package:sample/Controller/UserDetailsController.dart';
import 'package:sample/Database/Local/LUserDetails.dart';
import 'package:sample/Model/UserDetailsModel.dart';
import '../Controller/ConfigController.dart';

class VerificationOTP extends StatefulWidget {
  const VerificationOTP({super.key});

  @override
  State<VerificationOTP> createState() => _VerificationOTPState();
}

class _VerificationOTPState extends State<VerificationOTP> {
  List<TextEditingController>? codecontroller;
  late ConnectionController connectionController;
  late OTPController otpController;
  late APIDetailsController apiDetailsController;
  late ConfigController configController;
  FocusNode textfocus = FocusNode();
  int start = 59;
  bool wait = false;
  bool isOTPempty = true;
  bool isLoading = false;
  int randomNumber = 0;
  Timer? timer;

  @override
  initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    connectionController = Get.put(ConnectionController());
    otpController = Get.put(OTPController());
    codecontroller = List.generate(6, (index) => TextEditingController());
    configController = Get.put(ConfigController());
    apiDetailsController = Get.put(APIDetailsController());
    initTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var item in codecontroller!) {
      item.dispose();
    }
    super.dispose();
  }

  void initTimer() {
    startTimer();
    setState(() {
      wait = true;
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          start = 59;
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Future<void> submitUserDetails(bool check) async {
    UserDetailsController userDetailsController =
        Get.put(UserDetailsController());
    UserDetails? userDetails = userDetailsController.userDetails;
    if (check) {
      await LUserDetails.updateLocalUserDetails(userDetails!);
    } else {
      await LUserDetails.saveLocalUserDetails(userDetails!);
    }
  }

  void saveUserDetails() async {
    await submitUserDetails(await LUserDetails.isExists());
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
    final screenHeight = MediaQuery.of(context).size.height;
    debugPrint('screenHeight = $screenHeight');
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
        backgroundColor: Colors.grey[200],
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 80, left: 20),
                  child: const Text(
                    'Verification Code',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 20),
                  child: const Text(
                    'We have sent the\ncode verification',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Container(padding: const EdgeInsets.only(left: 10)),
                    TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Change Phone Number'),
                                content: const Text(
                                    'Are you sure you want to change phone number?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  TextButton(
                                      child: const Text('Change Phone Number'),
                                      onPressed: () async {
                                        await LUserDetails
                                                .deleteLocalUserDetails()
                                            .whenComplete(() {
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  Routes.login);
                                        });
                                      }),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('Change phone number?')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
      margin: const EdgeInsets.only(left: 10, top: 20),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(style: BorderStyle.solid, width: 0.2)),
      height: 58,
      width: 38,
      child: Center(
        child: Form(
          child: TextFormField(
            focusNode: textfocus,
            autofocus: true,
            controller: codecontroller?.elementAt(0),
            decoration: const InputDecoration(border: InputBorder.none),
            onChanged: (value) {
              setState(() {
                isOTPempty = value.isEmpty;
              });
              value.length == 1
                  ? FocusScope.of(context).nextFocus()
                  : FocusScope.of(context).previousFocus();
            },
            style: Theme.of(context).textTheme.titleLarge,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ),
      ),
    ),
                    box(context,
                        height: 58,
                        width: 38,
                        otpcode: codecontroller?.elementAt(1)),
                    box(context,
                        height: 58,
                        width: 38,
                        otpcode: codecontroller?.elementAt(2)),
                    box(context,
                        height: 58,
                        width: 38,
                        otpcode: codecontroller?.elementAt(3)),
                    box(context,
                        height: 58,
                        width: 38,
                        otpcode: codecontroller?.elementAt(4)),
                    box(context,
                        height: 58,
                        width: 38,
                        otpcode: codecontroller?.elementAt(5)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Resend code after : '),
                        Text('0:$start'),
                        const Text(' sec')
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: const Center(
                      child: Text(
                    'This helps us verify every user in our system',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: wait
                            ? null
                            : () async {
                                startTimer();
                                setState(() {
                                  wait = true;
                                });
                                randomGenerateNumbers();
                                debugPrint(
                                    'another random number = $randomNumber');
                                await ASyncData.loginandOTP(
                                    otpController.phoneNumber,
                                    otpController.otp);
                              },
                        child: InkWell(
                            child: Text('Didn\'t get the code?',
                                style: TextStyle(
                                    color: wait
                                        ? Colors.grey[200]
                                        : Colors.blue)))),
                  ],
                ),
                Column(
                  children: [
                    Container(height: screenHeight - 500),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))
                              ),
                          onPressed: isOTPempty
                              ? null
                              : () async {
                                  String? codes1 =
                                      codecontroller?.elementAt(0).text;
                                  String? codes2 =
                                      codecontroller?.elementAt(1).text;
                                  String? codes3 =
                                      codecontroller?.elementAt(2).text;
                                  String? codes4 =
                                      codecontroller?.elementAt(3).text;
                                  String? codes5 =
                                      codecontroller?.elementAt(4).text;
                                  String? codes6 =
                                      codecontroller?.elementAt(5).text;
                                  String inputOTP = codes1! +
                                      codes2! +
                                      codes3! +
                                      codes4! +
                                      codes5! +
                                      codes6!;
                                  debugPrint('inputOTP = $inputOTP');
                                  if (isLoading) return;
                                  setState(() => isLoading = true);
                                  await Future.delayed(
                                          const Duration(seconds: 3))
                                      .whenComplete(() {
                                    if (inputOTP == otpController.otp) {
                                      saveUserDetails();
                                      if (configController.config != null &&
                                          apiDetailsController.apiDetails !=
                                              null) {
                                        Navigator.popAndPushNamed(
                                            context, Routes.firstpage);
                                      } else {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'WELCOME TO MYBUDDY'),
                                              content: const Text(
                                                  'Your MYBUDDY server settings is not configure in this application, Click the '
                                                  'SET UP'
                                                  ' button to configure.'),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  style: const ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.white)),
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator
                                                        .pushNamedAndRemoveUntil(
                                                            context,
                                                            Routes.setdns,
                                                            (route) => false);
                                                  },
                                                  style: const ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.blue)),
                                                  child: const Text(
                                                    'SET UP',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    } else {
                                      showIncorrectDialog();
                                    }
                                  });
                                  setState(() => isLoading = false);
                                },
                          child: isLoading
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: 23,
                                        height: 23,
                                        child: CircularProgressIndicator(
                                            color: Colors.white)),
                                    SizedBox(width: 24),
                                    Text('Please Wait...')
                                  ],
                                )
                              : const Text('Confirm')),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              style: BorderStyle.solid,
                              width: 0.5,
                              color: Colors.blue)),
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: TextButton(
                          onPressed: () {
                            codecontroller?.elementAt(0).clear();
                            codecontroller?.elementAt(1).clear();
                            codecontroller?.elementAt(2).clear();
                            codecontroller?.elementAt(3).clear();
                            codecontroller?.elementAt(4).clear();
                            codecontroller?.elementAt(5).clear();
                            FocusScope.of(context).requestFocus(textfocus);
                          },
                          child: const Text('Clear',
                              style: TextStyle(fontSize: 16))),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget box(BuildContext context,
      {double height = 0, double width = 0, TextEditingController? otpcode}) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 20),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(style: BorderStyle.solid, width: 0.2)),
      height: height,
      width: width,
      child: Center(
        child: Form(
          child: TextFormField(
            controller: otpcode,
            decoration: const InputDecoration(border: InputBorder.none),
            onChanged: (value) {
              setState(() {
                isOTPempty = value.isEmpty;
              });
              value.length == 1
                  ? FocusScope.of(context).nextFocus()
                  : FocusScope.of(context).previousFocus();
            },
            style: Theme.of(context).textTheme.titleLarge,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ),
      ),
    );
  }

  void showIncorrectDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: connectionController.hasInternet
                ? const Text('Incorrect')
                : const Text('Error!'),
            content: connectionController.hasInternet
                ? const Text('Incorrect One Time Pin')
                : const Text('No Internet Connection'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'))
            ],
          );
        });
  }
}
