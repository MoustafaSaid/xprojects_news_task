import 'package:hive/hive.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_repository.dart';
import 'package:xprojects_news_task/features/home/data/models/bookmarked_article_model.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  static const String bookmarksBoxName = 'bookmarks_box';

  final Box<BookmarkedArticleModel> bookmarksBox;

  BookmarkRepositoryImpl({required this.bookmarksBox});

  @override
  Future<void> addBookmark(ArticleModel article) async {
    final bookmarkedArticle = BookmarkedArticleModel.fromArticleModel(article);
    await bookmarksBox.put(bookmarkedArticle.bookmarkKey, bookmarkedArticle);
  }

  @override
  Future<void> removeBookmark(ArticleModel article) async {
    final bookmarkedArticle = BookmarkedArticleModel.fromArticleModel(article);
    await bookmarksBox.delete(bookmarkedArticle.bookmarkKey);
  }

  @override
  Future<List<ArticleModel>> getBookmarkedArticles() async {
    return bookmarksBox.values
        .map((bookmarked) => bookmarked.toArticleModel())
        .toList();
  }

  @override
  Future<bool> isArticleBookmarked(ArticleModel article) async {
    final bookmarkedArticle = BookmarkedArticleModel.fromArticleModel(article);
    return bookmarksBox.containsKey(bookmarkedArticle.bookmarkKey);
  }
}
