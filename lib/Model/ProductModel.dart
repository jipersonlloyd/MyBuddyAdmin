// ignore_for_file: file_names

import '../Database/DatabaseTables/tblProduct.dart';

class Product {
  final int? productID;
  final String? supplier;
  final String? stockCode;
  final String? description;
  final String? brand;
  final String? stockUom;
  final String? alternateUom;
  final double? convFactAltUom;
  final String? otherUom;
  final double? convFactOthUom;
  final double? priceWithVat;
  final double? priceWithVatM;
  final String? lastUpdated;
  final String? shortname;
  final int? templateCode;
  final String? templateName;
  final String? thumbnail;
  final int? mustHave;
  final int? buyingAccounts;
  final String? barcodePC;
  final String? barcodeCS;
  final String? updateID;
  final String? remarks;
  final String? onExpired;
  final bool? isPurchased;
  final int? qtyExpired;
  final int? minOrderQtySmall;
  final int? minOrderQtyBig;

  Product(
      {this.productID,
      this.supplier,
      this.stockCode,
      this.description,
      this.brand,
      this.stockUom,
      this.alternateUom,
      this.convFactAltUom,
      this.otherUom,
      this.convFactOthUom,
      this.priceWithVat,
      this.priceWithVatM,
      this.lastUpdated,
      this.shortname,
      this.templateCode,
      this.templateName,
      this.thumbnail,
      this.mustHave,
      this.buyingAccounts,
      this.barcodePC,
      this.barcodeCS,
      this.updateID,
      this.remarks,
      this.onExpired,
      this.isPurchased,
      this.qtyExpired,
      this.minOrderQtySmall,
      this.minOrderQtyBig});
  static Map<String,dynamic> getProductMap(Product product){
    return{
      TblProduct.productID: product.productID,
      TblProduct.supplier: product.supplier,
      TblProduct.stockCode: product.stockCode,
      TblProduct.description: product.description,
      TblProduct.brand: product.brand,
      TblProduct.stockUom: product.stockUom,
      TblProduct.alternateUom: product.alternateUom,
      TblProduct.convFactAltUom: product.convFactAltUom,
      TblProduct.otherUom: product.otherUom,
      TblProduct.convFactOthUom: product.convFactOthUom,
      TblProduct.priceWithVat: product.priceWithVat,
      TblProduct.priceWithVatM: product.priceWithVatM,
      TblProduct.lastUpdated: product.lastUpdated,
      TblProduct.shortname: product.shortname,
      TblProduct.templateCode: product.templateCode,
      TblProduct.templateName: product.templateName,
      TblProduct.thumbnail: product.thumbnail,
      TblProduct.mustHave: product.mustHave,
      TblProduct.buyingAccounts: product.buyingAccounts,
      TblProduct.barcodePC: product.barcodePC,
      TblProduct.barcodeCS: product.barcodeCS,
      TblProduct.updateID: product.updateID,
      TblProduct.remarks: product.remarks,
      TblProduct.onExpired: product.onExpired,
      TblProduct.isPurchased: product.isPurchased,
      TblProduct.qtyExpired: product.qtyExpired,
      TblProduct.minOrderQtySmall: product.minOrderQtySmall,
      TblProduct.minOrderQtyBig: product.minOrderQtyBig
    };
  }
  static Product getProductFromJson(Map<String,dynamic> result){
    Product product = Product(
      productID: result[TblProduct.productID],
      supplier: result[TblProduct.supplier],
      stockCode: '${result[TblProduct.stockCode]}',
      description: result[TblProduct.description],
      brand: result[TblProduct.brand],
      stockUom: result[TblProduct.stockUom],
      alternateUom: result[TblProduct.alternateUom],
      convFactAltUom: result[TblProduct.convFactAltUom],
      otherUom: result[TblProduct.otherUom],
      convFactOthUom: result[TblProduct.convFactOthUom],
      priceWithVat: result[TblProduct.priceWithVat],
      priceWithVatM: result[TblProduct.priceWithVatM],
      lastUpdated: result[TblProduct.lastUpdated],
      shortname: result[TblProduct.shortname],
      templateCode: result[TblProduct.templateCode],
      templateName: result[TblProduct.templateName],
      thumbnail: result[TblProduct.thumbnail],
      mustHave: result[TblProduct.mustHave],
      buyingAccounts: result[TblProduct.buyingAccounts],
      barcodePC: result[TblProduct.barcodePC],
      barcodeCS: result[TblProduct.barcodeCS],
      updateID: result[TblProduct.updateID],
      remarks: result[TblProduct.remarks],
      onExpired: result[TblProduct.onExpired],
      isPurchased: result[TblProduct.isPurchased],
      qtyExpired: result[TblProduct.qtyExpired],
      minOrderQtySmall: result[TblProduct.minOrderQtySmall],
      minOrderQtyBig: result[TblProduct.minOrderQtyBig],
    );
    return product;
  }
}
