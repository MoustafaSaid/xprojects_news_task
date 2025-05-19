import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';
import 'package:xprojects_news_task/features/news_details/presentation/controller/states/news_details_states.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_repository.dart';

class NewsDetailsCubit extends Cubit<NewsDetailsState> {
  final BookmarkRepository _bookmarkRepository;
  bool _isBookmarked = false;

  NewsDetailsCubit(this._bookmarkRepository) : super(NewsDetailsInitial());

  bool get isBookmarked => _isBookmarked;

  // Load article details
  Future<void> loadArticleDetails(ArticleModel article) async {
    try {
      _isBookmarked = await _bookmarkRepository.isArticleBookmarked(article);
      emit(NewsDetailsLoaded(article, isBookmarked: _isBookmarked));
    } catch (e) {
      emit(NewsDetailsError('Failed to load article details: ${e.toString()}'));
    }
  }

  // Toggle bookmark
  Future<void> toggleBookmark(ArticleModel article) async {
    try {
      if (_isBookmarked) {
        await _bookmarkRepository.removeBookmark(article);
      } else {
        await _bookmarkRepository.addBookmark(article);
      }
      _isBookmarked = !_isBookmarked;
      emit(NewsDetailsLoaded(article, isBookmarked: _isBookmarked));
    } catch (e) {
      emit(NewsDetailsError('Failed to toggle bookmark: ${e.toString()}'));
    }
  }
}
