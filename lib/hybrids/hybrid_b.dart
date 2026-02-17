/// Hybrid_B — Low Density, Nubank-Style, Credit-First
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Density: LOW (spacious cards, generous whitespace)
/// CTA Placement: Floating Bottom Bar
/// Info Hierarchy: Credit First → Price Second
/// Naming Variable: "Limite Magalu" (VAR_B — Exclusivity)
/// Brand: Magalu Blue #0086FF, Inter font
/// Credit Injection: Phase A (Home) + Phase B (PDP) + Phase C (Cart) + Phase D (Payment)
///
/// Per funnel_logic.md: Credit visible at TOP of funnel.
/// "Carnê Digital" is FORBIDDEN.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/models.dart';
import '../data/mock_data.dart';
import '../utils/currency_format.dart';

// ─── CONSTANTS ───────────────────────────────────────────
const _magaluBlue = Color(0xFF0086FF);
const _magaluGreen = Color(0xFF00A650);
const _bgLight = Color(0xFFF9F9F9);
const _surfaceWhite = Colors.white;
const _textPrimary = Color(0xFF1A1A1A);
const _textSecondary = Color(0xFF757575);
const _cardRadius = 16.0;

// ─── ENTRY POINT ─────────────────────────────────────────
class HybridBApp extends StatelessWidget {
  const HybridBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hybrid B — Limite Magalu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: _magaluBlue,
        useMaterial3: true,
        scaffoldBackgroundColor: _bgLight,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const _HybridBHome(),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PHASE A — HOME (Discovery) — Spacious, Credit-First
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _HybridBHome extends StatefulWidget {
  const _HybridBHome();

  @override
  State<_HybridBHome> createState() => _HybridBHomeState();
}

class _HybridBHomeState extends State<_HybridBHome> {
  final _cart = <CartItem>[];
  int _navIndex = 0;

