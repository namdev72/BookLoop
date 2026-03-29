import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../dashboard/dashboard_screen.dart';
import '../academic/academic_screen.dart';
import '../books/books_screen.dart';
import '../community/community_screen.dart';
import '../add_book/add_book_modal.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const AcademicScreen(),
    const BooksScreen(),
    const CommunityScreen(),
  ];

  final List<_NavItem> _navItems = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.school_rounded, label: 'Academic'),
    _NavItem(icon: Icons.auto_stories_rounded, label: 'Books'),
    _NavItem(icon: Icons.people_rounded, label: 'Community'),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _screens),
          // Glassmorphism Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildGlassHeader(user?.name ?? '', user?.tokenBalance ?? 0, auth),
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 3 ? null : _buildFAB(user),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildGlassHeader(String userName, int tokens, AuthProvider auth) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.glassWhite,
            border: Border(
              bottom: BorderSide(color: AppColors.glassBorder, width: 1),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 16, 14),
              child: Row(
                children: [
                  // Logo
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          gradient: AppColors.purpleGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.purple.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.menu_book_rounded,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      RichText(
                        text: TextSpan(
                          style: AppTextStyles.logoStyle.copyWith(fontSize: 22, letterSpacing: -0.5),
                          children: const [
                            TextSpan(text: 'Book', style: TextStyle(color: AppColors.textPrimary)),
                            TextSpan(text: 'Loop', style: TextStyle(color: AppColors.purple)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Token pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.goldLight, // amber-50
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: const Color(0xFFFDE68A)), // amber-200
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.toll_outlined, size: 18, color: AppColors.pending),
                        const SizedBox(width: 4),
                        Text(
                          '$tokens',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.pending, // amber-700
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Logout
                  GestureDetector(
                    onTap: () => _showLogoutDialog(auth),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.output_rounded,
                          color: AppColors.textSecondary, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAB(user) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () => _showAddBookModal(user),
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
        label: Text(
          'List a Book',
          style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.glassBorder, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              return _buildNavButton(index);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(int index) {
    final isActive = _currentIndex == index;
    final item = _navItems[index];

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        transform: Matrix4.translationValues(0, isActive ? -4 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.gold.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? AppColors.gold.withOpacity(0.3)
                : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              color: isActive ? AppColors.gold : AppColors.textMuted,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isActive ? AppColors.gold : AppColors.textMuted,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBookModal(user) {
    if (user == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddBookModal(user: user),
    );
  }

  void _showLogoutDialog(AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Sign Out', style: AppTextStyles.headlineMedium),
        content: Text('Are you sure you want to sign out?',
            style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: AppTextStyles.labelLarge
                    .copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              auth.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rejected,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Sign Out',
                style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
