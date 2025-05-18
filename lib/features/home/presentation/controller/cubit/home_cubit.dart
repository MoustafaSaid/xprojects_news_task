import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_repository.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';
import 'package:xprojects_news_task/features/home/domain/repo/home_repo.dart';
import 'package:xprojects_news_task/features/home/presentation/controller/states/home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;
  final BookmarkRepository bookmarkRepository;

  HomeCubit({
    required this.homeRepo,
    required this.bookmarkRepository,
  }) : super(const HomeState());

  Future<void> getNews({
    String query = 'barcelona',
    String from = '2025-5-1',
    String sortBy = 'publishedAt',
    String apiKey = 'e4941a26a6ed466db07bce82adb1bbd6',
    String language = 'en',
  }) async {
    emit(state.copyWith(newsState: RequestState.loading));

    final result = await homeRepo.getNews(
      query: query,
      from: from,
      sortBy: sortBy,
      apiKey: apiKey,
      language: language,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          newsState: RequestState.error,
          message: failure.message,
        ));
      },
      (newsData) {
        emit(state.copyWith(
          newsState: RequestState.loaded,
          newsData: newsData,
        ));
      },
    );
  }

  // Bookmark functions
  Future<void> toggleBookmark(ArticleModel article) async {
    final isBookmarked = await bookmarkRepository.isArticleBookmarked(article);
    if (isBookmarked) {
      await bookmarkRepository.removeBookmark(article);
    } else {
      await bookmarkRepository.addBookmark(article);
    }
    // Emit the state to refresh UI
    emit(state.copyWith());
  }

  Future<bool> isArticleBookmarked(ArticleModel article) async {
    return await bookmarkRepository.isArticleBookmarked(article);
  }

  Future<List<ArticleModel>> getBookmarkedArticles() async {
    return await bookmarkRepository.getBookmarkedArticles();
  }
}
