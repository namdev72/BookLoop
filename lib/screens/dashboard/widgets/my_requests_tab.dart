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
              trailing: OutlinedButton.icon(
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
            );
          },
        );
      },
    );
  }
}
