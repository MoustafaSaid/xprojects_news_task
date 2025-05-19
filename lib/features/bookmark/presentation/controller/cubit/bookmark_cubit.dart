import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_repository.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_events.dart';
import 'package:xprojects_news_task/features/bookmark/presentation/controller/states/bookmark_states.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  final BookmarkRepository bookmarkRepository;
  List<ArticleModel> _bookmarkedArticles = [];
  final BookmarkEvents _bookmarkEvents = BookmarkEvents();

  BookmarkCubit({required this.bookmarkRepository})
      : super(const BookmarkInitial());

  Future<void> getBookmarkedArticles() async {
    emit(const BookmarkLoading());
    try {
      _bookmarkedArticles = await bookmarkRepository.getBookmarkedArticles();
      emit(BookmarkSuccess(bookmarkedArticles: _bookmarkedArticles));
    } catch (e) {
      emit(BookmarkError(message: e.toString()));
    }
  }

  Future<void> removeBookmark(ArticleModel article) async {
    try {
      await bookmarkRepository.removeBookmark(article);

      // Notify all listeners about the bookmark change
      _bookmarkEvents.notifyBookmarkChanged(article);

      await getBookmarkedArticles();
      emit(const BookmarkRemoveSuccess());
      emit(BookmarkSuccess(bookmarkedArticles: _bookmarkedArticles));
    } catch (e) {
      emit(BookmarkError(message: e.toString()));
    }
  }

  List<String> getUniqueCategories() {
    final Set<String> categories = {};
    for (var article in _bookmarkedArticles) {
      if (article.source?.name != null) {
        categories.add(article.source!.name!.toLowerCase());
      }
    }
    return categories.toList();
  }

  List<ArticleModel> get bookmarkedItems => _bookmarkedArticles;
}
