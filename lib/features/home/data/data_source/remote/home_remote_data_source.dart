import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';

part 'home_remote_data_source.g.dart';

@RestApi()
abstract class HomeRemoteDataSource {
  factory HomeRemoteDataSource(Dio dio, {String baseUrl}) =
      _HomeRemoteDataSource;

  @GET('/v2/everything')
  Future<NewsResponseModel> getNews({
    @Query('q') required String query,
    @Query('from') required String from,
    @Query('sortBy') required String sortBy,
    @Query('apiKey') required String apiKey,
    @Query('language') required String language,
  });
}
