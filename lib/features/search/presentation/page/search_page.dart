import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:xprojects_news_task/core/di/di.dart';
import 'package:xprojects_news_task/core/local_data_source/bookmark_repository.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';
import 'package:xprojects_news_task/features/home/presentation/controller/states/home_states.dart';
import 'package:xprojects_news_task/features/news_details/presentation/controller/cubit/news_details_cubit.dart';
import 'package:xprojects_news_task/features/news_details/presentation/page/news_details_page.dart';
import 'package:xprojects_news_task/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:xprojects_news_task/features/search/presentation/controller/states/search_states.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _trendingTopics = [
    'AI Technology',
    'Climate Change',
    'Space Exploration',
    'Quantum Computing',
    'Renewable Energy'
  ];
  late final SearchCubit _searchCubit;

  @override
  void initState() {
    super.initState();
    _searchCubit = sl<SearchCubit>();
    // Listen to language changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchCubit.listenToLanguageChanges(context);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchCubit,
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search header
                  const SizedBox(height: 40),
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF151C26),
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                      child: Row(
                        children: [
                          // Text field part
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) {
                                  context
                                      .read<SearchCubit>()
                                      .onSearchQueryChanged(value);
                                },
                                onSubmitted: (value) {
                                  context
                                      .read<SearchCubit>()
                                      .searchWithQuery(value);
                                },
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Virtual Reality',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),

                          // Search button
                          GestureDetector(
                            onTap: () => context
                                .read<SearchCubit>()
                                .searchWithQuery(_searchController.text),
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              child: SvgPicture.asset(
                                'assets/icons/search.svg',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Content area
                  Expanded(
                    child: _buildContentArea(state),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContentArea(SearchState state) {
    // Loading state
    if (state.searchState == RequestState.loading) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Results count shimmer
            Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 24.0, 32.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FadeShimmer(
                    height: 26,
                    width: 120,
                    radius: 4,
                    fadeTheme: FadeTheme.light,
                    highlightColor: Colors.grey[300]!,
                    baseColor: Colors.grey[200]!,
                  ),
                  FadeShimmer(
                    height: 24,
                    width: 24,
                    radius: 12,
                    fadeTheme: FadeTheme.light,
                    highlightColor: Colors.grey[300]!,
                    baseColor: Colors.grey[200]!,
                  ),
                ],
              ),
            ),

            // Video cards shimmer
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 32.0, right: 16.0),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    width: 224,
                    margin: const EdgeInsets.only(right: 16.0),
                    child: FadeShimmer(
                      height: 140,
                      width: 224,
                      radius: 16,
                      fadeTheme: FadeTheme.light,
                      highlightColor: Colors.grey[300]!,
                      baseColor: Colors.grey[200]!,
                    ),
                  );
                },
              ),
            ),

            // News section header shimmer
            Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FadeShimmer(
                    height: 26,
                    width: 80,
                    radius: 4,
                    fadeTheme: FadeTheme.light,
                    highlightColor: Colors.grey[300]!,
                    baseColor: Colors.grey[200]!,
                  ),
                  FadeShimmer(
                    height: 24,
                    width: 24,
                    radius: 12,
                    fadeTheme: FadeTheme.light,
                    highlightColor: Colors.grey[300]!,
                    baseColor: Colors.grey[200]!,
                  ),
                ],
              ),
            ),

            // News items shimmer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: List.generate(
                  5,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeShimmer(
                          height: 80,
                          width: 80,
                          radius: 8,
                          fadeTheme: FadeTheme.light,
                          highlightColor: Colors.grey[300]!,
                          baseColor: Colors.grey[200]!,
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                width: MediaQuery.of(context).size.width * 0.6,
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
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Error state
    if (state.searchState == RequestState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Initial state - show recent searches and trending topics
    if (state.searchState == RequestState.initial ||
        state.currentQuery.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recent searches
            if (state.recentSearches.isNotEmpty) ...[
              const Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.recentSearches
                    .map((term) => _buildSearchChip(term))
                    .toList(),
              ),
              const SizedBox(height: 32),
            ],

            // Trending topics
            const Text(
              'Trending Topics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _trendingTopics
                  .map((topic) => _buildSearchChip(topic))
                  .toList(),
            ),
          ],
        ),
      );
    }

    // Loaded state with results
    return SearchResultsView(
      searchResults: state.searchData?.articles ?? [],
    );
  }

  Widget _buildSearchChip(String text) {
    return GestureDetector(
      onTap: () {
        _searchController.text = text;
        context.read<SearchCubit>().searchWithQuery(text);
      },
      child: Chip(
        label: Text(text),
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}

class SearchResultsView extends StatelessWidget {
  final List<ArticleModel>? searchResults;

  const SearchResultsView({
    Key? key,
    required this.searchResults,
  }) : super(key: key);

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
              'No results found',
              style: TextStyle(
                fontSize: 16.0,
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
                  '$videoCount Videos',
                  style: const TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
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
                            title: article.title ?? 'No Title',
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
                  '$newsCount News',
                  style: const TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
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
                          title: article.title ?? 'No Title',
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
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              height: 140,
              width: 224,
              placeholder: (context, url) => FadeShimmer(
                height: 140,
                width: 224,
                radius: 16,
                fadeTheme: FadeTheme.light,
                highlightColor: Colors.grey[300]!,
                baseColor: Colors.grey[200]!,
              ),
              errorWidget: (context, url, error) => Container(
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
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: Colors.black,
          height: 1.3,
        ),
      ),
    );
  }
}
