import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xprojects_news_task/core/di/di.dart';
import 'package:xprojects_news_task/features/layout/presentation/controller/cubit/layout_cubit.dart';
import 'package:xprojects_news_task/features/layout/presentation/controller/states/layout_states.dart';
import 'package:xprojects_news_task/features/layout/presentation/widgets/bottom_nav_bar.dart';
import 'package:xprojects_news_task/features/settings/presentation/controller/settings_cubit.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<LayoutCubit>()),
        BlocProvider(create: (context) => sl<SettingsCubit>()),
      ],
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        body: BlocBuilder<LayoutCubit, LayoutStates>(
          builder: (context, state) {
            final layoutCubit = LayoutCubit.get(context);
            final index = layoutCubit.bottomNavIndex;
            if (index >= 0 && index < layoutCubit.screens.length) {
              return layoutCubit.screens[index];
            }
            return layoutCubit
                .screens[0]; // Default to home screen if index is invalid
          },
        ),
        bottomNavigationBar: const BottomNavBarWidget(),
      ),
    );
  }
}
