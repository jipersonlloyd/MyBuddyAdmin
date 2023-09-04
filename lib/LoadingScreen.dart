// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sample/Controller/Constants/Routes.dart';
import 'package:sample/Controller/PriceController.dart';
import 'package:sample/Controller/ProductController.dart';
import 'package:sample/Controller/SalespersonController.dart';
import 'package:sample/Database/Local/LPrice.dart';
import 'package:sample/Database/Local/LProduct.dart';
import 'package:sample/Database/Local/LSalesperson.dart';
import 'package:sample/Model/PriceModel.dart';
import 'package:sample/Model/ProductModel.dart';
import 'package:sample/Model/Salesperson.dart';
import 'package:sample/Server/SPrice.dart';
import 'package:sample/Server/SProduct.dart';
import 'package:sample/Server/SSalesperson.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  List<Salesperson> salespersonList = [];
  List<Product> productList = [];
  List<Price> priceList = [];
  int totalLength = 0;
  double totalPercent = 0;
  double percent = 1;
  int index = 0;

  @override
  void initState() {
    super.initState();
    initialize();
  }
  initialize() {
    saveDatatoLocalDatabase();
  }


  void saveDatatoLocalDatabase() async {
    await savePrice().whenComplete(() => debugPrint('FuturesavePrice Complete'));
    saveProduct().whenComplete(() => debugPrint('FuturesaveProduct Complete'));
    await saveSalesperson().whenComplete(() => debugPrint('Futuresalesperson Complete'));
    totalData().whenComplete(() {
      debugPrint('totalLength = $totalLength');
      if(totalPercent >= 0.90){
                    Navigator.popAndPushNamed(context, Routes.firstpage);
                  }
    });
    
  }

  Future<void> savePrice() async {
    PriceController priceController = Get.put(PriceController());
    priceList = await SPrice.getPrice();
    if (priceList.isNotEmpty) {
      LPrice.deletePrice();
      for (Price price in priceList) {
        LPrice.savePrice(price);
      }
    } else {
      for (Price price in priceList) {
        LPrice.savePrice(price);
      }
    }
    priceController.priceList = priceList;
    priceController.update();
  }

  Future<void> saveSalesperson() async {
    SalespersonController salespersonController =
        Get.put(SalespersonController());
    salespersonList = await SSalesperson.getSalesperson();
    if (salespersonList.isNotEmpty) {
      LSalesperson.deleteSalesperson();
      for (Salesperson salesperson in salespersonList) {
        LSalesperson.saveSalesperson(salesperson);
      }
    } else {
      for (Salesperson salesperson in salespersonList) {
        LSalesperson.saveSalesperson(salesperson);
      }
    }
    salespersonController.salesPersonList = salespersonList;
    salespersonController.update();
  }

  Future<void> saveProduct() async {
    ProductController productController = Get.put(ProductController());
    productList = await SProduct.getProducts();
    if (productList.isNotEmpty) {
      LProduct.deleteProducts();
      for (Product product in productList) {
        LProduct.saveProduct(product);
      }
    } else {
      for (Product product in productList) {
        LProduct.saveProduct(product);
      }
    }
    productController.productList = productList;
    productController.update();
  }

  Future<void> totalData() async {
    await Future.delayed(const Duration(seconds: 1)).whenComplete(() async {
      totalLength = productList.length + salespersonList.length + priceList.length;
      if (totalPercent == 0.0 && index == 0) {
        for (index = 0; index < totalLength; index++) {
          await Future.delayed(const Duration(microseconds: 100)).whenComplete(() {
            setState(() {
            totalPercent = (index / totalLength);
            //debugPrint('total Percent = ${index / totalLength}');
            //debugPrint('totallength = $totalLength');
          });
          });
        }
      } else {
        totalPercent = 0.0;
        index = 0;
        for (index = 0; index < totalLength; index++) {
          await Future.delayed(const Duration(milliseconds: 100)).whenComplete(() {
            setState(() {
            totalPercent = (index / totalLength);
            //debugPrint('total Percent = ${index / totalLength}');
          });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 80,
              height: 80,
              child: Image.asset('assets/MyBuddyLogo.png')),
          Container(margin: const EdgeInsets.only(bottom: 5)),
          Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: LinearPercentIndicator(
                lineHeight: 25,
                percent: totalPercent,
                progressColor: Colors.blue,
                backgroundColor: Colors.blue.shade200,
                barRadius: const Radius.elliptical(10, 10),
                center: Text('${(totalPercent * 100).toStringAsFixed(0)}%'),
              ))
        ],
      ),
    );
  }
}
