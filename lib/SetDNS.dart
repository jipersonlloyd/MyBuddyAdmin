// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sample/API/ASyncData.dart';
import 'package:sample/Controller/APIDetailsController.dart';
import 'package:sample/Controller/Constants/Routes.dart';
import 'package:sample/Database/Local/LAPIDetails.dart';
import 'package:sample/Model/APIDetailsModel.dart';

class SetDNS extends StatefulWidget {
  const SetDNS({super.key});

  @override
  State<SetDNS> createState() => _SetDNSState();
}

class _SetDNSState extends State<SetDNS> {
  String protocol = 'https://';
  bool testDnsLoading = false;
  bool updateDnsLoading = false;
  bool enableUpdatebtn = false;
  bool obscureText = true;
  TextEditingController apiDomainController = TextEditingController();
  TextEditingController apiUsernameController = TextEditingController();
  TextEditingController apiPasswordController = TextEditingController();

  Future<void> submitAPIDetails(bool isExists) async {
    APIDetailsController apiDetailsController = Get.put(APIDetailsController());
    APIDetails apiDetails = APIDetails(
      apiDomain: apiDomainController.text,
      apiUsername: apiUsernameController.text,
      apiPassword: apiPasswordController.text
    );
    if (isExists) {
      await LAPIDetails.updateLocalAPIDetails(apiDetails);
    } else {
      await LAPIDetails.saveLocalAPIDetails(apiDetails);
    }
    apiDetailsController.apiDetails = apiDetails;
    apiDetailsController.update();
  }

  void saveAPIDetails() async {
    await submitAPIDetails(await LAPIDetails.isExists());
  }

  void _toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
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
        appBar: AppBar(
          title: const Text('Setup DNS'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
                child: TextFormField(
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              isDense: true,
                              prefixText: protocol,
                                prefixIcon: const Icon(Icons.stacked_bar_chart),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.5))),
                            controller: apiDomainController,
                          ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: TextFormField(
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                hintText: 'Username',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.5))),
                            controller: apiUsernameController,
                          ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: TextFormField(
                  obscureText: obscureText,
                            textInputAction: TextInputAction.next,
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
                            controller: apiPasswordController,
                          ),
              ),
              Container(
                width: double.infinity,
                height: 35,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 2.5),
                            width: 70,
                            child: ElevatedButton(
                                    style: const ButtonStyle(
                                        backgroundColor: MaterialStatePropertyAll(
                                            Colors.green)),
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      String domain = '$protocol${apiDomainController.text}';
                                      if(apiDomainController.text.isNotEmpty && apiUsernameController.text.isNotEmpty && apiPasswordController.text.isNotEmpty){
                                        if(testDnsLoading)return;
                                        setState(() => testDnsLoading = true);
                                        await Future.delayed(const Duration(seconds: 3)).whenComplete(() async {
                                          await ASyncData.testConnection(domain, apiUsernameController.text, apiPasswordController.text).then((value) {
                                            debugPrint('testAPIConnection = $value');
                                            try{
                                        if(value['Result'] == true){
                                        showDialog(
                                          barrierDismissible: false,
                                                  context: this.context,
                                                  builder: ((context) {
                                                    return AlertDialog(
                                                      title: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.only(right: 5),
                                                            height: 25,
                                                            width: 25,
                                                            color: Colors.green,
                                                            child: const Center(child: Icon(Icons.check_outlined, color: Colors.white))
                                                          ),
                                                          Text('${value['Status']}')
    
                                                        ],
                                                      ),
                                                      content: Text(
                                                          '${value['Msg']}'),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              setState(() => enableUpdatebtn = true);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Text('OK')),
                                                      ],
                                                    );
                                                  }));
                                      }
                                      else{
                                        showDialog(
                                          barrierDismissible: false,
                                                  context: this.context,
                                                  builder: ((context) {
                                                    return AlertDialog(
                                                      title: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.only(right: 5),
                                                            height: 25,
                                                            width: 25,
                                                            color: Colors.red,
                                                            child: const Center(child: Icon(Icons.close, color: Colors.white))
                                                          ),
                                                          const Text('Error!')
                                                        ],
                                                      ),
                                                      content: Text(
                                                          '${value['Msg']}'),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                const Text('OK')),
                                                      ],
                                                    );
                                                  }));
                                      }
                                      }
                                      catch(e){
                                        showDialog(
                                          barrierDismissible: false,
                                                  context: this.context,
                                                  builder: ((context) {
                                                    return AlertDialog(
                                                      title: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.only(right: 5),
                                                            height: 25,
                                                            width: 25,
                                                            color: Colors.red,
                                                            child: const Center(child: Icon(Icons.close, color: Colors.white))
                                                          ),
                                                          const Text('Error!')
                                                        ],
                                                      ),
                                                      content: Text(
                                                          '${value['Msg']}'),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                const Text('OK')),
                                                      ],
                                                    );
                                                  }));
                                      }
                                          });               
                                        });
                                        setState(() => testDnsLoading = false);
                                      }
                                    },
                                    child: testDnsLoading
                                        ? const SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: CircularProgressIndicator(
                                                color: Colors.white))
                                        : const Text('Test'))),
                                        Container(
                                          margin: const EdgeInsets.only(left: 2.5),
                          width: 90,
                          child: ElevatedButton(
                              onPressed: enableUpdatebtn
                                  ? () async {
                                    try {
                                        if (updateDnsLoading) return;
                                        setState(() => updateDnsLoading = true);
                                        await Future.delayed(
                                                const Duration(seconds: 3))
                                            .whenComplete(() {
                                          saveAPIDetails();
                                          Navigator.pushNamed(
                                              context, Routes.setupdatabase);
                                        });
                                        setState(() => updateDnsLoading = false);
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
                                                          setState(() => updateDnsLoading = false);
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text('OK'))
                                                  ],
                                                ));
                                      }
                                  }
                                  : null,
                              child: updateDnsLoading
                                  ? const SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                          color: Colors.white))
                                  : const Text('Connect'),
                            ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}