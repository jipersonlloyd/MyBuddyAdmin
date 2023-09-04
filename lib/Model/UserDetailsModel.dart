// ignore_for_file: file_names

import 'package:sample/Database/DatabaseTables/tblUserDetails.dart';

class UserDetails{

  String? fullName;
  String? contactNumber;
  String? email;
  String? account;

  UserDetails({
    this.fullName,
    this.contactNumber,
    this.email,
    this.account,
  });

  static Map<String,dynamic> getUserDetailsMap(UserDetails userDetails){
    return {
      TblUserDetails.aFullName: userDetails.fullName,
      TblUserDetails.aContactNumber: userDetails.contactNumber,
      TblUserDetails.aEmail: userDetails.email,
      TblUserDetails.account: userDetails.account,
    };
  }

  static UserDetails getUserDetailsFromJson(Map<String,dynamic> result){
    UserDetails userDetails = UserDetails(
      fullName: result[TblUserDetails.aFullName],
      contactNumber: result[TblUserDetails.aContactNumber],
      email: result[TblUserDetails.aEmail],
      account: result[TblUserDetails.account],
    );
    return userDetails;
  }
}