import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:xprojects_news_task/core/theme/font/font_styles.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';
import 'package:xprojects_news_task/features/home/presentation/controller/cubit/home_cubit.dart';
import 'package:xprojects_news_task/features/home/presentation/controller/states/home_states.dart';
import 'package:xprojects_news_task/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:xprojects_news_task/features/home/presentation/widgets/featured_news_card.dart';
import 'package:xprojects_news_task/features/home/presentation/widgets/horizontal_news_card.dart';

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
    // Fetch news when page is initialized
    context.read<HomeCubit>().getNews();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.newsState == RequestState.loaded && state.newsData != null) {
          if (state.newsData!.articles != null) {
            setState(() {
              final articles = state.newsData!.articles!;
              if (articles.length > 3) {
                _featuredNews = articles.sublist(0, 3);
                _latestNews = articles.sublist(3);
              } else {
                _featuredNews = articles;
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
                        const SizedBox(height: 32.0),

                        // Featured news shimmer
                        SizedBox(
                          height: 311,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.only(left: 32.0, right: 32),
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: index == 0 ? 0 : 16.0),
                                child: FadeShimmer(
                                  height: 311,
                                  width: 311,
                                  radius: 12,
                                  fadeTheme: FadeTheme.light,
                                  highlightColor: Colors.grey[300]!,
                                  baseColor: Colors.grey[200]!,
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 40.0),

                        // Latest News section header shimmer
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FadeShimmer(
                                height: 24,
                                width: 120,
                                radius: 4,
                                fadeTheme: FadeTheme.light,
                                highlightColor: Colors.grey[300]!,
                                baseColor: Colors.grey[200]!,
                              ),
                              FadeShimmer(
                                height: 16,
                                width: 60,
                                radius: 4,
                                fadeTheme: FadeTheme.light,
                                highlightColor: Colors.grey[300]!,
                                baseColor: Colors.grey[200]!,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 23),

                        // Latest news list shimmer
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 24.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FadeShimmer(
                                      height: 100,
                                      width: 100,
                                      radius: 16,
                                      fadeTheme: FadeTheme.light,
                                      highlightColor: Colors.grey[300]!,
                                      baseColor: Colors.grey[200]!,
                                    ),
                                    const SizedBox(width: 24.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FadeShimmer(
                                            height: 12,
                                            width: 80,
                                            radius: 4,
                                            fadeTheme: FadeTheme.light,
                                            highlightColor: Colors.grey[300]!,
                                            baseColor: Colors.grey[200]!,
                                          ),
                                          const SizedBox(height: 8.0),
                                          FadeShimmer(
                                            height: 16,
                                            width: double.infinity,
                                            radius: 4,
                                            fadeTheme: FadeTheme.light,
                                            highlightColor: Colors.grey[300]!,
                                            baseColor: Colors.grey[200]!,
                                          ),
                                          const SizedBox(height: 8.0),
                                          FadeShimmer(
                                            height: 16,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            radius: 4,
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
                  // padding: const EdgeInsets.only(
                  //     bottom: 80), // Add padding for bottom nav bar
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32.0),

                      // Featured news horizontal slider
                      SizedBox(
                        height: 311,
                        child: _featuredNews.isEmpty
                            ? Center(
                                child: Text(
                                'No featured news available',
                                style: FontStyles.font16blackW400,
                              ))
                            : ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.only(
                                    left: 32.0, right: 32),
                                itemCount: _featuredNews.length,
                                itemBuilder: (context, index) {
                                  final article = _featuredNews[index];
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: index == 0 ? 0 : 16.0),
                                    child: FeaturedNewsCard(
                                      category:
                                          article.source?.name ?? 'Unknown',
                                      title: article.title ?? 'No title',
                                      imageUrl: article.urlToImage ?? '',
                                      timeAgo: _formatPublishedDate(
                                          article.publishedAt),
                                      article: article,
                                      onTap: () {
                                        // Handle tap action here
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),

                      const SizedBox(height: 40.0),

                      // Latest News section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: buildSectionHeader('Latest News'),
                      ),
                      SizedBox(
                        height: 23,
                      ),
                      // Latest news list
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                                    onTap: () {
                                      // Handle tap action here
                                    },
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
        bottomNavigationBar: CustomBottomNavBarWidget(),
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

class CustomBottomNavBarWidget extends StatelessWidget {
  const CustomBottomNavBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 58,
        width: 287,
        margin: EdgeInsets.symmetric(horizontal: 44, vertical: 35),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
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
          // color: Colors.red,
        ),
        child: BottomNavigationBar(
          enableFeedback: false,
          currentIndex: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.black,
          unselectedLabelStyle: FontStyles.font12blackW400.copyWith(
            color: Colors.grey,
          ),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: FontStyles.font12blackW400.copyWith(
            color: Colors.blue,
          ),
          // backgroundColor: ColorsConstants.white,
          backgroundColor: Colors.transparent,
          onTap: (index) {
            // Simplified navigation logic without actual pages
          },
          items: [
            BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                  'assets/icons/Home Icon.svg',
                  // colorFilter: ColorFilter.mode(
                  //     layoutCubit.bottomNavIndex == 0
                  //         ? ColorsConstants.mainColor
                  //         : Colors.grey,
                  //     BlendMode.srcIn),
                ),
                icon: SvgPicture.asset(
                  'assets/icons/Home Icon.svg',
                  // colorFilter: ColorFilter.mode(
                  //     layoutCubit.bottomNavIndex == 0
                  //         ? ColorsConstants.mainColor
                  //         : Colors.grey,
                  //     BlendMode.srcIn),
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/Bookmarks Icon.svg',
                  // colorFilter: ColorFilter.mode(
                  //     layoutCubit.bottomNavIndex == 1
                  //         ? ColorsConstants.mainColor
                  //         : Colors.grey,
                  //     BlendMode.srcIn)),
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/Search Icon.svg',
                  // colorFilter: ColorFilter.mode(
                  //     layoutCubit.bottomNavIndex == 1
                  //         ? ColorsConstants.mainColor
                  //         : Colors.grey,
                  //     BlendMode.srcIn)),
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/Notifications Icon.svg',
                  // colorFilter: ColorFilter.mode(
                  //     layoutCubit.bottomNavIndex == 1
                  //         ? ColorsConstants.mainColor
                  //         : Colors.grey,
                  //     BlendMode.srcIn)),
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/Settings Icon.svg',
                  // colorFilter: ColorFilter.mode(
                  //     layoutCubit.bottomNavIndex == 1
                  //         ? ColorsConstants.mainColor
                  //         : Colors.grey,
                  //     BlendMode.srcIn)),
                ),
                label: ""),
          ],
        ),
      ),
    );
  }
}
