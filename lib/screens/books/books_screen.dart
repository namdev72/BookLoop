import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/models/book_model.dart';
import '../books/subject_books_screen.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  static const _genres = [
    _GenreCard(emoji: '📖', title: 'Fiction', color: Color(0xFF7C3AED)),
    _GenreCard(emoji: '🔬', title: 'Science', color: Color(0xFF059669)),
    _GenreCard(emoji: '📜', title: 'History', color: Color(0xFFD97706)),
    _GenreCard(emoji: '💡', title: 'Self Help', color: Color(0xFF2563EB)),
    _GenreCard(emoji: '🌌', title: 'Fantasy', color: Color(0xFF7C3AED)),
    _GenreCard(emoji: '🔍', title: 'Mystery', color: Color(0xFFDC2626)),
    _GenreCard(emoji: '💼', title: 'Business', color: Color(0xFF0891B2)),
    _GenreCard(emoji: '🎭', title: 'Biography', color: Color(0xFF65A30D)),
    _GenreCard(emoji: '🌍', title: 'Travel', color: Color(0xFF0569A1)),
    _GenreCard(emoji: '🎨', title: 'Arts', color: Color(0xFFDB2777)),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                physics: const BouncingScrollPhysics(),
                children: _genres.map((g) => _GenreCardWidget(genre: g)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.purpleGradient.createShader(bounds),
          child: Text('Browse Books', style: AppTextStyles.displayMedium),
        ),
        const SizedBox(height: 6),
        Text('Explore books by genre', style: AppTextStyles.bodyMedium),
      ],
    );
  }
}

class _GenreCard {
  final String emoji;
  final String title;
  final Color color;
  const _GenreCard({required this.emoji, required this.title, required this.color});
}

class _GenreCardWidget extends StatefulWidget {
  final _GenreCard genre;
  const _GenreCardWidget({required this.genre});

  @override
  State<_GenreCardWidget> createState() => _GenreCardWidgetState();
}

class _GenreCardWidgetState extends State<_GenreCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.94,
      upperBound: 1.0,
    )..value = 1.0;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.genre;
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SubjectBooksScreen(
              title: g.title,
              genre: g.title,
              category: BookCategory.generic,
              gradient: LinearGradient(
                colors: [g.color, g.color.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              glowColor: g.color,
            ),
          ),
        );
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _ctrl,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: [
                g.color.withOpacity(0.22),
                g.color.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: g.color.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: g.color.withOpacity(0.1),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(g.emoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(height: 10),
              Text(g.title,
                  style: AppTextStyles.titleMedium
                      .copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
