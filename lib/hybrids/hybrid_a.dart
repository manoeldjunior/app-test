/// Hybrid_A — High Density, ML-Style, Price-First
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Density: HIGH (compact cards, tight spacing)
/// CTA Placement: Top-Right (price-adjacent)
/// Info Hierarchy: Price First → Credit Second
/// Naming Variable: "Pix Parcelado" (VAR_A — Speed)
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
const _bgGray = Color(0xFFF5F5F5);
const _surfaceWhite = Colors.white;
const _textPrimary = Color(0xFF1A1A1A);
const _textSecondary = Color(0xFF757575);

// ─── ENTRY POINT ─────────────────────────────────────────
class HybridAApp extends StatelessWidget {
  const HybridAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hybrid A — Pix Parcelado',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: _magaluBlue,
        useMaterial3: true,
        scaffoldBackgroundColor: _bgGray,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const _HybridAHome(),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PHASE A — HOME (Discovery)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _HybridAHome extends StatefulWidget {
  const _HybridAHome();

  @override
  State<_HybridAHome> createState() => _HybridAHomeState();
}

class _HybridAHomeState extends State<_HybridAHome> {
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

  double get _cartTotal => _cart.fold(0, (s, c) => s + c.total);
  int get _cartCount => _cart.fold(0, (s, c) => s + c.quantity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGray,
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
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}

// ─── HOME TAB ────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  final List<CartItem> cart;
  final ValueChanged<Product> onAddToCart;
  final void Function(Widget) onNavigate;

