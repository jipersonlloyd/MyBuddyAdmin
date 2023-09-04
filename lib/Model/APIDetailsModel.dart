// ignore_for_file: file_names

import 'package:sample/Database/DatabaseTables/tblAPIDetails.dart';

class APIDetails{
  final String? apiDomain;
  final String? apiUsername;
  final String? apiPassword;

  APIDetails({
    this.apiDomain,
    this.apiUsername,
    this.apiPassword
  });

  static Map<String,dynamic> getAPIDetailsMap(APIDetails apiDetails){
    return {
      TblAPIDetails.apiDomain: apiDetails.apiDomain,
      TblAPIDetails.apiUsername: apiDetails.apiUsername,
      TblAPIDetails.apiPassword: apiDetails.apiPassword
    };
  }

  static APIDetails getAPIDetailsFromJson (Map<String,dynamic> result){
    APIDetails apiDetails = APIDetails(
      apiDomain: result[TblAPIDetails.apiDomain],
      apiUsername: result[TblAPIDetails.apiUsername],
      apiPassword: result[TblAPIDetails.apiPassword],
    );
    return apiDetails;
  }
}