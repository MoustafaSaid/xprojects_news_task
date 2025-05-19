import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xprojects_news_task/core/di/di.dart';
import 'package:xprojects_news_task/features/bookmark/presentation/controller/cubit/bookmark_cubit.dart';
import 'package:xprojects_news_task/features/bookmark/presentation/page/bookmarks_page.dart';
import 'package:xprojects_news_task/features/home/presentation/controller/cubit/home_cubit.dart';
import 'package:xprojects_news_task/features/home/presentation/page/home_page.dart';
import 'package:xprojects_news_task/features/layout/presentation/controller/states/layout_states.dart';
import 'package:xprojects_news_task/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:xprojects_news_task/features/search/presentation/page/search_page.dart';
import 'package:xprojects_news_task/features/settings/presentation/pages/settings_page.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(InitialState());

  static LayoutCubit get(context) => BlocProvider.of(context);

  int bottomNavIndex = 0;

  List<Widget> screens = [
    BlocProvider(
      create: (context) => sl<HomeCubit>(),
      child: const HomePage(),
    ),
    BlocProvider(
      create: (context) => sl<BookmarkCubit>(),
      child: const BookmarksPage(),
    ),
    BlocProvider(
      create: (context) => sl<SearchCubit>(),
      child: const SearchPage(),
    ),
    const SettingsPage(),
  ];

  void changeBottomNav({required int value}) {
    if (value >= 0 && value < screens.length) {
      bottomNavIndex = value;
      emit(ChangeBottomNavState());
    }
  }
}
