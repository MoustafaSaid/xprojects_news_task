import 'package:dartz/dartz.dart';
import 'package:xprojects_news_task/core/network/error_handler/error_handler.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';

abstract class SearchRepo {
  Future<Either<Failure, NewsResponseModel>> searchNews({
    required String query,
    required String sortBy,
    required String apiKey,
    required String language,
    int page = 1,
    int pageSize = 20,
  });
}
