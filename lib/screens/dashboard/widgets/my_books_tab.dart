import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/book_model.dart';
import '../../../providers/book_provider.dart';
import '../../books/book_detail_screen.dart';
import '../../../widgets/book_card.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/loading_skeleton.dart';

class MyBooksTab extends StatelessWidget {
  final String uid;
  const MyBooksTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    return StreamBuilder<List<BookModel>>(
      stream: bookProvider.getUserBooks(uid),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const GridLoadingSkeleton();
        }
        if (!snap.hasData || snap.data!.isEmpty) {
          return const EmptyState(
            icon: '📚',
            title: 'No books listed yet',
            subtitle: 'Tap "List a Book" to share your first book',
          );
        }
        final books = snap.data!;
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 280,
          ),
          itemCount: books.length,
          itemBuilder: (ctx, i) => BookCard(
            book: books[i],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookDetailScreen(book: books[i]),
              ),
            ),
          ),
        );
      },
    );
  }
}
