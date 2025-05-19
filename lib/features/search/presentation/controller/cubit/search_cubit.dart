import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_repository.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_events.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';
import 'package:xprojects_news_task/features/home/presentation/controller/states/home_states.dart';
import 'package:xprojects_news_task/features/search/domain/repo/search_repo.dart';
import 'package:xprojects_news_task/features/search/presentation/controller/states/search_states.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo searchRepo;
  final BookmarkRepository bookmarkRepository;
  final BookmarkEvents _bookmarkEvents = BookmarkEvents();

  // Create a subject for search queries with debounce
  final _searchQuerySubject = BehaviorSubject<String>();

  // Stream subscription for debounced search
  StreamSubscription? _searchSubscription;

  SearchCubit({
    required this.searchRepo,
    required this.bookmarkRepository,
  }) : super(const SearchState()) {
    // Listen to bookmark changes
    _bookmarkEvents.bookmarkChanges.listen((article) {
      // When a bookmark changes, emit a new state to update UI
      emit(state.copyWith());
    });

    // Setup debounced search
    _searchSubscription = _searchQuerySubject
        .debounceTime(const Duration(milliseconds: 500))
        .distinct()
        .listen((query) {
      if (query.isNotEmpty) {
        _performSearch(query);
      }
    });
  }

  @override
  Future<void> close() {
    _searchSubscription?.cancel();
    _searchQuerySubject.close();
    return super.close();
  }

  void onSearchQueryChanged(String query) {
    emit(state.copyWith(currentQuery: query));
    _searchQuerySubject.add(query);

    if (query.isEmpty) {
      emit(state.copyWith(
        searchState: RequestState.initial,
        searchData: null,
      ));
    }
  }

  Future<void> _performSearch(String query) async {
    emit(state.copyWith(searchState: RequestState.loading));

    // Add the search term to recent searches if it's not already there
    if (!state.recentSearches.contains(query) && query.isNotEmpty) {
      final updatedRecentSearches = List<String>.from(state.recentSearches);
      updatedRecentSearches.insert(0, query);
      if (updatedRecentSearches.length > 5) {
        updatedRecentSearches.removeLast();
      }
      emit(state.copyWith(recentSearches: updatedRecentSearches));
    }

    final result = await searchRepo.searchNews(
      query: query,
      sortBy: 'publishedAt',
      apiKey:
          'e4941a26a6ed466db07bce82adb1bbd6', // Should be stored in a config
      language: 'en',
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          searchState: RequestState.error,
          message: failure.message,
        ));
      },
      (searchData) {
        emit(state.copyWith(
          searchState: RequestState.loaded,
          searchData: searchData,
        ));
      },
    );
  }

  void searchWithQuery(String query) {
    if (query.isNotEmpty) {
      emit(state.copyWith(currentQuery: query));
      _performSearch(query);
    }
  }

  // Bookmark functions
  Future<void> toggleBookmark(ArticleModel article) async {
    final isBookmarked = await bookmarkRepository.isArticleBookmarked(article);
    if (isBookmarked) {
      await bookmarkRepository.removeBookmark(article);
    } else {
      await bookmarkRepository.addBookmark(article);
    }

    // Notify other parts of the app about the bookmark change
    _bookmarkEvents.notifyBookmarkChanged(article);

    // Emit the state to refresh UI
    emit(state.copyWith());
  }

  Future<bool> isArticleBookmarked(ArticleModel article) async {
    return await bookmarkRepository.isArticleBookmarked(article);
  }
}
