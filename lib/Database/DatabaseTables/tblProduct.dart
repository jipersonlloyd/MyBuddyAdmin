// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'dbHelper.dart';

class TblProduct{
  static const String tableProduct = 'tblProduct';
  static const String productID = 'productID';
  static const String supplier = 'Supplier';
  static const String stockCode = 'StockCode';
  static const String description = 'Description';
  static const String brand = 'Brand';
  static const String stockUom = 'StockUom';
  static const String alternateUom = 'AlternateUom';
  static const String convFactAltUom = 'ConvFactAltUom';
  static const String otherUom = 'OtherUom';
  static const String convFactOthUom = 'ConvFactOthUom';
  static const String priceWithVat = 'priceWithVat';
  static const String priceWithVatM = 'priceWithVatM';
  static const String lastUpdated = 'lastUpdated';
  static const String shortname = 'shortName';
  static const String templateCode = 'templateCode';
  static const String templateName = 'templateName';
  static const String thumbnail = 'thumbnail';
  static const String mustHave = 'mustHave';
  static const String buyingAccounts = 'buyingAccounts';
  static const String barcodePC = 'barcodePC';
  static const String barcodeCS = 'barcodeCS';
  static const String updateID = 'updateID';
  static const String remarks = 'remarks';
  static const String onExpired = 'onExpired';
  static const String isPurchased = 'isPurchased';
  static const String qtyExpired = 'qtyExpired';
  static const String minOrderQtySmall = 'minOrderQtySmall';
  static const String minOrderQtyBig = 'minOrderQtyBig';

  static Future<void> create(Database db) async {
    bool isExists = await MybuddyDatabase.isTableExist(db, tableProduct);

    if (!isExists) {
      await db.execute(_createtblProduct());
    }
  }

  static String _createtblProduct(){
    return '''
CREATE TABLE $tableProduct(
  $productID INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
  $supplier TEXT,
  $stockCode TEXT NOT NULL,
  $description TEXT NOT NULL,
  $brand TEXT NOT NULL,
  $stockUom TEXT NOT NULL,
  $alternateUom TEXT,
  $convFactAltUom TEXT,
  $otherUom TEXT,
  $convFactOthUom TEXT,
  $priceWithVat REAL NOT NULL,
  $priceWithVatM REAL,
  $lastUpdated TEXT,
  $shortname TEXT,
  $templateCode INTEGER,
  $thumbnail TEXT,
  $mustHave INTEGER,
  $templateName TEXT,
  $buyingAccounts INTEGER NULL,
  $barcodePC TEXT,
  $barcodeCS TEXT,
  $updateID TEXT,
  $remarks TEXT,
  $onExpired TEXT,
  $isPurchased INT DEFAULT (0),
  $qtyExpired INTEGER DEFAULT (0),
  $minOrderQtySmall INTEGER,
  $minOrderQtyBig INTEGER
)
''';
  }
}