import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:xprojects_news_task/core/local_data_source/bookmark_repository.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_repository_impl.dart';
import 'package:xprojects_news_task/core/local_data_source/user_preference_repo.dart';
import 'package:xprojects_news_task/core/local_data_source/user_preference_repo_impl.dart';
import 'package:xprojects_news_task/core/local_data_source/user_preference_source.dart';
import 'package:xprojects_news_task/features/bookmark/presentation/controller/cubit/bookmark_cubit.dart';
import 'package:xprojects_news_task/features/home/data/data_source/remote/home_remote_data_source.dart';
import 'package:xprojects_news_task/features/home/data/models/bookmarked_article_model.dart';
import 'package:xprojects_news_task/features/home/data/repo_impl/home_repo_impl.dart';
import 'package:xprojects_news_task/features/home/domain/repo/home_repo.dart';
import 'package:xprojects_news_task/features/home/presentation/controller/cubit/home_cubit.dart';
import 'package:xprojects_news_task/features/layout/presentation/controller/cubit/layout_cubit.dart';
import 'package:xprojects_news_task/features/search/data/data_source/remote/search_remote_data_source.dart';
import 'package:xprojects_news_task/features/search/data/repo_impl/search_repo_impl.dart';
import 'package:xprojects_news_task/features/search/domain/repo/search_repo.dart';
import 'package:xprojects_news_task/features/search/presentation/controller/cubit/search_cubit.dart';

final sl = GetIt.instance;
Future<void> init({required Box userPreferenceBox}) async {
// Future<void> init() async {
  // Register Hive adapters
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(BookmarkedArticleModelAdapter());
  }

  // Open Hive boxes
  final bookmarksBox = await Hive.openBox<BookmarkedArticleModel>(
    BookmarkRepositoryImpl.bookmarksBoxName,
  );

  ///Cubit
  ///layout
  sl.registerLazySingleton<LayoutCubit>(() => LayoutCubit());

  ///Home
  // Remote Data Source
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSource(sl<Dio>(), baseUrl: 'https://newsapi.org'),
  );

  // Repository
  sl.registerLazySingleton<HomeRepo>(
    () => HomeRepoImpl(sl<HomeRemoteDataSource>()),
  );

  // Bookmark Repository
  sl.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(bookmarksBox: bookmarksBox),
  );

  // Cubit
  sl.registerFactory<HomeCubit>(
    () => HomeCubit(
      homeRepo: sl<HomeRepo>(),
      bookmarkRepository: sl<BookmarkRepository>(),
    ),
  );

  // Bookmark Cubit
  sl.registerFactory<BookmarkCubit>(
    () => BookmarkCubit(
      bookmarkRepository: sl<BookmarkRepository>(),
    ),
  );

  ///Search
  // Remote Data Source
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSource(sl<Dio>(), baseUrl: 'https://newsapi.org'),
  );

  // Repository
  sl.registerLazySingleton<SearchRepo>(
    () => SearchRepoImpl(sl<SearchRemoteDataSource>()),
  );

  // Cubit
  sl.registerFactory<SearchCubit>(
    () => SearchCubit(
      searchRepo: sl<SearchRepo>(),
      bookmarkRepository: sl<BookmarkRepository>(),
    ),
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
