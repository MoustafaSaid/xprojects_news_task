import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
                    height: 375,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
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
                    padding: const EdgeInsets.all(32),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            'https://randomuser.me/api/portraits/men/32.jpg',
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Text(
                          widget.article.author ?? 'Unknown Author',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Category and time
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6.0,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF2F5F9),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text(
                            widget.article.source?.name?.toUpperCase() ??
                                'UNKNOWN',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 14),
                    child: Text(
                      widget.article.title ?? 'No Title',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 2),
                    child: Text(
                      _formatPublishedDate(widget.article.publishedAt),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // Author info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Divider(
                      color: Color(0xff141E2814),
                      height: 2,
                      thickness: 2,
                    ),
                  ),
                  // Article content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.article.description ??
                              'No description available',
                          style: TextStyle(
                            fontSize: 16.0,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          widget.article.content ?? 'No content available',
                          style: TextStyle(
                            fontSize: 16.0,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100.0),
                ],
              ),
            ),
            backgroundColor: Colors.white,
            bottomNavigationBar: SafeArea(
              child: Container(
                height: 58,
                width: 193,
                margin:
                    const EdgeInsets.symmetric(horizontal: 91, vertical: 35),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
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
