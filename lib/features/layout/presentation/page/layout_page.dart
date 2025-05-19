import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xprojects_news_task/features/layout/presentation/controller/cubit/layout_cubit.dart';
import 'package:xprojects_news_task/features/layout/presentation/controller/states/layout_states.dart';
import 'package:xprojects_news_task/features/layout/presentation/widgets/bottom_nav_bar.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody:
      true, // Key property to extend content behind bottom nav bar
      backgroundColor: Colors.white,
      body: BlocBuilder<LayoutCubit, LayoutStates>(
        builder: (context, state) {
          return LayoutCubit.get(context)
              .screens[LayoutCubit.get(context).bottomNavIndex];
        },
      ),
      bottomNavigationBar: const BottomNavBarWidget(),
    );
  }
}