  const _HomeTab({
    required this.cart,
    required this.onAddToCart,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final user = MockData.user;
    final creditAvailable = user.carneDigitalAvailable;

    return CustomScrollView(
      slivers: [
        // ── HEADER ──
        SliverToBoxAdapter(
          child: Container(
            color: _magaluBlue,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, bottom: 12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'magalu',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      _HeaderIcon(Icons.search, onTap: () {}),
                      const SizedBox(width: 12),
                      _HeaderIcon(Icons.notifications_none, onTap: () {}),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(Icons.search, color: _textSecondary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Buscar produtos, marcas...',
                          style: GoogleFonts.inter(fontSize: 14, color: _textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── CREDIT BANNER (Phase A — Top of Funnel) ──
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_magaluBlue, Color(0xFF0066CC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.credit_score, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pix Parcelado disponível!',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Parcele em até 24x sem cartão',
                        style: GoogleFonts.inter(fontSize: 11, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    CurrencyFormat.format(creditAvailable),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── CATEGORY PILLS ──
        SliverToBoxAdapter(
          child: SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: const [
                _CategoryPill('Ofertas', selected: true),
                _CategoryPill('Eletrônicos'),
                _CategoryPill('Casa'),
                _CategoryPill('Moda'),
                _CategoryPill('Games'),
                _CategoryPill('Beleza'),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // ── PRODUCT GRID (High Density — 2 columns, compact) ──
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 0.52,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = MockData.products[index % MockData.products.length];
                return _ProductCard(
                  product: product,
                  creditAvailable: creditAvailable,
                  onTap: () => onNavigate(
                    _HybridAPDP(
                      product: product,
                      onAddToCart: onAddToCart,
                    ),
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

// ─── PRODUCT CARD (compact, credit badge) ────────────────
class _ProductCard extends StatelessWidget {
  final Product product;
  final double creditAvailable;
  final VoidCallback onTap;

  const _ProductCard({
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
        decoration: BoxDecoration(
          color: _surfaceWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    child: Container(
                      width: double.infinity,
                      color: const Color(0xFFF8F8F8),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.image, size: 40, color: Color(0xFFCCCCCC)),
                        ),
                      ),
                    ),
                  ),
                  if (product.discountPercent > 0)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _magaluGreen,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-${product.discountPercent}%',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  // Credit badge on product card (Phase A injection)
                  if (hasCredit)
                    Positioned(
                      bottom: 4,
                      left: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: _magaluBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.credit_card, color: _magaluBlue, size: 10),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                'Pix Parcelado até ${product.maxInstallments}x',
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: _magaluBlue,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Info
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: _textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    if (product.originalPrice != null)
                      Text(
                        CurrencyFormat.format(product.originalPrice!),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: _textSecondary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Text(
                      CurrencyFormat.format(product.price),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _textPrimary,
                      ),
                    ),
                    // Price First → then credit installment
                    if (product.maxInstallments > 1)
                      Text(
                        'até ${product.maxInstallments}x de ${CurrencyFormat.format(product.installmentPrice)}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: _magaluBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (product.freeShipping)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Frete grátis',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _magaluGreen,
                          ),
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
// PHASE B — PDP (Consideration)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _HybridAPDP extends StatelessWidget {
  final Product product;
  final ValueChanged<Product> onAddToCart;

  const _HybridAPDP({required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final user = MockData.user;
    final creditAvailable = user.carneDigitalAvailable;
    final installmentValue = product.price / product.maxInstallments;

    return Scaffold(
      backgroundColor: _bgGray,
      body: Column(
        children: [
          // ── App Bar ──
          Container(
            color: _magaluBlue,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: SizedBox(
              height: 48,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      product.name.split(' ').take(4).join(' '),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.white, size: 20),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          // ── Content ──
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Image
                Container(
                  color: Colors.white,
                  height: 280,
                  width: double.infinity,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.image, size: 60, color: Color(0xFFCCCCCC)),
                    ),
                  ),
                ),

                // Price section — PRICE FIRST
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.brand,
                        style: GoogleFonts.inter(fontSize: 12, color: _textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.name,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: _textPrimary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber.shade700, size: 14),
                          const SizedBox(width: 3),
                          Text(
                            '${product.rating}',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            ' (${product.reviewCount})',
                            style: GoogleFonts.inter(fontSize: 12, color: _textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (product.originalPrice != null) ...[
                        Row(
                          children: [
                            Text(
                              CurrencyFormat.format(product.originalPrice!),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: _textSecondary,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _magaluGreen,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '-${product.discountPercent}%',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],

                      Text(
                        CurrencyFormat.format(product.price),
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'até ${product.maxInstallments}x de ${CurrencyFormat.format(installmentValue)} sem juros',
                        style: GoogleFonts.inter(fontSize: 13, color: _magaluBlue),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                // ── CREDIT SECTION (Phase B — Consideration) ──
                // "Available Limit" pill next to price area per funnel_logic.md
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(14),
                  child: GestureDetector(
                    onTap: () => _showSimulator(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _magaluBlue.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _magaluBlue.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.credit_score, color: _magaluBlue, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pix Parcelado disponível',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _magaluBlue,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${product.maxInstallments}x de ${CurrencyFormat.format(installmentValue)} • ${CurrencyFormat.format(creditAvailable)} disponível',
                                  style: GoogleFonts.inter(fontSize: 11, color: _textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _magaluBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Simular',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // Shipping
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(
                        product.freeShipping ? Icons.local_shipping : Icons.local_shipping_outlined,
                        color: product.freeShipping ? _magaluGreen : _textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        product.freeShipping
                            ? 'Frete grátis'
                            : 'Frete: ${CurrencyFormat.format(product.shippingCost ?? 0)}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: product.freeShipping ? _magaluGreen : _textPrimary,
                        ),
                      ),
                      if (product.deliveryDate != null) ...[
                        const Spacer(),
                        Text(
                          'Chega ${product.deliveryDate}',
                          style: GoogleFonts.inter(fontSize: 12, color: _textSecondary),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                // Seller
                if (product.seller != null)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        const Icon(Icons.store, color: _textSecondary, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          'Vendido e entregue por ',
                          style: GoogleFonts.inter(fontSize: 12, color: _textSecondary),
                        ),
                        Text(
                          product.seller!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _magaluBlue,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
      // CTA — Price-adjacent Top-Right style (sticky bottom bar with price + button)
      bottomSheet: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(16, 10, 16, MediaQuery.of(context).padding.bottom + 10),
        child: Row(
          children: [
            // Price (left)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  CurrencyFormat.format(product.price),
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _textPrimary,
                  ),
                ),
                Text(
                  'até ${product.maxInstallments}x Pix Parcelado',
                  style: GoogleFonts.inter(fontSize: 11, color: _magaluBlue),
                ),
              ],
            ),
            const Spacer(),
            // Buy CTA (right, adjacent to price)
            ElevatedButton(
              onPressed: () {
                onAddToCart(product);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _magaluBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Comprar',
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSimulator(BuildContext context) {
    final price = product.price;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SimulatorSheet(productPrice: price),
    );
  }
}

// ─── SIMULATOR BOTTOM SHEET (Phase B) ────────────────────
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(color: const Color(0xFFDDDDDD), borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                const Icon(Icons.calculate, color: _magaluBlue, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Simular Pix Parcelado',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Divider(),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: _options.map((opt) {
                final isSelected = opt.count == _selected;
                return GestureDetector(
                  onTap: () => setState(() => _selected = opt.count),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? _magaluBlue.withValues(alpha: 0.08) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? _magaluBlue : const Color(0xFFEEEEEE),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Radio<int>(
                          value: opt.count,
                          groupValue: _selected,
                          onChanged: (v) => setState(() => _selected = v!),
                          activeColor: _magaluBlue,
                        ),
                        Expanded(
                          child: Text(
                            '${opt.count}x de ${CurrencyFormat.format(opt.perMonth)}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              CurrencyFormat.format(opt.total),
                              style: GoogleFonts.inter(fontSize: 12, color: _textSecondary),
                            ),
                            if (opt.hasInterest)
                              Text(
                                'com juros',
                                style: GoogleFonts.inter(fontSize: 10, color: _textSecondary),
                              )
                            else
                              Text(
                                'sem juros',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: _magaluGreen,
                                  fontWeight: FontWeight.w600,
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
            padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).padding.bottom + 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _magaluBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Aplicar ${_selected}x de ${CurrencyFormat.format(_options.firstWhere((o) => o.count == _selected).perMonth)}',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
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
// PHASE C — CART (Intent)
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
        backgroundColor: _bgGray,
        appBar: AppBar(
          backgroundColor: _magaluBlue,
          foregroundColor: Colors.white,
          title: Text('Sacola', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shopping_bag_outlined, size: 64, color: _textSecondary.withValues(alpha: 0.4)),
              const SizedBox(height: 12),
              Text('Sua sacola está vazia', style: GoogleFonts.inter(fontSize: 16, color: _textSecondary)),
            ],
          ),
        ),
      );
    }

    // Calculate savings hint per funnel_logic.md Phase C
    final savings = _total * 0.05; // 5% simulated savings

    return Scaffold(
      backgroundColor: _bgGray,
      appBar: AppBar(
        backgroundColor: _magaluBlue,
        foregroundColor: Colors.white,
        title: Text('Sacola (${cart.length})', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 8),
        children: [
          // ── SAVINGS CALLOUT (Phase C — Intent) ──
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _magaluBlue.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _magaluBlue.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.savings, color: _magaluBlue, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(fontSize: 12, color: _textPrimary),
                      children: [
                        const TextSpan(text: 'Você economiza '),
                        TextSpan(
                          text: CurrencyFormat.format(savings),
                          style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: _magaluBlue),
                        ),
                        const TextSpan(text: ' usando seu Pix Parcelado'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Cart items
          ...cart.map((item) => _CartItemTile(
                item: item,
                onRemove: () => onRemove(item.product.id),
                onUpdateQty: (q) => onUpdateQty(item.product.id, q),
              )),

          // Summary
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _SummaryRow('Subtotal', CurrencyFormat.format(_total)),
                const SizedBox(height: 6),
                _SummaryRow('Frete', 'Grátis', valueColor: _magaluGreen),
                const Divider(height: 16),
                _SummaryRow('Total', CurrencyFormat.format(_total), isBold: true),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ou até 24x de ${CurrencyFormat.format(_total / 24)} com Pix Parcelado',
                    style: GoogleFonts.inter(fontSize: 11, color: _magaluBlue),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 60),
        ],
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(16, 10, 16, MediaQuery.of(context).padding.bottom + 10),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => onNavigate(
              _HybridACheckout(cart: cart, total: _total),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _magaluBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Continuar • ${CurrencyFormat.format(_total)}',
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
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
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              item.product.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                width: 60,
                height: 60,
                color: const Color(0xFFF0F0F0),
                child: const Icon(Icons.image, size: 24, color: Color(0xFFCCCCCC)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 12, color: _textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormat.format(item.total),
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _QtyButton(
                    icon: Icons.remove,
                    onTap: () => onUpdateQty(item.quantity - 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '${item.quantity}',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  _QtyButton(
                    icon: Icons.add,
                    onTap: () => onUpdateQty(item.quantity + 1),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onRemove,
                child: Text(
                  'Remover',
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.red),
                ),
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
class _HybridACheckout extends StatefulWidget {
  final List<CartItem> cart;
  final double total;

  const _HybridACheckout({required this.cart, required this.total});

  @override
  State<_HybridACheckout> createState() => _HybridACheckoutState();
}

class _HybridACheckoutState extends State<_HybridACheckout> {
  // Per funnel_logic.md Phase D: credit should be SELECTED by default
  int _selectedPayment = 0; // 0 = Pix Parcelado (pre-selected)
  int _selectedInstallments = 12;

  @override
  Widget build(BuildContext context) {
    final user = MockData.user;
    final creditAvailable = user.carneDigitalAvailable;
    final installmentValue = widget.total / _selectedInstallments;

    return Scaffold(
      backgroundColor: _bgGray,
      appBar: AppBar(
        backgroundColor: _magaluBlue,
        foregroundColor: Colors.white,
        title: Text('Pagamento', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Order summary
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumo do pedido',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...widget.cart.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantity}x ${item.product.name.split(' ').take(4).join(' ')}',
                              style: GoogleFonts.inter(fontSize: 12, color: _textSecondary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            CurrencyFormat.format(item.total),
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                    Text(
                      CurrencyFormat.format(widget.total),
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Payment methods
          Text(
            'Forma de pagamento',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),

          // ── Pix Parcelado — PRE-SELECTED per funnel_logic.md ──
          _PaymentTile(
            icon: Icons.credit_score,
            label: 'Pix Parcelado',
            subtitle: 'Até ${_selectedInstallments}x • ${CurrencyFormat.format(creditAvailable)} disponível',
            badge: 'Mais rápido',
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

          // Installment selection if Pix Parcelado is selected
          if (_selectedPayment == 0) ...[
            const SizedBox(height: 12),
            Text(
              'Parcelas',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [1, 2, 3, 6, 12, 18, 24].map((n) {
                final isSelected = n == _selectedInstallments;
                return GestureDetector(
                  onTap: () => setState(() => _selectedInstallments = n),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? _magaluBlue : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? _magaluBlue : const Color(0xFFDDDDDD),
                      ),
                    ),
                    child: Text(
                      '${n}x de ${CurrencyFormat.format(widget.total / n)}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : _textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 80),
        ],
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(16, 10, 16, MediaQuery.of(context).padding.bottom + 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedPayment == 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${_selectedInstallments}x de ${CurrencyFormat.format(installmentValue)} com Pix Parcelado',
                  style: GoogleFonts.inter(fontSize: 13, color: _magaluBlue, fontWeight: FontWeight.w600),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const _HybridASuccess()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _magaluBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Finalizar compra',
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
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
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFEEEEEE),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge!,
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(fontSize: 11, color: _textSecondary),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? color : const Color(0xFFCCCCCC),
              size: 22,
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
class _HybridASuccess extends StatelessWidget {
  const _HybridASuccess();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGray,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _magaluGreen.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: _magaluGreen, size: 48),
                ),
                const SizedBox(height: 20),
                Text(
                  'Pedido confirmado!',
                  style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: _textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pagamento via Pix Parcelado aprovado.\nVocê receberá atualizações por e-mail.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 14, color: _textSecondary, height: 1.4),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _magaluBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Voltar ao início',
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
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
class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIcon(this.icon, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;
  final bool selected;

  const _CategoryPill(this.label, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? _magaluBlue.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? _magaluBlue : const Color(0xFFDDDDDD),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected ? _magaluBlue : _textSecondary,
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(6),
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
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: _textPrimary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: isBold ? 15 : 13,
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
      selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
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
