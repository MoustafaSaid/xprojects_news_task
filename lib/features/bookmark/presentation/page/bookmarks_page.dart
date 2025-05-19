import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xprojects_news_task/core/constants/colors/colors_constants.dart';
import 'package:xprojects_news_task/core/di/di.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_repository.dart';
import 'package:xprojects_news_task/core/theme/font/font_styles.dart';
import 'package:xprojects_news_task/features/bookmark/presentation/controller/cubit/bookmark_cubit.dart';
import 'package:xprojects_news_task/features/bookmark/presentation/controller/states/bookmark_states.dart';
import 'package:xprojects_news_task/features/bookmark/presentation/widgets/swipe_to_delete_list.dart';
import 'package:xprojects_news_task/features/news_details/presentation/controller/cubit/news_details_cubit.dart';
import 'package:xprojects_news_task/features/news_details/presentation/page/news_details_page.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  void initState() {
    super.initState();
    // Load bookmarked articles when page is initialized
    context.read<BookmarkCubit>().getBookmarkedArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<BookmarkCubit, BookmarkState>(
          builder: (context, state) {
            if (state is BookmarkLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BookmarkError) {
              return Center(child: Text(state.message));
            }

            final bookmarkCubit = context.read<BookmarkCubit>();

            // Generate collection categories from bookmarked items
            List<Collection> collections = bookmarkCubit
                .getUniqueCategories()
                .map((category) => Collection(
                      title: category.toUpperCase(),
                      imageUrl: _getCategoryImage(category),
                    ))
                .toList();

            // If there are no collections, create default ones
            if (collections.isEmpty) {
              collections = [
                Collection(
                  title: 'SPORTS',
                  imageUrl: 'assets/icons/tech_image.jpg',
                ),
                Collection(
                  title: 'TECH',
                  imageUrl: 'assets/icons/tech_image.jpg',
                ),
              ];
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Collections heading
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                    child: Text(
                      'Collections',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // Collections horizontal list
                  SizedBox(
                    height: 140.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(left: 32.w),
                      itemCount: collections.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(right: 16.w),
                          child: CollectionCard(
                            title: collections[index].title,
                            imageUrl: collections[index].imageUrl,
                            onTap: () {
                              // Navigate to collection details
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  // Latest bookmarks heading
                  Padding(
                    padding: EdgeInsets.fromLTRB(32.w, 40.h, 32.w, 20.h),
                    child: Text(
                      'Latest bookmarks',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // Bookmarked news list
                  bookmarkCubit.bookmarkedItems.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.w),
                            child: Text(
                              'No bookmarks yet. Start adding some!',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      : SwipeToDeleteList(
                          items: bookmarkCubit.bookmarkedItems,
                          onItemRemoved: (item) =>
                              bookmarkCubit.removeBookmark(item),
                          onItemTap: (item) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) =>
                                      NewsDetailsCubit(sl<BookmarkRepository>())
                                        ..loadArticleDetails(item),
                                  child: NewsDetailsPage(article: item),
                                ),
                              ),
                            );
                          },
                        ),

                  // Extra padding for bottom nav bar
                  SizedBox(height: 100.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper function to get image based on category
  String _getCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case 'sports':
        return 'assets/icons/sports_image.jpg';
      case 'technology':
        return 'assets/icons/tech_image.jpg';
      case 'business':
        return 'assets/icons/tech_image.jpg'; // Using tech image for business as fallback
      default:
        return 'assets/icons/background.jpg';
    }
  }
}

// Model for collection items
class Collection {
  final String title;
  final String imageUrl;

  Collection({
    required this.title,
    required this.imageUrl,
  });
}

// Collection card widget
class CollectionCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const CollectionCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140.w,
        height: 140.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Category title
            Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookmarkBottomNavBarWidget extends StatelessWidget {
  const BookmarkBottomNavBarWidget({
    super.key,
  });

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
          currentIndex: 1, // Bookmark is selected
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
            if (index == 0) {
              // Navigate back to home page
              Navigator.pop(context);
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
                  colorFilter: ColorFilter.mode(
                      ColorsConstants.primaryColor, BlendMode.srcIn),
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
                label: ""),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/Notifications Icon.svg',
                  colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/Settings Icon.svg',
                  colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
                label: ""),
          ],
        ),
      ),
    );
  }
}
