// ignore_for_file: file_names

import 'package:sample/Database/DatabaseTables/tblSalesperson.dart';

class Salesperson{

  final int? mdCode;
  final String? mdSalesmanCode;
  final String? mdName;
  final String? group3;
  final String? type;
  final String? mdColor;

  Salesperson({
    this.mdCode,
    this.mdSalesmanCode,
    this.mdName,
    this.group3,
    this.type,
    this.mdColor
  });
  static Map<String, dynamic> getSalespersonMap(Salesperson salesperson){
    return{
      TblSalesperson.mdCode: salesperson.mdCode,
      TblSalesperson.mdSalesmanCode: salesperson.mdSalesmanCode,
      TblSalesperson.mdName: salesperson.mdName,
      TblSalesperson.group3: salesperson.group3,
      TblSalesperson.type: salesperson.type,
      TblSalesperson.mdColor: salesperson.mdColor
    };
  }
  static Salesperson getSalespersonFromJson(Map<String,dynamic> result){
    Salesperson salesperson = Salesperson(
      mdCode: result[TblSalesperson.mdCode],
      mdSalesmanCode: result[TblSalesperson.mdSalesmanCode],
      mdName: result[TblSalesperson.mdName],
      group3: result[TblSalesperson.group3],
      type: result[TblSalesperson.type],
      mdColor: result[TblSalesperson.mdColor]
    );
    return salesperson;
  }
}