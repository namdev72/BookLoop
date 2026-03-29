import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_model.dart';
import 'package:provider/provider.dart';
import '../../../providers/request_provider.dart';
import '../../../core/models/request_model.dart';

class StatsRow extends StatelessWidget {
  final UserModel user;
  const StatsRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _StatCard(
            title: 'Listed',
            value: '${user.booksListed}',
            icon: '📚',
            gradient: AppColors.greenGradient,
            glowColor: AppColors.green,
          ),
          const SizedBox(width: 12),
          StreamBuilder<List<RequestModel>>(
            stream: context.read<RequestProvider>().getMyRequests(user.uid),
            builder: (ctx, snap) {
              final count = snap.hasData ? '${snap.data!.length}' : '—';
              return _StatCard(
                title: 'Requests',
                value: count,
                icon: '📤',
                gradient: AppColors.blueGradient,
                glowColor: AppColors.blue,
              );
            },
          ),
          const SizedBox(width: 12),
          StreamBuilder<List<RequestModel>>(
            stream: context.read<RequestProvider>().getIncomingRequests(user.uid),
            builder: (ctx, snap) {
              final count = snap.hasData ? '${snap.data!.length}' : '—';
              return _StatCard(
                title: 'Incoming',
                value: count,
                icon: '📥',
                gradient: AppColors.purpleGradient,
                glowColor: AppColors.purple,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  final String title;
  final String value;
  final String icon;
  final LinearGradient gradient;
  final Color glowColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
    required this.glowColor,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..value = 1.0;
    _scaleAnim = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) => _ctrl.forward(),
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          width: 130,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: widget.glowColor.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: widget.gradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: widget.glowColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(widget.icon,
                      style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.value,
                style: AppTextStyles.displayLarge.copyWith(
                  fontSize: 28,
                  color: widget.glowColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(widget.title, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
