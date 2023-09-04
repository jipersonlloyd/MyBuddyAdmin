// ignore_for_file: file_names

import '../Database/DatabaseTables/tblUser.dart';

class User {
  final int? mdID;
  final String? mdCode;
  final String? mdPassword;
  final String? mdLevel;
  final String? mdUserCreated;
  final String? mdSalesmancode;
  final String? mdName;
  final String? siteCode;
  final String? eodNumber1;
  final String? eodNumber2;
  final int? geolocking;
  final String? baseGpsLong;
  final String? baseGpsLat;
  final bool? isLogin;
  final String? thumbnail;
  final String? priceCode;
  final String? password1;
  final String? inventoryType;
  final String? customerLastDateReset;
  final int? maxSellingTime;
  final String? token;
  final int? printNameLimit;
  final int? printMarginLeft;
  final int? printLineType;
  final double? targetSales;
  final int? preRouteCL;
  final int? postRouteCL;
  final int? stockTakeCL;
  final int? eOD;
  final String? stklist;
  final String? defaultOrdType;
  final String? stkRequired;
  final bool? isDraftAllowed;
  final String? callTime;
  final double? loadingCap;
  final String? printerSN;
  final bool? isCancelNotAllowed;
  final String? lastUpdated;
  final bool? isNCRestricted;
  final String? phoneSN;
  final String? versionNumber;
  final String? lastActive;
  final String? contactNo;
  final bool? isdisableOTP;
  final String? region;
  final int? periodWeek;

