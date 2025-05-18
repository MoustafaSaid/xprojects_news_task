import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:xprojects_news_task/core/local_data_source/user_preference_repo.dart';
import 'package:xprojects_news_task/core/local_data_source/user_preference_repo_impl.dart';
import 'package:xprojects_news_task/core/local_data_source/user_preference_source.dart';
import 'package:xprojects_news_task/features/home/data/data_source/remote/home_remote_data_source.dart';
import 'package:xprojects_news_task/features/home/data/repo_impl/home_repo_impl.dart';
import 'package:xprojects_news_task/features/home/domain/repo/home_repo.dart';
import 'package:xprojects_news_task/features/home/presentation/controller/cubit/home_cubit.dart';

final sl = GetIt.instance;
Future<void> init({required Box userPreferenceBox}) async {
// Future<void> init() async {
  ///Cubit
  ///layout
  // sl.registerLazySingleton<LayoutCubit>(() => LayoutCubit());

  ///Home
  // Remote Data Source
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSource(sl<Dio>(), baseUrl: 'https://newsapi.org'),
  );

  // Repository
  sl.registerLazySingleton<HomeRepo>(
    () => HomeRepoImpl(sl<HomeRemoteDataSource>()),
  );

  // Cubit
  sl.registerFactory<HomeCubit>(
    () => HomeCubit(homeRepo: sl<HomeRepo>()),
  );

  // Dio
  sl.registerLazySingleton<Dio>(() => createAndSetupDio());
  sl.registerLazySingleton<UserPreferenceRepo>(
      () => UserPreferenceRepoImpl(userPreference: sl()));
  sl.registerLazySingleton<UserPreferenceSource>(
      () => UserPreferenceSource(userPreferenceBox: userPreferenceBox));
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
