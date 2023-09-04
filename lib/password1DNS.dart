// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sample/Controller/Constants/Routes.dart';

class Password1DNS extends StatefulWidget {
  const Password1DNS({super.key});

  @override
  State<Password1DNS> createState() => _Password1DNSState();
}

class _Password1DNSState extends State<Password1DNS> {
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Password to Change DNS', style: TextStyle(fontSize: 17))),
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
                            Navigator.popAndPushNamed(
                                context, Routes.changedns);
                          }
                          else{
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
    );
  }
}
