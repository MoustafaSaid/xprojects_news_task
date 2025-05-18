import 'package:flutter/material.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xprojects_news_task/core/constants/colors/colors_constants.dart';
import 'package:xprojects_news_task/core/theme/font/font_styles.dart';

class HorizontalNewsCard extends StatelessWidget {
  final String category;
  final String title;
  final String imageUrl;
  final VoidCallback? onTap;
  // final NewsItem newsItem;

  const HorizontalNewsCard({
    super.key,
    required this.category,
    required this.title,
    required this.imageUrl,
    // required this.newsItem,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => FadeShimmer(
                        height: 100,
                        width: 100,
                        radius: 16,
                        fadeTheme: FadeTheme.light,
                        highlightColor: Colors.grey[300]!,
                        baseColor: Colors.grey[200]!,
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image),
                      ),
                    )
                  : Image.asset(
                      "assets/icons/tech_image.jpg",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 24.0),
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
                          category.toUpperCase(),
                          style: FontStyles.font12blackW900.copyWith(
                              color:
                                  ColorsConstants.primaryColorSemitransparent),
                        ),
                      ),
                      // BookmarkButton(
                      //   newsItem: newsItem,
                      //   size: 30,
                      // ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  // Title
                  Text(
                    title,
                    style: FontStyles.font18blackW900,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
