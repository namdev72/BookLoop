import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/models/book_model.dart';
import '../../providers/book_provider.dart';
import 'book_detail_screen.dart';
import '../../widgets/book_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_skeleton.dart';

class SubjectBooksScreen extends StatelessWidget {
  final String title;
  final String genre;
  final BookCategory category;
  final LinearGradient gradient;
  final Color glowColor;

  const SubjectBooksScreen({
    super.key,
    required this.title,
    required this.genre,
    required this.category,
    required this.gradient,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.glassWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 16),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: gradient),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Text(title,
                        style: AppTextStyles.displayMedium
                            .copyWith(color: Colors.white)),
                    const SizedBox(height: 6),
                    Text(
                      category == BookCategory.academic
                          ? 'Academic Textbooks'
                          : 'Genre: $genre',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
          StreamBuilder<List<BookModel>>(
            stream: bookProvider.getBooksByGenre(genre),
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                    child: GridLoadingSkeleton());
              }
              if (!snap.hasData || snap.data!.isEmpty) {
                return const SliverFillRemaining(
                  child: EmptyState(
                    icon: '📭',
                    title: 'No books yet',
                    subtitle: 'Be the first to list a book in this category!',
                  ),
                );
              }
              final books = snap.data!;
              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 280,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => BookCard(
                      book: books[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BookDetailScreen(book: books[i]),
                        ),
                      ),
                    ),
                    childCount: books.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
