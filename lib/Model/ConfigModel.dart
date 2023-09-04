// ignore_for_file: file_names

import '../Database/DatabaseTables/tblConfig.dart';

class Config {
  final String? ip;
  final String? port;
  final String? database;
  final String? username;
  final String? password;

  Config({
    this.ip,
    this.port,
    this.database,
    this.username,
    this.password,

  });

  static Map<String, dynamic> getConfigMap(Config config) {
    return {
      TblConfig.ip: config.ip,
      TblConfig.port: config.port,
      TblConfig.database: config.database,
      TblConfig.username: config.username,
      TblConfig.password: config.password,
    };
  }

  static Config getConfigFromJson(Map<String, dynamic> result) {
    Config config = Config(
      ip: result[TblConfig.ip],
      port: result[TblConfig.port],
      database: result[TblConfig.database],
      username: result[TblConfig.username],
      password: result[TblConfig.password],
    );
    return config;
  }
}
