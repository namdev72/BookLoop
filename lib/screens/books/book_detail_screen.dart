import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/models/book_model.dart';
import '../../core/models/request_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/request_provider.dart';

class BookDetailScreen extends StatelessWidget {
  final BookModel book;
  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final isOwner = user?.uid == book.ownerId;
    final isAvailable = book.status == BookStatus.available;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero header with cover
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.glassWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 16),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  book.coverUrl.isNotEmpty
                      ? Image.network(book.coverUrl, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _gradientFallback())
                      : _gradientFallback(),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.background,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title, style: AppTextStyles.displayMedium),
                  const SizedBox(height: 8),
                  Text('by ${book.author}',
                      style: AppTextStyles.bodyLarge
                          .copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 20),
                  _buildInfoRow(book),
                  const SizedBox(height: 20),
                  _buildOwnerCard(book),
                  const SizedBox(height: 28),
                  if (!isOwner && isAvailable && user != null)
                    _RequestButton(book: book, user: user),
                  if (!isAvailable)
                    _buildExchangedBanner(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradientFallback() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.purpleGradient),
      child: const Center(
        child: Icon(Icons.book_rounded, color: Colors.white54, size: 80),
      ),
    );
  }

  Widget _buildInfoRow(BookModel book) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _InfoChip(
          label: '🪙 ${book.tokenPrice} tokens',
          color: AppColors.gold,
        ),
        _InfoChip(
          label: '📦 ${book.conditionLabel}',
          color: AppColors.teal,
        ),
        _InfoChip(
          label: book.category == BookCategory.academic
              ? '🎓 Academic'
              : '📚 General',
          color: AppColors.purple,
        ),
        _InfoChip(
          label: '🏷 ${book.genre}',
          color: AppColors.blue,
        ),
      ],
    );
  }

  Widget _buildOwnerCard(BookModel book) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColors.tealGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                book.ownerName.isNotEmpty
                    ? book.ownerName[0].toUpperCase()
                    : '?',
                style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Listed by', style: AppTextStyles.bodyMedium),
              Text(book.ownerName, style: AppTextStyles.titleMedium),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExchangedBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accepted.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accepted.withOpacity(0.3)),
      ),
      child: Text(
        '✅ This book has been exchanged',
        style: AppTextStyles.titleMedium.copyWith(color: AppColors.accepted),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  const _InfoChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label,
          style:
              AppTextStyles.labelLarge.copyWith(color: color, fontSize: 12)),
    );
  }
}

class _RequestButton extends StatefulWidget {
  final BookModel book;
  final dynamic user;
  const _RequestButton({required this.book, required this.user});

  @override
  State<_RequestButton> createState() => _RequestButtonState();
}

class _RequestButtonState extends State<_RequestButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final reqProvider = context.watch<RequestProvider>();

    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: _loading ? null : () => _request(context, reqProvider),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppColors.tealGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: _loading
                ? const CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2)
                : Text(
                    '🔄 Request Exchange',
                    style: AppTextStyles.titleLarge
                        .copyWith(color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _request(BuildContext context, RequestProvider provider) async {
    setState(() => _loading = true);
    final req = RequestModel(
      id: '',
      bookId: widget.book.id,
      bookTitle: widget.book.title,
      bookCoverUrl: widget.book.coverUrl,
      tokenPrice: widget.book.tokenPrice,
      requesterId: widget.user.uid,
      requesterName: widget.user.name,
      ownerId: widget.book.ownerId,
      ownerName: widget.book.ownerName,
      createdAt: DateTime.now(),
    );
    final success = await provider.createRequest(req);
    setState(() => _loading = false);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              success ? AppColors.accepted : AppColors.rejected,
          content: Text(
            success
                ? '✅ Request sent! The owner will review it.'
                : provider.error ?? 'Failed to send request.',
            style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
          ),
        ),
      );
      if (success) Navigator.pop(context);
    }
  }
}
