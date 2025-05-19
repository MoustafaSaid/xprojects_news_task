abstract class BookmarkState {
  const BookmarkState();
}

class BookmarkInitial extends BookmarkState {
  const BookmarkInitial();
}

class BookmarkLoading extends BookmarkState {
  const BookmarkLoading();
}

class BookmarkSuccess extends BookmarkState {
  final List<dynamic> bookmarkedArticles;

  const BookmarkSuccess({required this.bookmarkedArticles});
}

class BookmarkError extends BookmarkState {
  final String message;

  const BookmarkError({required this.message});
}

class BookmarkRemoveSuccess extends BookmarkState {
  const BookmarkRemoveSuccess();
}
