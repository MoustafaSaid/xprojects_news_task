import 'package:dartz/dartz.dart';
import 'package:xprojects_news_task/core/network/error_handler/error_handler.dart';
import 'package:xprojects_news_task/features/home/data/data_source/remote/home_remote_data_source.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';
import 'package:xprojects_news_task/features/home/domain/repo/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, NewsResponseModel>> getNews({
    required String query,
    required String from,
    required String sortBy,
    required String apiKey,
    required String language,
  }) async {
    try {
      final response = await _remoteDataSource.getNews(
        query: query,
        from: from,
        sortBy: sortBy,
        apiKey: apiKey,
        language: language,
      );
      return Right(response);
    } catch (error) {
      final failure = ErrorHandler.handle(error);
      return Left(Failure(failure.dataSource, failure.errorMessage));
    }
  }
}
