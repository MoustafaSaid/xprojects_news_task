import 'package:equatable/equatable.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';

enum RequestState { initial, loading, loaded, error }

class HomeState extends Equatable {
  final RequestState newsState;
  final NewsResponseModel? newsData;
  final String message;

  const HomeState({
    this.newsState = RequestState.initial,
    this.newsData,
    this.message = '',
  });

  @override
  List<Object?> get props => [newsState, newsData, message];

  HomeState copyWith({
    RequestState? newsState,
    NewsResponseModel? newsData,
    String? message,
  }) {
    return HomeState(
      newsState: newsState ?? this.newsState,
      newsData: newsData ?? this.newsData,
      message: message ?? this.message,
    );
  }
}
