/// Hybrid_C — Balanced Density, Inline CTA, Equal Weight
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Density: BALANCED (medium cards, moderate spacing)
/// CTA Placement: Inline (Below Image on PDP)
/// Info Hierarchy: Equal Weight — Price & Credit side by side (Split View)
/// Naming Variable: "Crédito Rápido" (Speed + Trust)
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
const _textPrimary = Color(0xFF1A1A1A);
const _textSecondary = Color(0xFF757575);
const _cardRadius = 12.0;

// ─── ENTRY POINT ─────────────────────────────────────────
class HybridCApp extends StatelessWidget {
  const HybridCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hybrid C — Crédito Rápido',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: _magaluBlue,
        useMaterial3: true,
        scaffoldBackgroundColor: _bgGray,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const _HybridCHome(),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PHASE A — HOME (Discovery) — Balanced, Equal Weight
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _HybridCHome extends StatefulWidget {
  const _HybridCHome();

  @override
  State<_HybridCHome> createState() => _HybridCHomeState();
}

class _HybridCHomeState extends State<_HybridCHome> {
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
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

// ─── HOME TAB ────────────────────────────────────────────
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
        // ── HEADER ──
        SliverToBoxAdapter(
          child: Container(
            color: _magaluBlue,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 14),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'magalu',
                        style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      const Spacer(),
                      const Icon(Icons.notifications_none, color: Colors.white, size: 24),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        Icon(Icons.search, color: _textSecondary, size: 20),
                        const SizedBox(width: 10),
                        Text('Buscar produtos...', style: GoogleFonts.inter(fontSize: 14, color: _textSecondary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── CREDIT BANNER (Phase A — Equal Weight: shows BOTH limit AND installments) ──
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(14, 14, 14, 6),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_cardRadius),
              border: Border.all(color: _magaluBlue.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                // Left — Credit info
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _magaluBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.credit_score, color: _magaluBlue, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Crédito Rápido pré-aprovado!',
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: _magaluBlue),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Parcele sem burocracia',
                              style: GoogleFonts.inter(fontSize: 11, color: _textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider
                Container(
                  height: 36,
                  width: 1,
                  color: const Color(0xFFEEEEEE),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
                // Right — Limit amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CurrencyFormat.format(creditAvailable),
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: _magaluBlue),
                    ),
                    Text(
                      'até 24x',
                      style: GoogleFonts.inter(fontSize: 11, color: _textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ── CATEGORY PILLS ──
        SliverToBoxAdapter(
          child: SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              children: const [
                _CategoryPill('Ofertas', selected: true),
                _CategoryPill('Eletrônicos'),
                _CategoryPill('Casa'),
                _CategoryPill('Moda'),
                _CategoryPill('Games'),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // ── PRODUCT GRID (Balanced — 2 columns, moderate spacing) ──
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.57,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = MockData.products[index % MockData.products.length];
                return _ProductCard(
                  product: product,
                  creditAvailable: creditAvailable,
                  onTap: () => onNavigate(
                    _HybridCPDP(product: product, onAddToCart: onAddToCart),
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

// ─── PRODUCT CARD (Split View: price left, credit right) ─
class _ProductCard extends StatelessWidget {
  final Product product;
  final double creditAvailable;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.creditAvailable, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasCredit = creditAvailable >= product.price;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_cardRadius),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2)),
          ],
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
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(_cardRadius)),
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
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(color: _magaluGreen, borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          '-${product.discountPercent}%',
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Info — EQUAL WEIGHT (price + credit side by side)
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 11, color: _textPrimary, height: 1.3),
                    ),
                    const Spacer(),
                    // Split view: price and credit equal weight
                    if (product.originalPrice != null)
                      Text(
                        CurrencyFormat.format(product.originalPrice!),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: _textSecondary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Row(
                      children: [
                        // Price
                        Expanded(
                          child: Text(
                            CurrencyFormat.format(product.price),
                            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: _textPrimary),
                          ),
                        ),
                        // Credit pill (equal visual weight)
                        if (hasCredit)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: _magaluBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'até ${product.maxInstallments}x',
                              style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: _magaluBlue),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    if (product.freeShipping)
                      Text(
                        'Frete grátis',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: _magaluGreen),
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
// PHASE B — PDP (Consideration) — Inline CTA, Equal Weight
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _HybridCPDP extends StatelessWidget {
  final Product product;
  final ValueChanged<Product> onAddToCart;

  const _HybridCPDP({required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final user = MockData.user;
    final creditAvailable = user.carneDigitalAvailable;
    final installmentValue = product.price / product.maxInstallments;

    return Scaffold(
      backgroundColor: _bgGray,
      body: Column(
        children: [
          // App Bar
          Container(
            color: _magaluBlue,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      product.name.split(' ').take(4).join(' '),
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.share, color: Colors.white, size: 20), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.favorite_border, color: Colors.white, size: 20), onPressed: () {}),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Large image
                Container(
                  color: Colors.white,
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.image, size: 60, color: Color(0xFFCCCCCC)),
                    ),
                  ),
                ),

                // ── INLINE CTA (Below Image) ──
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        onAddToCart(product);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _magaluBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'Comprar com Crédito Rápido',
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ── EQUAL WEIGHT SECTION — Price & Credit Split View ──
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(_cardRadius),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        // LEFT — Price
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Preço', style: GoogleFonts.inter(fontSize: 11, color: _textSecondary)),
                                const SizedBox(height: 6),
                                if (product.originalPrice != null) ...[
                                  Text(
                                    CurrencyFormat.format(product.originalPrice!),
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: _textSecondary,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                ],
                                Text(
                                  CurrencyFormat.format(product.price),
                                  style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: _textPrimary),
                                ),
                                if (product.discountPercent > 0) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _magaluGreen,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '-${product.discountPercent}%',
                                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        // Vertical divider
                        Container(width: 1, color: const Color(0xFFEEEEEE)),
                        // RIGHT — Credit
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showSimulator(context),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('Crédito Rápido', style: GoogleFonts.inter(fontSize: 11, color: _magaluBlue, fontWeight: FontWeight.w600)),
                                      const Spacer(),
                                      Icon(Icons.info_outline, color: _magaluBlue, size: 16),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    CurrencyFormat.format(creditAvailable),
                                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: _magaluBlue),
                                  ),
                                  Text('disponível', style: GoogleFonts.inter(fontSize: 11, color: _textSecondary)),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: _magaluBlue.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${product.maxInstallments}x de ${CurrencyFormat.format(installmentValue)}',
                                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: _magaluBlue),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Product details
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(_cardRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.brand, style: GoogleFonts.inter(fontSize: 12, color: _textSecondary)),
                      const SizedBox(height: 4),
                      Text(
                        product.name,
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: _textPrimary, height: 1.3),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber.shade700, size: 15),
                          const SizedBox(width: 4),
                          Text('${product.rating}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                          Text(' (${product.reviewCount})', style: GoogleFonts.inter(fontSize: 12, color: _textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Shipping
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(_cardRadius),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        product.freeShipping ? Icons.local_shipping : Icons.local_shipping_outlined,
                        color: product.freeShipping ? _magaluGreen : _textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        product.freeShipping ? 'Frete grátis' : 'Frete: ${CurrencyFormat.format(product.shippingCost ?? 0)}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: product.freeShipping ? _magaluGreen : _textPrimary,
                        ),
                      ),
                      if (product.deliveryDate != null) ...[
                        const Spacer(),
                        Text('Chega ${product.deliveryDate}', style: GoogleFonts.inter(fontSize: 12, color: _textSecondary)),
                      ],
                    ],
                  ),
                ),

                // Seller
                if (product.seller != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(_cardRadius),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.store, color: _textSecondary, size: 18),
                        const SizedBox(width: 10),
                        Text('Vendido por ', style: GoogleFonts.inter(fontSize: 12, color: _textSecondary)),
                        Text(
                          product.seller!,
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: _magaluBlue),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
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

