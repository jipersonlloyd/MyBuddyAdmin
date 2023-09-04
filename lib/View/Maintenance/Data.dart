// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sample/API/ASyncData.dart';
import 'package:sample/Controller/APIDetailsController.dart';
import 'package:sample/Controller/CompanyController.dart';
import 'package:sample/Controller/ConfigController.dart';
import 'package:sample/Controller/ConnectionController.dart';
import 'package:sample/Controller/Constants/Routes.dart';
import 'package:sample/Controller/SalespersonController.dart';
import 'package:sample/Model/Salesperson.dart';
import 'package:sample/Model/SyncDetailsModel.dart';
import 'package:sample/Server/SSyncData.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_conn/sql_conn.dart';

class Data extends StatefulWidget {
  const Data({super.key});

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  DateTime selectedDate = DateTime.now();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController syncInvoiceDateController = TextEditingController();
  TextEditingController syncStockRequestDateController =
      TextEditingController();
  TextEditingController syncSFAQueuingDateController = TextEditingController();
  late SalespersonController salespersonController;
  late CompanyController companyController;
  late ConfigController configController;
  late ConnectionController connectionController;
  late APIDetailsController apiDetailsController;
  SyncDetails? syncDetails;
  Database? dbase;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
void dispose() {
  textEditingController.dispose();
  super.dispose();
}

  initialize() {
    companyController = Get.put(CompanyController());
    salespersonController = Get.put(SalespersonController());
    configController = Get.put(ConfigController());
    connectionController = Get.put(ConnectionController());
    apiDetailsController = Get.put(APIDetailsController());
    syncDetail();
  }

