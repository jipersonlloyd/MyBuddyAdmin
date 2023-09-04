// ignore_for_file: file_names

import 'package:sample/View/Maintenance/Product.dart';
import '../Database/DatabaseTables/tblStockRequest.dart';

class StockRequest extends Product { //explanation in UserModel
  final int? cID;
  final String? transDate;
  final String? mdCode;
  final String? refNo;
  final String? stockCode;
  final int? quantity;
  final int? approveStat;
  final int? exportStat;
  final String? source;
  final String? remarks;
  final String? transactionID;

  const StockRequest(
      {super.key, this.cID,
      this.transDate,
      this.mdCode,
      this.refNo,
      this.stockCode,
      this.quantity,
      this.approveStat,
      this.exportStat,
      this.source,
      this.remarks,
      this.transactionID});
  static Map<String, dynamic> getStockRequestMap(StockRequest stockRequest) {
    return {
      TblStockRequest.cID: stockRequest.cID,
      TblStockRequest.transDate: stockRequest.transDate,
      TblStockRequest.mdCode: stockRequest.mdCode,
      TblStockRequest.refNo: stockRequest.refNo,
      TblStockRequest.stockCode: stockRequest.stockCode,
      TblStockRequest.quantity: stockRequest.quantity,
      TblStockRequest.approveStat: stockRequest.approveStat,
      TblStockRequest.exportStat: stockRequest.exportStat,
      TblStockRequest.source: stockRequest.source,
      TblStockRequest.remarks: stockRequest.remarks,
      TblStockRequest.transactionID: stockRequest.transactionID
    };
  }
  static StockRequest getStockRequestFromJson(Map<String,dynamic> result){
    StockRequest stockRequest = StockRequest(
      cID: result[TblStockRequest.cID],
      transDate: result[TblStockRequest.transDate],
      mdCode: result[TblStockRequest.mdCode],
      refNo: result[TblStockRequest.refNo],
      stockCode: result[TblStockRequest.stockCode],
      quantity: result[TblStockRequest.quantity],
      approveStat: result[TblStockRequest.approveStat],
      exportStat: result[TblStockRequest.exportStat],
      source: result[TblStockRequest.source],
      remarks: result[TblStockRequest.remarks],
      transactionID: result[TblStockRequest.transactionID],
    );
    return stockRequest;
  }
}
