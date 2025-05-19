import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xprojects_news_task/features/bookmark/presentation/widgets/bookmark_news_card.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';

class SwipeToDeleteList extends StatelessWidget {
  final List<ArticleModel> items;
  final Function(ArticleModel) onItemTap;
  final Function(ArticleModel) onItemRemoved;

  const SwipeToDeleteList({
    Key? key,
    required this.items,
    required this.onItemTap,
    required this.onItemRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 32.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final newsItem = items[index];
        return _buildSwipeToDeleteItem(newsItem);
      },
    );
  }

  Widget _buildSwipeToDeleteItem(ArticleModel newsItem) {
    return Dismissible(
      key: Key(newsItem.title ?? ''),
      direction: DismissDirection.endToStart,
      background: _buildDeleteBackground(),
      confirmDismiss: (_) async {
        onItemRemoved(newsItem);
        return true;
      },
      child: BookmarkNewsCard(
        article: newsItem,
        onTap: () => onItemTap(newsItem),
      ),
    );
  }

  // Background that shows when user swipes to delete
  Widget _buildDeleteBackground() {
    return Container(
      height: 132,
      color: Color(0xff141E280A),
      margin: EdgeInsets.only(bottom: 24.0),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(
        right: 24.0,
      ),
      child: SvgPicture.asset("assets/icons/close-circle-outline.svg"),
    );
  }
}
