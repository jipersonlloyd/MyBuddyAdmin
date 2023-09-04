import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/ChangeDNS.dart';
import 'package:sample/Controller/APIDetailsController.dart';
import 'package:sample/Controller/CompanyController.dart';
import 'package:sample/Controller/ConfigController.dart';
import 'package:sample/Controller/OTPController.dart';
import 'package:sample/Controller/SalespersonController.dart';
import 'package:sample/Controller/ConnectionController.dart';
import 'package:sample/Controller/UserDetailsController.dart';
import 'package:sample/LoadingScreen.dart';
import 'package:sample/SetConfiguration.dart';
import 'package:sample/SetDNS.dart';
import 'package:sample/View/Account.dart';
import 'package:sample/View/FirstPage.dart';
import 'package:sample/View/Login.dart';
import 'package:sample/View/LogoScreen.dart';
import 'package:sample/View/Maintenance/Bank.dart';
import 'package:sample/View/Maintenance/CMF.dart';
import 'package:sample/View/Maintenance/Customer.dart';
import 'package:sample/View/Maintenance/Data.dart';
import 'package:sample/View/Maintenance/Georeset.dart';
import 'package:sample/View/Maintenance/Product.dart';
import 'package:sample/View/Maintenance/Salesman.dart';
import 'package:sample/View/Maintenance/Tagging.dart';
import 'package:sample/View/Notifications.dart';
import 'package:sample/View/PanelList/AlertMessages.dart';
import 'package:sample/View/PanelList/CustomerMapping.dart';
import 'package:sample/View/PanelList/DigitalMapping.dart';
import 'package:sample/View/PanelList/TerritoryGeofencing.dart';
import 'package:sample/View/PanelList/Dashboard.dart';
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
import 'package:sample/Controller/Constants/Routes.dart';
import 'package:sample/View/SetupDatabase.dart';
import 'package:sample/View/Verification.dart';
import 'package:sample/password1DNS.dart';
import 'package:sample/passwordDNS.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  initState() {
    super.initState();
    initialize();
  }

  initialize() {
      Get.put(ConnectionController());
      Get.put(ConfigController());
      Get.put(CompanyController());
      Get.put(SalespersonController());
      Get.put(OTPController());
      Get.put(UserDetailsController());
      Get.put(APIDetailsController());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.logoscreen,
        routes: {
          Routes.logoscreen: (context) => const LogoScreen(),
          Routes.login: (context) => const Login(),
          Routes.dashboard: (context) => const Dashboard(),
          Routes.data: (context) => const Data(),
          Routes.firstpage: (context) => const FirstPage(),
          Routes.bank: (context) => const Bank(),
          Routes.cmf: (context) => const CMF(),
          Routes.customer: (context) => const Customer(),
          Routes.georeset: (context) => const Georeset(),
          Routes.product: (context) => const Product(),
          Routes.salesman: (context) => const Salesman(),
          Routes.tagging: (context) => const Tagging(),
          Routes.alertmessages: (context) => const AlertMessages(),
          Routes.customermapping: (context) => const CustomerMapping(),
          Routes.digitalmapping: (context) => const DigitalMapping(),
          Routes.territorygeofencing: (context) => const TerritoryGeofencing(),
          Routes.bo: (context) => const BO(),
          Routes.dsr: (context) => const DSR(),
          Routes.setupConfiguration: (context) => const SetupConfiguration(),
          Routes.dailycollection: (context) => const DailyCollection(),
          Routes.inventoryvaluation: (context) => const InventoryValuation(),
          Routes.jobber: (context) => const Jobber(),
          Routes.salesaudit: (context) => const SalesAudit(),
          Routes.stockrequest: (context) => const StockRequest(),
          Routes.stocktake: (context) => const StockTake(),
          Routes.syncreport: (context) => const SyncReport(),
          Routes.transactionledger: (context) => const TransactionLedger(),
          Routes.unprocessedorders: (context) => const UnprocessedOrders(),
          Routes.unuploaded: (context) => const UnUploaded(),
          Routes.salesreport: (context) => const SalesReport(),
          Routes.account: (context) => const Account(),
          Routes.notificaions: (context) => const Notifications(),
          Routes.setupdatabase: (context) => const SetupDatabase(),
          Routes.verificationotp: (context) => const VerificationOTP(),
          Routes.loadingscreen:(context) => const LoadingScreen(),
          Routes.setdns:(context) => const SetDNS(),
          Routes.changedns:(context) => const ChangeDNS(),
          Routes.passworddns:(context) => const PasswordDNS(),
          Routes.password1dns:(context) => const Password1DNS()
        });
  }
}
