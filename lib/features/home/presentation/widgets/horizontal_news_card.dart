import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xprojects_news_task/core/constants/colors/colors_constants.dart';
import 'package:xprojects_news_task/core/constants/icons/icons_constants.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_events.dart';
import 'package:xprojects_news_task/core/theme/font/font_styles.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';
import 'package:xprojects_news_task/features/home/presentation/controller/cubit/home_cubit.dart';

class HorizontalNewsCard extends StatefulWidget {
  final String category;
  final String title;
  final String imageUrl;
  final VoidCallback? onTap;
  final ArticleModel article;

  const HorizontalNewsCard({
    super.key,
    required this.category,
    required this.title,
    required this.imageUrl,
    required this.article,
    this.onTap,
  });

  @override
  State<HorizontalNewsCard> createState() => _HorizontalNewsCardState();
}

class _HorizontalNewsCardState extends State<HorizontalNewsCard> {
  bool _isBookmarked = false;
  StreamSubscription? _bookmarkSubscription;
  final BookmarkEvents _bookmarkEvents = BookmarkEvents();

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();

    // Subscribe to bookmark changes
    _bookmarkSubscription = _bookmarkEvents.bookmarkChanges.listen((article) {
      // Check if the changed article is the one in this widget
      if (article.title == widget.article.title &&
          article.url == widget.article.url) {
        _checkIfBookmarked();
      }
    });
  }

  @override
  void dispose() {
    _bookmarkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkIfBookmarked() async {
    final isBookmarked =
        await context.read<HomeCubit>().isArticleBookmarked(widget.article);
    if (mounted) {
      setState(() {
        _isBookmarked = isBookmarked;
      });
    }
  }

  Future<void> _toggleBookmark() async {
    await context.read<HomeCubit>().toggleBookmark(widget.article);
    _checkIfBookmarked();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: widget.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => FadeShimmer(
                        height: 100.h,
                        width: 100.w,
                        radius: 16.r,
                        fadeTheme: FadeTheme.light,
                        highlightColor: Colors.grey[300]!,
                        baseColor: Colors.grey[200]!,
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 100.w,
                        height: 100.h,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image),
                      ),
                    )
                  : Image.asset(
                      "assets/icons/tech_image.jpg",
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(width: 24.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category and Bookmark Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          widget.category.toUpperCase(),
                          style: FontStyles.font12blackW900.copyWith(
                            color: ColorsConstants.primaryColorSemitransparent,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleBookmark,
                        child: SvgPicture.asset(
                          _isBookmarked
                              ? IconsConstants.bookmarksIcon
                              : IconsConstants.bookmarkOutline,
                          colorFilter: _isBookmarked
                              ? const ColorFilter.mode(
                                  Colors.yellow, BlendMode.srcIn)
                              : null,
                          width: 24.w,
                          height: 24.h,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  // Title
                  SizedBox(
                    height: 67.h,
                    child: Text(
                      widget.title,
                      style: FontStyles.font18blackW900.copyWith(
                        letterSpacing: 0,
                        height: 1,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
