import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class GridLoadingSkeleton extends StatefulWidget {
  const GridLoadingSkeleton({super.key});

  @override
  State<GridLoadingSkeleton> createState() => _GridLoadingSkeletonState();
}

class _GridLoadingSkeletonState extends State<GridLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (ctx, _) {
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.62,
          ),
          itemCount: 6,
          itemBuilder: (ctx, i) => Container(
            decoration: BoxDecoration(
              color: Color.lerp(
                AppColors.cardDark,
                AppColors.cardLight,
                _anim.value,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        );
      },
    );
  }
}
