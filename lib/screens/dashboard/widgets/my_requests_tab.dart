import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/request_model.dart';
import '../../../providers/request_provider.dart';
import '../../chat/chat_screen.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/request_card.dart';

class MyRequestsTab extends StatelessWidget {
  final String uid;
  const MyRequestsTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final reqProvider = context.watch<RequestProvider>();
    return StreamBuilder<List<RequestModel>>(
      stream: reqProvider.getMyRequests(uid),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.gold));
        }
        if (!snap.hasData || snap.data!.isEmpty) {
          return const EmptyState(
            icon: '📤',
            title: 'No outgoing requests',
            subtitle: 'Browse books and request an exchange to get started',
          );
        }
        final requests = snap.data!;
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          itemCount: requests.length,
          itemBuilder: (ctx, i) {
            final req = requests[i];
            return RequestCard(
              request: req,
              showStatus: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(request: req, currentUserId: uid),
                      ),
                    ),
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14),
                    label: const Text('Message'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.teal,
                      side: const BorderSide(color: AppColors.teal, width: 1),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  if (req.status == RequestStatus.accepted) ...[
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _confirmExchange(context, reqProvider, req),
                      icon: const Icon(Icons.handshake_rounded, size: 14),
                      label: const Text('Exchange'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmExchange(
      BuildContext context, RequestProvider provider, RequestModel req) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Your request is accepted', style: AppTextStyles.headlineMedium),
        content: Text(
          'Click exchange to complete the transaction.\n\n${req.tokenPrice} 🪙 tokens will be deducted from your account and the book will be marked as exchanged.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: AppTextStyles.labelLarge
                    .copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await provider.completeExchange(req);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: success
                        ? AppColors.accepted
                        : AppColors.rejected,
                    content: Text(
                      success
                          ? '✅ Exchange completed!'
                          : provider.error ?? 'Failed to complete exchange.',
                      style: AppTextStyles.labelLarge
                          .copyWith(color: Colors.white),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Exchange',
                style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
