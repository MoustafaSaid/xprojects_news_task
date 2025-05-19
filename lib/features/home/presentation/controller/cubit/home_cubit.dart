import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_repository.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_events.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';
import 'package:xprojects_news_task/features/home/domain/repo/home_repo.dart';
import 'package:xprojects_news_task/features/home/presentation/controller/states/home_states.dart';
import 'package:xprojects_news_task/features/settings/presentation/controller/settings_cubit.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;
  final BookmarkRepository bookmarkRepository;
  final BookmarkEvents _bookmarkEvents = BookmarkEvents();
  final SharedPreferences _prefs;
  static const String _languageKey = 'language';
  StreamSubscription? _bookmarkSubscription;
  StreamSubscription? _settingsSubscription;

  HomeCubit({
    required this.homeRepo,
    required this.bookmarkRepository,
    required SharedPreferences prefs,
  })  : _prefs = prefs,
        super(const HomeState()) {
    // Listen to bookmark changes
    _bookmarkSubscription = _bookmarkEvents.bookmarkChanges.listen((article) {
      if (!isClosed) {
        // When a bookmark changes, emit a new state to update UI
        emit(state.copyWith());
      }
    });
    // Initial news fetch with saved language
    getNews(language: _prefs.getString(_languageKey) ?? 'en');
  }

  @override
  Future<void> close() {
    _bookmarkSubscription?.cancel();
    _settingsSubscription?.cancel();
    return super.close();
  }

  void listenToLanguageChanges(BuildContext context) {
    _settingsSubscription?.cancel();
    // Get initial language
    final settingsState = context.read<SettingsCubit>().state;
    if (settingsState is SettingsLoaded) {
      _prefs.setString(_languageKey, settingsState.language);
      getNews(language: settingsState.language);
    }
    // Listen to future changes
    _settingsSubscription =
        context.read<SettingsCubit>().stream.listen((settingsState) {
      if (settingsState is SettingsLoaded) {
        _prefs.setString(_languageKey, settingsState.language);
        getNews(language: settingsState.language);
      }
    });
  }

  Future<void> getNews({
    String query = "sports",
    String from = '2025-5-1',
    String sortBy = 'publishedAt',
    String apiKey = 'e4941a26a6ed466db07bce82adb1bbd6',
    String? language,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(newsState: RequestState.loading));

    final result = await homeRepo.getNews(
      query: query,
      from: from,
      sortBy: sortBy,
      apiKey: apiKey,
      language: language ?? _prefs.getString(_languageKey) ?? 'en',
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(
            newsState: RequestState.error,
            message: failure.message,
          ));
        }
      },
      (newsData) {
        if (!isClosed) {
          emit(state.copyWith(
            newsState: RequestState.loaded,
            newsData: newsData,
          ));
        }
      },
    );
  }

  // Bookmark functions
  Future<void> toggleBookmark(ArticleModel article) async {
    if (isClosed) return;
    final isBookmarked = await bookmarkRepository.isArticleBookmarked(article);
    if (isBookmarked) {
      await bookmarkRepository.removeBookmark(article);
    } else {
      await bookmarkRepository.addBookmark(article);
    }

    // Notify other parts of the app about the bookmark change
    _bookmarkEvents.notifyBookmarkChanged(article);

    // Emit the state to refresh UI
    if (!isClosed) {
      emit(state.copyWith());
    }
  }

  Future<bool> isArticleBookmarked(ArticleModel article) async {
    return await bookmarkRepository.isArticleBookmarked(article);
  }

  Future<List<ArticleModel>> getBookmarkedArticles() async {
    return await bookmarkRepository.getBookmarkedArticles();
  }
}
