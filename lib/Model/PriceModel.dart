// ignore_for_file: file_names

import '../Database/DatabaseTables/tblPrice.dart';

class Price{

  final int? cID;
  final String? priceCode;
  final String? stockCode;
  final double? unitPrice;
  final String? lastUpdated;

  Price({
    this.cID,
    this.priceCode,
    this.stockCode,
    this.unitPrice,
    this.lastUpdated
  });

  static Map<String,dynamic> getPriceMap(Price price){
    return{
      TblPrice.cID: price.cID,
      TblPrice.priceCode: price.priceCode,
      TblPrice.stockCode: price.stockCode,
      TblPrice.unitPrice: price.unitPrice,
      TblPrice.lastUpdated: price.lastUpdated
    };
  }
  static Price getPricefromJson(Map<String,dynamic> result){
    Price price = Price(
      cID: result[TblPrice.cID],
      priceCode: '${result[TblPrice.priceCode]}',
      stockCode: '${result[TblPrice.stockCode]}',
      unitPrice: result[TblPrice.unitPrice],
      lastUpdated: result[TblPrice.lastUpdated],
    );
    return price;
  }
}