// ═══════════════════════════════════════════════════════════
// V3 — Magalu × Nubank (Premium Polish)
// ═══════════════════════════════════════════════════════════
// Nubank-level refinement: soft shadows, generous whitespace,
// micro-interactions (PressableScale), animated transitions,
// floating balance card, banner carousel, confetti success.
// Adapted from the standalone app to use Navigator.
// ═══════════════════════════════════════════════════════════

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/models.dart';
import '../data/mock_data.dart';
import '../providers/providers.dart';
import '../utils/currency_format.dart';

// ─── Colors ──────────────────────────────────────────────
class _C {
  static const primary = Color(0xFF0086FF);
  static const primaryDark = Color(0xFF0060CC);
  static const surface = Colors.white;
  static const bg = Color(0xFFF8F8F8);
  static const green = Color(0xFF00A650);
  static const greenLight = Color(0xFFE8F5E9);
  static const orange = Color(0xFFFF6F00);
  static const orangeLight = Color(0xFFFFF3E0);
  static const pix = Color(0xFF00BDAE);
  static const text = Color(0xFF1A1A1A);
  static const textSec = Color(0xFF757575);
  static const textTer = Color(0xFFBDBDBD);
  static const border = Color(0xFFEEEEEE);
  static const divider = Color(0xFFE0E0E0);
  static const star = Color(0xFFFFC107);
  static const shadow = Color(0x0D000000);
  static const shadowMed = Color(0x1A000000);
}

// ─── Entry Point ─────────────────────────────────────────
class V3App extends StatelessWidget {
  const V3App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          primaryColor: _C.primary,
          scaffoldBackgroundColor: _C.bg,
          colorScheme: const ColorScheme.light(
            primary: _C.primary,
            onPrimary: Colors.white,
            secondary: _C.orange,
            surface: _C.surface,
            onSurface: _C.text,
          ),
          textTheme: GoogleFonts.interTextTheme(),
          cardTheme: CardThemeData(
            color: _C.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: _C.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: _C.primary, width: 1.5),
            ),
          ),
        ),
        home: const _Home(),
      ),
    );
  }
}

// ─── Pressable Scale ─────────────────────────────────────
class _Press extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _Press({required this.child, this.onTap});
  @override
  State<_Press> createState() => _PressState();
}

class _PressState extends State<_Press> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
        reverseDuration: const Duration(milliseconds: 200));
    _s = Tween(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _c.forward(),
      onTapUp: (_) {
        _c.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _c.reverse(),
      child: ScaleTransition(scale: _s, child: widget.child),
    );
  }
}

