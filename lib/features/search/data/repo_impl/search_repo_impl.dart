import 'package:dartz/dartz.dart';
import 'package:xprojects_news_task/core/network/error_handler/error_handler.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';
import 'package:xprojects_news_task/features/search/data/data_source/remote/search_remote_data_source.dart';
import 'package:xprojects_news_task/features/search/domain/repo/search_repo.dart';

class SearchRepoImpl implements SearchRepo {
  final SearchRemoteDataSource _remoteDataSource;

  SearchRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, NewsResponseModel>> searchNews({
    required String query,
    required String sortBy,
    required String apiKey,
    required String language,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _remoteDataSource.searchNews(
        query: query,
        sortBy: sortBy,
        apiKey: apiKey,
        language: language,
        page: page,
        pageSize: pageSize,
      );
      return Right(response);
    } catch (error) {
      final failure = ErrorHandler.handle(error);
      return Left(Failure(failure.dataSource, failure.errorMessage));
    }
  }
}
