// ignore_for_file: file_names

import 'package:sample/Database/DatabaseTables/dbHelper.dart';
import 'package:sqflite/sqflite.dart';

class TblUserDetails{
  static const String tableUserDetails = 'tblUserDetails';
  static const String id = 'id';
  static const String aFullName = 'AFULLNAME';
  static const String aContactNumber = 'ACONTACTNO';
  static const String aEmail = 'AEMAIL';
  static const String account = 'ADESIGNATION';

    static Future<void> create(Database db) async {
    bool isExists = await MybuddyDatabase.isTableExist(db, tableUserDetails);
    if (!isExists) {
      await db.execute(_createtblCompany());
    }
  }
  static String _createtblCompany(){
    return '''
CREATE TABLE $tableUserDetails(
  $id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
  $aFullName NVARCHAR NULL,
  $aContactNumber NVARCHAR NULL,
  $aEmail NVARCHAR NULL,
  $account NVARCHAR NULL
)
''';
  }

}