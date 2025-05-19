import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xprojects_news_task/core/constants/icons/icons_constants.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_events.dart';
import 'package:xprojects_news_task/core/theme/font/font_styles.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';
import 'package:xprojects_news_task/features/home/presentation/controller/cubit/home_cubit.dart';

class FeaturedNewsCard extends StatefulWidget {
  final String category;
  final String title;
  final String imageUrl;
  final String timeAgo;
  final VoidCallback? onTap;
  final ArticleModel article;

  const FeaturedNewsCard({
    super.key,
    required this.category,
    required this.title,
    required this.imageUrl,
    required this.timeAgo,
    required this.article,
    this.onTap,
  });

  @override
  State<FeaturedNewsCard> createState() => _FeaturedNewsCardState();
}

class _FeaturedNewsCardState extends State<FeaturedNewsCard> {
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 311.w,
          height: 311.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Stack(
            children: [
              widget.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.cover,
                      height: 311.h,
                      width: 311.w,
                      placeholder: (context, url) => FadeShimmer(
                        height: 311.h,
                        width: 311.w,
                        radius: 12.r,
                        fadeTheme: FadeTheme.light,
                        highlightColor: Colors.grey[300]!,
                        baseColor: Colors.grey[200]!,
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 311.h,
                        width: 311.w,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image),
                      ),
                    )
                  : Image.asset(
                      IconsConstants.techImage,
                      fit: BoxFit.cover,
                      height: 311.h,
                      width: 311.w,
                    ),
              // Category Label
              Positioned(
                top: 24.h,
                left: 24.w,
                child: Text(
                  widget.category.toUpperCase(),
                  style: FontStyles.font12blackW900.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              // Time Label
              Positioned(
                top: 26.h,
                right: 14.w,
                child: Text(
                  widget.timeAgo,
                  style: FontStyles.font12blackW400.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                  top: 173.h,
                  left: 24.w,
                  right: 24.w,
                  child: Column(
                    children: [
                      Text(
                        widget.title,
                        style: FontStyles.font18blackW800.copyWith(
                          color: Colors.white,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      // Action Buttons
                    ],
                  )),
              Positioned(
                bottom: 24.h,
                left: 24.w,
                right: 24.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildActionButton(IconsConstants.chat),
                        SizedBox(
                          width: 24.w,
                        ),
                        GestureDetector(
                          onTap: _toggleBookmark,
                          child: _buildBookmarkIcon(),
                        ),
                      ],
                    ),
                    _buildActionButton(IconsConstants.forward),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String iconPath) {
    return SvgPicture.asset(
      iconPath,
    );
  }

  Widget _buildBookmarkIcon() {
    return SvgPicture.asset(
      _isBookmarked
          ? IconsConstants.bookmarksIcon
          : IconsConstants.bookmarkOutline,
      colorFilter: _isBookmarked
          ? const ColorFilter.mode(Colors.yellow, BlendMode.srcIn)
          : null,
    );
  }
}
