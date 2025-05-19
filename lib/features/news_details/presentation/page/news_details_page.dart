import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xprojects_news_task/core/constants/strings/strings_constants.dart';
import 'package:xprojects_news_task/core/constants/icons/icons_constants.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';
import 'package:xprojects_news_task/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:xprojects_news_task/features/news_details/presentation/controller/cubit/news_details_cubit.dart';
import 'package:xprojects_news_task/features/news_details/presentation/controller/states/news_details_states.dart';

import '../../../../core/constants/colors/colors_constants.dart';
import '../../../../core/theme/font/font_styles.dart';

class NewsDetailsPage extends StatefulWidget {
  final ArticleModel article;

  const NewsDetailsPage({
    super.key,
    required this.article,
  });

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  late NewsDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<NewsDetailsCubit>();
    _cubit.loadArticleDetails(widget.article);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsDetailsCubit, NewsDetailsState>(
      builder: (context, state) {
        bool isBookmarked = false;
        if (state is NewsDetailsLoaded) {
          isBookmarked = state.isBookmarked;
        }

        return Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            appBar: CustomDetailsAppBar(),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero image
                  Container(
                    height: 375.h,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.r),
                      bottomRight: Radius.circular(32.r),
                    )),
                    child: widget.article.urlToImage != null &&
                            widget.article.urlToImage!.isNotEmpty
                        ? Image.network(
                            widget.article.urlToImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "assets/icons/background.jpg",
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            "assets/icons/background.jpg",
                            fit: BoxFit.cover,
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(32.w),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25.r,
                          backgroundImage: NetworkImage(
                            'https://randomuser.me/api/portraits/men/32.jpg',
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          widget.article.author ??
                              StringsConstants.unknownAuthor.tr(),
                          style: FontStyles.font16blackW400,
                        ),
                      ],
                    ),
                  ),

                  // Category and time
                  Padding(
                    padding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 0),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF2F5F9),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            widget.article.source?.name?.toUpperCase() ??
                                'UNKNOWN',
                            style: FontStyles.font12blackW900,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Title
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                    child: Text(
                      widget.article.title ?? StringsConstants.noTitle.tr(),
                      style: FontStyles.font26blackW400.copyWith(
                        height: 1.3,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.w, vertical: 2.h),
                    child: Text(
                      _formatPublishedDate(widget.article.publishedAt),
                      style: FontStyles.font14blackW400.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  // Author info
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Divider(
                      color: Color(0xff141E2814),
                      height: 2,
                      thickness: 2,
                    ),
                  ),
                  // Article content
                  Padding(
                    padding: EdgeInsets.fromLTRB(32.w, 8.h, 32.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.article.description ??
                              StringsConstants.noDescriptionAvailable.tr(),
                          style: FontStyles.font16blackW400.copyWith(
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          widget.article.content ??
                              StringsConstants.noContentAvailable.tr(),
                          style: FontStyles.font16blackW400.copyWith(
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 100.h),
                ],
              ),
            ),
            backgroundColor: Colors.white,
            bottomNavigationBar: SafeArea(
              child: Container(
                height: 58.h,
                width: 193.w,
                margin: EdgeInsets.symmetric(horizontal: 91.w, vertical: 35.h),
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28.r),
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
                child: BottomNavigationBar(
                  enableFeedback: false,
                  currentIndex: 2,
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
                    if (index == 1) {
                      _cubit.toggleBookmark(widget.article);
                    }
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        IconsConstants.chat,
                        colorFilter:
                            ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                      ),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        IconsConstants.bookmarkOutline,
                        colorFilter: ColorFilter.mode(
                          isBookmarked
                              ? ColorsConstants.primaryColor
                              : Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                      activeIcon: SvgPicture.asset(
                        IconsConstants.bookmarkOutline,
                        colorFilter: ColorFilter.mode(
                          ColorsConstants.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        IconsConstants.forward,
                        colorFilter:
                            ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                      ),
                      label: "",
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  String _formatPublishedDate(String? publishedAt) {
    if (publishedAt == null) return '17 June, 2023 — 4:49 PM';

    final date = DateTime.tryParse(publishedAt);
    if (date == null) return '17 June, 2023 — 4:49 PM';

    // Format the date
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$day $month, $year — $hour:$minute $period';
  }
}
