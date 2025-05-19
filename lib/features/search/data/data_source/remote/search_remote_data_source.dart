import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';

part 'search_remote_data_source.g.dart';

@RestApi()
abstract class SearchRemoteDataSource {
  factory SearchRemoteDataSource(Dio dio, {String baseUrl}) =
      _SearchRemoteDataSource;

  @GET('/v2/everything')
  Future<NewsResponseModel> searchNews({
    @Query('q') required String query,
    @Query('sortBy') required String sortBy,
    @Query('apiKey') required String apiKey,
    @Query('language') required String language,
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 20,
  });
}
