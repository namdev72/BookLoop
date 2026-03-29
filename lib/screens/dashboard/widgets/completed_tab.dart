import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/exchange_model.dart';
import '../../../providers/request_provider.dart';
import '../../../widgets/empty_state.dart';
import 'package:intl/intl.dart';
import '../../chat/chat_screen.dart';

class CompletedTab extends StatelessWidget {
  final String uid;
  const CompletedTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final reqProvider = context.watch<RequestProvider>();

    return StreamBuilder<List<ExchangeModel>>(
      stream: reqProvider.getCompletedExchanges(uid),
      builder: (ctx, snap1) {
        return StreamBuilder<List<ExchangeModel>>(
          stream: reqProvider.getOwnerExchanges(uid),
          builder: (ctx2, snap2) {
            if (snap1.connectionState == ConnectionState.waiting ||
                snap2.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: AppColors.gold));
            }
            final sent = snap1.data ?? [];
            final received = snap2.data ?? [];
            final all = [...sent, ...received];
            all.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            if (all.isEmpty) {
              return const EmptyState(
                icon: '✅',
                title: 'No completed exchanges',
                subtitle: 'Accept an exchange request to see it here',
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              itemCount: all.length,
              itemBuilder: (ctx, i) {
                final ex = all[i];
                final isSent = ex.requesterId == uid;
                return _ExchangeCard(exchange: ex, isSent: isSent);
              },
            );
          },
        );
      },
    );
  }
}

class _ExchangeCard extends StatelessWidget {
  final ExchangeModel exchange;
  final bool isSent;

  const _ExchangeCard({required this.exchange, required this.isSent});

  @override
  Widget build(BuildContext context) {
    final dateStr =
        DateFormat('MMM dd, yyyy').format(exchange.createdAt);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSent
              ? AppColors.blue.withOpacity(0.2)
              : AppColors.green.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: isSent
                ? AppColors.blue.withOpacity(0.05)
                : AppColors.green.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Book cover
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: exchange.bookCoverUrl.isNotEmpty
                    ? Image.network(
                        exchange.bookCoverUrl,
                        width: 56,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _PlaceholderCover(),
                      )
                    : _PlaceholderCover(),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exchange.bookTitle,
                        style: AppTextStyles.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: (isSent ? AppColors.blue : AppColors.green)
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isSent ? '📤 Sent' : '📥 Received',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: isSent ? AppColors.blue : AppColors.green,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(dateStr, style: AppTextStyles.labelSmall),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isSent ? '-' : '+'}${exchange.tokens}',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: isSent ? AppColors.blue : AppColors.green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text('🪙', style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.glassBorder, height: 1),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                      exchange: exchange,
                      currentUserId: isSent ? exchange.requesterId : exchange.ownerId),
                ),
              ),
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14),
              label: const Text('Message'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.teal,
                side: const BorderSide(color: AppColors.teal, width: 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 70,
      decoration: BoxDecoration(
        gradient: AppColors.purpleGradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.book_rounded, color: Colors.white, size: 28),
    );
  }
}
