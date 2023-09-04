// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/Controller/Constants/Constant.dart';
import 'package:sample/Controller/UserDetailsController.dart';
import 'package:sample/ErrorLogger.dart';
import 'package:sample/Model/APIDetailsModel.dart';
import 'package:sample/Model/SyncDetailsModel.dart';
import 'package:sample/Model/UserDetailsModel.dart';
import 'package:sample/Model/Utility.dart';

class ASyncData {

  static Future<Map<String, dynamic>> syncDeliveryTagging(
      SyncDetails syncDetails, APIDetails? apiDetails) async {
    String apiFolder = '${Constant.indexphp}mybuddy/mobile/sync/';
    Map<String, dynamic> result;
    String url =
        '${Constant.protocol}${apiDetails?.apiDomain}$apiFolder${Constant.deliveryTagging}?siteID=${syncDetails.siteID}&siteMain_enc_Db=${syncDetails.encDBName}&site_serverIP=${syncDetails.serverIP}&site_db=${syncDetails.dbase}&site_uname=${syncDetails.userName}&site_pword=${syncDetails.password}';
    debugPrint('apiURL = $url');
    try {
      var client = Utility.ioClient();
      var response = await client.post(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader:
            'Basic ${base64Encode(utf8.encode('${apiDetails?.apiUsername}:${apiDetails?.apiPassword}'))}',
        HttpHeaders.contentTypeHeader: 'application/json'
      }).whenComplete(() => client.close());
      Map<String, dynamic> jsonRes = await json.decode(response.body);
      String statusUpperCase = jsonRes['result'];
      if (response.statusCode == 200 && !response.body.contains('SQLSTATE')) {
        result = {
          Constant.RETURN: true,
          Constant.statusCode: response.statusCode,
          Constant.status: statusUpperCase.toUpperCase(),
          Constant.msg: jsonRes['Message'],
        };
      } else {
        result = {
          Constant.RETURN: false,
          Constant.statusCode: response.statusCode,
          Constant.status: statusUpperCase.toUpperCase(),
          Constant.msg: jsonRes['Message'],
        };
      }
    } catch (e) {
      debugPrint('exception');
      ErrorLogger.write(e.toString());
      result = {
        //Constant.status: '404 Not Found',
        Constant.RETURN: false,
        Constant.msg: e.toString()
      };
    }
    return result;
  }

  static Future<Map<String, dynamic>> syncSweeperTransaction(
      SyncDetails syncDetails, APIDetails? apiDetails) async {
    String apiFolder = '${Constant.indexphp}mybuddy/mobile/sync/';
    Map<String, dynamic> result;
    String url =
        '${Constant.protocol}${apiDetails?.apiDomain}$apiFolder${Constant.sweeperTransaction}?siteID=${syncDetails.siteID}&siteMain_enc_Db=${syncDetails.encDBName}&site_serverIP=${syncDetails.serverIP}&site_db=${syncDetails.dbase}&site_uname=${syncDetails.userName}&site_pword=${syncDetails.password}';
    try {
      var client = Utility.ioClient();
      var response = await client.post(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader:
            'Basic ${base64Encode(utf8.encode('${apiDetails?.apiUsername}:${apiDetails?.apiPassword}'))}',
        HttpHeaders.contentTypeHeader: 'application/json'
      }).whenComplete(() => client.close());
      Map<String, dynamic> jsonRes = await json.decode(response.body);
      String statusUpperCase = jsonRes['result'];
      if (response.statusCode == 200 && !response.body.contains('SQLSTATE')) {
        result = {
          Constant.RETURN: true,
          Constant.statusCode: response.statusCode,
          Constant.status: statusUpperCase.toUpperCase(),
          Constant.msg: jsonRes['Message'],
        };
      } else {
        result = {
          Constant.RETURN: false,
          Constant.statusCode: response.statusCode,
          Constant.status: statusUpperCase.toUpperCase(),
          Constant.msg: jsonRes['Message'],
        };
      }
    } catch (e) {
      ErrorLogger.write(e.toString());
      result = {
        //Constant.status: '404 Not Found',
        Constant.RETURN: false,
        Constant.msg: e.toString()
      };
    }
    return result;
  }

  static Future<Map<String, dynamic>> syncIDeliverInvoice(
      SyncDetails syncDetails, String date, APIDetails? apiDetails) async {
    String apiFolder = '${Constant.indexphp}mybuddy/mobile/sync/';
    Map<String, dynamic> result;
    String url =
        '${Constant.protocol}${apiDetails?.apiDomain}$apiFolder${Constant.iDeliverInvoice}?siteID=${syncDetails.siteID}&siteMain_enc_Db=${syncDetails.encDBName}&site_serverIP=${syncDetails.serverIP}&site_db=${syncDetails.dbase}&site_uname=${syncDetails.userName}&site_pword=${syncDetails.password}&invoiceDate=$date';
    try {
      var client = Utility.ioClient();
      var response = await client.post(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader:
            'Basic ${base64Encode(utf8.encode('${apiDetails?.apiUsername}:${apiDetails?.apiPassword}'))}',
        HttpHeaders.contentTypeHeader: 'application/json'
      }).whenComplete(() => client.close());
      Map<String, dynamic> jsonRes = await json.decode(response.body);
      String statusUpperCase = jsonRes['result'];
      if (response.statusCode == 200 && !response.body.contains('SQLSTATE')) {
        result = {
          Constant.RETURN: true,
          Constant.statusCode: response.statusCode,
          Constant.status: statusUpperCase.toUpperCase(),
          Constant.msg: jsonRes['Message'],
        };
      } else {
        result = {
          Constant.RETURN: false,
          Constant.statusCode: response.statusCode,
          Constant.status: statusUpperCase.toUpperCase(),
          Constant.msg: jsonRes['Message'],
        };
      }
    } catch (e) {
      ErrorLogger.write(e.toString());
      result = {
        //Constant.status: '404 Not Found',
        Constant.RETURN: false,
        Constant.msg: e.toString()
      };
    }
    return result;
  }

  static Future<Map<String, dynamic>> realignMCPSchedule(
      SyncDetails syncDetails, APIDetails? apiDetails) async {
    String apiFolder = '${Constant.indexphp}mybuddy/mobile/sync/';
    Map<String, dynamic> result;
    String url =
        '${Constant.protocol}${apiDetails?.apiDomain}$apiFolder${Constant.mcpRealignment}?siteID=${syncDetails.siteID}&siteMain_enc_Db=${syncDetails.encDBName}&site_serverIP=${syncDetails.serverIP}&site_db=${syncDetails.dbase}&site_uname=${syncDetails.userName}&site_pword=${syncDetails.password}';
    try {
      var client = Utility.ioClient();
      var response = await client.post(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader:
            'Basic ${base64Encode(utf8.encode('${apiDetails?.apiUsername}:${apiDetails?.apiPassword}'))}',
        HttpHeaders.contentTypeHeader: 'application/json'
      }).whenComplete(() => client.close());
      Map<String, dynamic> jsonRes = await json.decode(response.body);
      String statusUpperCase = jsonRes['result'];
      if (response.statusCode == 200 && !response.body.contains('SQLSTATE')) {
        result = {
          Constant.RETURN: true,
          Constant.statusCode: response.statusCode,
          Constant.status: statusUpperCase.toUpperCase(),
          Constant.msg: jsonRes['Message'],
        };
      } else {
        result = {
          Constant.RETURN: false,
          Constant.statusCode: response.statusCode,
          Constant.status: statusUpperCase.toUpperCase(),
          Constant.msg: jsonRes['Message'],
        };
      }
    } catch (e) {
      ErrorLogger.write(e.toString());
      result = {
        //Constant.status: '404 Not Found',
        Constant.RETURN: false,
        Constant.msg: e.toString()
      };
    }
    return result;
  }

  static Future<Map<String, dynamic>> loginandOTP(
      String phonenumber, String otp) async {
    UserDetailsController userDetailsController =
        Get.put(UserDetailsController());
    UserDetails? userDetails;
    String loginDomain =
        '${Constant.protocol}fastdevs-api.com/BUDDYGBLAPI/mybuddyapi/${Constant.indexphp}mybuddy/mobile/login';
    Map<String, dynamic> result;
    String url =
        '$loginDomain?phoneNumber=$phonenumber&OTP=$otp&actionType=mobile';
    try {
      var client = Utility.ioClient();
      var response = await client.post(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader:
            'Basic ${base64Encode(utf8.encode('fdcdev:1245678'))}',
        HttpHeaders.contentTypeHeader: 'application/json'
      }).whenComplete(() => client.close());
      if (response.statusCode == 200 &&
          !response.body.contains('does not exist') &&
          !response.body.contains('super admin users')) {
        Map<String, dynamic> jsonRes = await json.decode(response.body);
        String statusUpperCase = jsonRes['Result'];
        List<dynamic> userDetailsjson = jsonRes['USER_DETAILS'];
        for (dynamic res in userDetailsjson) {
          userDetails =
              UserDetails.getUserDetailsFromJson(res as Map<String, dynamic>);
        }
        userDetailsController.userDetails = userDetails;
        userDetailsController.update();
        result = {
          Constant.RETURN: true,
          Constant.statusCode: response.statusCode,
          Constant.status: statusUpperCase,
          Constant.msg: jsonRes['Result'],
        };
      } else {
        debugPrint('loginOTP is false');
        Map<String, dynamic> jsonRes = await json.decode(response.body);
        String statusUpperCase = jsonRes['Result'];
        result = {
          Constant.RETURN: false,
          Constant.statusCode: response.statusCode,
          Constant.status: statusUpperCase,
          Constant.msg: jsonRes['message'],
        };
        debugPrint('${jsonRes['message']}');
      }
    } catch (e) {
      debugPrint('loginOTP is exception');
      ErrorLogger.write(e.toString());
      result = {Constant.RETURN: false, Constant.msg: '$e'};
    }
    return result;
  }

  static Future<Map<String, dynamic>> testConnection(
      String apiDomain, String apiUsername, String apiPassword) async {
    Map<String, dynamic> result;
    String url = '$apiDomain${Constant.indexphp}/dynamic/check/connection';
    try {
      var client = Utility.ioClient();
      var response = await client.post(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader:
            'Basic ${base64Encode(utf8.encode('$apiUsername:$apiPassword'))}',
        HttpHeaders.contentTypeHeader: 'application/json'
      }).whenComplete(() => client.close());
      Map<String, dynamic> jsonRes = await json.decode(response.body);
      String statusUpperCase = jsonRes['result'];
      if (response.statusCode == 200 && !response.body.contains('SQLSTATE')) {
        result = {
          Constant.RETURN: true,
          Constant.statusCode: response.statusCode,
          Constant.status: statusUpperCase.toUpperCase(),
          Constant.msg: jsonRes['Message'],
        };
      } else {
        result = {
          Constant.RETURN: false,
          Constant.statusCode: response.statusCode,
          Constant.status: statusUpperCase.toUpperCase(),
          Constant.msg: jsonRes['Message'],
        };
      }
    } catch (e) {
      debugPrint('exception');
      ErrorLogger.write(e.toString());
      result = {
        //Constant.status: '403 Forbidden',
        Constant.RETURN: false,
        Constant.msg: e.toString()
      };
    }
    return result;
  }
}