  User({
    this.mdID,
    this.mdCode,
    this.mdPassword,
    this.mdLevel,
    this.mdUserCreated,
    this.mdSalesmancode,
    this.mdName,
    this.siteCode,
    this.eodNumber1,
    this.eodNumber2,
    this.geolocking,
    this.baseGpsLong,
    this.baseGpsLat,
    this.isLogin,
    this.thumbnail,
    this.priceCode,
    this.password1,
    this.inventoryType,
    this.customerLastDateReset,
    this.maxSellingTime,
    this.token,
    this.printNameLimit,
    this.printMarginLeft,
    this.printLineType,
    this.targetSales,
    this.preRouteCL,
    this.postRouteCL,
    this.stockTakeCL,
    this.eOD,
    this.stklist,
    this.defaultOrdType,
    this.stkRequired,
    this.isDraftAllowed,
    this.callTime,
    this.loadingCap,
    this.printerSN,
    this.isCancelNotAllowed,
    this.lastUpdated,
    this.isNCRestricted,
    this.phoneSN,
    this.versionNumber,
    this.lastActive,
    this.contactNo,
    this.isdisableOTP,
    this.region,
    this.periodWeek,
  });
  static Map<String,dynamic> getUserMap(User user){       //created this method in a JSON like Format which is the Map<String,dynamic>, used to transfer the data to local database  
    return{
      TblUser.mdID: user.mdID,
      TblUser.mdCode: user.mdCode,
      TblUser.mdPassword: user.mdPassword,
      TblUser.mdLevel: user.mdLevel,
      TblUser.mdUserCreated: user.mdUserCreated,
      TblUser.mdSalesmancode: user.mdSalesmancode,
      TblUser.mdName: user.mdName,
      TblUser.siteCode: user.siteCode,
      TblUser.eodNumber1: user.eodNumber1,
      TblUser.eodNumber2: user.eodNumber2,
      TblUser.geolocking: user.geolocking,
      TblUser.baseGpsLong: user.baseGpsLong,
      TblUser.baseGpsLat: user.baseGpsLat,
      TblUser.isLogin: user.isLogin,
      TblUser.thumbnail: user.thumbnail,
      TblUser.priceCode: user.priceCode,
      TblUser.password1: user.password1,
      TblUser.inventoryType: user.inventoryType,
      TblUser.customerLastDateReset: user.customerLastDateReset,
      TblUser.maxSellingTime: user.maxSellingTime,
      TblUser.token: user.token,
      TblUser.printNameLimit: user.printNameLimit,
      TblUser.printMarginLeft: user.printMarginLeft,
      TblUser.printLineType: user.printLineType,
      TblUser.targetSales: user.targetSales,
      TblUser.preRouteCL: user.preRouteCL,
      TblUser.postRouteCL: user.postRouteCL,
      TblUser.stockTakeCL: user.stockTakeCL,
      TblUser.eOD: user.eOD,
      TblUser.stklist: user.stklist,
      TblUser.defaultOrdType: user.defaultOrdType,
      TblUser.stkRequired: user.stkRequired,
      TblUser.isDraftAllowed: user.isDraftAllowed,
      TblUser.callTime: user.callTime,
      TblUser.loadingCap: user.loadingCap,
      TblUser.printerSN: user.printerSN,
      TblUser.isCancelNotAllowed: user.isCancelNotAllowed,
      TblUser.lastUpdated: user.lastUpdated,
      TblUser.isNCRestricted: user.isNCRestricted,
      TblUser.phoneSN: user.phoneSN,
      TblUser.versionNumber: user.versionNumber,
      TblUser.lastActive: user.lastActive,
      TblUser.contactNo: user.contactNo,
      TblUser.isdisableOTP: user.isdisableOTP,
      TblUser.region: user.region,
      TblUser.periodWeek: user.periodWeek
    };
  }
  static User getUserFromJson(Map<String,dynamic> result){   //retrieving the data either from local database or from server 

    User user = User(
      mdID: result[TblUser.mdID],
      mdCode: result[TblUser.mdCode],
      mdPassword: result[TblUser.mdPassword],
      mdLevel: result[TblUser.mdLevel],
      mdUserCreated: result[TblUser.mdUserCreated],
      mdSalesmancode: result[TblUser.mdSalesmancode],
      mdName: result[TblUser.mdName],
      siteCode: result[TblUser.siteCode],
      eodNumber1: result[TblUser.eodNumber1],
      eodNumber2: result[TblUser.eodNumber2],
      geolocking: result[TblUser.geolocking],
      baseGpsLong: result[TblUser.baseGpsLong],
      baseGpsLat: result[TblUser.baseGpsLat],
      isLogin: result[TblUser.isLogin],
      thumbnail: result[TblUser.thumbnail],
      priceCode: result[TblUser.priceCode],
      password1: result[TblUser.password1],
      inventoryType: result[TblUser.inventoryType],
      customerLastDateReset: result[TblUser.customerLastDateReset],
      maxSellingTime: result[TblUser.maxSellingTime],
      token: result[TblUser.token],
      printNameLimit: result[TblUser.printNameLimit],
      printMarginLeft: result[TblUser.printMarginLeft],
      printLineType: result[TblUser.printLineType],
      targetSales: result[TblUser.targetSales],
      preRouteCL: result[TblUser.preRouteCL],
      postRouteCL: result[TblUser.postRouteCL],
      stockTakeCL: result[TblUser.stockTakeCL],
      eOD: result[TblUser.eOD],
      stklist: result[TblUser.stklist],
      defaultOrdType: result[TblUser.defaultOrdType],
      stkRequired: result[TblUser.stkRequired],
      isDraftAllowed: result[TblUser.isDraftAllowed],
      callTime: result[TblUser.callTime],
      loadingCap: result[TblUser.loadingCap],
      printerSN: result[TblUser.printerSN],
      isCancelNotAllowed: result[TblUser.isCancelNotAllowed],
      lastUpdated: result[TblUser.lastUpdated],
      isNCRestricted: result[TblUser.isNCRestricted],
      phoneSN: result[TblUser.phoneSN],
      versionNumber: result[TblUser.versionNumber],
      lastActive: result[TblUser.lastActive],
      contactNo: result[TblUser.contactNo],
      isdisableOTP: result[TblUser.isdisableOTP],
      region: result[TblUser.region],
      periodWeek: result[TblUser.periodWeek],
    );
    return user;
  }
}
