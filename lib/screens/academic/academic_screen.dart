import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/models/book_model.dart';
import '../books/subject_books_screen.dart';

class AcademicScreen extends StatelessWidget {
  const AcademicScreen({super.key});

  static const _subjects = [
    _SubjectCard(
      title: 'Embedded Systems',
      icon: Icons.memory_rounded,
      gradient: AppColors.tealGradient,
      glowColor: AppColors.teal,
      description: 'Tap to view books',
    ),
    _SubjectCard(
      title: 'Software Engineering',
      icon: Icons.code_rounded,
      gradient: AppColors.purpleGradient,
      glowColor: AppColors.purple,
      description: 'Tap to view books',
    ),
    _SubjectCard(
      title: 'Microprocessors',
      icon: Icons.developer_board_rounded,
      gradient: AppColors.blueGradient,
      glowColor: AppColors.blue,
      description: 'Tap to view books',
    ),
    _SubjectCard(
      title: 'Cryptography',
      icon: Icons.security_rounded,
      gradient: AppColors.goldGradient,
      glowColor: AppColors.gold,
      description: 'Tap to view books',
    ),
    _SubjectCard(
      title: 'Other',
      icon: Icons.category_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF94A3B8), Color(0xFF475569)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      glowColor: const Color(0xFF64748B),
      description: 'Various subjects',
    ),
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
            const SizedBox(height: 28),
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 195,
                ),
                physics: const BouncingScrollPhysics(),
                children: _subjects.map((s) => _SubjectCardWidget(subject: s)).toList(),
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
              AppColors.tealGradient.createShader(bounds),
          child: Text('Academic', style: AppTextStyles.displayMedium),
        ),
        const SizedBox(height: 6),
        Text('Browse textbooks by subject', style: AppTextStyles.bodyMedium),
      ],
    );
  }
}

class _SubjectCard {
  final String title;
  final IconData icon;
  final LinearGradient gradient;
  final Color glowColor;
  final String description;
  const _SubjectCard({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.glowColor,
    required this.description,
  });
}

class _SubjectCardWidget extends StatefulWidget {
  final _SubjectCard subject;
  const _SubjectCardWidget({required this.subject});

  @override
  State<_SubjectCardWidget> createState() => _SubjectCardWidgetState();
}

class _SubjectCardWidgetState extends State<_SubjectCardWidget>
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
    final s = widget.subject;
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SubjectBooksScreen(
              title: s.title,
              genre: s.title,
              category: BookCategory.academic,
              gradient: s.gradient,
              glowColor: s.glowColor,
            ),
          ),
        );
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _ctrl,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: s.glowColor.withOpacity(0.25)),
            boxShadow: [
              BoxShadow(
                color: s.glowColor.withOpacity(0.14),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: s.gradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: s.glowColor.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(s.icon, color: Colors.white, size: 28),
              ),
              const Spacer(),
              Text(s.title,
                  style: AppTextStyles.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(s.description,
                        style: AppTextStyles.bodyMedium,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      color: s.glowColor, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