  void _addToCart(Product p) {
    setState(() {
      final idx = _cart.indexWhere((c) => c.product.id == p.id);
      if (idx >= 0) {
        _cart[idx] = _cart[idx].copyWith(quantity: _cart[idx].quantity + 1);
      } else {
        _cart.add(CartItem(product: p));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${p.name.split(' ').take(3).join(' ')} adicionado'),
        duration: const Duration(seconds: 1),
        backgroundColor: _magaluBlue,
      ),
    );
  }

  void _removeFromCart(String productId) {
    setState(() => _cart.removeWhere((c) => c.product.id == productId));
  }

  void _updateQuantity(String productId, int qty) {
    setState(() {
      if (qty <= 0) {
        _cart.removeWhere((c) => c.product.id == productId);
      } else {
        final idx = _cart.indexWhere((c) => c.product.id == productId);
        if (idx >= 0) _cart[idx] = _cart[idx].copyWith(quantity: qty);
      }
    });
  }

  int get _cartCount => _cart.fold(0, (s, c) => s + c.quantity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      body: IndexedStack(
        index: _navIndex,
        children: [
          _HomeTab(cart: _cart, onAddToCart: _addToCart, onNavigate: _goTo),
          _CartScreen(
            cart: _cart,
            onRemove: _removeFromCart,
            onUpdateQty: _updateQuantity,
            onNavigate: _goTo,
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        index: _navIndex,
        cartCount: _cartCount,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  void _goTo(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

// ─── HOME TAB — Spacious with large credit card ──────────
class _HomeTab extends StatelessWidget {
  final List<CartItem> cart;
  final ValueChanged<Product> onAddToCart;
  final void Function(Widget) onNavigate;

  const _HomeTab({required this.cart, required this.onAddToCart, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final user = MockData.user;
    final creditAvailable = user.carneDigitalAvailable;

    return CustomScrollView(
      slivers: [
        // ── HEADER (clean, minimal) ──
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, bottom: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        'magalu',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: _magaluBlue,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.notifications_none, color: _textSecondary, size: 24),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // Search bar (rounded, spacious)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: _bgLight,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Icon(Icons.search, color: _textSecondary, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'Buscar produtos...',
                          style: GoogleFonts.inter(fontSize: 15, color: _textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── CREDIT HERO CARD (Phase A — Credit FIRST, large, prominent) ──
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_magaluBlue, Color(0xFF005BBF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(_cardRadius),
              boxShadow: [
                BoxShadow(
                  color: _magaluBlue.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.credit_score, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seu Limite Magalu está ativo!',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Limite exclusivo pré-aprovado para você',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Limite disponível',
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormat.format(creditAvailable),
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Parcele em até 24x sem cartão',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── SECTION TITLE ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(
              'Produtos para você',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: _textPrimary),
            ),
          ),
        ),

        // ── PRODUCT LIST (Low density — vertical cards, spacious) ──
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = MockData.products[index % MockData.products.length];
                return _ProductCardSpacious(
                  product: product,
                  creditAvailable: creditAvailable,
                  onTap: () => onNavigate(
                    _HybridBPDP(product: product, onAddToCart: onAddToCart),
                  ),
                );
              },
              childCount: MockData.products.length,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}

// ─── SPACIOUS PRODUCT CARD (credit-first info) ───────────
class _ProductCardSpacious extends StatelessWidget {
  final Product product;
  final double creditAvailable;
  final VoidCallback onTap;

  const _ProductCardSpacious({
    required this.product,
    required this.creditAvailable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasCredit = creditAvailable >= product.price;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _surfaceWhite,
          borderRadius: BorderRadius.circular(_cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(_cardRadius)),
              child: Container(
                width: 120,
                height: 140,
                color: const Color(0xFFF8F8F8),
                child: Stack(
                  children: [
                    Center(
                      child: Image.network(
                        product.imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 40, color: Color(0xFFCCCCCC)),
                      ),
                    ),
                    if (product.discountPercent > 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: _magaluGreen,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '-${product.discountPercent}%',
                            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Info — CREDIT FIRST
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Credit badge FIRST (Credit First hierarchy)
                    if (hasCredit)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _magaluBlue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.credit_card, color: _magaluBlue, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              'Limite Magalu até ${product.maxInstallments}x',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: _magaluBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 13, color: _textPrimary, height: 1.3),
                    ),
                    const SizedBox(height: 8),
                    if (product.originalPrice != null)
                      Text(
                        CurrencyFormat.format(product.originalPrice!),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: _textSecondary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Text(
                      CurrencyFormat.format(product.price),
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: _textPrimary),
                    ),
                    if (product.freeShipping)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(Icons.local_shipping, color: _magaluGreen, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              'Frete grátis',
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: _magaluGreen),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PHASE B — PDP (Consideration) — Credit-First, Floating CTA
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _HybridBPDP extends StatelessWidget {
  final Product product;
  final ValueChanged<Product> onAddToCart;

  const _HybridBPDP({required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final user = MockData.user;
    final creditAvailable = user.carneDigitalAvailable;
    final installmentValue = product.price / product.maxInstallments;

    return Scaffold(
      backgroundColor: _bgLight,
      body: Column(
        children: [
          // ── App Bar (clean) ──
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: SizedBox(
              height: 52,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.share_outlined, size: 20), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.favorite_border, size: 20), onPressed: () {}),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Image (large, generous spacing)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  height: 320,
                  width: double.infinity,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.image, size: 60, color: Color(0xFFCCCCCC)),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── CREDIT SECTION FIRST (Phase B — Credit First hierarchy) ──
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_magaluBlue.withValues(alpha: 0.08), _magaluBlue.withValues(alpha: 0.03)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(_cardRadius),
                    border: Border.all(color: _magaluBlue.withValues(alpha: 0.15)),
                  ),
                  child: GestureDetector(
                    onTap: () => _showSimulator(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.credit_score, color: _magaluBlue, size: 22),
                            const SizedBox(width: 10),
                            Text(
                              'Limite Magalu disponível',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _magaluBlue,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _magaluBlue,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                'Simular',
                                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Credit first → then installments
                        Text(
                          '${CurrencyFormat.format(creditAvailable)} disponível',
                          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: _magaluBlue),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${product.maxInstallments}x de ${CurrencyFormat.format(installmentValue)} sem cartão',
                          style: GoogleFonts.inter(fontSize: 13, color: _textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── PRODUCT INFO (price second) ──
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(_cardRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.brand,
                        style: GoogleFonts.inter(fontSize: 12, color: _textSecondary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product.name,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _textPrimary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber.shade700, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${product.rating}',
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            ' (${product.reviewCount} avaliações)',
                            style: GoogleFonts.inter(fontSize: 13, color: _textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (product.originalPrice != null) ...[
                        Row(
                          children: [
                            Text(
                              CurrencyFormat.format(product.originalPrice!),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: _textSecondary,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _magaluGreen,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '-${product.discountPercent}%',
                                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],

                      Text(
                        CurrencyFormat.format(product.price),
                        style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: _textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'até ${product.maxInstallments}x de ${CurrencyFormat.format(installmentValue)} sem juros',
                        style: GoogleFonts.inter(fontSize: 13, color: _magaluBlue),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Shipping
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(_cardRadius),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        product.freeShipping ? Icons.local_shipping : Icons.local_shipping_outlined,
                        color: product.freeShipping ? _magaluGreen : _textSecondary,
                        size: 22,
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.freeShipping ? 'Frete grátis' : 'Frete: ${CurrencyFormat.format(product.shippingCost ?? 0)}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: product.freeShipping ? _magaluGreen : _textPrimary,
                            ),
                          ),
                          if (product.deliveryDate != null)
                            Text(
                              'Previsão: ${product.deliveryDate}',
                              style: GoogleFonts.inter(fontSize: 12, color: _textSecondary),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100), // space for floating CTA
              ],
            ),
          ),
        ],
      ),
      // ── FLOATING BOTTOM BAR CTA ──
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  CurrencyFormat.format(product.price),
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: _textPrimary),
                ),
                Text(
                  'ou ${product.maxInstallments}x Limite Magalu',
                  style: GoogleFonts.inter(fontSize: 11, color: _magaluBlue),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                onAddToCart(product);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _magaluBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text(
                'Comprar',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSimulator(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SimulatorSheet(productPrice: product.price),
    );
  }
}

// ─── SIMULATOR BOTTOM SHEET ──────────────────────────────
class _SimulatorSheet extends StatefulWidget {
  final double productPrice;
  const _SimulatorSheet({required this.productPrice});

  @override
  State<_SimulatorSheet> createState() => _SimulatorSheetState();
}

class _SimulatorSheetState extends State<_SimulatorSheet> {
  int _selected = 1;

  List<_InstOpt> get _options {
    const installments = [1, 2, 3, 6, 10, 12, 18, 24];
    return installments.map((n) {
      double rate = 0;
      if (n > 3 && n <= 6) rate = 0.0199;
      if (n > 6 && n <= 12) rate = 0.0249;
      if (n > 12) rate = 0.0299;
      final total = widget.productPrice * (1 + rate * n);
      return _InstOpt(count: n, perMonth: total / n, total: total, hasInterest: n > 3);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.65),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(color: const Color(0xFFDDDDDD), borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                const Icon(Icons.calculate, color: _magaluBlue, size: 24),
                const SizedBox(width: 10),
                Text(
                  'Simular Limite Magalu',
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Divider(),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: _options.map((opt) {
                final isSelected = opt.count == _selected;
                return GestureDetector(
                  onTap: () => setState(() => _selected = opt.count),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? _magaluBlue.withValues(alpha: 0.06) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? _magaluBlue : const Color(0xFFEEEEEE),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? _magaluBlue : const Color(0xFFCCCCCC),
                              width: 2,
                            ),
                            color: isSelected ? _magaluBlue : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white, size: 14)
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            '${opt.count}x de ${CurrencyFormat.format(opt.perMonth)}',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(CurrencyFormat.format(opt.total), style: GoogleFonts.inter(fontSize: 12, color: _textSecondary)),
                            Text(
                              opt.hasInterest ? 'com juros' : 'sem juros',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: opt.hasInterest ? _textSecondary : _magaluGreen,
                                fontWeight: opt.hasInterest ? FontWeight.w400 : FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).padding.bottom + 14),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _magaluBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  'Aplicar ${_selected}x de ${CurrencyFormat.format(_options.firstWhere((o) => o.count == _selected).perMonth)}',
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InstOpt {
  final int count;
  final double perMonth;
  final double total;
  final bool hasInterest;
  const _InstOpt({required this.count, required this.perMonth, required this.total, required this.hasInterest});
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PHASE C — CART (Intent) — Spacious
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _CartScreen extends StatelessWidget {
  final List<CartItem> cart;
  final void Function(String) onRemove;
  final void Function(String, int) onUpdateQty;
  final void Function(Widget) onNavigate;

  const _CartScreen({
    required this.cart,
    required this.onRemove,
    required this.onUpdateQty,
    required this.onNavigate,
  });

  double get _total => cart.fold(0, (s, c) => s + c.total);

  @override
  Widget build(BuildContext context) {
    if (cart.isEmpty) {
      return Scaffold(
        backgroundColor: _bgLight,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: _textPrimary,
          elevation: 0,
          title: Text('Sacola', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shopping_bag_outlined, size: 72, color: _textSecondary.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text('Sua sacola está vazia', style: GoogleFonts.inter(fontSize: 17, color: _textSecondary)),
              const SizedBox(height: 4),
              Text('Adicione produtos para continuar', style: GoogleFonts.inter(fontSize: 13, color: _textSecondary)),
            ],
          ),
        ),
      );
    }

    final savings = _total * 0.05;

    return Scaffold(
      backgroundColor: _bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _textPrimary,
        elevation: 0,
        title: Text('Sacola (${cart.length})', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          // ── SAVINGS CALLOUT (Phase C) ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _magaluBlue.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(_cardRadius),
              border: Border.all(color: _magaluBlue.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.savings, color: _magaluBlue, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(fontSize: 13, color: _textPrimary),
                      children: [
                        const TextSpan(text: 'Você economiza '),
                        TextSpan(
                          text: CurrencyFormat.format(savings),
                          style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: _magaluBlue),
                        ),
                        const TextSpan(text: ' usando seu Limite Magalu'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Cart items (spacious)
          ...cart.map((item) => _CartItemTile(
                item: item,
                onRemove: () => onRemove(item.product.id),
                onUpdateQty: (q) => onUpdateQty(item.product.id, q),
              )),

          // Summary
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_cardRadius),
            ),
            child: Column(
              children: [
                _SummaryRow('Subtotal', CurrencyFormat.format(_total)),
                const SizedBox(height: 8),
                _SummaryRow('Frete', 'Grátis', valueColor: _magaluGreen),
                const Divider(height: 20),
                _SummaryRow('Total', CurrencyFormat.format(_total), isBold: true),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'até 24x de ${CurrencyFormat.format(_total / 24)} com Limite Magalu',
                    style: GoogleFonts.inter(fontSize: 12, color: _magaluBlue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Floating CTA bar
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, -2)),
          ],
        ),
        padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => onNavigate(_HybridBCheckout(cart: cart, total: _total)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _magaluBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: Text(
              'Continuar • ${CurrencyFormat.format(_total)}',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── CART ITEM TILE ──────────────────────────────────────
class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final ValueChanged<int> onUpdateQty;

  const _CartItemTile({required this.item, required this.onRemove, required this.onUpdateQty});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.product.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                width: 70,
                height: 70,
                color: const Color(0xFFF0F0F0),
                child: const Icon(Icons.image, size: 28, color: Color(0xFFCCCCCC)),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 13, color: _textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  CurrencyFormat.format(item.total),
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _QtyButton(icon: Icons.remove, onTap: () => onUpdateQty(item.quantity - 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('${item.quantity}', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                  _QtyButton(icon: Icons.add, onTap: () => onUpdateQty(item.quantity + 1)),
                ],
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: onRemove,
                child: Text('Remover', style: GoogleFonts.inter(fontSize: 11, color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PHASE D — CHECKOUT / PAYMENT (Conversion)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _HybridBCheckout extends StatefulWidget {
  final List<CartItem> cart;
  final double total;

  const _HybridBCheckout({required this.cart, required this.total});

  @override
  State<_HybridBCheckout> createState() => _HybridBCheckoutState();
}

class _HybridBCheckoutState extends State<_HybridBCheckout> {
  int _selectedPayment = 0; // Limite Magalu pre-selected
  int _selectedInstallments = 12;

  @override
  Widget build(BuildContext context) {
    final user = MockData.user;
    final creditAvailable = user.carneDigitalAvailable;
    final installmentValue = widget.total / _selectedInstallments;

    return Scaffold(
      backgroundColor: _bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _textPrimary,
        elevation: 0,
        title: Text('Pagamento', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Order summary
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_cardRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resumo do pedido', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                ...widget.cart.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantity}x ${item.product.name.split(' ').take(4).join(' ')}',
                              style: GoogleFonts.inter(fontSize: 13, color: _textSecondary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(CurrencyFormat.format(item.total), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700)),
                    Text(CurrencyFormat.format(widget.total), style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text('Forma de pagamento', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),

          // Limite Magalu — PRE-SELECTED
          _PaymentTile(
            icon: Icons.credit_score,
            label: 'Limite Magalu',
            subtitle: 'Até ${_selectedInstallments}x • ${CurrencyFormat.format(creditAvailable)} disponível',
            badge: 'Recomendado',
            isSelected: _selectedPayment == 0,
            color: _magaluBlue,
            onTap: () => setState(() => _selectedPayment = 0),
          ),

          _PaymentTile(
            icon: Icons.pix,
            label: 'Pix',
            subtitle: 'Aprovação imediata',
            isSelected: _selectedPayment == 1,
            color: const Color(0xFF00BDAE),
            onTap: () => setState(() => _selectedPayment = 1),
          ),

          _PaymentTile(
            icon: Icons.credit_card,
            label: 'Cartão de crédito',
            subtitle: 'Até 12x',
            isSelected: _selectedPayment == 2,
            color: _textSecondary,
            onTap: () => setState(() => _selectedPayment = 2),
          ),

          _PaymentTile(
            icon: Icons.receipt_long,
            label: 'Boleto',
            subtitle: 'Até 3 dias úteis',
            isSelected: _selectedPayment == 3,
            color: _textSecondary,
            onTap: () => setState(() => _selectedPayment = 3),
          ),

          // Installment grid
          if (_selectedPayment == 0) ...[
            const SizedBox(height: 16),
            Text('Parcelas', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [1, 2, 3, 6, 12, 18, 24].map((n) {
                final isSel = n == _selectedInstallments;
                return GestureDetector(
                  onTap: () => setState(() => _selectedInstallments = n),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSel ? _magaluBlue : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSel ? _magaluBlue : const Color(0xFFDDDDDD)),
                    ),
                    child: Text(
                      '${n}x de ${CurrencyFormat.format(widget.total / n)}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        color: isSel ? Colors.white : _textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 100),
        ],
      ),
      // Floating bottom CTA
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, -2)),
          ],
        ),
        padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedPayment == 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  '${_selectedInstallments}x de ${CurrencyFormat.format(installmentValue)} com Limite Magalu',
                  style: GoogleFonts.inter(fontSize: 14, color: _magaluBlue, fontWeight: FontWeight.w600),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const _HybridBSuccess()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _magaluBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text(
                  'Finalizar compra',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── PAYMENT TILE ────────────────────────────────────────
class _PaymentTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final String? badge;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.badge,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFEEEEEE),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(label, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            badge!,
                            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: _textSecondary)),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? color : const Color(0xFFCCCCCC),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// SUCCESS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _HybridBSuccess extends StatelessWidget {
  const _HybridBSuccess();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: _magaluGreen.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: _magaluGreen, size: 52),
                ),
                const SizedBox(height: 24),
                Text(
                  'Pedido confirmado!',
                  style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: _textPrimary),
                ),
                const SizedBox(height: 10),
                Text(
                  'Pagamento via Limite Magalu aprovado.\nVocê receberá atualizações por e-mail.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 15, color: _textSecondary, height: 1.5),
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _magaluBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Voltar ao início',
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// SHARED WIDGETS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: _textSecondary),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow(this.label, this.value, {this.isBold = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: _textPrimary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor ?? _textPrimary,
          ),
        ),
      ],
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int index;
  final int cartCount;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.index, required this.cartCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: onTap,
      selectedItemColor: _magaluBlue,
      unselectedItemColor: _textSecondary,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Início'),
        BottomNavigationBarItem(
          icon: Badge(
            isLabelVisible: cartCount > 0,
            label: Text('$cartCount', style: const TextStyle(fontSize: 10)),
            backgroundColor: _magaluBlue,
            child: const Icon(Icons.shopping_bag_outlined),
          ),
          label: 'Sacola',
        ),
      ],
    );
  }
}
