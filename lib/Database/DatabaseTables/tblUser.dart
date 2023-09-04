// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'dbHelper.dart';

class TblUser{
  static const String tableUser = 'tblUser';
  static const String mdID = '_id';
  static const String mdCode = 'mdCode';
  static const String mdPassword = 'mdPassword';
  static const String mdLevel = 'mdLevel';
  static const String mdUserCreated = 'mdUserCreated';
  static const String mdSalesmancode = 'mdSalesmancode';
  static const String mdName = 'mdName';
  static const String siteCode = 'siteCode';
  static const String eodNumber1 = 'eodNumber1';
  static const String eodNumber2 = 'eodNumber2';
  static const String geolocking = 'geolocking';
  static const String baseGpsLong = 'baseGpsLong';
  static const String baseGpsLat = 'baseGpsLat';
  static const String isLogin = 'isLogin';
  static const String thumbnail = 'thumbnail';
  static const String priceCode = 'priceCode';
  static const String password1 = 'password1';
  static const String inventoryType = 'inventoryType';
  static const String customerLastDateReset = 'customerLastDateReset';
  static const String maxSellingTime = 'maxSellingTime';
  static const String token = 'token';
  static const String printNameLimit = 'printNameLimit';
  static const String printMarginLeft = 'printMarginLeft';
  static const String printLineType = 'printLineType';
  static const String targetSales = 'targetSales';
  static const String preRouteCL = 'preRouteCL';
  static const String postRouteCL = 'postRouteCL';
  static const String stockTakeCL = 'stockTakeCL';
  static const String eOD = 'EOD';
  static const String stklist = 'stklist';
  static const String defaultOrdType = 'defaultOrdType';
  static const String stkRequired = 'stkRequired';
  static const String isDraftAllowed = 'isDraftAllowed';
  static const String callTime = 'callTime';
  static const String loadingCap = 'loadingCap';
  static const String printerSN = 'printerSN';
  static const String isCancelNotAllowed = 'isCancelNotAllowed';
  static const String lastUpdated = 'lastUpdated';
  static const String isNCRestricted = 'isNCRestricted';
  static const String phoneSN = 'phoneSN';
  static const String versionNumber = 'versionNumber';
  static const String lastActive = 'lastActive';
  static const String contactNo = 'contactNo';
  static const String isdisableOTP = 'isdisableOTP';
  static const String region = 'region';
  static const String periodWeek = 'periodWeek';

   static Future<void> create(Database db) async {
    bool isExists = await MybuddyDatabase.isTableExist(db, tableUser);

    if (!isExists) {
      await db.execute(_createtblUser());
    }
  }

  static String _createtblUser() {
   return '''
CREATE TABLE $tableUser(
  $mdID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  $mdCode VARCHAR NOT NULL,
  $mdPassword VARCHAR NOT NULL,
  $mdLevel VARCHAR NOT NULL,
  $mdUserCreated TEXT NOT NULL,
  $mdSalesmancode VARCHAR NOT NULL,
  $mdName TEXT NOT NULL,
  $siteCode TEXT NOT NULL,
  $eodNumber1 TEXT,
  $eodNumber2 TEXT,
  $geolocking REAL,
  $baseGpsLong TEXT,
  $baseGpsLat TEXT,
  $isLogin INT DEFAULT (0),
  $thumbnail TEXT,
  $priceCode TEXT,
  $password1 TEXT,
  $inventoryType TEXT DEFAULT syspro,
  $customerLastDateReset TEXT DEFAULT 'no',
  $maxSellingTime INTEGER DEFAULT (15),
  $token TEXT,
  $printNameLimit INT DEFAULT (25),
  $printMarginLeft INT DEFAULT(1),
  $printLineType INT DEFAULT (0),
  $targetSales DOUBLE DEFAULT (0.0),
  $preRouteCL INT DEFAULT (0),
  $postRouteCL INT DEFAULT (0),
  $stockTakeCL INT DEFAULT (0),
  $eOD INT DEFAULT (0),
  $stklist TEXT,
  $defaultOrdType TEXT,
  $stkRequired TEXT,
  $isDraftAllowed INT DEFAULT (0),
  $callTime STRING DEFAULT '8:10',
  $loadingCap DOUBLE DEFAULT (0),
  $printerSN TEXT,
  $isCancelNotAllowed INT DEFAULT (0),
  $lastUpdated TEXT,
  $isNCRestricted TEXT DEFAULT (0),
  $phoneSN TEXT,
  $versionNumber TEXT,
  $lastActive DATETIME,
  $contactNo TEXT,
  $isdisableOTP INTEGER DEFAULT (0),
  $region TEXT,
  $periodWeek INTEGER DEFAULT (1)
)
''';
  }
}