  Future<void> handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1)).whenComplete(
        () => Navigator.popAndPushNamed(context, Routes.firstpage));
  }
  
  void syncDetail(){
    syncDetails = SyncDetails(
      siteID: companyController.company?.distCD,
      encDBName: companyController.company?.dbName,
      serverIP: configController.config?.ip,
      dbase: configController.config?.database,
      userName: configController.config?.username,
      password: configController.config?.password
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => handleRefresh(),
        child: ListView(
          children: [
            Column(
              children: [
          //       Container(
          //         margin: const EdgeInsets.only(top: 25, left: 250),
          //         height: 30,
          //         child: GetBuilder<ConfigController>(
          //           builder: (controller) => ElevatedButton(
          //           child: configController.testLoading
          //                         ? const SizedBox(
          //                             width: 20,
          //                             height: 20,
          //                             child: CircularProgressIndicator(
          //                                 color: Colors.white))
          //                         : const Text('Test'),
          //           onPressed: () async {
          //             if(configController.testLoading)return;
          //             configController.testLoading = true;
          //             configController.update();
          //             await Future.delayed(const Duration(seconds: 3)).whenComplete(() async {
          //               await SqlConn.disconnect().whenComplete(() async {
          //                 await SqlConn.connect(
          //                   ip: configController.config!.ip!,
          //                   port: configController.config!.port!,
          //                   databaseName: configController.config!.database!,
          //                   username: configController.config!.username!,
          //                   password: configController.config!.password!).whenComplete(() {
          //                     if (SqlConn.isConnected == true) {
          //   showDialog(
          //       barrierDismissible: false,
          //       context: context,
          //       builder: (_) => AlertDialog(
          //             title: const Text('Connection Successful'),
          //             content: const Text(
          //                 'The SQL connection was established successfully.'),
          //             actions: [
          //               TextButton(
          //                   onPressed: () {
          //                     Navigator.pop(context);
          //                   },
          //                   child: const Text('OK'))
          //             ],
          //           ));
          // } else {
          //   showDialog(
          //       barrierDismissible: false,
          //       context: context,
          //       builder: (_) => AlertDialog(
          //             title: const Text('Connection Error'),
          //             content: const Text('Failed to establish SQL Connection'),
          //             actions: [
          //               TextButton(
          //                   onPressed: () {
          //                     Navigator.pop(context);
          //                   },
          //                   child: const Text('OK'))
          //             ],
          //           ));
          // }
          // configController.testLoading = false;
          // configController.update();
          //                   });
      
          //             });
          //             });
          //           },
          //         ),
          //         )
          //       ),
                Container(
                  color: Colors.blue,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 25),
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: GetBuilder<CompanyController>(
                                init: companyController,
                                builder: (context) => Text(
                                    '${companyController.company?.company}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 1,
                      color: Colors.blue,
                    ),
                  ),
                  child: Column(
                    children: [
                      list('Sync Customer\n',
                          'This will align customer details on MCP, NPIReturns Reason, Salesman details, Offtake, Musthave, Cycle Plan, buying Accounts from syspro',
                          () {
                        syncCustomer();
                      }),
                      list('Sync Product\n',
                          'This will align product details & price list.\n',
                          () {
                        syncProduct();
                      }),
                      list('Sync SFA Queuing\n',
                          'This will populate data for Nestle Queuing Services.\n',
                          () {
                        syncSFAQueuing();
                      }),
                      list('Sync Stock Request\n',
                          'This will populate stock request to Nestle Queuing Services.\n',
                          () {
                        syncStockRequest();
                      }),
                      list('Data Replication\n',
                          'Please select target account to be replicated for testing.\n',
                          () {
                        dataReplication();
                      }),
                      list('Sync Invoice (IDELIVER)\n',
                          'This will populate ideliver invoice data for creating trip / freight order.\n',
                          () {
                        syncInvoiceIDELIVER();
                      }),
                      list('Sync Delivery Tagging (IDELIVER)',
                          'This will populate nestle requirements delivery tagging data from ideliver to syspro.\n',
                          () {
                        syncDeliveryTagging();
                      }),
                      list('Sync Sweeper Transaction (SOSYO)\n',
                          'This will populate sosyo sweeper transaction data for reporting purposes.',
                          () {
                        syncSweeperTransaction();
                      }),
                      list('Realign MCP Schedule (SOSYO)\n',
                          'This will realign any changes in salesman coverage or customer assignment for sosyo order transaction.',
                          () {
                        realignMCPSchedule();
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget list(String title, String description, Function() function) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              style: BorderStyle.solid, width: 0.5, color: Colors.grey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(description,
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 14)),
            ElevatedButton(onPressed: function, child: const Text('EXECUTE')),
          ],
        ),
      ),
    );
  }

  void realignMCPSchedule() {
    //double showDialogHeight = MediaQuery.of(context).size.height - 534.4;
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: SizedBox(
                width: 300,
                height: 160,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 280,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          'Realign MCP Schedule(SOSYO)',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const Text(
                        'This could take time, please wait while we process your request.'),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: GetBuilder<ConfigController>(
                              builder:(controller) => Visibility(
                              visible: !configController.hidecancelbutton,
                              child: ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.white)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ),
                            )
                          ),
                          GetBuilder<ConfigController>(
                            builder:(controller) => ElevatedButton(
                              onPressed: () async {
                                if(configController.realignMCPLoading) return;
                                configController.hidecancelbutton = true;
                                configController.realignMCPLoading = true;
                                configController.update();
                                await Future.delayed(const Duration(seconds: 5)).whenComplete(() async {
                                  await ASyncData.realignMCPSchedule(syncDetails!, apiDetailsController.apiDetails).then((value) {
                                    debugPrint('value = $value');
                                    try{
                                      if(value['Result'] == true){
                                      configController.hidecancelbutton = false;
                                      configController.realignMCPLoading = false;
                                      configController.update();
                                      Navigator.pop(context);
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
                                      configController.hidecancelbutton = false;
                                      configController.realignMCPLoading = false;
                                      configController.update();
                                      Navigator.pop(context);
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
                                                        connectionController.hasInternet ? Text('${value['Status']}') : const Text('Error!'),
                                                      ],
                                                    ),
                                                    content: connectionController.hasInternet ? Text('${value['Msg']}') : const Text('No Internet Connection'), 
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
                                      configController.hidecancelbutton = false;
                                      configController.realignMCPLoading = false;
                                      configController.update();
                                      Navigator.pop(context);
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
                              },
                              child: configController.realignMCPLoading
                                    ? const SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: CircularProgressIndicator(
                                            color: Colors.white))
                                    : const Text('Execute'))   
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

  void syncSweeperTransaction() {
    //double showDialogHeight = MediaQuery.of(context).size.height - 534.4;
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: SizedBox(
                width: 300,
                height: 180,
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                      width: 280,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          'Sync Sweeper Transaction(SOSYO)',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const Text(
                        'This could take time, please wait while we process your request.'),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: GetBuilder<ConfigController>(
                              builder:(controller) => Visibility(
                              visible: !configController.hidecancelbutton,
                              child: ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.white)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ),
                            )
                          ),
                          GetBuilder<ConfigController>(
                            builder:(controller) => ElevatedButton(
                              onPressed: () async {
                                if(configController.syncSweeperLoading) return;
                                configController.hidecancelbutton = true;
                                configController.syncSweeperLoading = true;
                                configController.update();
                                await Future.delayed(const Duration(seconds: 5)).whenComplete(() async {
                                  await ASyncData.syncSweeperTransaction(syncDetails!, apiDetailsController.apiDetails).then((value) {
                                    debugPrint('value = $value');
                                    try{
                                      if(value['Result'] == true){
                                        configController.hidecancelbutton = false;
                                      configController.syncSweeperLoading = false;
                                      configController.update();
                                      Navigator.pop(context);
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
                                      configController.hidecancelbutton = false;
                                      configController.syncSweeperLoading = false;
                                      configController.update();
                                      Navigator.pop(context);
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
                                                        connectionController.hasInternet ? Text('${value['Status']}') : const Text('Error!'),
                                                      ],
                                                    ),
                                                    content: connectionController.hasInternet ? Text('${value['Msg']}') : const Text('No Internet Connection'), 
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
                                      configController.hidecancelbutton = false;
                                      configController.syncSweeperLoading = false;
                                      configController.update();
                                      Navigator.pop(context);
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
                              },
                              child: configController.syncSweeperLoading
                                    ? const SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: CircularProgressIndicator(
                                            color: Colors.white))
                                    : const Text('Execute'))   
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

  void syncStockRequest() {
    int count = 0;
    int temp = 0;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: SizedBox(
                width: 300,
                height: 265,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 280,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          'Sync Stock Request',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const Divider(),
                    SizedBox(
                      width: 300,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          'SALESMAN :',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 300,
                        child: GetBuilder<SalespersonController>(
                            builder: (context) =>
                                MultiSelectDialogField<Salesperson>(
                                  buttonText: Text('$count selected salesman',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2),
                                  chipDisplay: MultiSelectChipDisplay.none(),
                                  isDismissible: false,
                                  items: salespersonController.salesPersonList
                                      .map((salesperson) => MultiSelectItem(
                                          salesperson,
                                          '${salesperson.mdSalesmanCode} ${salesperson.mdName}'))
                                      .toList(),
                                  initialValue: salespersonController
                                      .selectedSalesmenStockRequest,
                                  searchable: true,
                                  title: const Text('Salesmen', style: TextStyle(fontSize: 18)),
                                  onConfirm: (value) {
                                    salespersonController
                                        .selectedSalesmenStockRequest = value;
                                    for (var index in Iterable<int>.generate(
                                        salespersonController
                                            .selectedSalesmenStockRequest
                                            .length)) {
                                      index = 1;
                                      temp += index;
                                      count = temp;
                                    }
                                    temp = 0;
                                    salespersonController.update();
                                  },
                                ))),
                    const Divider(),
                    Column(
                      children: [
                        const SizedBox(
                          width: 300,
                          child: Text(
                            'DATE :',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 40,
                          padding: const EdgeInsets.only(left: 5),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            onChanged: (value) {},
                            readOnly: true,
                            controller: syncStockRequestDateController,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 6),
                              suffixIcon: SizedBox(
                                width: 10,
                                height: 10,
                                child: IconButton(
                                  onPressed: () async {
                                    //insert logic code here
                                    final DateTime? dateTime =
                                        await showDatePicker(
                                            context: context,
                                            initialDate: selectedDate,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime.now());
                                    if (dateTime != null) {
                                      setState(() {
                                        syncStockRequestDateController.text =
                                            formatDate(dateTime);
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.date_range_outlined),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: GetBuilder<ConfigController>(
                            builder:(controller) => Visibility(
                              visible: !configController.hidecancelbutton,
                              child: ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.white)),
                                onPressed: () {
                                  for (int index = 0;
                                      index <
                                          salespersonController
                                              .selectedSalesmenStockRequest
                                              .length;
                                      index++) {
                                    salespersonController
                                        .selectedSalesmenStockRequest
                                        .removeRange(
                                            index,
                                            salespersonController
                                                .selectedSalesmenStockRequest
                                                .length);
                                  }
                                  syncStockRequestDateController.clear();
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.black),
                                )),
                            ),
                          )
                        ),
                        GetBuilder<ConfigController>(
                            builder: (controller) => ElevatedButton(
                                onPressed: () async {
                                  if (configController.syncStockRequestLoading) return;
                                  configController.hidecancelbutton = true;
                                  configController.syncStockRequestLoading =
                                      true;
                                  configController.update();
                                  await Future.delayed(
                                          const Duration(seconds: 5))
                                      .whenComplete(() async {
                                    if (syncStockRequestDateController
                                            .text.isNotEmpty &&
                                        salespersonController
                                            .selectedSalesmenStockRequest
                                            .isNotEmpty) {
                                      await SSyncData.syncstockRequest(
                                              syncStockRequestDateController
                                                  .text,
                                              salespersonController
                                                  .selectedSalesmenStockRequest)
                                          .then((value) {
                                        try {
                                          if (value == true) {
                                            configController.hidecancelbutton = false;
                                            for (int index = 0;
                                                index <
                                                    salespersonController
                                                        .selectedSalesmenStockRequest
                                                        .length;
                                                index++) {
                                              salespersonController
                                                  .selectedSalesmenStockRequest
                                                  .removeRange(
                                                      index,
                                                      salespersonController
                                                          .selectedSalesmenStockRequest
                                                          .length);
                                            }
                                            configController
                                                    .syncStockRequestLoading =
                                                false;
                                            configController.update();
                                            syncStockRequestDateController
                                                .clear();
                                            Navigator.pop(context);
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
                                                        const Text('Success!')

                                                      ],
                                                    ),
                                                    content: const Text(
                                                        'Sync Stock Request was Successful. Thank You!'),
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
                                          } else {
                                            configController.hidecancelbutton = false;
                                            configController
                                                    .syncStockRequestLoading =
                                                false;
                                            configController.update();
                                            Navigator.pop(context);
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
                                                    content: const Text(
                                                        'Connection Error'),
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
                                        } catch (e) {
                                          configController.hidecancelbutton = false;
                                          configController
                                              .syncStockRequestLoading = false;
                                          configController.update();
                                          Navigator.pop(context);
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
                                                  content: Text(e.toString()),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('OK')),
                                                  ],
                                                );
                                              }));
                                        }
                                      });
                                    } else {
                                      configController.hidecancelbutton = false;
                                      showDialog(
                                          context: this.context,
                                          builder: ((context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Date and Salesman Required'),
                                              content: const Text(
                                                  'Please Input Date/Salesman'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      configController
                                                              .syncStockRequestLoading =
                                                          false;
                                                      configController.update();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('OK')),
                                              ],
                                            );
                                          }));
                                    }
                                  });
                                },
                                child: configController.syncStockRequestLoading
                                    ? const SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: CircularProgressIndicator(
                                            color: Colors.white))
                                    : const Text('Execute')))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void syncSFAQueuing() {
    int count = 0;
    int temp = 0;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: SizedBox(
                width: 300,
                height: 265,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 280,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          'Sync SFA Queuing',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const Divider(),
                    SizedBox(
                      width: 300,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          'SALESMAN :',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 300,
                        child: GetBuilder<SalespersonController>(
                            builder: (context) =>
                                MultiSelectDialogField<Salesperson>(
                                  buttonText: Text('$count selected salesman',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2),
                                  chipDisplay: MultiSelectChipDisplay.none(),
                                  isDismissible: false,
                                  items: salespersonController.salesPersonList
                                      .map((salesperson) => MultiSelectItem(
                                          salesperson,
                                          '${salesperson.mdSalesmanCode} ${salesperson.mdName}'))
                                      .toList(),
                                  initialValue: salespersonController
                                      .selectedSalesmenSFAQueuing,
                                  searchable: true,
                                  title: const Text('Select Salesmen', style: TextStyle(fontSize: 18)),
                                  onConfirm: (value) {
                                    salespersonController
                                        .selectedSalesmenSFAQueuing = value;
                                    for (var index in Iterable<int>.generate(
                                        salespersonController
                                            .selectedSalesmenSFAQueuing
                                            .length)) {
                                      index = 1;
                                      temp += index;
                                      count = temp;
                                    }
                                    temp = 0;
                                    salespersonController.update();
                                  },
                                ))),
                    const Divider(),
                    Column(
                      children: [
                        const SizedBox(
                          width: 300,
                          child: Text(
                            'DATE :',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 40,
                          padding: const EdgeInsets.only(left: 5),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            onChanged: (value) {},
                            readOnly: true,
                            controller: syncSFAQueuingDateController,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 6),
                              suffixIcon: SizedBox(
                                width: 10,
                                height: 10,
                                child: IconButton(
                                  onPressed: () async {
                                    final DateTime? dateTime =
                                        await showDatePicker(
                                            context: context,
                                            initialDate: selectedDate,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime.now());
                                    if (dateTime != null) {
                                      setState(() {
                                        syncSFAQueuingDateController.text =
                                            formatDate(dateTime);
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.date_range_outlined),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: GetBuilder<ConfigController>(
                            builder:(controller) => Visibility(
                            visible: !configController.hidecancelbutton,
                            child: ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.white)),
                                onPressed: () {
                                  for (int index = 0;
                                      index <
                                          salespersonController
                                              .selectedSalesmenSFAQueuing.length;
                                      index++) {
                                    salespersonController
                                        .selectedSalesmenSFAQueuing
                                        .removeRange(
                                            index,
                                            salespersonController
                                                .selectedSalesmenSFAQueuing
                                                .length);
                                  }
                                  syncSFAQueuingDateController.clear();
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.black),
                                )),
                          ),
                          )
                        ),
                        GetBuilder<ConfigController>(
                            builder: (controller) => ElevatedButton(
                                onPressed: () async {
                                  if (configController.syncSFALoading) return;
                                  configController.hidecancelbutton = true;
                                  configController.syncSFALoading = true;
                                  configController.update();
                                  await Future.delayed(
                                          const Duration(seconds: 5))
                                      .whenComplete(() async {
                                    if (syncSFAQueuingDateController
                                            .text.isNotEmpty &&
                                        salespersonController
                                            .selectedSalesmenSFAQueuing
                                            .isNotEmpty) {
                                      await SSyncData.syncSFAQueuing(
                                              syncSFAQueuingDateController.text,
                                              salespersonController
                                                  .selectedSalesmenSFAQueuing)
                                          .then((value) {
                                        debugPrint('value SFA = $value');
                                        try {
                                          if (value == true) {
                                            configController.hidecancelbutton = false;
                                            for (int index = 0;
                                                index <
                                                    salespersonController
                                                        .selectedSalesmenSFAQueuing
                                                        .length;
                                                index++) {
                                              salespersonController
                                                  .selectedSalesmenSFAQueuing
                                                  .removeRange(
                                                      index,
                                                      salespersonController
                                                          .selectedSalesmenSFAQueuing
                                                          .length);
                                            }
                                            configController.syncSFALoading =
                                                false;
                                            configController.update();
                                            syncSFAQueuingDateController
                                                .clear();
                                            Navigator.pop(context);
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
                                                        const Text('Success!')

                                                      ],
                                                    ),
                                                    content: const Text(
                                                        'SFA Queuing was successfully updated. Thank You!'),
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
                                          } else {
                                            configController.hidecancelbutton = false;
                                            configController.syncSFALoading =
                                                false;
                                            configController.update();
                                            Navigator.pop(context);
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
                                                    content: const Text(
                                                        'Connection Error'),
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
                                        } catch (e) {
                                          configController.hidecancelbutton = false;
                                          configController.syncSFALoading =
                                              false;
                                          configController.update();
                                          Navigator.pop(context);
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
                                                  content: Text(e.toString()),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('OK')),
                                                  ],
                                                );
                                              }));
                                        }
                                      });
                                    } else {
                                      configController.hidecancelbutton = false;
                                      showDialog(
                                          context: this.context,
                                          builder: ((context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Date and Salesman Required'),
                                              content: const Text(
                                                  'Please Input Date/Salesman'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      configController
                                                              .syncSFALoading =
                                                          false;
                                                      configController.update();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('OK')),
                                              ],
                                            );
                                          }));
                                    }
                                  });
                                },
                                child: configController.syncSFALoading
                                    ? const SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: CircularProgressIndicator(
                                            color: Colors.white))
                                    : const Text('Execute')))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void dataReplication() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: SizedBox(
                width: 300,
                height: 185,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 280,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          'Data Replication',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),     
                    const Divider(),
                    const SizedBox(
                      width: 300,
                      height: 30,
                      child: Text(
                        'SALESMAN :',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: GetBuilder<SalespersonController>(
                          builder: (context) => 
                          DropdownButton2<Salesperson>(
                            items: salespersonController.salesPersonList.map((salesperson) {
                              return DropdownMenuItem(
                                value: salesperson,
                                child: Text('${salesperson.mdSalesmanCode} ${salesperson.mdName}')
                                );
                            }).toList(),
                            isExpanded: true,
                            value: salespersonController.selectedDataReplication,
                            onChanged: (value) {
                                  salespersonController.selectedDataReplication = value;
                                  salespersonController.update();
                              debugPrint('${salespersonController.selectedDataReplication?.mdName}');
                            },
                            dropdownSearchData: DropdownSearchData(
            searchController: textEditingController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Container(
              height: 50,
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
                right: 8,
                left: 8,
              ),
              child: TextFormField(
                expands: true,
                maxLines: null,
                controller: textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: 'Search Salesman...',
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: (salesperson, searchValue) {
              Salesperson value = salesperson.value as Salesperson;
              return value.mdName!.toLowerCase().contains(searchValue.toLowerCase());
            }),
            onMenuStateChange: (isOpen) {
            if (!isOpen) {
              textEditingController.clear();
            }
            }
                      ),
                    ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: GetBuilder<ConfigController>(
                              builder:(controller) => Visibility(
                              visible: !configController.hidecancelbutton,
                              child: ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.white)),
                                  onPressed: () {
                                    salespersonController.selectedDataReplication = null;
                                    salespersonController.update();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ),
                            )
                        ),
                        GetBuilder<ConfigController>(
                            builder: (controller) => ElevatedButton(
                                onPressed: () async {
                                  if (configController
                                      .syncDataReplicationLoading) return;
                                      configController.hidecancelbutton = true;
                                  configController.syncDataReplicationLoading =
                                      true;
                                  configController.update();
                                  await Future.delayed(
                                          const Duration(seconds: 5))
                                      .whenComplete(() async {
                                    if (salespersonController
                                            .selectedDataReplication !=
                                        null) {
                                      await SSyncData.dataReplication(
                                              salespersonController
                                                  .selectedDataReplication!)
                                          .then((value) {
                                        debugPrint(
                                            'value dataReplication = $value');
                                        try {
                                          if (value == true) {
                                            configController.hidecancelbutton = false;
                                            configController
                                                    .syncDataReplicationLoading =
                                                false;
                                            configController.update();
                                            Navigator.pop(context);
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
                                                        const Text('Success!')

                                                      ],
                                                    ),
                                                    content: const Text(
                                                        'Buddy Data Replication was Successful. Thank You!'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            salespersonController.selectedDataReplication = null;
                                    salespersonController.update();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('OK')),
                                                    ],
                                                  );
                                                }));
                                          } else {
                                            configController.hidecancelbutton = false;
                                            configController
                                                    .syncDataReplicationLoading =
                                                false;
                                            configController.update();
                                            Navigator.pop(context);
                                            showDialog(
                                                context: this.context,
                                                builder: ((context) {
                                                  return AlertDialog(
                                                    title:  Row(
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
                                                    content: const Text(
                                                        'Connection Error'),
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
                                        } catch (e) {
                                          configController.hidecancelbutton = false;
                                          configController
                                                  .syncDataReplicationLoading =
                                              false;
                                          configController.update();
                                          Navigator.pop(context);
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
                                                  content: Text(e.toString()),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('OK')),
                                                  ],
                                                );
                                              }));
                                        }
                                      });
                                    } else {
                                      configController.hidecancelbutton = false;
                                      showDialog(
                                          context: this.context,
                                          builder: ((context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Salesman Required'),
                                              content: const Text(
                                                  'Please Choose Salesman'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      configController
                                                              .syncDataReplicationLoading =
                                                          false;
                                                      configController.update();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('OK')),
                                              ],
                                            );
                                          }));
                                    }
                                  });
                                },
                                child:
                                    configController.syncDataReplicationLoading
                                        ? const SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: CircularProgressIndicator(
                                                color: Colors.white))
                                        : const Text('Execute')))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void syncInvoiceIDELIVER() {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: SizedBox(
                width: 300,
                height: 190,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 280,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          'Sync Invoice to iDeliver',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const Divider(),
                    Container(
                      width: 300,
                      margin: const EdgeInsets.only(top: 10),
                      child: const Text(
                        'INVOICE DATE :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 40,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        onChanged: (value) {},
                        readOnly: true,
                        controller: syncInvoiceDateController,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 6),
                          suffixIcon: SizedBox(
                            width: 10,
                            height: 10,
                            child: IconButton(
                              onPressed: () async {
                                final DateTime? dateTime = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now());
                                if (dateTime != null) {
                                  setState(() {
                                    syncInvoiceDateController.text =
                                        formatDate(dateTime);
                                  });
                                }
                              },
                              icon: const Icon(Icons.date_range_outlined),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: GetBuilder<ConfigController>(
                              builder:(controller) => Visibility(
                              visible: !configController.hidecancelbutton,
                              child: ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.white)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ),
                            )
                        ),
                        GetBuilder<ConfigController>(
                            builder: (controller) => ElevatedButton(
                                onPressed: () async {
                                  if (configController.syncIDeliverLoading) return;
                                  configController.hidecancelbutton = true;
                                  configController.syncIDeliverLoading = true;
                                  configController.update();
                                  await Future.delayed(
                                          const Duration(seconds: 5))
                                      .whenComplete(() async {
                                    if (syncInvoiceDateController
                                        .text.isNotEmpty) {
                                      await ASyncData.syncIDeliverInvoice(syncDetails!, syncInvoiceDateController.text, apiDetailsController.apiDetails)
                                          .then((value) {
                                        debugPrint('value Invoice = $value');
                                          if (value['Result'] == true) {
                                            configController.hidecancelbutton = false;
                                            configController
                                                .syncIDeliverLoading = false;
                                            configController.update();
                                            Navigator.pop(context);
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
                                                            syncInvoiceDateController.clear();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text('OK')),
                                                    ],
                                                  );
                                                }));
                                          } else {
                                            configController.hidecancelbutton = false;
                                            configController
                                                .syncIDeliverLoading = false;
                                            configController.update();
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
                                                        connectionController.hasInternet ? Text('${value['Status']}') : const Text('Error!'),
                                                      ],
                                                    ),
                                                    content: connectionController.hasInternet ? Text('${value['Msg']}') : const Text('No Internet Connection'), 
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
                                    } else {
                                      configController.hidecancelbutton = false;
                                      showDialog(
                                          context: this.context,
                                          builder: ((context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Date Required'),
                                              content: const Text(
                                                  'Please Input Date'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      configController
                                                              .syncIDeliverLoading =
                                                          false;
                                                      configController.update();
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('OK')),
                                              ],
                                            );
                                          }));
                                    }
                                  });
                                },
                                child: configController.syncIDeliverLoading
                                    ? const SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: CircularProgressIndicator(
                                            color: Colors.white))
                                    : const Text('Execute')))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void syncDeliveryTagging() {
    //double showDialogHeight = MediaQuery.of(context).size.height - 534.4;
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: SizedBox(
                width: 300,
                height: 180,
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                      width: 280,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          'Sync Delivery Tagging(IDELIVER)',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const Text(
                        'This could take time, please wait while we process your request.'),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: GetBuilder<ConfigController>(
                              builder:(controller) => Visibility(
                              visible: !configController.hidecancelbutton,
                              child: ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.white)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ),
                            )
                          ),
                          GetBuilder<ConfigController>(
                            builder:(controller) => ElevatedButton(
                              onPressed: () async {
                                if(configController.syncTaggingLoading) return;
                                configController.hidecancelbutton = true;
                                configController.syncTaggingLoading = true;
                                configController.update();
                                await Future.delayed(const Duration(seconds: 5)).whenComplete(() async {
                                  await ASyncData.syncDeliveryTagging(syncDetails!, apiDetailsController.apiDetails).then((value) {
                                    debugPrint('value = $value');
                                      if(value['Result'] == true){
                                        configController.hidecancelbutton = false;
                                      configController.syncTaggingLoading = false;
                                      configController.update();
                                      Navigator.pop(context);
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
                                      configController.hidecancelbutton = false;
                                      configController.syncTaggingLoading = false;
                                      configController.update();
                                      Navigator.pop(context);
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
                                                        connectionController.hasInternet ? Text('${value['Status']}') : const Text('Error!'),
                                                      ],
                                                    ),
                                                    content: connectionController.hasInternet ? Text('${value['Msg']}') : const Text('No Internet Connection'), 
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
                              },
                              child: configController.syncTaggingLoading
                                    ? const SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: CircularProgressIndicator(
                                            color: Colors.white))
                                    : const Text('Execute'))   
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

  void syncCustomer() {
    //double showDialogHeight = MediaQuery.of(context).size.height - 534.4;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: SizedBox(
                width: 300,
                height: 150,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 280,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          'Sync Customer',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const Text(
                        'This could take time, please wait while we process your request.'),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: GetBuilder<ConfigController>(
                              builder:(controller) => Visibility(
                              visible: !configController.hidecancelbutton,
                              child: ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.white)),
                                  onPressed: () {
                                    debugPrint('isSQLConnected = ${SqlConn.isConnected}');
                                    debugPrint('hasInternet = ${connectionController.hasInternet}');
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ),
                            )
                          ),
                          GetBuilder<ConfigController>(
                              builder: (controller) => ElevatedButton(
                                  onPressed: () async {
                                    if (configController.syncCustomerLoading) return;
                                    configController.syncCustomerLoading = true;
                                    configController.hidecancelbutton = true;
                                    configController.update();
                                    await Future.delayed(
                                            const Duration(seconds: 5))
                                        .whenComplete(() async {
                                      await SSyncData.syncCustomer()
                                          .then((value) async {
                                        debugPrint(
                                            'value syncCustomer = $value');
                                        try {
                                          if (value == true) {
                                            configController.hidecancelbutton = false;
                                            configController
                                                .syncCustomerLoading = false;
                                            configController.update();
                                            Navigator.pop(context);
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
                                                        const Text('Success!')

                                                      ],
                                                    ),
                                                    content: const Text(
                                                        'Buddy Customers Successfully updated. Thank You!'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            configController
                                                                    .syncCustomerLoading =
                                                                false;
                                                            configController
                                                                .update();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('OK')),
                                                    ],
                                                  );
                                                }));
                                          } else {
                                            configController.hidecancelbutton = false;
                                            configController
                                                .syncCustomerLoading = false;
                                            configController.update();
                                            Navigator.pop(context);
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
                                                    content: const Text(
                                                        'Connection Error'),
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
                                        } catch (e) {
                                          configController.hidecancelbutton = false;
                                          configController.syncCustomerLoading =
                                              false;
                                          configController.update();
                                          Navigator.pop(context);
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
                                                  content: Text(e.toString()),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
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
                                  },
                                  child: configController.syncCustomerLoading
                                      ? const SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: CircularProgressIndicator(
                                              color: Colors.white))
                                      : const Text('Execute')))
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

  void syncProduct() {
    //double showDialogHeight = MediaQuery.of(context).size.height - 534.4;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: SizedBox(
                width: 300,
                height: 150,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 280,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          'Sync Product',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const Text(
                        'This could take time, please wait while we process your request.'),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: GetBuilder<ConfigController>(
                              builder:(controller) => Visibility(
                              visible: !configController.hidecancelbutton,
                              child: ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.white)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ),
                            )
                          ),
                          GetBuilder<ConfigController>(
                              builder: (controller) => ElevatedButton(
                                  onPressed: () async {
                                    if (configController.syncProductLoading) return;
                                    configController.hidecancelbutton = true;
                                    configController.syncProductLoading = true;
                                    configController.update();
                                    await Future.delayed(
                                            const Duration(seconds: 5))
                                        .whenComplete(() async {
                                      await SSyncData.syncProduct()
                                          .then((value) {
                                        try {
                                          if (value == true) {
                                            configController.hidecancelbutton = false;
                                            configController
                                                .syncProductLoading = false;
                                            configController.update();
                                            Navigator.pop(context);
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
                                                        const Text('Success!')

                                                      ],
                                                    ),
                                                    content: const Text(
                                                        'Buddy Inventory Successfully updated. Thank You!'),
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
                                          } else {
                                            configController.hidecancelbutton = false;
                                            configController
                                                .syncProductLoading = false;
                                            configController.update();
                                            Navigator.pop(context);
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
                                                    content: const Text(
                                                        'Connection Error'),
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
                                        } catch (e) {
                                          configController.hidecancelbutton = false;
                                          configController.syncProductLoading =
                                              false;
                                          configController.update();
                                          Navigator.pop(context);
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
                                                  content: Text(e.toString()),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
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
                                  },
                                  child: configController.syncProductLoading
                                      ? const SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: CircularProgressIndicator(
                                              color: Colors.white))
                                      : const Text('Execute')))
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

  String formatDate(DateTime? date) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(date!);
  }
}
