// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sample/Controller/CompanyController.dart';
import 'package:sample/Controller/ConfigController.dart';
import 'package:sample/Controller/ConnectionController.dart';
import 'package:sample/Database/Local/LUserDetails.dart';
import 'package:sample/View/PanelList/Dashboard.dart';
import 'package:sample/Controller/Constants/Routes.dart';
import 'package:sample/View/Maintenance/Bank.dart';
import 'package:sample/View/Maintenance/CMF.dart';
import 'package:sample/View/Maintenance/Customer.dart';
import 'package:sample/View/Maintenance/Data.dart';
import 'package:sample/View/Maintenance/Georeset.dart';
import 'package:sample/View/Maintenance/Product.dart';
import 'package:sample/View/Maintenance/Salesman.dart';
import 'package:sample/View/Maintenance/Tagging.dart';
import 'package:sample/View/PanelList/AlertMessages.dart';
import 'package:sample/View/PanelList/CustomerMapping.dart';
import 'package:sample/View/PanelList/DigitalMapping.dart';
import 'package:sample/View/PanelList/TerritoryGeofencing.dart';
import 'package:sample/View/Reports/BO.dart';
import 'package:sample/View/Reports/DSR.dart';
import 'package:sample/View/Reports/DailyCollection.dart';
import 'package:sample/View/Reports/InventoryValuation.dart';
import 'package:sample/View/Reports/Jobber.dart';
import 'package:sample/View/Reports/SalesAudit.dart';
import 'package:sample/View/Reports/SalesReport.dart';
import 'package:sample/View/Reports/StockRequest.dart';
import 'package:sample/View/Reports/Stocktake.dart';
import 'package:sample/View/Reports/SyncReport.dart';
import 'package:sample/View/Reports/TransactionLedger.dart';
import 'package:sample/View/Reports/UnprocessedOrders.dart';
import 'package:sample/View/Reports/Unuploaded.dart';
import 'package:sql_conn/sql_conn.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  var currentPage = Routes.data;
  late CompanyController companyController;
  late ConfigController configController;
  late ConnectionController connectionController;
  String appbarname = '';
  bool isSqlConnect = false;
  Color serverColorConn = Colors.orange;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    companyController = Get.put(CompanyController());
    configController = Get.put(ConfigController());
    connectionController = Get.put(ConnectionController());
    await isConnected();
    isSqlConnectIcon();
  }

    Future<void> handleRefresh() async {
    await Future.delayed(const Duration(seconds: 3)).whenComplete(
        () => Navigator.popAndPushNamed(context, Routes.setupConfiguration));
  }

    Future<bool> isSqlConnected() async {

      if (isSqlConnect == true && connectionController.hasInternet == true) {
      return true;
    } else if (isSqlConnect == false && connectionController.hasInternet == true) {

      await SqlConn.connect(
          ip: configController.config!.ip!,
          port: configController.config!.port!,
          databaseName: configController.config!.database!,
          username: configController.config!.username!,
          password: configController.config!.password!,
          timeout: 60);
      if (SqlConn.isConnected == true) {
        return true;
      } else {
        return false;
      }
    } 
    else {
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

  // Future<void> sqlConn() async {
  //   await Future.delayed(const Duration(seconds: 1))
  //       .whenComplete(() => isConnected()).whenComplete(() => debugPrint('accountSQLConnected = ${SqlConn.isConnected}'));
  // }
  
  void isSqlConnectIcon(){
    if(isSqlConnect == true && connectionController.hasInternet == true){
       setState(() {
         serverColorConn = Colors.green;
       });
    }
    else if(isSqlConnect == false && connectionController.hasInternet == true){
      setState(() {
         serverColorConn = Colors.orange;
       });
    }
    else if(isSqlConnect == true && connectionController.hasInternet == false){
      setState(() {
        serverColorConn = Colors.red;
      });
    }
    else{
      setState(() {
         serverColorConn = Colors.red;
       });
    }
  }
  


  @override
  Widget build(BuildContext context) {
    dynamic container;
    switch (currentPage) {
      case Routes.dashboard:
        container = const Dashboard();
        appbarname = 'Dashboard';
        break;
      case Routes.digitalmapping:
        container = const DigitalMapping();
        appbarname = 'Digital Mapping';
        break;
      case Routes.customermapping:
        container = const CustomerMapping();
        appbarname = 'Customer Mapping';
        break;
      case Routes.territorygeofencing:
        container = const TerritoryGeofencing();
        appbarname = 'Territory Geofencing';
        break;
      case Routes.alertmessages:
        container = const AlertMessages();
        appbarname = 'Alert Messages';
        break;
      case Routes.salesreport:
        container = const SalesReport();
        appbarname = 'Sales Report';
        break;
      case Routes.salesaudit:
        container = const SalesAudit();
        appbarname = 'Sales Audit';
        break;
      case Routes.transactionledger:
        container = const TransactionLedger();
        appbarname = 'Transaction Ledger';
        break;
      case Routes.unprocessedorders:
        container = const UnprocessedOrders();
        appbarname = 'Unprocessed Orders';
        break;
      case Routes.dsr:
        container = const DSR();
        appbarname = 'DSR';
        break;
      case Routes.dailycollection:
        container = const DailyCollection();
        appbarname = 'Daily Collection';
        break;
      case Routes.stockrequest:
        container = const StockRequest();
        appbarname = 'Stock Request';
        break;
      case Routes.unuploaded:
        container = const UnUploaded();
        appbarname = 'Unuploaded';
        break;
      case Routes.bo:
        container = const BO();
        appbarname = 'BO';
        break;
      case Routes.inventoryvaluation:
        container = const InventoryValuation();
        appbarname = 'Inventory Valuation';
        break;
      case Routes.stocktake:
        container = const StockTake();
        appbarname = 'Stock Take';
        break;
      case Routes.jobber:
        container = const Jobber();
        appbarname = 'Jobber';
        break;
      case Routes.syncreport:
        container = const SyncReport();
        appbarname = 'Sync Report';
        break;
      case Routes.data:
        container = const Data();
        appbarname = 'Data Maintenance';
        break;
      case Routes.customer:
        container = const Customer();
        appbarname = 'Customer';
        break;
      case Routes.cmf:
        container = const CMF();
        appbarname = 'CMF';
        break;
      case Routes.georeset:
        container = const Georeset();
        appbarname = 'Georeset';
        break;
      case Routes.salesman:
        container = const Salesman();
        appbarname = 'Salesman';
        break;
      case Routes.product:
        container = const Product();
        appbarname = 'Product';
        break;
      case Routes.tagging:
        container = const Tagging();
        appbarname = 'Tagging';
        break;
      case Routes.bank:
        container = const Bank();
        appbarname = 'Bank';
        break;
    }
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
        body: container,
        appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(appbarname),
            Row(
              children: [
                Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 10,
                                  color: serverColorConn
                                ))),
                const Padding(padding: EdgeInsets.only(left: 5, right: 5)),
                GetBuilder<ConnectionController>(
                  builder: (controller) => Icon(connectionController.hasInternet
                    ? Icons.wifi
                    : Icons.wifi_off)
                )
                    
              ],
            )
          ],
        ),
      ),
        drawer: Drawer(
          width: 230,
          backgroundColor: Colors.blue,
          child: ListView(
            children: [
              Container(
                color: Colors.blue,
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/MyBuddyLogo.png',
                        width: 60,
                        height: 50,
                      ),
                      const Text(
                        'My Buddy Sync',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              drawerList(),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                iconColor: Colors.white,
                textColor: Colors.white,
                onTap: () {
                  Navigator.pushNamed(context, Routes.notificaions);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Account'),
                iconColor: Colors.white,
                textColor: Colors.white,
                onTap: () {
                  Navigator.popAndPushNamed(context, Routes.account);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                iconColor: Colors.white,
                textColor: Colors.white,
                onTap: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Logout'),
                            onPressed: () async {
                              await LUserDetails.deleteLocalUserDetails().whenComplete(() {
                                Navigator.pushNamedAndRemoveUntil(
                                  context, Routes.login, (route) => false);
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerList() {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(1, 'Dashboard', Icons.home,
              currentPage == Routes.dashboard ? true : false),
          menuItem(2, 'Digital Mapping', Icons.location_on,
              currentPage == Routes.digitalmapping ? true : false),
          menuItem(3, 'Customer Mapping', Icons.people,
              currentPage == Routes.customermapping ? true : false),
          menuItem(4, 'Territory Geofencing', Icons.settings,
              currentPage == Routes.territorygeofencing ? true : false),
          ExpansionTile(
            title: const Text(
              'Reports',
              style: TextStyle(color: Colors.white),
            ),
            leading: const Icon(
              Icons.file_copy,
              color: Colors.white,
            ),
            children: [
              reportsItem(
                  11, "Sales Report", currentPage == Routes.salesreport),
              reportsItem(12, "Sales Audit", currentPage == Routes.salesaudit),
              reportsItem(13, "Transaction Ledger",
                  currentPage == Routes.transactionledger),
              reportsItem(14, "Unprocessed Orders",
                  currentPage == Routes.unprocessedorders),
              reportsItem(15, "DSR", currentPage == Routes.dsr),
              reportsItem(16, "Daily Collection",
                  currentPage == Routes.dailycollection),
              reportsItem(
                  17, "Stock Request", currentPage == Routes.stockrequest),
              reportsItem(18, "Unuploaded", currentPage == Routes.unuploaded),
              reportsItem(19, "BO", currentPage == Routes.bo),
              reportsItem(20, "Inventory Valuation",
                  currentPage == Routes.inventoryvaluation),
              reportsItem(21, "Stocktake", currentPage == Routes.stocktake),
              reportsItem(22, "Jobber", currentPage == Routes.jobber),
              reportsItem(23, "Sync Report", currentPage == Routes.syncreport),
            ],
          ),
          ExpansionTile(
            title: const Text(
              'Maintenance',
              style: TextStyle(color: Colors.white),
            ),
            leading: const Icon(
              Icons.settings_cell,
              color: Colors.white,
            ),
            children: [
              maintenanceItem(31, "Data", currentPage == Routes.data),
              maintenanceItem(32, "Customer", currentPage == Routes.customer),
              maintenanceItem(33, "CMF", currentPage == Routes.cmf),
              maintenanceItem(34, "Georeset", currentPage == Routes.georeset),
              maintenanceItem(35, "Salesman", currentPage == Routes.salesman),
              maintenanceItem(36, "Product", currentPage == Routes.product),
              maintenanceItem(37, "Tagging", currentPage == Routes.tagging),
              maintenanceItem(38, "Bank", currentPage == Routes.bank),
            ],
          ),
          menuItem(5, "Alert Messages", Icons.message,
              currentPage == Routes.alertmessages ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[200] : Colors.blue,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = Routes.dashboard;
            } else if (id == 2) {
              currentPage = Routes.digitalmapping;
            } else if (id == 3) {
              currentPage = Routes.customermapping;
            } else if (id == 4) {
              currentPage = Routes.territorygeofencing;
            } else if (id == 5) {
              currentPage = Routes.alertmessages;
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 3),
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 33),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget maintenanceItem(int id, String title, bool selected) {
    return Material(
      color: selected ? Colors.grey[200] : Colors.blue,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 31) {
              currentPage = Routes.data;
            } else if (id == 32) {
              currentPage = Routes.customer;
            } else if (id == 33) {
              currentPage = Routes.cmf;
            } else if (id == 34) {
              currentPage = Routes.georeset;
            } else if (id == 35) {
              currentPage = Routes.salesman;
            } else if (id == 36) {
              currentPage = Routes.product;
            } else if (id == 37) {
              currentPage = Routes.tagging;
            } else if (id == 38) {
              currentPage = Routes.bank;
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 3),
              ),
              Container(
                padding: const EdgeInsets.only(left: 55),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget reportsItem(int id, String title, bool selected) {
    return Material(
      color: selected ? Colors.grey[200] : Colors.blue,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 11) {
              currentPage = Routes.salesreport;
            } else if (id == 12) {
              currentPage = Routes.salesaudit;
            } else if (id == 13) {
              currentPage = Routes.transactionledger;
            } else if (id == 14) {
              currentPage = Routes.unprocessedorders;
            } else if (id == 15) {
              currentPage = Routes.dsr;
            } else if (id == 16) {
              currentPage = Routes.dailycollection;
            } else if (id == 17) {
              currentPage = Routes.stockrequest;
            } else if (id == 18) {
              currentPage = Routes.unuploaded;
            } else if (id == 19) {
              currentPage = Routes.bo;
            } else if (id == 20) {
              currentPage = Routes.inventoryvaluation;
            } else if (id == 21) {
              currentPage = Routes.stocktake;
            } else if (id == 22) {
              currentPage = Routes.jobber;
            } else if (id == 23) {
              currentPage = Routes.syncreport;
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 3),
              ),
              Container(
                padding: const EdgeInsets.only(left: 55),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
