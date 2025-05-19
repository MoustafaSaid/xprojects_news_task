import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';
import 'package:xprojects_news_task/features/news_details/presentation/controller/states/news_details_states.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_repository.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_events.dart';

class NewsDetailsCubit extends Cubit<NewsDetailsState> {
  final BookmarkRepository _bookmarkRepository;
  final BookmarkEvents _bookmarkEvents = BookmarkEvents();
  bool _isBookmarked = false;
  StreamSubscription? _bookmarkSubscription;

  NewsDetailsCubit(this._bookmarkRepository) : super(NewsDetailsInitial()) {
    // Listen to bookmark changes
    _bookmarkSubscription =
        _bookmarkEvents.bookmarkChanges.listen((article) async {
      if (!isClosed) {
        _isBookmarked = await _bookmarkRepository.isArticleBookmarked(article);
        emit(NewsDetailsLoaded(article, isBookmarked: _isBookmarked));
      }
    });
  }

  @override
  Future<void> close() {
    _bookmarkSubscription?.cancel();
    return super.close();
  }

  bool get isBookmarked => _isBookmarked;

  // Load article details
  Future<void> loadArticleDetails(ArticleModel article) async {
    if (isClosed) return;
    try {
      _isBookmarked = await _bookmarkRepository.isArticleBookmarked(article);
      if (!isClosed) {
        emit(NewsDetailsLoaded(article, isBookmarked: _isBookmarked));
      }
    } catch (e) {
      if (!isClosed) {
        emit(NewsDetailsError(
            'Failed to load article details: ${e.toString()}'));
      }
    }
  }

  // Toggle bookmark
  Future<void> toggleBookmark(ArticleModel article) async {
    if (isClosed) return;
    try {
      if (_isBookmarked) {
        await _bookmarkRepository.removeBookmark(article);
      } else {
        await _bookmarkRepository.addBookmark(article);
      }
      _isBookmarked = !_isBookmarked;
      if (!isClosed) {
        emit(NewsDetailsLoaded(article, isBookmarked: _isBookmarked));
        // Notify other parts of the app about the bookmark change
        _bookmarkEvents.notifyBookmarkChanged(article);
      }
    } catch (e) {
      if (!isClosed) {
        emit(NewsDetailsError('Failed to toggle bookmark: ${e.toString()}'));
      }
    }
  }
}
