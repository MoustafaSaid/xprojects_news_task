import 'package:equatable/equatable.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';

// Base class for news details states
abstract class NewsDetailsState extends Equatable {
  const NewsDetailsState();

  @override
  List<Object?> get props => [];
}

// Initial state
class NewsDetailsInitial extends NewsDetailsState {}

// State for when the details are loaded
class NewsDetailsLoaded extends NewsDetailsState {
  final ArticleModel article;

  const NewsDetailsLoaded(this.article);

  @override
  List<Object?> get props => [article];
}

// State for when there's an error
class NewsDetailsError extends NewsDetailsState {
  final String message;

  const NewsDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
