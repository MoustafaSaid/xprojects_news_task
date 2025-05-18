import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';
import 'package:xprojects_news_task/features/news_details/presentation/controller/states/news_details_states.dart';

class NewsDetailsCubit extends Cubit<NewsDetailsState> {
  NewsDetailsCubit() : super(NewsDetailsInitial());

  // Load article details
  void loadArticleDetails(ArticleModel article) {
    try {
      emit(NewsDetailsLoaded(article));
    } catch (e) {
      emit(NewsDetailsError('Failed to load article details: ${e.toString()}'));
    }
  }
}
