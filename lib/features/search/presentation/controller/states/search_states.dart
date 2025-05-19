import 'package:equatable/equatable.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';
import 'package:xprojects_news_task/features/home/presentation/controller/states/home_states.dart';

class SearchState extends Equatable {
  final RequestState searchState;
  final NewsResponseModel? searchData;
  final String message;
  final String currentQuery;
  final List<String> recentSearches;

  const SearchState({
    this.searchState = RequestState.initial,
    this.searchData,
    this.message = '',
    this.currentQuery = '',
    this.recentSearches = const [],
  });

  @override
  List<Object?> get props =>
      [searchState, searchData, message, currentQuery, recentSearches];

  SearchState copyWith({
    RequestState? searchState,
    NewsResponseModel? searchData,
    String? message,
    String? currentQuery,
    List<String>? recentSearches,
  }) {
    return SearchState(
      searchState: searchState ?? this.searchState,
      searchData: searchData ?? this.searchData,
      message: message ?? this.message,
      currentQuery: currentQuery ?? this.currentQuery,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }
}
