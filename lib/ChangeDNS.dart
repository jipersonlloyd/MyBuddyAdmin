// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/API/ASyncData.dart';
import 'package:sample/Controller/APIDetailsController.dart';
import 'package:sample/Controller/ConfigController.dart';
import 'package:sample/Controller/Constants/Routes.dart';
import 'package:sample/Database/Local/LAPIDetails.dart';
import 'package:sample/Model/APIDetailsModel.dart';

class ChangeDNS extends StatefulWidget {
  const ChangeDNS({super.key});

  @override
  State<ChangeDNS> createState() => _ChangeDNSState();
}

class _ChangeDNSState extends State<ChangeDNS> {
  String protocol = 'https://';
  bool testDnsLoading = false;
  bool updateDnsLoading = false;
  bool enableUpdatebtn = false;
  TextEditingController apiDomainController = TextEditingController();
  TextEditingController apiUsernameController = TextEditingController();
  TextEditingController apiPasswordController = TextEditingController();
  late APIDetailsController apiDetailsController;
  late ConfigController configController;

  @override
  void initState(){
    super.initState();
    initialize();
  }
  
  initialize(){
    apiDetailsController = Get.put(APIDetailsController());
    configController = Get.put(ConfigController());
    apiDomainController.text = apiDetailsController.apiDetails!.apiDomain!;
    apiUsernameController.text = apiDetailsController.apiDetails!.apiUsername!;
    apiPasswordController.text = apiDetailsController.apiDetails!.apiPassword!;
    debugPrint('apiDetailschangeDNS = ${apiDetailsController.apiDetails}');
  }

  Future<void> submitAPIDetails(bool isExists) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change DNS'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
              child: GetBuilder<APIDetailsController>(
                builder: (controller) => TextFormField(
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
              )
            ),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: GetBuilder<APIDetailsController>(
                builder: (controller) => TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: 'Username',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.5))),
                          controller: apiUsernameController,
                        ),
              )
            ),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: GetBuilder<APIDetailsController>(
                builder: (controller) => TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: 'Password',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.5))),
                          controller: apiPasswordController,
                        ),
              )
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
                                    String domain = '$protocol${apiDomainController.text}';
                                    if(apiDomainController.text.isNotEmpty && apiUsernameController.text.isNotEmpty && apiPasswordController.text.isNotEmpty){
                                      if(testDnsLoading)return;
                                      setState(() => testDnsLoading = true);
                                      await Future.delayed(const Duration(seconds: 3)).whenComplete(() async {
                                        await ASyncData.testConnection(domain, apiUsernameController.text, apiPasswordController.text).then((value) {
                                          debugPrint('testAPIConnection = $value');
                                          debugPrint('status = ${value['statusCode']}');
                                      if(value['Result'] == true){
                                      showDialog(
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
                        width: 80,
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
                                        showDialog(
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
                                                        const Text('Success')
    
                                                      ],
                                                    ),
                                                    content: const Text(
                                                        'Updated Succesfully'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            setState(() => enableUpdatebtn = true);
                                                            Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              Routes.firstpage,
                                              (route) => false);
                                                          },
                                                          child:
                                                              const Text('OK')),
                                                    ],
                                                  );
                                                }));
                                      });
                                      setState(() => updateDnsLoading = false);
                                    } catch (e) {
                                      showDialog(
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
                                : const Text('Update'),
                          ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}