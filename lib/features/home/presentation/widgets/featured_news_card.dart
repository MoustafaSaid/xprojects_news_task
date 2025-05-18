import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xprojects_news_task/core/constants/icons/icons_constants.dart';
import 'package:xprojects_news_task/core/theme/font/font_styles.dart';

class FeaturedNewsCard extends StatelessWidget {
  final String category;
  final String title;
  final String imageUrl;
  final String timeAgo;
  final VoidCallback? onTap;

  const FeaturedNewsCard({
    super.key,
    required this.category,
    required this.title,
    required this.imageUrl,
    required this.timeAgo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 311,
          height: 311,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Stack(
            children: [
              imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      height: 311,
                      width: 311,
                      placeholder: (context, url) => FadeShimmer(
                        height: 311,
                        width: 311,
                        radius: 12,
                        fadeTheme: FadeTheme.light,
                        highlightColor: Colors.grey[300]!,
                        baseColor: Colors.grey[200]!,
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 311,
                        width: 311,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image),
                      ),
                    )
                  : Image.asset(
                      IconsConstants.techImage,
                      fit: BoxFit.cover,
                      height: 311,
                      width: 311,
                    ),
              // Category Label
              Positioned(
                top: 24,
                left: 24,
                child: Text(
                  category.toUpperCase(),
                  style: FontStyles.font12blackW900.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              // Time Label
              Positioned(
                top: 26,
                right: 14,
                child: Text(
                  timeAgo,
                  style: FontStyles.font12blackW400.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                  top: 173,
                  left: 24,
                  right: 24,
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: FontStyles.font18blackW800.copyWith(
                          color: Colors.white,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8.0),
                      // Action Buttons
                    ],
                  )),
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildActionButton(IconsConstants.chat),
                        SizedBox(
                          width: 24,
                        ),
                        _buildActionButton(IconsConstants.bookmarkOutline),
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
}
