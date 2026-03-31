import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/models/book_model.dart';
import '../../providers/book_provider.dart';
import '../../widgets/book_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_skeleton.dart';
import '../books/book_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();

    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: StreamBuilder<List<BookModel>>(
              stream: bookProvider.getAvailableBooks(),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: GridLoadingSkeleton(),
                  );
                }
                if (!snap.hasData || snap.data!.isEmpty) {
                  return const EmptyState(
                    icon: '📚',
                    title: 'No books available',
                    subtitle: 'Check back later for new books!',
                  );
                }

                final allBooks = snap.data!;
                final filteredBooks = allBooks.where((book) {
                  final query = _searchQuery.toLowerCase();
                  return book.title.toLowerCase().contains(query) ||
                      book.author.toLowerCase().contains(query);
                }).toList();

                if (filteredBooks.isEmpty) {
                  return const EmptyState(
                    icon: '🔍',
                    title: 'No results found',
                    subtitle: 'Try searching for something else.',
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 280,
                  ),
                  itemCount: filteredBooks.length,
                  itemBuilder: (ctx, i) => BookCard(
                    book: filteredBooks[i],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailScreen(book: filteredBooks[i]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 80, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.purpleGradient.createShader(bounds),
            child: Text('Discover Books', style: AppTextStyles.displayMedium),
          ),
          const SizedBox(height: 4),
          Text('Find your next favorite read', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 24),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search by title or author',
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.purple, size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: _searchQuery.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  child: const Icon(Icons.close_rounded, color: AppColors.textSecondary, size: 20),
                )
              : null,
        ),
      ),
    );
  }
}