// ═════════════════════════════════════════════════════════
// HOME
// ═════════════════════════════════════════════════════════
class _Home extends ConsumerWidget {
  const _Home();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user;
    final cartCount = ref.watch(cartItemCountProvider);
    final userState = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: _C.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── Sliver App Bar ──────────────────────────
          SliverAppBar(
            expandedHeight: 110,
            floating: true,
            pinned: true,
            backgroundColor: _C.primary,
            surfaceTintColor: _C.primary,
            leading: IconButton(
              onPressed: () {},
              icon: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.white),
              ),
              Stack(
                children: [
                  IconButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const _Cart())),
                    icon: const Icon(Icons.shopping_bag_outlined,
                        color: Colors.white),
                  ),
                  if (cartCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: _C.orange,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                            minWidth: 18, minHeight: 18),
                        child: Text('$cartCount',
                            style: GoogleFonts.inter(
                                color: Colors.white, fontSize: 10),
                            textAlign: TextAlign.center),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: _C.primary,
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: _C.textSec, size: 20),
                      const SizedBox(width: 10),
                      Text('Busca no Magalu',
                          style: GoogleFonts.inter(
                              color: _C.textTer, fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ─── Balance Card ──────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _C.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: _C.shadowMed,
                      blurRadius: 16,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Saldo MagaluPay',
                          style: GoogleFonts.inter(
                              color: _C.textSec,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                      GestureDetector(
                        onTap: () => ref
                            .read(userProvider.notifier)
                            .toggleBalanceVisibility(),
                        child: Icon(
                          userState.balanceVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: _C.textSec,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userState.balanceVisible
                        ? CurrencyFormat.format(user.magaluPayBalance)
                        : r'R$ ••••••',
                    style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: _C.text),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _QuickAction(Icons.account_balance_wallet, 'Saldo',
                          _C.primary),
                      _QuickAction(Icons.pix, 'Pix', _C.pix),
                      _QuickAction(Icons.receipt_long, 'Carnê', _C.orange),
                      _QuickAction(Icons.swap_horiz, 'Transferir', _C.primary),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ─── Banner ────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: _C.shadowMed,
                      blurRadius: 12,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: MockData.banners.first.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: Colors.grey[200]),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 14,
                      left: 14,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Oferta do Dia',
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                          Text('Até 50% OFF em Eletrônicos',
                              style: GoogleFonts.inter(
                                  color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Categories ────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text('Categorias',
                  style: GoogleFonts.inter(
                      fontSize: 18, fontWeight: FontWeight.w600)),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: MockData.categories.length,
                itemBuilder: (context, i) {
                  final cat = MockData.categories[i];
                  return _Press(
                    child: Container(
                      width: 68,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: _C.primary.withOpacity(0.08),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: _C.primary.withOpacity(0.15),
                                  width: 1.5),
                            ),
                            child: Icon(cat.icon,
                                color: _C.primary, size: 24),
                          ),
                          const SizedBox(height: 6),
                          Text(cat.name,
                              style: GoogleFonts.inter(
                                  fontSize: 10, color: _C.textSec),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ─── Products ──────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text('Recomendados para você',
                  style: GoogleFonts.inter(
                      fontSize: 18, fontWeight: FontWeight.w600)),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final p = MockData.products[i];
                return _ProductCard(product: p, onAddToCart: () {
                  ref.read(cartProvider.notifier).addItem(p);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${p.brand} adicionado à sacola',
                          style: const TextStyle(color: Colors.white)),
                      backgroundColor: _C.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                });
              },
              childCount: MockData.products.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      bottomNavigationBar: _BottomNav(cartCount: cartCount),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _QuickAction(this.icon, this.label, this.color);
  @override
  Widget build(BuildContext context) {
    return _Press(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.inter(fontSize: 10, color: _C.textSec)),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int cartCount;
  const _BottomNav({required this.cartCount});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        boxShadow: [
          BoxShadow(
              color: _C.shadowMed,
              blurRadius: 20,
              offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(Icons.home, 'Início', true),
              _NavItem(Icons.search, 'Buscar', false),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _NavItem(Icons.shopping_bag_outlined, 'Sacola', false),
                  if (cartCount > 0)
                    Positioned(
                      right: 2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                            color: _C.orange, shape: BoxShape.circle),
                        child: Text('$cartCount',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 8)),
                      ),
                    ),
                ],
              ),
              _NavItem(Icons.account_balance_wallet_outlined, 'MagaluPay',
                  false),
              _NavItem(Icons.person_outline, 'Perfil', false),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const _NavItem(this.icon, this.label, this.active);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            color: active ? _C.primary : _C.textSec, size: 24),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? _C.primary : _C.textSec)),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onAddToCart;
  const _ProductCard({required this.product, this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return _Press(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => _ProductDetail(product: product)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: _C.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: _C.shadow, blurRadius: 12, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: Colors.grey[100], height: 180),
                  ),
                ),
                if (product.discountPercent > 0)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _C.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('${product.discountPercent}% OFF',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
              ],
            ),
            // Details
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  // Rating
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < product.rating.floor()
                              ? Icons.star
                              : (i < product.rating
                                  ? Icons.star_half
                                  : Icons.star_border),
                          color: _C.star,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('${product.rating}',
                          style: GoogleFonts.inter(
                              fontSize: 11, color: _C.textSec)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (product.originalPrice != null)
                    Text(CurrencyFormat.format(product.originalPrice!),
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            color: _C.textTer,
                            decoration: TextDecoration.lineThrough)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(CurrencyFormat.format(product.price),
                          style: GoogleFonts.inter(
                              fontSize: 20, fontWeight: FontWeight.w700)),
                      if (product.maxInstallments > 1) ...[
                        const SizedBox(width: 8),
                        Text(
                            'em até ${product.maxInstallments}x de ${CurrencyFormat.format(product.installmentPrice)}',
                            style: GoogleFonts.inter(
                                fontSize: 11, color: _C.textSec)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (product.freeShipping)
                    Row(
                      children: [
                        const Icon(Icons.local_shipping,
                            color: _C.green, size: 14),
                        const SizedBox(width: 4),
                        Text(
                            'Chegará grátis ${product.deliveryDate ?? ""}',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: _C.green,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                ],
              ),
            ),
            // Add to cart
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onAddToCart,
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  label: const Text('Adicionar à sacola'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════
// PRODUCT DETAIL
// ═════════════════════════════════════════════════════════
class _ProductDetail extends ConsumerWidget {
  final Product product;
  const _ProductDetail({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: _C.surface,
            foregroundColor: _C.text,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1), blurRadius: 8),
                    ],
                  ),
                  child: const Icon(Icons.arrow_back, color: _C.text),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: Colors.grey[100]),
                  ),
                  if (product.discountPercent > 0)
                    Positioned(
                      top: 100,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _C.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('${product.discountPercent}% OFF',
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Product info
          SliverToBoxAdapter(
            child: Container(
              color: _C.surface,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.brand.toUpperCase(),
                      style: GoogleFonts.inter(
                          color: _C.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2)),
                  const SizedBox(height: 6),
                  Text(product.name,
                      style: GoogleFonts.inter(
                          fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < product.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: _C.star,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                          '${product.rating} (${product.reviewCount} avaliações)',
                          style: GoogleFonts.inter(
                              fontSize: 12, color: _C.textSec)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Price
          SliverToBoxAdapter(
            child: Container(
              color: _C.surface,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 24),
                  if (product.originalPrice != null)
                    Text('De ${CurrencyFormat.format(product.originalPrice!)}',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: _C.textTer,
                            decoration: TextDecoration.lineThrough)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(CurrencyFormat.format(product.price),
                          style: GoogleFonts.inter(
                              fontSize: 24, fontWeight: FontWeight.w700)),
                      if (product.discountPercent > 0) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _C.greenLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('-${product.discountPercent}%',
                              style: GoogleFonts.inter(
                                  color: _C.green,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                  if (product.maxInstallments > 1) ...[
                    const SizedBox(height: 6),
                    Text(
                        'em até ${product.maxInstallments}x de ${CurrencyFormat.format(product.installmentPrice)} sem juros',
                        style: GoogleFonts.inter(
                            fontSize: 14, color: _C.textSec)),
                  ],
                  // Cashback
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _C.orangeLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet,
                            color: _C.orange, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                              'Ganhe ${CurrencyFormat.format(product.price * 0.05)} de cashback com MagaluPay',
                              style: GoogleFonts.inter(
                                  color: _C.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Shipping
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              color: _C.surface,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _C.greenLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.local_shipping,
                        color: _C.green, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          product.freeShipping
                              ? 'Frete Grátis'
                              : 'Frete a calcular',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: product.freeShipping
                                  ? _C.green
                                  : _C.text)),
                      if (product.deliveryDate != null)
                        Text('Chegará ${product.deliveryDate}',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: _C.textSec)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        decoration: BoxDecoration(
          color: _C.surface,
          boxShadow: [
            BoxShadow(
                color: _C.shadowMed,
                blurRadius: 20,
                offset: const Offset(0, -4)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(cartProvider.notifier).addItem(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.brand} adicionado à sacola'),
                      backgroundColor: _C.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: const Text('Adicionar'),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).addItem(product);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const _Cart()));
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text('Comprar agora'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════
// CART
// ═════════════════════════════════════════════════════════
class _Cart extends ConsumerWidget {
  const _Cart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.surface,
        foregroundColor: _C.text,
        elevation: 0,
        title: Text('Sacola', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_bag_outlined,
                      size: 64, color: _C.textTer.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text('Sua sacola está vazia',
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _C.textSec)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8),
                    children: items
                        .map((item) => _CartItemCard(
                              item: item,
                              onRemove: () => ref
                                  .read(cartProvider.notifier)
                                  .removeItem(item.product.id),
                              onQty: (q) => ref
                                  .read(cartProvider.notifier)
                                  .updateQuantity(item.product.id, q),
                            ))
                        .toList(),
                  ),
                ),
                // Total + CTA
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  decoration: BoxDecoration(
                    color: _C.surface,
                    boxShadow: [
                      BoxShadow(
                          color: _C.shadowMed,
                          blurRadius: 20,
                          offset: const Offset(0, -4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total',
                              style: GoogleFonts.inter(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          Text(CurrencyFormat.format(total),
                              style: GoogleFonts.inter(
                                  fontSize: 22, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const _Checkout()),
                          ),
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16)),
                          child: const Text('Continuar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final ValueChanged<int> onQty;
  const _CartItemCard(
      {required this.item, required this.onRemove, required this.onQty});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.product.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _C.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: _C.shadow, blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: item.product.imageUrl,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name,
                      style: GoogleFonts.inter(
                          fontSize: 13, fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(CurrencyFormat.format(item.product.price),
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            // Quantity controls
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: _C.border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => item.quantity > 1
                        ? onQty(item.quantity - 1)
                        : onRemove(),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: Icon(
                        item.quantity > 1
                            ? Icons.remove
                            : Icons.delete_outline,
                        size: 14,
                        color: item.quantity > 1 ? _C.textSec : Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 26,
                    child: Text('${item.quantity}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                  GestureDetector(
                    onTap: () => onQty(item.quantity + 1),
                    child: const SizedBox(
                      width: 30,
                      height: 30,
                      child:
                          Icon(Icons.add, size: 14, color: _C.primary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════
// CHECKOUT (combined checkout + payment)
// ═════════════════════════════════════════════════════════
class _Checkout extends ConsumerStatefulWidget {
  const _Checkout();
  @override
  ConsumerState<_Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends ConsumerState<_Checkout> {
  PaymentMethod? _selected;

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.surface,
        foregroundColor: _C.text,
        elevation: 0,
        title: Text('Checkout',
            style: GoogleFonts.inter(
                fontSize: 20, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Items
            Container(
              color: _C.surface,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Itens do pedido',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 14),
                  ...items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: item.product.imageUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name,
                                      style: GoogleFonts.inter(fontSize: 13),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  Text('Qtd: ${item.quantity}',
                                      style: GoogleFonts.inter(
                                          fontSize: 11, color: _C.textSec)),
                                ],
                              ),
                            ),
                            Text(CurrencyFormat.format(item.total),
                                style: GoogleFonts.inter(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Shipping
            Container(
              color: _C.surface,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _C.greenLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.local_shipping,
                        color: _C.green, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text('Frete Grátis',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _C.green)),
                  const Spacer(),
                  Text('até 22 de fev',
                      style:
                          GoogleFonts.inter(fontSize: 12, color: _C.textSec)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Payment methods
            Container(
              color: _C.surface,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Forma de pagamento',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  ...[
                    (PaymentMethod.pix, Icons.pix, 'Pix',
                        'Aprovação imediata', _C.pix),
                    (PaymentMethod.creditCard, Icons.credit_card,
                        'Cartão de Crédito', 'Visa •••• 4321', _C.primary),
                    (PaymentMethod.magaluPay, Icons.account_balance_wallet,
                        'Saldo MagaluPay', 'R\$ 1.250,80', _C.orange),
                  ].map((e) => _Press(
                        onTap: () => setState(() => _selected = e.$1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _selected == e.$1
                                ? _C.primary.withOpacity(0.05)
                                : _C.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _selected == e.$1
                                  ? _C.primary
                                  : _C.border,
                              width: _selected == e.$1 ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: e.$5.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child:
                                    Icon(e.$2, color: e.$5, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(e.$3,
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                    Text(e.$4,
                                        style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: _C.textSec)),
                                  ],
                                ),
                              ),
                              AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 200),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _selected == e.$1
                                        ? _C.primary
                                        : _C.textTer,
                                    width: 2,
                                  ),
                                  color: _selected == e.$1
                                      ? _C.primary
                                      : Colors.transparent,
                                ),
                                child: _selected == e.$1
                                    ? const Icon(Icons.check,
                                        color: Colors.white, size: 16)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Summary
            Container(
              color: _C.surface,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _Sum('Subtotal', CurrencyFormat.format(total)),
                  const SizedBox(height: 6),
                  const _Sum('Frete', 'Grátis', color: _C.green),
                  const Divider(height: 20),
                  _Sum('Total', CurrencyFormat.format(total), bold: true),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        decoration: BoxDecoration(
          color: _C.surface,
          boxShadow: [
            BoxShadow(
                color: _C.shadowMed,
                blurRadius: 20,
                offset: const Offset(0, -4)),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selected != null
                ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const _Success()))
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              disabledBackgroundColor: _C.divider,
            ),
            child: Text(_selected != null
                ? 'Confirmar pagamento'
                : 'Selecione o pagamento'),
          ),
        ),
      ),
    );
  }
}

class _Sum extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool bold;
  const _Sum(this.label, this.value, {this.color, this.bold = false});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: bold ? 18 : 14,
                fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
                color: bold ? _C.text : _C.textSec)),
        Text(value,
            style: GoogleFonts.inter(
                fontSize: bold ? 22 : 14,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                color: color ?? _C.text)),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════
// SUCCESS (with confetti)
// ═════════════════════════════════════════════════════════
class _Success extends ConsumerStatefulWidget {
  const _Success();
  @override
  ConsumerState<_Success> createState() => _SuccessState();
}

class _SuccessState extends ConsumerState<_Success>
    with TickerProviderStateMixin {
  late final AnimationController _checkCtrl;
  late final AnimationController _scaleCtrl;
  late final AnimationController _confettiCtrl;

  @override
  void initState() {
    super.initState();
    _checkCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _scaleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _confettiCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));

    _scaleCtrl.forward().then((_) {
      _checkCtrl.forward();
      _confettiCtrl.forward();
    });
  }

  @override
  void dispose() {
    _checkCtrl.dispose();
    _scaleCtrl.dispose();
    _confettiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: _C.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Animated check + confetti
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _confettiCtrl,
                    builder: (context, _) => CustomPaint(
                      size: const Size(200, 200),
                      painter: _ConfettiPainter(
                          progress: _confettiCtrl.value),
                    ),
                  ),
                  ScaleTransition(
                    scale: CurvedAnimation(
                        parent: _scaleCtrl, curve: Curves.easeOutBack),
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: _C.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            color: _C.green,
                            shape: BoxShape.circle,
                          ),
                          child: ScaleTransition(
                            scale: CurvedAnimation(
                                parent: _checkCtrl,
                                curve: Curves.elasticOut),
                            child: const Icon(Icons.check,
                                color: Colors.white, size: 36),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: CurvedAnimation(
                    parent: _checkCtrl, curve: Curves.easeIn),
                child: Column(
                  children: [
                    Text('Compra realizada!',
                        style: GoogleFonts.inter(
                            fontSize: 22, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('Seu pedido foi confirmado com sucesso.',
                        style: GoogleFonts.inter(
                            fontSize: 14, color: _C.textSec),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: _C.bg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _InfoRow('Total', CurrencyFormat.format(total)),
                          const SizedBox(height: 8),
                          const _InfoRow('Previsão', '20-22 de fev'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(cartProvider.notifier).clear();
                    ref.read(paymentProvider.notifier).reset();
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('Voltar ao início'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.inter(fontSize: 13, color: _C.textSec)),
        Text(value,
            style:
                GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final _rng = Random(42);
  _ConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;
    final colors = [_C.primary, _C.orange, _C.green, _C.star, _C.pix];
    for (int i = 0; i < 20; i++) {
      final a = _rng.nextDouble() * 2 * pi;
      final d = 40 + _rng.nextDouble() * 80;
      final x = size.width / 2 + cos(a) * d * progress;
      final y =
          size.height / 2 + sin(a) * d * progress + 20 * progress * progress;
      final paint = Paint()
        ..color = colors[i % colors.length].withOpacity(1 - progress)
        ..style = PaintingStyle.fill;
      final s = 3 + _rng.nextDouble() * 4;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(x, y), width: s, height: s * 1.5),
          const Radius.circular(1),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) =>
      old.progress != progress;
}
