// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample/Controller/Constants/Routes.dart';

class PasswordDNS extends StatefulWidget {
  const PasswordDNS({super.key});

  @override
  State<PasswordDNS> createState() => _PasswordDNSState();
}

class _PasswordDNSState extends State<PasswordDNS> {
  TextEditingController passController = TextEditingController();

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
        appBar: AppBar(
            title: AppBar(
                title: const Text('Input Password to Set DNS',
                    style: TextStyle(fontSize: 17)))),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
                child: TextFormField(
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      hintText: 'Password',
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.5))),
                  controller: passController,
                ),
              ),
              Container(
                width: double.infinity,
                height: 35,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
                child: Center(
                  child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      width: double.infinity,
                      child: ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.blue)),
                          onPressed: () {
                            String pass = '12345';
                            if (passController.text == pass) {
                              Navigator.popAndPushNamed(context, Routes.setdns);
                            } else {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title:
                                            const Text('Error!'),
                                        content: const Text(
                                            'Incorrect Password'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('OK'))
                                        ],
                                      ));
                            }
                          },
                          child: const Text('Confirm'))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
