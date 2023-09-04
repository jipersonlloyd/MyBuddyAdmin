// ignore_for_file: file_names

import 'package:sample/Database/DatabaseTables/tblcompany.dart';

class Company{
  final String? id;
  final String? distCD;
  final String? serverIP;
  final String? dbName;
  final String? lastupdated;
  final String? logo;
  final String? notation;
  final String? company;
  final int? zipCode;
  final double? longitude;
  final double? latitude;
  final int? center;
  final String? officeaddress;
  final String? tin;
  final String? email;
  final String? telephone;
  final String? fax;
  //final String? mcpNotes;
  //final String? soNotes;
  final String? olapsvrname;
  final String? hostnameapi;

  Company({
    this.id,
    this.distCD,
    this.serverIP,
    this.dbName,
    this.lastupdated,
    this.logo,
    this.notation,
    this.company,
    this.zipCode,
    this.longitude,
    this.latitude,
    this.center,
    this.officeaddress,
    this.tin,
    this.email,
    this.telephone,
    this.fax,
    //this.mcpNotes,
    //this.soNotes,
    this.olapsvrname,
    this.hostnameapi
  });
  static Map<String, dynamic> getCompanyMap(Company company) {
    return {
      TblCompany.distCD: company.distCD,
      TblCompany.serverIP: company.serverIP,
      TblCompany.dbName: company.serverIP,
      TblCompany.lastupdated: company.lastupdated,
      TblCompany.logo: company.logo,
      TblCompany.notation: company.notation,
      TblCompany.company: company.company,
      TblCompany.zipCode: company.zipCode,
      TblCompany.longitude: company.longitude,
      TblCompany.latitude: company.latitude,
      TblCompany.center: company.center,
      TblCompany.officeaddress: company.officeaddress,
      TblCompany.tin: company.tin,
      TblCompany.email: company.email,
      TblCompany.telephone: company.telephone,
      TblCompany.fax: company.fax,
      //TblCompany.mcpNotes: company.mcpNotes,
      //TblCompany.soNotes: company.soNotes,
      TblCompany.olapsvrname: company.olapsvrname,
      TblCompany.hostnameapi: company.hostnameapi
    };
  }

  static Company getCompanyFromJson(Map<String,dynamic> result) {
      Company company = Company(
        distCD: result[TblCompany.distCD],
        serverIP: result[TblCompany.serverIP],
        dbName: result[TblCompany.dbName],
        lastupdated: result[TblCompany.lastupdated],
        logo: result[TblCompany.logo],
        notation: result[TblCompany.notation],
        company: result[TblCompany.company],
        zipCode: result[TblCompany.zipCode],
        longitude: result[TblCompany.longitude],
        latitude: result[TblCompany.latitude],
        center: result[TblCompany.center],
        officeaddress: result[TblCompany.officeaddress],
        tin: result[TblCompany.tin],
        email: result[TblCompany.email],
        telephone: result[TblCompany.telephone],
        fax: result[TblCompany.fax],
        olapsvrname: result[TblCompany.olapsvrname],
        hostnameapi: result[TblCompany.hostnameapi],
      );
    return company;
  }
}