// ─── SIMULATOR SHEET ─────────────────────────────────────
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(color: const Color(0xFFDDDDDD), borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
            child: Row(
              children: [
                const Icon(Icons.calculate, color: _magaluBlue, size: 22),
                const SizedBox(width: 10),
                Text('Simular Crédito Rápido', style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const Divider(),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              children: _options.map((opt) {
                final isSel = opt.count == _selected;
                return GestureDetector(
                  onTap: () => setState(() => _selected = opt.count),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 7),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSel ? _magaluBlue.withValues(alpha: 0.07) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSel ? _magaluBlue : const Color(0xFFEEEEEE),
                        width: isSel ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSel ? _magaluBlue : const Color(0xFFCCCCCC),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${opt.count}x de ${CurrencyFormat.format(opt.perMonth)}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
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
            padding: EdgeInsets.fromLTRB(18, 8, 18, MediaQuery.of(context).padding.bottom + 14),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _magaluBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
// PHASE C — CART (Intent) — Balanced
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
              const SizedBox(height: 14),
              Text('Sua sacola está vazia', style: GoogleFonts.inter(fontSize: 16, color: _textSecondary)),
            ],
          ),
        ),
      );
    }

    final savings = _total * 0.05;

    return Scaffold(
      backgroundColor: _bgGray,
      appBar: AppBar(
        backgroundColor: _magaluBlue,
        foregroundColor: Colors.white,
        title: Text('Sacola (${cart.length})', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 80),
        children: [
          // ── SAVINGS CALLOUT (Phase C) ──
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _magaluBlue.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(_cardRadius),
              border: Border.all(color: _magaluBlue.withValues(alpha: 0.15)),
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
                        const TextSpan(text: ' usando Crédito Rápido'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          ...cart.map((item) => _CartItemTile(
                item: item,
                onRemove: () => onRemove(item.product.id),
                onUpdateQty: (q) => onUpdateQty(item.product.id, q),
              )),

          // Summary
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_cardRadius),
            ),
            child: Column(
              children: [
                _SummaryRow('Subtotal', CurrencyFormat.format(_total)),
                const SizedBox(height: 6),
                _SummaryRow('Frete', 'Grátis', valueColor: _magaluGreen),
                const Divider(height: 16),
                _SummaryRow('Total', CurrencyFormat.format(_total), isBold: true),
                const SizedBox(height: 4),
                // Equal weight: both price and credit installment shown
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ou até 24x de ${CurrencyFormat.format(_total / 24)} com Crédito Rápido',
                    style: GoogleFonts.inter(fontSize: 11, color: _magaluBlue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(14, 10, 14, MediaQuery.of(context).padding.bottom + 10),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => onNavigate(_HybridCCheckout(cart: cart, total: _total)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _magaluBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

// ─── CART ITEM ───────────────────────────────────────────
class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final ValueChanged<int> onUpdateQty;

  const _CartItemTile({required this.item, required this.onRemove, required this.onUpdateQty});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.product.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                width: 64, height: 64,
                color: const Color(0xFFF0F0F0),
                child: const Icon(Icons.image, size: 24, color: Color(0xFFCCCCCC)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 12, color: _textPrimary)),
                const SizedBox(height: 4),
                Text(CurrencyFormat.format(item.total),
                    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('${item.quantity}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                  _QtyButton(icon: Icons.add, onTap: () => onUpdateQty(item.quantity + 1)),
                ],
              ),
              const SizedBox(height: 4),
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
// PHASE D — CHECKOUT (Conversion) — Equal weight payment
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _HybridCCheckout extends StatefulWidget {
  final List<CartItem> cart;
  final double total;

  const _HybridCCheckout({required this.cart, required this.total});

  @override
  State<_HybridCCheckout> createState() => _HybridCCheckoutState();
}

class _HybridCCheckoutState extends State<_HybridCCheckout> {
  int _selectedPayment = 0; // Crédito Rápido pre-selected
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
        padding: const EdgeInsets.all(14),
        children: [
          // Order summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_cardRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resumo do pedido', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
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
                          Text(CurrencyFormat.format(item.total),
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                    Text(CurrencyFormat.format(widget.total),
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Text('Forma de pagamento', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),

          // Crédito Rápido — PRE-SELECTED
          _PaymentTile(
            icon: Icons.credit_score,
            label: 'Crédito Rápido',
            subtitle: 'Até ${_selectedInstallments}x • ${CurrencyFormat.format(creditAvailable)} disponível',
            badge: 'Rápido',
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

          // Installment selector
          if (_selectedPayment == 0) ...[
            const SizedBox(height: 14),
            Text('Parcelas', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [1, 2, 3, 6, 12, 18, 24].map((n) {
                final isSel = n == _selectedInstallments;
                return GestureDetector(
                  onTap: () => setState(() => _selectedInstallments = n),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSel ? _magaluBlue : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isSel ? _magaluBlue : const Color(0xFFDDDDDD)),
                    ),
                    child: Text(
                      '${n}x de ${CurrencyFormat.format(widget.total / n)}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        color: isSel ? Colors.white : _textPrimary,
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
        padding: EdgeInsets.fromLTRB(14, 10, 14, MediaQuery.of(context).padding.bottom + 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedPayment == 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${_selectedInstallments}x de ${CurrencyFormat.format(installmentValue)} com Crédito Rápido',
                  style: GoogleFonts.inter(fontSize: 13, color: _magaluBlue, fontWeight: FontWeight.w600),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const _HybridCSuccess()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _magaluBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Finalizar compra', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
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
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFEEEEEE),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
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
                      Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
                          child: Text(badge!, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)),
                        ),
                      ],
                    ],
                  ),
                  Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: _textSecondary)),
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
class _HybridCSuccess extends StatelessWidget {
  const _HybridCSuccess();

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
                    color: _magaluGreen.withValues(alpha: 0.12),
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
                  'Pagamento via Crédito Rápido aprovado.\nVocê receberá atualizações por e-mail.',
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Voltar ao início', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
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
class _CategoryPill extends StatelessWidget {
  final String label;
  final bool selected;

  const _CategoryPill(this.label, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? _magaluBlue.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: selected ? _magaluBlue : const Color(0xFFDDDDDD)),
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
        width: 28, height: 28,
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
        Text(label, style: GoogleFonts.inter(
          fontSize: isBold ? 15 : 13,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          color: _textPrimary,
        )),
        Text(value, style: GoogleFonts.inter(
          fontSize: isBold ? 15 : 13,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          color: valueColor ?? _textPrimary,
        )),
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
