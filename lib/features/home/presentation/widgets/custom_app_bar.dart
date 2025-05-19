import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xprojects_news_task/core/constants/icons/icons_constants.dart';
import 'package:xprojects_news_task/core/theme/font/font_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onMicTap;

  const CustomAppBar({
    super.key,
    this.onMenuTap,
    this.onMicTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Menu Button
            InkWell(
              onTap: onMenuTap,
              child: SvgPicture.asset(
                IconsConstants.menuIcon,
              ),
            ),

            // App title
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'News',
                    style: FontStyles.font16blackW900,
                  ),
                  TextSpan(text: 'App', style: FontStyles.font16blackW100),
                ],
              ),
            ),
            // Text(
            //   'App',
            //   style: FontStyles.font16blackW100,
            // ),

            // Mic Button
            InkWell(
              onTap: onMicTap,
              child: SvgPicture.asset(IconsConstants.podcastIcon),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10.h);
}

class CustomDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomDetailsAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset(
                IconsConstants.navBar,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10.h);
}
