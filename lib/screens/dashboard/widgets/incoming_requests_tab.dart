import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/request_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/request_provider.dart';
import '../../chat/chat_screen.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/request_card.dart';

class IncomingRequestsTab extends StatelessWidget {
  final String uid;
  const IncomingRequestsTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final reqProvider = context.watch<RequestProvider>();
    return StreamBuilder<List<RequestModel>>(
      stream: reqProvider.getIncomingRequests(uid),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.gold));
        }
        if (!snap.hasData || snap.data!.isEmpty) {
          return const EmptyState(
            icon: '📥',
            title: 'No incoming requests',
            subtitle: 'When someone requests your book, it will appear here',
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
              showOwnerView: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Message
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ChatScreen(request: req, currentUserId: uid),
                      ),
                    ),
                    icon: const Icon(Icons.chat_bubble_outline_rounded,
                        color: AppColors.teal, size: 20),
                    tooltip: 'Message',
                  ),
                  // Reject
                  GestureDetector(
                    onTap: () => _confirmReject(context, reqProvider, req.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.rejected.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.rejected.withOpacity(0.4)),
                      ),
                      child: Text('❌ Reject',
                          style: AppTextStyles.labelLarge
                              .copyWith(color: AppColors.rejected, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Accept
                  GestureDetector(
                    onTap: () => _confirmAccept(context, reqProvider, req),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: AppColors.greenGradient,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.green.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text('✅ Accept',
                          style: AppTextStyles.labelLarge
                              .copyWith(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmAccept(
      BuildContext context, RequestProvider provider, RequestModel req) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Accept Exchange?', style: AppTextStyles.headlineMedium),
        content: Text(
          '${req.requesterName} will send you ${req.tokenPrice} 🪙 tokens for "${req.bookTitle}".\n\nThis cannot be undone.',
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
              final success = await provider.acceptRequest(req);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: success
                        ? AppColors.accepted
                        : AppColors.rejected,
                    content: Text(
                      success
                          ? '✅ Exchange accepted! ${req.tokenPrice} tokens added.'
                          : 'Failed to accept request.',
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
            child: Text('Accept',
                style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmReject(
      BuildContext context, RequestProvider provider, String requestId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Reject Request?', style: AppTextStyles.headlineMedium),
        content: Text('The book will remain available for others.',
            style: AppTextStyles.bodyMedium),
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
              await provider.rejectRequest(requestId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rejected,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Reject',
                style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
