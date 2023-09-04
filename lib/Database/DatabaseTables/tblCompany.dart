// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'dbHelper.dart';

class TblCompany{
  static const String tableCompany = 'tblCompany';
  static const String id = 'id';
  static const String distCD = 'DIST_CD';
  static const String serverIP = 'SERVER_IP';
  static const String dbName = 'DBNAME';
  static const String lastupdated = 'LAST_UPDATED';
  static const String logo = 'logo';
  static const String notation = 'Notation';
  static const String company = 'Company';
  static const String zipCode = 'ZIPCODE';
  static const String longitude = 'longitude';
  static const String latitude = 'latitude';
  static const String center = 'center';
  static const String officeaddress = 'officeaddress';
  static const String tin = 'tin';
  static const String email = 'email';
  static const String telephone = 'telephone';
  static const String fax = 'fax';
  //static const String mcpNotes = 'MCPNotes';
  //static const String soNotes = 'SONotes';
  static const String olapsvrname = 'OLAP_SVRNAME';
  static const String hostnameapi = 'hostname_api';

  static Future<void> create(Database db) async {
    bool isExists = await MybuddyDatabase.isTableExist(db, tableCompany);
    if (!isExists) {
      await db.execute(_createtblCompany());
    }
  }
  static String _createtblCompany(){
    return '''
CREATE TABLE $tableCompany(
  $id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
  $distCD NVARCHAR NULL,
  $serverIP NVARCHAR NULL,
  $dbName NVARCHAR NULL,
  $lastupdated DATETIME NULL,
  $logo NVARCHAR NULL,
  $notation NVARCHAR NULL,
  $company NVARCHAR NULL,
  $zipCode INTEGER NULL,
  $longitude DECIMAL NULL,
  $latitude DECIMAL NULL,
  $center INTEGER NULL,
  $officeaddress NVARCHAR NULL,
  $tin NVARCHAR NULL,
  $email NVARCHAR NULL,
  $telephone NVARCHAR NULL,
  $fax NVARCHAR NULL,
  $olapsvrname NVARCHAR NULL,
  $hostnameapi NVARCHAR NULL
)
''';
  }
}