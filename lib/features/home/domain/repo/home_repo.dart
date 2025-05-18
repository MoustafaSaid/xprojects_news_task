import 'package:dartz/dartz.dart';
import 'package:xprojects_news_task/core/network/error_handler/error_handler.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';

abstract class HomeRepo {
  Future<Either<Failure, NewsResponseModel>> getNews({
    required String query,
    required String from,
    required String sortBy,
    required String apiKey,
    required String language,
  });
}
