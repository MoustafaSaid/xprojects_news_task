import 'dart:async';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';

// Singleton class to manage bookmark events
class BookmarkEvents {
  static final BookmarkEvents _instance = BookmarkEvents._internal();
  factory BookmarkEvents() => _instance;
  BookmarkEvents._internal();

  // Stream controller for bookmark changes
  final _bookmarkChangesController = StreamController<ArticleModel>.broadcast();

  // Stream that other widgets can listen to
  Stream<ArticleModel> get bookmarkChanges => _bookmarkChangesController.stream;

  // Method to notify listeners when a bookmark is added or removed
  void notifyBookmarkChanged(ArticleModel article) {
    _bookmarkChangesController.add(article);
  }

  // Close the stream controller
  void dispose() {
    _bookmarkChangesController.close();
  }
}
