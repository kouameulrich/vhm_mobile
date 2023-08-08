import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:vhm_mobile/_api/apiService.dart';
import 'package:vhm_mobile/_api/dioClient.dart';
import 'package:vhm_mobile/_api/tokenStorageService.dart';
import 'package:vhm_mobile/db/database.connection.dart';
import 'package:vhm_mobile/db/local.servie.dart';
import 'package:vhm_mobile/db/repository.dart';

final locator = GetIt.instance;

Future<void> setup() async {
  locator.registerSingleton(const FlutterSecureStorage());
  locator
      .registerSingleton(TokenStorageService(locator<FlutterSecureStorage>()));
  locator.registerSingleton(Dio());
  //locator.registerSingleton(AuthService(locator<TokenStorageService>()));
  locator.registerSingleton(DioClient(locator<Dio>()));
  locator.registerSingleton(ApiService(locator<DioClient>()));
  locator.registerSingleton(DatabaseConnection());
  locator.registerSingleton(Repository(locator<DatabaseConnection>()));
  locator.registerSingleton(LocalService(locator<Repository>()));
  //locator.registerSingleton(PrinterService());
}
