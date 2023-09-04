// ignore_for_file: file_names

import 'dart:io';

import 'package:http/io_client.dart';

class Utility{
  static IOClient ioClient() {
    bool trustSelfSigned = true;
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = IOClient(httpClient);

    return ioClient;
  }
}