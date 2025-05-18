import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:xprojects_news_task/core/local_data_source/user_preference_repo.dart';

final sl = GetIt.instance;
Future<void> init({required Box userPreferenceBox}) async {
// Future<void> init() async {
  ///Cubit
  ///layout
  // sl.registerLazySingleton<LayoutCubit>(() => LayoutCubit());

  ///Home


}

Dio createAndSetupDio() {
  Dio dio = Dio();
  dio.interceptors.addAll([AppendHeaderInterceptor()]);


  dio.interceptors.add(PrettyDioLogger(
    requestBody: true,
    error: true,
    requestHeader: true,
    responseHeader: true,
    responseBody: true,
  ));
  return dio;
}

class AppendHeaderInterceptor extends Interceptor {
  AppendHeaderInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept'] = 'application/json';

    options.queryParameters['lang'] = sl<UserPreferenceRepo>().getLanguage();
    return super.onRequest(options, handler);
  }
}
