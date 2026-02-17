// ═══════════════════════════════════════════════════════════
// V3 — Nubank Experience (Black/Purple, NuPay)
// ═══════════════════════════════════════════════════════════
// Pixel-perfect replica of the Nubank checkout + NuPay
// payment screens from the provided screenshots.
// Dark theme, purple accents, minimalist typography.
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

// ─── Nubank Colors (from screenshots) ────────────────────
class _C {
  static const purple = Color(0xFF820AD1);
  static const purpleDark = Color(0xFF6B07AE);
  static const purpleLight = Color(0xFF9B3FDB);
  static const bg = Color(0xFF111111);
  static const surface = Color(0xFF1A1A1A);
  static const card = Color(0xFF222222);
  static const cardLight = Color(0xFF2A2A2A);
  static const cardBorder = Color(0xFF333333);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFAAAAAA);
  static const textTertiary = Color(0xFF777777);
  static const green = Color(0xFF00A650);
  static const greenLight = Color(0xFF1A3A2A);
  static const red = Color(0xFFFF4444);
  static const star = Color(0xFFFFC107);
  static const pix = Color(0xFF00BDAE);
}

TextStyle _nu({
  double size = 14,
  FontWeight weight = FontWeight.w400,
  Color color = _C.textPrimary,
  double? height,
}) {
  return GoogleFonts.inter(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
  );
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
          brightness: Brightness.dark,
          scaffoldBackgroundColor: _C.bg,
          colorScheme: const ColorScheme.dark(
            primary: _C.purple,
            onPrimary: Colors.white,
            surface: _C.surface,
            onSurface: _C.textPrimary,
          ),
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
          appBarTheme: const AppBarTheme(
            backgroundColor: _C.bg,
            foregroundColor: _C.textPrimary,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
          ),
          cardTheme: CardThemeData(
            color: _C.card,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.purple,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
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
      reverseDuration: const Duration(milliseconds: 200),
    );
    _s = Tween(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _c, curve: Curves.easeInOut),
    );
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
// HOME — Nubank dark style with credit indicators
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
          SliverAppBar(
            expandedHeight: 110,
            floating: true,
            pinned: true,
            backgroundColor: _C.purple,
            surfaceTintColor: _C.purple,
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
                icon: const Icon(Icons.visibility_outlined, color: Colors.white),
              ),
              Stack(
                children: [
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const _Cart()),
                    ),
                    icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                  ),
                  if (cartCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: _C.red, shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text('$cartCount', style: _nu(size: 10), textAlign: TextAlign.center),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: _C.purple,
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.white70, size: 20),
                      const SizedBox(width: 10),
                      Text('Buscar no Shopping', style: _nu(size: 14, color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Balance / Credit Card
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _C.cardBorder, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Conta', style: _nu(size: 14, weight: FontWeight.w600, color: _C.textSecondary)),
                      GestureDetector(
                        onTap: () => ref.read(userProvider.notifier).toggleBalanceVisibility(),
                        child: Icon(
                          userState.balanceVisible ? Icons.visibility : Icons.visibility_off,
                          color: _C.textSecondary,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userState.balanceVisible ? CurrencyFormat.format(user.nubankBalance) : r'R$ ••••••',
                    style: _nu(size: 28, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  // Credit indicator (top of funnel)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _C.purple.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _C.purple.withValues(alpha: 0.3), width: 0.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.credit_card, color: _C.purpleLight, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Limite disponível', style: _nu(size: 11, color: _C.textSecondary)),
                              Text(
                                CurrencyFormat.format(user.nubankCreditAvailable),
                                style: _nu(size: 15, weight: FontWeight.w600, color: _C.purpleLight),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: _C.purple, borderRadius: BorderRadius.circular(12)),
                          child: Text('Até 24x', style: _nu(size: 10, weight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _QuickAct(Icons.pix, 'Pix', _C.pix),
                      _QuickAct(Icons.receipt_long, 'Pagar', _C.purple),
                      _QuickAct(Icons.swap_horiz, 'Transferir', _C.purpleLight),
                      _QuickAct(Icons.credit_card, 'Cartão', _C.purple),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Shopping do Nu Banner
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [_C.purple, _C.purpleDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Shopping do Nu', style: _nu(size: 18, weight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text('Parcele em até 24x no crédito', style: _nu(size: 13, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Products
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Para você', style: _nu(size: 18, weight: FontWeight.w600)),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final p = MockData.products[i];
                return _ProductCard(
                  product: p,
                  onAddToCart: () {
                    ref.read(cartProvider.notifier).addItem(p);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${p.brand} adicionado', style: const TextStyle(color: Colors.white)),
                        backgroundColor: _C.purple,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  },
                );
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

class _QuickAct extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _QuickAct(this.icon, this.label, this.color);

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
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 4),
          Text(label, style: _nu(size: 10, color: _C.textSecondary)),
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
        border: const Border(top: BorderSide(color: _C.cardBorder, width: 0.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NI(Icons.home, 'Início', true),
              _NI(Icons.credit_card, 'Cartão', false),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _NI(Icons.shopping_bag_outlined, 'Shopping', false),
                  if (cartCount > 0)
                    Positioned(
                      right: 2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(color: _C.purple, shape: BoxShape.circle),
                        child: Text('$cartCount', style: _nu(size: 8)),
                      ),
                    ),
                ],
              ),
              _NI(Icons.pix, 'Pix', false),
              _NI(Icons.person_outline, 'Perfil', false),
            ],
          ),
        ),
      ),
    );
  }
}

