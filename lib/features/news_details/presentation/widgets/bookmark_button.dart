import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xprojects_news_task/features/home/data/models/news_response_model.dart';
import 'package:xprojects_news_task/features/home/presentation/controller/cubit/home_cubit.dart';

class BookmarkButton extends StatefulWidget {
  final ArticleModel article;
  final Color? backgroundColor;
  final double size;

  const BookmarkButton({
    super.key,
    required this.article,
    this.backgroundColor,
    this.size = 40,
  });

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            _isBookmarked ? 'Removed from bookmarks' : 'Added to bookmarks'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleBookmark,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Color(0xFFF2F5F9),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/Bookmarks Icon.svg',
            width: widget.size * 0.45,
            height: widget.size * 0.45,
            colorFilter: ColorFilter.mode(
              _isBookmarked ? Colors.black : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
