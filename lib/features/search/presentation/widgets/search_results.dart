import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xprojects_news_task/core/constants/strings/strings_constants.dart';
import 'package:xprojects_news_task/core/theme/font/font_styles.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';
import 'package:xprojects_news_task/features/news_details/presentation/page/news_details_page.dart';
import 'package:xprojects_news_task/features/news_details/presentation/controller/cubit/news_details_cubit.dart';
import 'package:xprojects_news_task/core/di/di.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_repository.dart';

class SearchResults extends StatelessWidget {
  final List<ArticleModel>? searchResults;

  const SearchResults({
    Key? key,
    required this.searchResults,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (searchResults == null || searchResults!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/Search Icon.svg',
              width: 64,
              height: 64,
              colorFilter: ColorFilter.mode(Colors.grey[300]!, BlendMode.srcIn),
            ),
            const SizedBox(height: 24.0),
            Text(
              StringsConstants.noResultsFound.tr(),
              style: FontStyles.font16blackW400.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // Calculate counts
    final videoCount =
        searchResults!.where((article) => article.urlToImage != null).length;
    final newsCount = searchResults!.length;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Videos Section
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 24.0, 32.0, 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StringsConstants.videosCount
                      .tr(args: [videoCount.toString()]),
                  style: FontStyles.font26blackW400,
                ),
                SvgPicture.asset(
                  'assets/icons/arrow-forward-circle-outline.svg',
                ),
              ],
            ),
          ),

          // Video cards horizontal scroll if we have images
          if (videoCount > 0) ...[
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 32.0, right: 16.0),
                children: searchResults!
                    .where((article) => article.urlToImage != null)
                    .take(5)
                    .map((article) => GestureDetector(
                          onTap: () => _navigateToNewsDetails(context, article),
                          child: VideoCard(
                            imageUrl: article.urlToImage!,
                            title:
                                article.title ?? StringsConstants.noTitle.tr(),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],

          // News Section
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StringsConstants.newsCount.tr(args: [newsCount.toString()]),
                  style: FontStyles.font26blackW400,
                ),
                SvgPicture.asset(
                  'assets/icons/arrow-forward-circle-outline.svg',
                ),
              ],
            ),
          ),

          // News items list
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: searchResults!
                  .map((article) => GestureDetector(
                        onTap: () => _navigateToNewsDetails(context, article),
                        child: NewsItemWidget(
                          title: article.title ?? StringsConstants.noTitle.tr(),
                        ),
                      ))
                  .toList(),
            ),
          ),

          // Extra padding at bottom
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }

  void _navigateToNewsDetails(BuildContext context, ArticleModel article) {
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
}

class VideoCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const VideoCard({
    Key? key,
    required this.imageUrl,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 224,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Stack(
        children: [
          // Image with shimmer loading
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 140,
              width: 224,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 140,
                width: 224,
                color: Colors.grey[300],
                child: const Icon(Icons.image),
              ),
            ),
          ),

          // Play button
          Positioned(
            top: 16.0,
            left: 16.0,
            child: Center(
              child: SvgPicture.asset("assets/icons/play.svg"),
            ),
          ),

          // Video title
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: SizedBox(
              width: 192,
              child: Text(
                title,
                maxLines: 2,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewsItemWidget extends StatelessWidget {
  final String title;

  const NewsItemWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Text(
        title,
        style: FontStyles.font16blackW400.copyWith(
          height: 1.3,
        ),
      ),
    );
  }
}
