// ignore_for_file: file_names

import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ErrorLogger{

static Future<String> get _localPath async {
  var directory = await getExternalStorageDirectory();
  directory ??= await getApplicationDocumentsDirectory();
  return directory.path;
}

static Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/Error.txt');
}

static Future<File> write(String data) async {
  final file = await _localFile;
  return file.writeAsString('$data\n', mode: FileMode.append);
}
}