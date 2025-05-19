import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xprojects_news_task/core/constants/colors/colors_constants.dart';
import 'package:xprojects_news_task/core/theme/font/font_styles.dart';
import 'package:xprojects_news_task/features/layout/presentation/controller/cubit/layout_cubit.dart';
import 'package:xprojects_news_task/features/layout/presentation/controller/states/layout_states.dart';

class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 58,
        width: 287,
        margin: const EdgeInsets.symmetric(horizontal: 44, vertical: 35),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 15,
            ),
            BoxShadow(
              color: Colors.white,
              blurRadius: 15,
              spreadRadius: 4,
            ),
          ],
          color: Colors.white,
        ),
        child: BlocBuilder<LayoutCubit, LayoutStates>(
          builder: (context, state) {
            return BottomNavigationBar(
              enableFeedback: false,
              currentIndex: LayoutCubit.get(context).bottomNavIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              unselectedItemColor: Colors.grey,
              selectedItemColor: ColorsConstants.primaryColor,
              unselectedLabelStyle: FontStyles.font12blackW400.copyWith(
                color: Colors.grey,
              ),
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              selectedLabelStyle: FontStyles.font12blackW400.copyWith(
                color: ColorsConstants.primaryColor,
              ),
              backgroundColor: Colors.transparent,
              onTap: (index) {
                LayoutCubit.get(context).changeBottomNav(value: index);
              },
              items: [
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    'assets/icons/Home Icon.svg',
                    colorFilter: ColorFilter.mode(
                        ColorsConstants.primaryColor, BlendMode.srcIn),
                  ),
                  icon: SvgPicture.asset(
                    'assets/icons/Home Icon.svg',
                    colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/Bookmarks Icon.svg',
                    colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/icons/Bookmarks Icon.svg',
                    colorFilter: ColorFilter.mode(
                        ColorsConstants.primaryColor, BlendMode.srcIn),
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/Search Icon.svg',
                    colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                  ),
                  activeIcon:SvgPicture.asset(
                    'assets/icons/Search Icon.svg',
                    colorFilter: ColorFilter.mode(ColorsConstants.primaryColor, BlendMode.srcIn),
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/Notifications Icon.svg',
                    colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/Settings Icon.svg',
                    colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                  ),
                  label: "",
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
