import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/request_provider.dart';
import 'widgets/stats_row.dart';
import 'widgets/my_books_tab.dart';
import 'widgets/my_requests_tab.dart';
import 'widgets/incoming_requests_tab.dart';
import 'widgets/completed_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    if (user == null) return const SizedBox();

    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcome(user.name),
                  const SizedBox(height: 24),
                  StatsRow(user: user),
                  const SizedBox(height: 24),
                  _buildTabBar(),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            MyBooksTab(uid: user.uid),
            MyRequestsTab(uid: user.uid),
            IncomingRequestsTab(uid: user.uid),
            CompletedTab(uid: user.uid),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcome(String name) {
    final firstName = name.split(' ').first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Welcome back, ',
                style: AppTextStyles.headlineLarge
                    .copyWith(color: AppColors.textSecondary),
              ),
              TextSpan(
                text: firstName,
                style: AppTextStyles.headlineLarge
                    .copyWith(color: AppColors.gold),
              ),
              TextSpan(
                text: ' 👋',
                style: AppTextStyles.headlineLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Ready to discover your next great read?',
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        indicator: BoxDecoration(
          gradient: AppColors.goldGradient,
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.all(4),
        labelStyle: AppTextStyles.labelLarge.copyWith(fontSize: 11),
        unselectedLabelStyle: AppTextStyles.labelSmall.copyWith(fontSize: 11),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textMuted,
        tabs: const [
          Tab(text: 'My Books'),
          Tab(text: 'Requests'),
          Tab(text: 'Incoming'),
          Tab(text: 'Completed'),
        ],
      ),
    );
  }
}
