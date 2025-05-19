import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xprojects_news_task/core/constants/colors/colors_constants.dart';
import 'package:xprojects_news_task/core/di/di.dart';
import 'package:xprojects_news_task/core/theme/font/font_styles.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_repository.dart';
import 'package:xprojects_news_task/features/bookmark/presentation/controller/cubit/bookmark_cubit.dart';
import 'package:xprojects_news_task/features/bookmark/presentation/page/bookmarks_page.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';
import 'package:xprojects_news_task/features/home/presentation/controller/cubit/home_cubit.dart';
import 'package:xprojects_news_task/features/home/presentation/controller/states/home_states.dart';
import 'package:xprojects_news_task/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:xprojects_news_task/features/home/presentation/widgets/featured_news_card.dart';
import 'package:xprojects_news_task/features/home/presentation/widgets/horizontal_news_card.dart';
import 'package:xprojects_news_task/features/news_details/presentation/controller/cubit/news_details_cubit.dart';
import 'package:xprojects_news_task/features/news_details/presentation/page/news_details_page.dart';
import 'package:xprojects_news_task/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:xprojects_news_task/features/search/presentation/page/search_page.dart';
import 'package:xprojects_news_task/features/settings/presentation/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ArticleModel> _featuredNews = [];
  List<ArticleModel> _latestNews = [];

  @override
  void initState() {
    super.initState();
    // Listen to language changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().listenToLanguageChanges(context);
    });
    // Fetch news when page is initialized
    context.read<HomeCubit>().getNews();
  }

  // Navigate to news details page
  void _navigateToNewsDetails(ArticleModel article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => NewsDetailsCubit(sl<BookmarkRepository>())
            ..loadArticleDetails(article),
          child: NewsDetailsPage(article: article),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.newsState == RequestState.loaded && state.newsData != null) {
          if (state.newsData!.articles != null) {
            setState(() {
              final articles = state.newsData?.articles ?? [];
              if (articles.length > 0) {
                _featuredNews = articles;
                _latestNews = articles;
              } else {
                _featuredNews = [];
                _latestNews = [];
              }
            });
          }
        }
      },
      child: Scaffold(
        extendBody:
            true, // Key property to extend content behind bottom nav bar
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(),
        body: Stack(
          children: [
            // Main content
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state.newsState == RequestState.loading) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 32.h),

                        // Featured news shimmer
                        SizedBox(
                          height: 311.h,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(left: 32.w, right: 32.w),
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: index == 0 ? 0 : 16.w),
                                child: FadeShimmer(
                                  height: 311.h,
                                  width: 311.w,
                                  radius: 12.r,
                                  fadeTheme: FadeTheme.light,
                                  highlightColor: Colors.grey[300]!,
                                  baseColor: Colors.grey[200]!,
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // Latest News section header shimmer
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FadeShimmer(
                                height: 24.h,
                                width: 120.w,
                                radius: 4.r,
                                fadeTheme: FadeTheme.light,
                                highlightColor: Colors.grey[300]!,
                                baseColor: Colors.grey[200]!,
                              ),
                              FadeShimmer(
                                height: 16.h,
                                width: 60.w,
                                radius: 4.r,
                                fadeTheme: FadeTheme.light,
                                highlightColor: Colors.grey[300]!,
                                baseColor: Colors.grey[200]!,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 23.h),

                        // Latest news list shimmer
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 24.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FadeShimmer(
                                      height: 100.h,
                                      width: 100.w,
                                      radius: 16.r,
                                      fadeTheme: FadeTheme.light,
                                      highlightColor: Colors.grey[300]!,
                                      baseColor: Colors.grey[200]!,
                                    ),
                                    SizedBox(width: 24.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FadeShimmer(
                                            height: 12.h,
                                            width: 80.w,
                                            radius: 4.r,
                                            fadeTheme: FadeTheme.light,
                                            highlightColor: Colors.grey[300]!,
                                            baseColor: Colors.grey[200]!,
                                          ),
                                          SizedBox(height: 8.h),
                                          FadeShimmer(
                                            height: 16.h,
                                            width: double.infinity,
                                            radius: 4.r,
                                            fadeTheme: FadeTheme.light,
                                            highlightColor: Colors.grey[300]!,
                                            baseColor: Colors.grey[200]!,
                                          ),
                                          SizedBox(height: 8.h),
                                          FadeShimmer(
                                            height: 16.h,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            radius: 4.r,
                                            fadeTheme: FadeTheme.light,
                                            highlightColor: Colors.grey[300]!,
                                            baseColor: Colors.grey[200]!,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state.newsState == RequestState.error) {
                  return Center(
                      child: Text(
                    state.message,
                    style: FontStyles.font16blackW400,
                  ));
                }

                // The original UI structure is maintained
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32.h),

                      // Featured news horizontal slider
                      SizedBox(
                        height: 311.h,
                        child: _featuredNews.isEmpty
                            ? Center(
                                child: Text(
                                'No featured news available',
                                style: FontStyles.font16blackW400,
                              ))
                            : ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                padding:
                                    EdgeInsets.only(left: 32.w, right: 32.w),
                                itemCount: _featuredNews.length,
                                itemBuilder: (context, index) {
                                  final article = _featuredNews[index];
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: index == 0 ? 0 : 16.w),
                                    child: FeaturedNewsCard(
                                      category:
                                          article.source?.name ?? 'Unknown',
                                      title: article.title ?? 'No title',
                                      imageUrl: article.urlToImage ?? '',
                                      timeAgo: _formatPublishedDate(
                                          article.publishedAt),
                                      article: article,
                                      onTap: () =>
                                          _navigateToNewsDetails(article),
                                    ),
                                  );
                                },
                              ),
                      ),

                      SizedBox(height: 40.h),

                      // Latest News section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: buildSectionHeader('Latest News'),
                      ),
                      SizedBox(height: 23.h),
                      // Latest news list
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: _latestNews.isEmpty
                            ? Center(
                                child: Text(
                                'No latest news available',
                                style: FontStyles.font16blackW400,
                              ))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _latestNews.length,
                                itemBuilder: (context, index) {
                                  final article = _latestNews[index];
                                  return HorizontalNewsCard(
                                    category: article.source?.name ?? 'Unknown',
                                    title: article.title ?? 'No title',
                                    imageUrl: article.urlToImage ?? '',
                                    article: article,
                                    onTap: () =>
                                        _navigateToNewsDetails(article),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        // bottomNavigationBar: CustomBottomNavBarWidget(),
      ),
    );
  }

  // Helper method to build section header
  Widget buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: FontStyles.font22blackW800,
        ),
        TextButton(
          onPressed: () {
            // Handle see all action
          },
          child: Text(
            'See All',
            style: FontStyles.font14blackW400,
          ),
        ),
      ],
    );
  }

  String _formatPublishedDate(String? publishedAt) {
    if (publishedAt == null) return 'Unknown';

    final date = DateTime.tryParse(publishedAt);
    if (date == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}

class CustomBottomNavBarWidget extends StatefulWidget {
  const CustomBottomNavBarWidget({
    super.key,
  });

  @override
  State<CustomBottomNavBarWidget> createState() =>
      _CustomBottomNavBarWidgetState();
}

class _CustomBottomNavBarWidgetState extends State<CustomBottomNavBarWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 58.h,
        width: 287.w,
        margin: EdgeInsets.symmetric(horizontal: 44.w, vertical: 35.h),
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
          currentIndex: _currentIndex,
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
            setState(() {
              _currentIndex = index;
            });

            if (index == 1) {
              // Navigate to Bookmarks page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: sl<BookmarkCubit>(),
                    child: BookmarksPage(),
                  ),
                ),
              ).then((_) {
                // Reset current index to 0 when returning from bookmarks
                setState(() {
                  _currentIndex = 0;
                });
              });
            } else if (index == 2) {
              // Navigate to Search page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => sl<SearchCubit>(),
                    child: const SearchPage(),
                  ),
                ),
              ).then((_) {
                // Reset current index to 0 when returning from search
                setState(() {
                  _currentIndex = 0;
                });
              });
            } else if (index == 3) {
              // Navigate to Settings page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              ).then((_) {
                // Reset current index to 0 when returning from settings
                setState(() {
                  _currentIndex = 0;
                });
              });
            }
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
                label: ""),
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
                label: ""),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/Search Icon.svg',
                  colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
                activeIcon: SvgPicture.asset(
                  'assets/icons/Search Icon.svg',
                  colorFilter: ColorFilter.mode(
                      ColorsConstants.primaryColor, BlendMode.srcIn),
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/Settings Icon.svg',
                  colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
                activeIcon: SvgPicture.asset(
                  'assets/icons/Settings Icon.svg',
                  colorFilter: ColorFilter.mode(
                      ColorsConstants.primaryColor, BlendMode.srcIn),
                ),
                label: ""),
          ],
        ),
      ),
    );
  }
}
