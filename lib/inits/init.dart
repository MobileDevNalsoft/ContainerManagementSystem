import 'package:get_it/get_it.dart';
import 'package:network_calls/src.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:warehouse_3d/contants/app_constants.dart';
import '../navigations/navigator_service.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.allowReassignment = true;

  // Api
  getIt.registerLazySingleton<NetworkCalls>(() => NetworkCalls(AppConstants.APEX_URL, getIt<Dio>(),
      connectTimeout: 30, receiveTimeout: 30, username: AppConstants.APIUSERNAME, password: AppConstants.APIPASSWORD));

  // Navigator Service
  getIt.registerSingleton<NavigatorService>(NavigatorService());

  //Initializations
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerFactory(() => Dio());
}
