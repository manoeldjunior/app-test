import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../providers/providers.dart';
import '../../widgets/magalu_app_bar.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/banner_carousel.dart';
import '../../widgets/category_carousel.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/drawer_menu.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.scaffoldBackground,
      drawer: DrawerMenu(
        userName: user.name,
        onClose: () => scaffoldKey.currentState?.closeDrawer(),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── App Bar ──────────────────────────────────
          MagaluAppBar(
            onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
            onCartTap: () => context.push('/cart'),
          ),

          // ─── Balance Card ─────────────────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 16),
              child: BalanceCard(),
            ),
          ),

          // ─── Banner Carousel ──────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: BannerCarousel(banners: MockData.banners),
            ),
          ),

          // ─── Categories ───────────────────────────────
          const SliverToBoxAdapter(
            child: SectionHeader(title: 'Categorias', actionText: 'Ver todas'),
          ),
          SliverToBoxAdapter(
            child: CategoryCarousel(categories: MockData.categories),
          ),

          // ─── Recently Viewed ──────────────────────────
          const SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Visto recentemente',
              actionText: 'Ver mais',
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: MockData.recentlyViewed.length,
                itemBuilder: (context, index) {
                  final product = MockData.recentlyViewed[index];
                  return ProductCard(
                    product: product,
                    compact: true,
                    heroTagPrefix: 'recent',
                    onTap: () => context.push('/product/${product.id}'),
                  );
                },
              ),
            ),
          ),

          // ─── Recommended Products ─────────────────────
          const SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Recomendados para você',
              actionText: 'Ver todos',
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = MockData.recommended[index];
                return ProductCard(
                  product: product,
                  heroTagPrefix: 'recommended',
                  onTap: () => context.push('/product/${product.id}'),
                  onAddToCart: () {
                    ref.read(cartProvider.notifier).addItem(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${product.brand} adicionado à sacola',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: AppColors.accentGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        duration: const Duration(seconds: 2),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  },
                );
              },
              childCount: MockData.recommended.length,
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      // ─── Bottom Navigation ──────────────────────────
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _BottomNav extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedNavIndexProvider);
    final cartCount = ref.watch(cartItemCountProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Início',
                isSelected: selectedIndex == 0,
                onTap: () =>
                    ref.read(selectedNavIndexProvider.notifier).state = 0,
              ),
              _NavItem(
                icon: Icons.search,
                activeIcon: Icons.search,
                label: 'Buscar',
                isSelected: selectedIndex == 1,
                onTap: () =>
                    ref.read(selectedNavIndexProvider.notifier).state = 1,
              ),
              _NavItem(
                icon: Icons.shopping_bag_outlined,
                activeIcon: Icons.shopping_bag,
                label: 'Sacola',
                isSelected: selectedIndex == 2,
                badge: cartCount > 0 ? cartCount : null,
                onTap: () => context.push('/cart'),
              ),
              _NavItem(
                icon: Icons.account_balance_wallet_outlined,
                activeIcon: Icons.account_balance_wallet,
                label: 'MagaluPay',
                isSelected: selectedIndex == 3,
                onTap: () =>
                    ref.read(selectedNavIndexProvider.notifier).state = 3,
              ),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Perfil',
                isSelected: selectedIndex == 4,
                onTap: () => context.push('/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final int? badge;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.isSelected = false,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  size: 24,
                ),
                if (badge != null)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.magaluPay,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$badge',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
