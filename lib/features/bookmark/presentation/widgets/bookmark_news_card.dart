import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xprojects_news_task/core/constants/strings/strings_constants.dart';
import 'package:xprojects_news_task/core/theme/font/font_styles.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';

class BookmarkNewsCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onTap;

  const BookmarkNewsCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h, right: 32.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // News image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r),
              ),
              child:
                  article.urlToImage != null && article.urlToImage!.isNotEmpty
                      ? Image.network(
                          article.urlToImage!,
                          width: 96.w,
                          height: 96.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/icons/tech_image.jpg",
                              width: 96.w,
                              height: 96.h,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          "assets/icons/tech_image.jpg",
                          width: 96.w,
                          height: 96.h,
                          fit: BoxFit.cover,
                        ),
            ),

            // News content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category tag
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Color(0xFFF2F5F9),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        article.source?.name?.toUpperCase() ?? 'UNKNOWN',
                        style: FontStyles.font12blackW900,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // News title
                    Text(
                      article.title ?? StringsConstants.noTitle.tr(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyles.font14blackW800,
                    ),

                    SizedBox(height: 4.h),

                    // Published date
                    Text(
                      _formatPublishedDate(article.publishedAt),
                      style: FontStyles.font12blackW400.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPublishedDate(String? publishedAt) {
    if (publishedAt == null) return StringsConstants.unknown.tr();

    final date = DateTime.tryParse(publishedAt);
    if (date == null) return StringsConstants.unknown.tr();

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return StringsConstants.minutesAgo
          .tr(args: [difference.inMinutes.toString()]);
    } else if (difference.inHours < 24) {
      return StringsConstants.hoursAgo
          .tr(args: [difference.inHours.toString()]);
    } else {
      return StringsConstants.daysAgo.tr(args: [difference.inDays.toString()]);
    }
  }
}
