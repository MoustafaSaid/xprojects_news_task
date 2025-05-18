import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';

abstract class BookmarkRepository {
  Future<void> addBookmark(ArticleModel article);
  Future<void> removeBookmark(ArticleModel article);
  Future<List<ArticleModel>> getBookmarkedArticles();
  Future<bool> isArticleBookmarked(ArticleModel article);
}
