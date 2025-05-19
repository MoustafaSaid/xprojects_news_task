import 'package:hive/hive.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';

part 'bookmarked_article_model.g.dart';

@HiveType(typeId: 1)
class BookmarkedArticleModel extends HiveObject {
  @HiveField(0)
  final String? sourceId;

  @HiveField(1)
  final String? sourceName;

  @HiveField(2)
  final String? author;

  @HiveField(3)
  final String? title;

  @HiveField(4)
  final String? description;

  @HiveField(5)
  final String? url;

  @HiveField(6)
  final String? urlToImage;

  @HiveField(7)
  final String? publishedAt;

  @HiveField(8)
  final String? content;

  BookmarkedArticleModel({
    this.sourceId,
    this.sourceName,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  // Factory method to create a BookmarkedArticleModel from ArticleModel
  factory BookmarkedArticleModel.fromArticleModel(ArticleModel article) {
    return BookmarkedArticleModel(
      sourceId: article.source?.id,
      sourceName: article.source?.name,
      author: article.author,
      title: article.title,
      description: article.description,
      url: article.url,
      urlToImage: article.urlToImage,
      publishedAt: article.publishedAt,
      content: article.content,
    );
  }

  // Convert back to ArticleModel
  ArticleModel toArticleModel() {
    return ArticleModel(
      source: SourceModel(
        id: sourceId,
        name: sourceName,
      ),
      author: author,
      title: title,
      description: description,
      url: url,
      urlToImage: urlToImage,
      publishedAt: publishedAt,
      content: content,
    );
  }

  // Generate a unique key for the bookmark based on url
  String get bookmarkKey {
    if (url == null) return '';
    // Create a hash of the URL to ensure uniqueness while keeping the key short
    return url!.hashCode.toString();
  }
}
