import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../providers/providers.dart';
import '../../utils/currency_format.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  late final PageController _galleryController;
  int _currentPage = 0;

  Product get product =>
      MockData.products.firstWhere((p) => p.id == widget.productId);

  @override
  void initState() {
    super.initState();
    _galleryController = PageController();
  }

  @override
  void dispose() {
    _galleryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = product;
    final gallery =
        p.galleryUrls.isNotEmpty ? p.galleryUrls : [p.imageUrl];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── Image Gallery App Bar ─────────────────────
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            leading: _CircleBackButton(onTap: () => context.pop()),
            actions: [
              _CircleIconButton(
                icon: Icons.favorite_border,
                onTap: () {},
              ),
              _CircleIconButton(
                icon: Icons.share,
                onTap: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Gallery
                  PageView.builder(
                    controller: _galleryController,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemCount: gallery.length,
                    itemBuilder: (context, index) {
                      return Hero(
                        tag: index == 0 ? 'product-${p.id}' : 'gallery-$index',
                        child: CachedNetworkImage(
                          imageUrl: gallery[index],
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: AppColors.shimmerBase,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: AppColors.shimmerBase,
                            child: const Icon(Icons.image,
                                color: AppColors.textTertiary, size: 60),
                          ),
                        ),
                      );
                    },
                  ),
                  // Page indicator
                  if (gallery.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(gallery.length, (i) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentPage == i ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == i
                                  ? AppColors.primary
                                  : AppColors.textTertiary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                    ),
                  // Badges
                  if (p.discountPercent > 0)
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 56,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accentGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${p.discountPercent}% OFF',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ─── Product Info ──────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.surface,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Text(
                    p.brand.toUpperCase(),
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Name
                  Text(
                    p.name,
                    style: AppTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  // Rating
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        return Icon(
                          i < p.rating.floor()
                              ? Icons.star
                              : (i < p.rating
                                  ? Icons.star_half
                                  : Icons.star_border),
                          color: AppColors.ratingStar,
                          size: 18,
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        '${p.rating} (${p.reviewCount} avaliações)',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ─── Price Section ─────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.surface,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 24),
                  if (p.originalPrice != null)
                    Text(
                      'De ${CurrencyFormat.format(p.originalPrice!)}',
                      style: AppTextStyles.priceOld.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        CurrencyFormat.format(p.price),
                        style: AppTextStyles.priceTotal.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (p.discountPercent > 0) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accentGreenLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '-${p.discountPercent}%',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.accentGreen,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (p.maxInstallments > 1) ...[
                    const SizedBox(height: 6),
                    Text(
                      'em até ${p.maxInstallments}x de ${CurrencyFormat.format(p.installmentPrice)} sem juros',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  // MagaluPay cashback
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.magaluPayLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet,
                            color: AppColors.magaluPay, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Ganhe ${CurrencyFormat.format(p.price * 0.05)} de cashback com MagaluPay',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.magaluPay,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Shipping ──────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              color: AppColors.surface,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accentGreenLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.local_shipping,
                        color: AppColors.accentGreen, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.freeShipping ? 'Frete Grátis' : 'Frete a calcular',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: p.freeShipping
                                ? AppColors.accentGreen
                                : AppColors.textPrimary,
                          ),
                        ),
                        if (p.deliveryDate != null)
                          Text(
                            'Chegará ${p.deliveryDate}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Description ───────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              color: AppColors.surface,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Descrição', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    p.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      // ─── Bottom CTAs ───────────────────────────────────
      bottomSheet: _BottomCTA(
        product: p,
        onAddToCart: () {
          ref.read(cartProvider.notifier).addItem(p);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${p.brand} adicionado à sacola',
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: AppColors.accentGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        onBuyNow: () {
          ref.read(cartProvider.notifier).addItem(p);
          context.push('/checkout');
        },
      ),
    );
  }
}

class _CircleBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CircleBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 20),
        ),
      ),
    );
  }
}

class _BottomCTA extends StatelessWidget {
  final Product product;
  final VoidCallback? onAddToCart;
  final VoidCallback? onBuyNow;

  const _BottomCTA({
    required this.product,
    this.onAddToCart,
    this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        16 + MediaQuery.of(context).padding.bottom,
      ),
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
      child: Row(
        children: [
          // Add to cart
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onAddToCart,
              icon: const Icon(Icons.add_shopping_cart, size: 18),
              label: const Text('Adicionar'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Buy now
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onBuyNow,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Comprar agora'),
            ),
          ),
        ],
      ),
    );
  }
}
