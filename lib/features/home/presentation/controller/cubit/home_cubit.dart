import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xprojects_news_task/features/home/domain/repo/home_repo.dart';
import 'package:xprojects_news_task/features/home/presentation/controller/states/home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit({required this.homeRepo}) : super(const HomeState());

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
}
