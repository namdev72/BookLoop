import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../core/models/request_model.dart';
import 'package:intl/intl.dart';

class RequestCard extends StatelessWidget {
  final RequestModel request;
  final bool showStatus;
  final bool showOwnerView;
  final Widget? trailing;

  const RequestCard({
    super.key,
    required this.request,
    this.showStatus = false,
    this.showOwnerView = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM dd').format(request.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Cover
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: request.bookCoverUrl.isNotEmpty
                    ? Image.network(
                        request.bookCoverUrl,
                        width: 52,
                        height: 66,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _fallbackCover(),
                      )
                    : _fallbackCover(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.bookTitle,
                      style: AppTextStyles.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      showOwnerView
                          ? 'From: ${request.requesterName}'
                          : 'Owner: ${request.ownerName}',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('🪙 ${request.tokenPrice} tokens',
                            style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.gold, fontSize: 12)),
                        const Spacer(),
                        Text(dateStr, style: AppTextStyles.labelSmall),
                      ],
                    ),
                    if (showStatus) ...[
                      const SizedBox(height: 6),
                      _StatusBadge(status: request.status),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (trailing != null) ...[
            const SizedBox(height: 12),
            const Divider(color: AppColors.glassBorder, height: 1),
            const SizedBox(height: 10),
            Align(alignment: Alignment.centerRight, child: trailing!),
          ],
        ],
      ),
    );
  }

  Widget _fallbackCover() {
    return Container(
      width: 52,
      height: 66,
      decoration: BoxDecoration(
        gradient: AppColors.purpleGradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.book_rounded, color: Colors.white, size: 26),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final RequestStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case RequestStatus.pending:
        color = AppColors.pending;
        label = '⏳ Pending';
        break;
      case RequestStatus.accepted:
        color = AppColors.accepted;
        label = '✅ Accepted';
        break;
      case RequestStatus.rejected:
        color = AppColors.rejected;
        label = '❌ Rejected';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label,
          style: AppTextStyles.labelSmall.copyWith(color: color)),
    );
  }
}