class _NI extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const _NI(this.icon, this.label, this.active);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? _C.purple : _C.textTertiary, size: 24),
        const SizedBox(height: 2),
        Text(
          label,
          style: _nu(
            size: 10,
            weight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? _C.purple : _C.textTertiary,
          ),
        ),
      ],
    );
  }
}

// ─── Product Card ────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onAddToCart;
  const _ProductCard({required this.product, this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final user = MockData.user;
    return _Press(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => _ProductDetail(product: product)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.cardBorder, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: _C.cardLight, height: 180),
                  ),
                ),
                if (product.discountPercent > 0)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: _C.purple, borderRadius: BorderRadius.circular(20)),
                      child: Text('${product.discountPercent}% OFF', style: _nu(size: 11, weight: FontWeight.w700)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: _nu(size: 14, weight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  if (product.originalPrice != null)
                    Text(
                      CurrencyFormat.format(product.originalPrice!),
                      style: _nu(size: 12, color: _C.textTertiary).copyWith(decoration: TextDecoration.lineThrough),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(CurrencyFormat.format(product.price), style: _nu(size: 20, weight: FontWeight.w700)),
                      if (product.maxInstallments > 1) ...[
                        const SizedBox(width: 8),
                        Text(
                          'em até ${product.maxInstallments}x de ${CurrencyFormat.format(product.installmentPrice)}',
                          style: _nu(size: 11, color: _C.textSecondary),
                        ),
                      ],
                    ],
                  ),
                  // Credit indicator on product card (top of funnel)
                  if (user.nubankCreditAvailable >= product.price)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _C.purple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.credit_card, color: _C.purpleLight, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              'Parcele em até 24x no crédito',
                              style: _nu(size: 10, color: _C.purpleLight, weight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onAddToCart,
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  label: const Text('Adicionar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
    final user = MockData.user;
    return Scaffold(
      backgroundColor: _C.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: _C.surface,
            foregroundColor: _C.textPrimary,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: _C.card.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: _C.textPrimary),
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
                    placeholder: (_, __) => Container(color: _C.cardLight),
                  ),
                  if (product.discountPercent > 0)
                    Positioned(
                      top: 100,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: _C.purple, borderRadius: BorderRadius.circular(20)),
                        child: Text('${product.discountPercent}% OFF', style: _nu(size: 12, weight: FontWeight.w700)),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: _C.surface,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.brand.toUpperCase(), style: _nu(size: 12, weight: FontWeight.w500, color: _C.purple).copyWith(letterSpacing: 1.2)),
                  const SizedBox(height: 6),
                  Text(product.name, style: _nu(size: 20, weight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ...List.generate(5, (i) => Icon(i < product.rating.floor() ? Icons.star : Icons.star_border, color: _C.star, size: 18)),
                      const SizedBox(width: 8),
                      Text('${product.rating} (${product.reviewCount})', style: _nu(size: 12, color: _C.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: _C.surface,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 24, color: _C.cardBorder),
                  if (product.originalPrice != null)
                    Text(
                      'De ${CurrencyFormat.format(product.originalPrice!)}',
                      style: _nu(size: 14, color: _C.textTertiary).copyWith(decoration: TextDecoration.lineThrough),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(CurrencyFormat.format(product.price), style: _nu(size: 28, weight: FontWeight.w700)),
                      if (product.discountPercent > 0) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: _C.greenLight, borderRadius: BorderRadius.circular(6)),
                          child: Text('-${product.discountPercent}%', style: _nu(size: 11, weight: FontWeight.w700, color: _C.green)),
                        ),
                      ],
                    ],
                  ),
                  if (product.maxInstallments > 1) ...[
                    const SizedBox(height: 6),
                    Text(
                      'em até ${product.maxInstallments}x de ${CurrencyFormat.format(product.installmentPrice)} sem juros',
                      style: _nu(size: 14, color: _C.textSecondary),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _C.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _C.purple.withValues(alpha: 0.25), width: 0.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.credit_card, color: _C.purple, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Crédito pré-aprovado disponível', style: _nu(size: 12, weight: FontWeight.w600, color: _C.purpleLight)),
                              Text(
                                '${CurrencyFormat.format(user.nubankCreditAvailable)} de limite \u2022 Até 24x',
                                style: _nu(size: 11, color: _C.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              color: _C.surface,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: _C.greenLight, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.local_shipping, color: _C.green, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.freeShipping ? 'Frete Grátis' : 'Frete a calcular',
                        style: _nu(size: 14, weight: FontWeight.w600, color: product.freeShipping ? _C.green : _C.textPrimary),
                      ),
                      if (product.deliveryDate != null) Text('Chegará ${product.deliveryDate}', style: _nu(size: 12, color: _C.textSecondary)),
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
        decoration: const BoxDecoration(
          color: _C.surface,
          border: Border(top: BorderSide(color: _C.cardBorder, width: 0.5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(cartProvider.notifier).addItem(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.brand} adicionado'),
                      backgroundColor: _C.purple,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: const Text('Adicionar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _C.purple,
                  side: const BorderSide(color: _C.purple),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).addItem(product);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const _Cart()));
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
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
        foregroundColor: _C.textPrimary,
        elevation: 0,
        title: Text('Sacola', style: _nu(size: 20, weight: FontWeight.w600)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 64, color: _C.textTertiary.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text('Sua sacola está vazia', style: _nu(size: 18, weight: FontWeight.w600, color: _C.textSecondary)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8),
                    children: items.map((item) => _CartItemCard(
                      item: item,
                      onRemove: () => ref.read(cartProvider.notifier).removeItem(item.product.id),
                      onQty: (q) => ref.read(cartProvider.notifier).updateQuantity(item.product.id, q),
                    )).toList(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  decoration: const BoxDecoration(
                    color: _C.surface,
                    border: Border(top: BorderSide(color: _C.cardBorder, width: 0.5)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: _nu(size: 18, weight: FontWeight.w600)),
                          Text(CurrencyFormat.format(total), style: _nu(size: 22, weight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _NuCheckout())),
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
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
  const _CartItemCard({required this.item, required this.onRemove, required this.onQty});

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
        decoration: BoxDecoration(color: _C.red, borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.cardBorder, width: 0.5),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(imageUrl: item.product.imageUrl, width: 72, height: 72, fit: BoxFit.cover),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name, style: _nu(size: 13, weight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(CurrencyFormat.format(item.product.price), style: _nu(size: 16, weight: FontWeight.w700)),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(border: Border.all(color: _C.cardBorder), borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => item.quantity > 1 ? onQty(item.quantity - 1) : onRemove(),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: Icon(item.quantity > 1 ? Icons.remove : Icons.delete_outline, size: 14, color: item.quantity > 1 ? _C.textSecondary : _C.red),
                    ),
                  ),
                  SizedBox(width: 26, child: Text('${item.quantity}', textAlign: TextAlign.center, style: _nu(size: 13, weight: FontWeight.w600))),
                  GestureDetector(
                    onTap: () => onQty(item.quantity + 1),
                    child: const SizedBox(width: 30, height: 30, child: Icon(Icons.add, size: 14, color: _C.purple)),
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
// CHECKOUT — "Tudo certo para finalizar seu pedido?"
// ═════════════════════════════════════════════════════════
class _NuCheckout extends ConsumerWidget {
  const _NuCheckout();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);
    const shipping = 40.91;
    final grandTotal = total + shipping;

    return Scaffold(
      backgroundColor: _C.bg,
      body: Column(
        children: [
          // Purple header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            decoration: const BoxDecoration(color: _C.purple),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white54, width: 1.5)),
                        child: const Icon(Icons.help_outline, color: Colors.white54, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Tudo certo para\nfinalizar seu pedido?', style: _nu(size: 26, weight: FontWeight.w700, height: 1.2)),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Resumo do pedido
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _C.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _C.cardBorder, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Resumo do pedido', style: _nu(size: 16, weight: FontWeight.w600)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Itens (${items.length})', style: _nu(size: 14, color: _C.textSecondary)),
                            Text(CurrencyFormat.format(total), style: _nu(size: 14, color: _C.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Frete', style: _nu(size: 14, color: _C.textSecondary)),
                            Text(CurrencyFormat.format(shipping), style: _nu(size: 14, color: const Color(0xFFCCCC00))),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: _C.cardBorder),
                        const SizedBox(height: 16),
                        Center(child: Text('Você pagará', style: _nu(size: 14, color: _C.textSecondary))),
                        const SizedBox(height: 4),
                        Center(child: Text(CurrencyFormat.format(grandTotal), style: _nu(size: 28, weight: FontWeight.w700))),
                        const SizedBox(height: 4),
                        Center(child: Text('Parcele em até 24x', style: _nu(size: 13, color: _C.textSecondary))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Product items
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _C.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _C.cardBorder, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Chegará em 7 dias úteis por ${CurrencyFormat.format(shipping)}', style: _nu(size: 13, color: _C.textSecondary)),
                        const SizedBox(height: 12),
                        ...items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: item.product.imageUrl,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(color: _C.cardLight, width: 56, height: 56),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.name, style: _nu(size: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                                    Text('Qtd: ${item.quantity}', style: _nu(size: 11, color: _C.textTertiary)),
                                  ],
                                ),
                              ),
                              Text(CurrencyFormat.format(item.total), style: _nu(size: 13, weight: FontWeight.w600)),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Delivery address
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _C.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _C.cardBorder, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Endereço de entrega', style: _nu(size: 13, color: _C.textSecondary)),
                              const SizedBox(height: 4),
                              Text('Rua Topázio, 701', style: _nu(size: 15, weight: FontWeight.w600)),
                              Text('Complemento', style: _nu(size: 13, color: _C.textTertiary)),
                            ],
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(color: _C.purple.withValues(alpha: 0.15), shape: BoxShape.circle),
                          child: const Icon(Icons.edit, color: _C.purpleLight, size: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          // Bottom bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            decoration: const BoxDecoration(
              color: _C.surface,
              border: Border(top: BorderSide(color: _C.cardBorder, width: 0.5)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Total com frete', style: _nu(size: 12, color: _C.textSecondary)),
                        Text(CurrencyFormat.format(grandTotal), style: _nu(size: 18, weight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _NuPay(total: grandTotal))),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
                    child: const Text('Ir para pagamento'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════
// NuPay — Payment Screen (Screenshot 2)
// ═════════════════════════════════════════════════════════
class _NuPay extends ConsumerStatefulWidget {
  final double total;
  const _NuPay({required this.total});
  @override
  ConsumerState<_NuPay> createState() => _NuPayState();
}

class _NuPayState extends ConsumerState<_NuPay> {
  String _method = 'credit';
  int _installments = 1;

  @override
  Widget build(BuildContext context) {
    final user = MockData.user;
    final total = widget.total;

    final installmentOptions = <int, double>{1: total, 2: total / 2, 3: total / 3, 12: total / 12, 24: total / 24};

    return Scaffold(
      backgroundColor: _C.bg,
      body: Column(
        children: [
          // Header: NuPay branding
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            decoration: const BoxDecoration(
              color: _C.surface,
              border: Border(bottom: BorderSide(color: _C.cardBorder, width: 0.5)),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: _C.textPrimary, size: 24),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('nu', style: _nu(size: 22, weight: FontWeight.w700, color: _C.purple)),
                          Text('Pay', style: _nu(size: 22, weight: FontWeight.w300)),
                        ],
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Pagando', style: _nu(size: 16, color: _C.textSecondary)),
                  Text(CurrencyFormat.format(total), style: _nu(size: 32, weight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: _nu(size: 14, color: _C.textSecondary),
                      children: [
                        const TextSpan(text: 'para '),
                        TextSpan(text: 'Shopping do Nu', style: _nu(size: 14, weight: FontWeight.w600, color: _C.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Payment Methods
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  // Balance option
                  _Press(
                    onTap: () => setState(() => _method = 'balance'),
                    child: Row(
                      children: [
                        _RadioDot(selected: _method == 'balance'),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('À vista com saldo da conta', style: _nu(size: 15, weight: FontWeight.w500)),
                              Text('${CurrencyFormat.format(user.nubankBalance)} de saldo disponível', style: _nu(size: 13, color: _C.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Credit option
                  _Press(
                    onTap: () => setState(() => _method = 'credit'),
                    child: Row(
                      children: [
                        _RadioDot(selected: _method == 'credit'),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Crédito', style: _nu(size: 15, weight: FontWeight.w500)),
                              Text('${CurrencyFormat.format(user.nubankCreditAvailable)} de limite disponível', style: _nu(size: 13, color: _C.textSecondary)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(border: Border.all(color: _C.textTertiary, width: 0.5), borderRadius: BorderRadius.circular(12)),
                          child: Text('Até 24x', style: _nu(size: 11, color: _C.textSecondary)),
                        ),
                      ],
                    ),
                  ),
                  if (_method == 'credit') ...[
                    const SizedBox(height: 16),
                    _buildInstGrid(installmentOptions),
                  ],
                ],
              ),
            ),
          ),
          // CTA
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            decoration: const BoxDecoration(
              color: _C.surface,
              border: Border(top: BorderSide(color: _C.cardBorder, width: 0.5)),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _Success())),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: Text(_method == 'credit' ? 'Pagar no crédito em ${_installments}x' : 'Pagar com saldo'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstGrid(Map<int, double> options) {
    final entries = options.entries.toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1.6),
      itemCount: entries.length + 1,
      itemBuilder: (context, i) {
        if (i >= entries.length) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(color: _C.cardLight, borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Icon(Icons.edit, color: _C.textSecondary, size: 22)),
            ),
          );
        }
        final e = entries[i];
        final selected = _installments == e.key;
        return GestureDetector(
          onTap: () => setState(() => _installments = e.key),
          child: Container(
            decoration: BoxDecoration(
              color: selected ? _C.purple : _C.cardLight,
              borderRadius: BorderRadius.circular(12),
              border: selected ? Border.all(color: const Color(0xFFCCCC00), width: 1.5) : null,
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${e.key}x', style: _nu(size: 18, weight: FontWeight.w700, color: selected ? const Color(0xFFCCCC00) : _C.textPrimary)),
                Text(CurrencyFormat.format(e.value), style: _nu(size: 11, color: selected ? Colors.white70 : _C.textSecondary)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool selected;
  const _RadioDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: selected ? _C.purple : _C.textTertiary, width: 2),
        color: selected ? _C.purple : Colors.transparent,
      ),
      child: selected ? const Icon(Icons.circle, size: 12, color: Colors.white) : null,
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

class _SuccessState extends ConsumerState<_Success> with TickerProviderStateMixin {
  late final AnimationController _checkCtrl;
  late final AnimationController _scaleCtrl;
  late final AnimationController _confettiCtrl;

  @override
  void initState() {
    super.initState();
    _checkCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scaleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _confettiCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
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
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _confettiCtrl,
                    builder: (context, _) => CustomPaint(size: const Size(200, 200), painter: _ConfettiPainter(progress: _confettiCtrl.value)),
                  ),
                  ScaleTransition(
                    scale: CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOutBack),
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(color: _C.purple.withValues(alpha: 0.15), shape: BoxShape.circle),
                      child: Center(
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(color: _C.purple, shape: BoxShape.circle),
                          child: ScaleTransition(
                            scale: CurvedAnimation(parent: _checkCtrl, curve: Curves.elasticOut),
                            child: const Icon(Icons.check, color: Colors.white, size: 36),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: CurvedAnimation(parent: _checkCtrl, curve: Curves.easeIn),
                child: Column(
                  children: [
                    Text('Pagamento confirmado!', style: _nu(size: 22, weight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('Seu pedido foi processado com sucesso.', style: _nu(size: 14, color: _C.textSecondary), textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: _C.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _C.cardBorder, width: 0.5),
                      ),
                      child: Column(
                        children: [
                          _IRow('Total', CurrencyFormat.format(total)),
                          const SizedBox(height: 8),
                          const _IRow('Previsão', '20-22 de fev'),
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
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
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

class _IRow extends StatelessWidget {
  final String label;
  final String value;
  const _IRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: _nu(size: 13, color: _C.textSecondary)),
        Text(value, style: _nu(size: 13, weight: FontWeight.w600)),
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
    final colors = [_C.purple, _C.purpleLight, _C.green, _C.star, _C.pix];
    for (int i = 0; i < 20; i++) {
      final a = _rng.nextDouble() * 2 * pi;
      final d = 40 + _rng.nextDouble() * 80;
      final x = size.width / 2 + cos(a) * d * progress;
      final y = size.height / 2 + sin(a) * d * progress + 20 * progress * progress;
      final paint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: 1 - progress)
        ..style = PaintingStyle.fill;
      final s = 3 + _rng.nextDouble() * 4;
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(x, y), width: s, height: s * 1.5), const Radius.circular(1)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.progress != progress;
}
