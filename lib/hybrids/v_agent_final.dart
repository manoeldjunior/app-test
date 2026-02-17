/// V_Agent_Final — The Synthesis
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Shell = Nubank (fluid, minimalist, large whitespace, rounded corners, elegant typography)
/// Engine = Mercado Livre (credit limit aggressively visible at Top of Funnel per funnel_logic.md)
/// Brand = Magalu Blue (#0086FF), Inter font
///
/// This is the recommended production variant — it combines:
/// • Nubank's premium UX feel (trust, simplicity, spaciousness)
/// • ML's aggressive credit conversion engine (credit at discovery, credit at PDP)
/// • Magalu's brand identity (Blue #0086FF, Inter, "Limite Magalu" naming)
///
/// Credit Strategy per funnel_logic.md:
///   Phase A (Home): Large credit hero card + credit badges on product cards
///   Phase B (PDP): Credit pill above fold + simulator bottom sheet
///   Phase C (Cart): Savings callout
///   Phase D (Payment): Credit pre-selected, highlighted as RECOMMENDED
///
/// "Carnê Digital" is FORBIDDEN.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/models.dart';
import '../data/mock_data.dart';
import '../utils/currency_format.dart';

// ─── BRAND TOKENS ────────────────────────────────────────
const _blue = Color(0xFF0086FF);       // Magalu Blue (primary)
const _blueDark = Color(0xFF005BBF);   // Gradient end
const _green = Color(0xFF00A650);      // Success / free shipping
const _bg = Color(0xFFF8F9FA);         // Nubank-style very light bg
const _surface = Colors.white;
const _text1 = Color(0xFF1A1A1A);      // Primary text
const _text2 = Color(0xFF757575);      // Secondary text
const _radius = 16.0;                   // Nubank-style generous radius
const _radiusSm = 12.0;

// ─── ENTRY POINT ─────────────────────────────────────────
class VAgentFinalApp extends StatelessWidget {
  const VAgentFinalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magalu — Limite Magalu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: _blue,
        useMaterial3: true,
        scaffoldBackgroundColor: _bg,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const _FinalHome(),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// SHELL: Nubank-style navigation and state management
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _FinalHome extends StatefulWidget {
  const _FinalHome();

  @override
  State<_FinalHome> createState() => _FinalHomeState();
}

class _FinalHomeState extends State<_FinalHome> {
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
        content: Text('${p.name.split(' ').take(3).join(' ')} adicionado ao carrinho'),
        duration: const Duration(seconds: 1),
        backgroundColor: _blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radiusSm)),
      ),
    );
  }

  void _removeFromCart(String id) => setState(() => _cart.removeWhere((c) => c.product.id == id));

  void _updateQty(String id, int qty) {
    setState(() {
      if (qty <= 0) {
        _cart.removeWhere((c) => c.product.id == id);
      } else {
        final idx = _cart.indexWhere((c) => c.product.id == id);
        if (idx >= 0) _cart[idx] = _cart[idx].copyWith(quantity: qty);
      }
    });
  }

  int get _cartCount => _cart.fold(0, (s, c) => s + c.quantity);

  void _push(Widget screen) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => screen),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: IndexedStack(
        index: _navIndex,
        children: [
          _HomeTab(onAddToCart: _addToCart, onPush: _push),
          _CartTab(cart: _cart, onRemove: _removeFromCart, onUpdateQty: _updateQty, onPush: _push),
          const _ProfileTab(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        index: _navIndex,
        cartCount: _cartCount,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PHASE A — HOME (Discovery)
// ENGINE: ML-style aggressive credit at top of funnel
// SHELL: Nubank-style minimalist layout
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _HomeTab extends StatelessWidget {
  final ValueChanged<Product> onAddToCart;
  final void Function(Widget) onPush;

  const _HomeTab({required this.onAddToCart, required this.onPush});

  @override
  Widget build(BuildContext context) {
    final user = MockData.user;
    final creditAvailable = user.carneDigitalAvailable;

    return CustomScrollView(
      slivers: [
        // ── HEADER (Nubank: clean white, logo only) ──
        SliverToBoxAdapter(
          child: Container(
            color: _surface,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 14, bottom: 18),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        'magalu',
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: _blue,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Spacer(),
                      _CircleIcon(Icons.notifications_none_rounded, onTap: () {}),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Nubank-style rounded search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: _bg,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 18),
                        Icon(Icons.search_rounded, color: _text2, size: 22),
                        const SizedBox(width: 12),
                        Text(
                          'O que você procura?',
                          style: GoogleFonts.inter(fontSize: 15, color: _text2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── CREDIT HERO CARD (ENGINE: ML-aggressive, at Discovery) ──
        // Per funnel_logic.md Phase A:
        //   IF user_has_preapproved_credit == TRUE:
        //     Display prominently at top of funnel
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_blue, _blueDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(_radius),
              boxShadow: [
                BoxShadow(
                  color: _blue.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
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
                      child: const Icon(Icons.credit_score_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
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
                          Text(
                            'Limite exclusivo pré-aprovado',
                            style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  'Disponível',
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormat.format(creditAvailable),
                  style: GoogleFonts.inter(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _PillTag('Até 24x', Colors.white.withValues(alpha: 0.2)),
                    const SizedBox(width: 8),
                    _PillTag('Sem cartão', Colors.white.withValues(alpha: 0.2)),
                    const SizedBox(width: 8),
                    _PillTag('Aprovação imediata', Colors.white.withValues(alpha: 0.2)),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ── QUICK ACTIONS ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _QuickAction(Icons.local_offer_outlined, 'Ofertas'),
                _QuickAction(Icons.bolt_outlined, 'Flash'),
                _QuickAction(Icons.card_giftcard_outlined, 'Cupons'),
                _QuickAction(Icons.category_outlined, 'Categorias'),
              ],
            ),
          ),
        ),

        // ── SECTION HEADER ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Text(
                  'Para você',
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: _text1),
                ),
                const Spacer(),
                Text('Ver tudo', style: GoogleFonts.inter(fontSize: 13, color: _blue, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),

        // ── PRODUCT CARDS (Nubank shell + ML credit badges) ──
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final p = MockData.products[index];
                return _ProductCardFinal(
                  product: p,
                  creditAvailable: creditAvailable,
                  onTap: () => onPush(_FinalPDP(product: p, onAddToCart: onAddToCart)),
                );
              },
              childCount: MockData.products.length,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

// ─── PRODUCT CARD (Nubank feel + ML credit badge) ────────
class _ProductCardFinal extends StatelessWidget {
  final Product product;
  final double creditAvailable;
  final VoidCallback onTap;

  const _ProductCardFinal({required this.product, required this.creditAvailable, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final eligible = creditAvailable >= product.price;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(_radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image (Nubank: generous padding, rounded)
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(_radius)),
              child: Container(
                width: 130,
                height: 150,
                color: const Color(0xFFF5F5F5),
                padding: const EdgeInsets.all(12),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 40, color: Color(0xFFCCCCCC)),
                ),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ML ENGINE: Credit badge VISIBLE at discovery
                    if (eligible)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _blue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.credit_score_rounded, color: _blue, size: 13),
                            const SizedBox(width: 4),
                            Text(
                              'Limite Magalu até ${product.maxInstallments}x',
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: _blue),
                            ),
                          ],
                        ),
                      ),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 13, color: _text1, height: 1.35),
                    ),
                    const SizedBox(height: 10),
                    if (product.originalPrice != null)
                      Text(
                        CurrencyFormat.format(product.originalPrice!),
                        style: GoogleFonts.inter(
                          fontSize: 11, color: _text2, decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Row(
                      children: [
                        Text(
                          CurrencyFormat.format(product.price),
                          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: _text1),
                        ),
                        if (product.discountPercent > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: _green, borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              '-${product.discountPercent}%',
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (product.freeShipping)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                            Icon(Icons.local_shipping_rounded, color: _green, size: 14),
                            const SizedBox(width: 4),
                            Text('Frete grátis', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: _green)),
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
// PHASE B — PDP (Consideration)
// ENGINE: Credit pill above-fold + simulator
// SHELL: Nubank generous spacing + rounded surfaces
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _FinalPDP extends StatelessWidget {
  final Product product;
  final ValueChanged<Product> onAddToCart;

  const _FinalPDP({required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final user = MockData.user;
    final creditAvailable = user.carneDigitalAvailable;
    final installmentValue = product.price / product.maxInstallments;

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          // Nubank-style clean app bar (white bg, minimal)
          Container(
            color: _surface,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: SizedBox(
              height: 54,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.share_outlined, size: 20), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.favorite_border_rounded, size: 20), onPressed: () {}),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Image (Nubank: large, generous, white bg)
                Container(
                  color: _surface,
                  padding: const EdgeInsets.all(24),
                  height: 320,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.image, size: 64, color: Color(0xFFCCCCCC)),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ── CREDIT PILL (ENGINE: ML-aggressive, above fold) ──
                // Per funnel_logic.md Phase B:
                //   Display "Available Limit" pill next to the price.
                //   Tap opens a bottom sheet with a quick simulation.
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_blue.withValues(alpha: 0.06), _blue.withValues(alpha: 0.02)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(_radius),
                    border: Border.all(color: _blue.withValues(alpha: 0.12)),
                  ),
                  child: GestureDetector(
                    onTap: () => _showSimulator(context),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.credit_score_rounded, color: _blue, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Limite Magalu disponível',
                                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: _blue),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${CurrencyFormat.format(creditAvailable)} • até ${product.maxInstallments}x de ${CurrencyFormat.format(installmentValue)}',
                                style: GoogleFonts.inter(fontSize: 12, color: _text2),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _blue,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            'Simular',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ── PRICE & PRODUCT INFO (Nubank spacing) ──
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(_radius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.brand, style: GoogleFonts.inter(fontSize: 12, color: _text2)),
                      const SizedBox(height: 6),
                      Text(
                        product.name,
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: _text1, height: 1.4),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, color: Colors.amber.shade700, size: 16),
                          const SizedBox(width: 4),
                          Text('${product.rating}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(' (${product.reviewCount} avaliações)', style: GoogleFonts.inter(fontSize: 13, color: _text2)),
                        ],
                      ),
                      const SizedBox(height: 18),
                      if (product.originalPrice != null) ...[
                        Row(
                          children: [
                            Text(
                              CurrencyFormat.format(product.originalPrice!),
                              style: GoogleFonts.inter(fontSize: 14, color: _text2, decoration: TextDecoration.lineThrough),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: _green, borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                '-${product.discountPercent}%',
                                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                      ],
                      Text(
                        CurrencyFormat.format(product.price),
                        style: GoogleFonts.inter(fontSize: 30, fontWeight: FontWeight.w800, color: _text1, letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'até ${product.maxInstallments}x de ${CurrencyFormat.format(installmentValue)} sem juros',
                        style: GoogleFonts.inter(fontSize: 13, color: _blue),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Shipping (Nubank card)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(_radius)),
                  child: Row(
                    children: [
                      Icon(
                        product.freeShipping ? Icons.local_shipping_rounded : Icons.local_shipping_outlined,
                        color: product.freeShipping ? _green : _text2,
                        size: 22,
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.freeShipping ? 'Frete grátis' : 'Frete: ${CurrencyFormat.format(product.shippingCost ?? 0)}',
                            style: GoogleFonts.inter(
                              fontSize: 14, fontWeight: FontWeight.w600,
                              color: product.freeShipping ? _green : _text1,
                            ),
                          ),
                          if (product.deliveryDate != null)
                            Text(
                              'Previsão: ${product.deliveryDate}',
                              style: GoogleFonts.inter(fontSize: 12, color: _text2),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      // Nubank-style floating bottom bar with shadow
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: _surface,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -3)),
          ],
        ),
        padding: EdgeInsets.fromLTRB(20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  CurrencyFormat.format(product.price),
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: _text1),
                ),
                Text(
                  'ou ${product.maxInstallments}x Limite Magalu',
                  style: GoogleFonts.inter(fontSize: 12, color: _blue),
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
                backgroundColor: _blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text('Comprar', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
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

// ─── SIMULATOR (ML engine, Nubank sheet style) ───────────
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Nubank-style handle
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(top: 14),
            decoration: BoxDecoration(color: const Color(0xFFDDDDDD), borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
            child: Row(
              children: [
                Icon(Icons.calculate_rounded, color: _blue, size: 24),
                const SizedBox(width: 12),
                Text('Simular Limite Magalu', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const Divider(),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: _options.map((opt) {
                final isSel = opt.count == _selected;
                return GestureDetector(
                  onTap: () => setState(() => _selected = opt.count),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSel ? _blue.withValues(alpha: 0.06) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSel ? _blue : const Color(0xFFEEEEEE),
                        width: isSel ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24, height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: isSel ? _blue : const Color(0xFFCCCCCC), width: 2),
                            color: isSel ? _blue : Colors.transparent,
                          ),
                          child: isSel ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            '${opt.count}x de ${CurrencyFormat.format(opt.perMonth)}',
                            style: GoogleFonts.inter(fontSize: 15, fontWeight: isSel ? FontWeight.w700 : FontWeight.w500),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(CurrencyFormat.format(opt.total), style: GoogleFonts.inter(fontSize: 12, color: _text2)),
                            Text(
                              opt.hasInterest ? 'com juros' : 'sem juros',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: opt.hasInterest ? _text2 : _green,
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
            padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).padding.bottom + 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
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
// PHASE C — CART (Intent)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _CartTab extends StatelessWidget {
  final List<CartItem> cart;
  final void Function(String) onRemove;
  final void Function(String, int) onUpdateQty;
  final void Function(Widget) onPush;

  const _CartTab({required this.cart, required this.onRemove, required this.onUpdateQty, required this.onPush});

  double get _total => cart.fold(0, (s, c) => s + c.total);

  @override
  Widget build(BuildContext context) {
    if (cart.isEmpty) {
      return Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 72, color: _text2.withValues(alpha: 0.3)),
                const SizedBox(height: 16),
                Text('Sua sacola está vazia', style: GoogleFonts.inter(fontSize: 18, color: _text2)),
                const SizedBox(height: 6),
                Text('Explore os produtos e adicione aqui', style: GoogleFonts.inter(fontSize: 14, color: _text2)),
              ],
            ),
          ),
        ),
      );
    }

    final savings = _total * 0.05;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sacola (${cart.length})',
                  style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: _text1),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                children: [
                  // ── SAVINGS CALLOUT (Phase C per funnel_logic.md) ──
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _blue.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(_radius),
                      border: Border.all(color: _blue.withValues(alpha: 0.12)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.savings_rounded, color: _blue, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.inter(fontSize: 13, color: _text1),
                              children: [
                                const TextSpan(text: 'Você economiza '),
                                TextSpan(
                                  text: CurrencyFormat.format(savings),
                                  style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: _blue),
                                ),
                                const TextSpan(text: ' usando seu Limite Magalu'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Cart items
                  ...cart.map((item) => _CartItemTile(
                        item: item,
                        onRemove: () => onRemove(item.product.id),
                        onUpdateQty: (q) => onUpdateQty(item.product.id, q),
                      )),

                  // Summary
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(_radius)),
                    child: Column(
                      children: [
                        _SummaryRow('Subtotal', CurrencyFormat.format(_total)),
                        const SizedBox(height: 8),
                        _SummaryRow('Frete', 'Grátis', valueColor: _green),
                        const Divider(height: 20),
                        _SummaryRow('Total', CurrencyFormat.format(_total), isBold: true),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'até 24x de ${CurrencyFormat.format(_total / 24)} com Limite Magalu',
                            style: GoogleFonts.inter(fontSize: 12, color: _blue),
                          ),
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
      // Floating CTA (Nubank shadow style)
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: _surface,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, -2))],
        ),
        padding: EdgeInsets.fromLTRB(20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => onPush(_FinalCheckout(cart: cart, total: _total)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _blue,
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

// ─── CART ITEM ───────────────────────────────────────────
class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final ValueChanged<int> onUpdateQty;

  const _CartItemTile({required this.item, required this.onRemove, required this.onUpdateQty});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(_radius)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.product.imageUrl,
              width: 72, height: 72,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                width: 72, height: 72, color: const Color(0xFFF0F0F0),
                child: const Icon(Icons.image, size: 28, color: Color(0xFFCCCCCC)),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 13, color: _text1)),
                const SizedBox(height: 6),
                Text(CurrencyFormat.format(item.total),
                    style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _QtyBtn(Icons.remove, () => onUpdateQty(item.quantity - 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('${item.quantity}', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                  _QtyBtn(Icons.add, () => onUpdateQty(item.quantity + 1)),
                ],
              ),
              const SizedBox(height: 6),
              GestureDetector(onTap: onRemove, child: Text('Remover', style: GoogleFonts.inter(fontSize: 11, color: Colors.red))),
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
class _FinalCheckout extends StatefulWidget {
  final List<CartItem> cart;
  final double total;

  const _FinalCheckout({required this.cart, required this.total});

  @override
  State<_FinalCheckout> createState() => _FinalCheckoutState();
}

class _FinalCheckoutState extends State<_FinalCheckout> {
  // Per funnel_logic.md Phase D: credit SELECTED by default, highlighted as RECOMMENDED
  int _selectedPayment = 0;
  int _selectedInstallments = 12;

  @override
  Widget build(BuildContext context) {
    final user = MockData.user;
    final creditAvailable = user.carneDigitalAvailable;
    final installmentValue = widget.total / _selectedInstallments;

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          // Nubank-style white header
          Container(
            color: _surface,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: SizedBox(
              height: 54,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text('Pagamento', style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700)),
                  const Spacer(),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Order summary
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(_radius)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Resumo do pedido', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 14),
                      ...widget.cart.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.quantity}x ${item.product.name.split(' ').take(4).join(' ')}',
                                    style: GoogleFonts.inter(fontSize: 13, color: _text2),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(CurrencyFormat.format(item.total),
                                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          )),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
                          Text(CurrencyFormat.format(widget.total),
                              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Text('Forma de pagamento', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),

                // Limite Magalu — PRE-SELECTED, RECOMMENDED badge
                _PaymentTile(
                  icon: Icons.credit_score_rounded,
                  label: 'Limite Magalu',
                  subtitle: 'Até ${_selectedInstallments}x • ${CurrencyFormat.format(creditAvailable)} disponível',
                  badge: 'Recomendado',
                  isSelected: _selectedPayment == 0,
                  color: _blue,
                  onTap: () => setState(() => _selectedPayment = 0),
                ),

                _PaymentTile(
                  icon: Icons.pix_rounded,
                  label: 'Pix',
                  subtitle: 'Aprovação imediata',
                  isSelected: _selectedPayment == 1,
                  color: const Color(0xFF00BDAE),
                  onTap: () => setState(() => _selectedPayment = 1),
                ),

                _PaymentTile(
                  icon: Icons.credit_card_rounded,
                  label: 'Cartão de crédito',
                  subtitle: 'Até 12x',
                  isSelected: _selectedPayment == 2,
                  color: _text2,
                  onTap: () => setState(() => _selectedPayment = 2),
                ),

                _PaymentTile(
                  icon: Icons.receipt_long_rounded,
                  label: 'Boleto',
                  subtitle: 'Até 3 dias úteis',
                  isSelected: _selectedPayment == 3,
                  color: _text2,
                  onTap: () => setState(() => _selectedPayment = 3),
                ),

                // Installment selection
                if (_selectedPayment == 0) ...[
                  const SizedBox(height: 16),
                  Text('Parcelas', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [1, 2, 3, 6, 12, 18, 24].map((n) {
                      final isSel = n == _selectedInstallments;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedInstallments = n),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSel ? _blue : _surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSel ? _blue : const Color(0xFFDDDDDD)),
                          ),
                          child: Text(
                            '${n}x de ${CurrencyFormat.format(widget.total / n)}',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                              color: isSel ? Colors.white : _text1,
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
          ),
        ],
      ),
      // Floating CTA
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: _surface,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, -2))],
        ),
        padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedPayment == 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  '${_selectedInstallments}x de ${CurrencyFormat.format(installmentValue)} com Limite Magalu',
                  style: GoogleFonts.inter(fontSize: 14, color: _blue, fontWeight: FontWeight.w600),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const _FinalSuccess()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text('Finalizar compra', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
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
          color: isSelected ? color.withValues(alpha: 0.06) : _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFEEEEEE),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
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
                          child: Text(badge!, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: _text2)),
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
// SUCCESS (Nubank-style clean celebration)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _FinalSuccess extends StatelessWidget {
  const _FinalSuccess();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96, height: 96,
                  decoration: BoxDecoration(
                    color: _green.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded, color: _green, size: 56),
                ),
                const SizedBox(height: 28),
                Text(
                  'Pedido confirmado!',
                  style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w800, color: _text1, letterSpacing: -0.5),
                ),
                const SizedBox(height: 12),
                Text(
                  'Pagamento via Limite Magalu aprovado.\nVocê receberá atualizações por e-mail.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 15, color: _text2, height: 1.5),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text('Voltar ao início', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
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

// ─── PROFILE TAB (placeholder) ──────────────────────────
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final user = MockData.user;
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text('Perfil', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: _text1)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(_radius)),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: _blue.withValues(alpha: 0.1),
                      child: Text(
                        user.name[0],
                        style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: _blue),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w600)),
                        Text(user.email, style: GoogleFonts.inter(fontSize: 13, color: _text2)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(_radius)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Limite Magalu', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: _blue)),
                    const SizedBox(height: 10),
                    Text('Disponível', style: GoogleFonts.inter(fontSize: 12, color: _text2)),
                    Text(
                      CurrencyFormat.format(user.carneDigitalAvailable),
                      style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: _text1),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: user.carneDigitalUsed / user.carneDigitalLimit,
                      backgroundColor: _blue.withValues(alpha: 0.1),
                      color: _blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${CurrencyFormat.format(user.carneDigitalUsed)} de ${CurrencyFormat.format(user.carneDigitalLimit)} utilizado',
                      style: GoogleFonts.inter(fontSize: 11, color: _text2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// SHARED ATOMS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIcon(this.icon, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: _bg,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: _text2, size: 22),
      ),
    );
  }
}

class _PillTag extends StatelessWidget {
  final String text;
  final Color bg;

  const _PillTag(this.text, this.bg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white)),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickAction(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: _blue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: _blue, size: 24),
        ),
        const SizedBox(height: 6),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: _text2, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyBtn(this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30, height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: _text2),
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
          fontSize: isBold ? 16 : 14,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          color: _text1,
        )),
        Text(value, style: GoogleFonts.inter(
          fontSize: isBold ? 16 : 14,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          color: valueColor ?? _text1,
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
      selectedItemColor: _blue,
      unselectedItemColor: _text2,
      backgroundColor: _surface,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Início'),
        BottomNavigationBarItem(
          icon: Badge(
            isLabelVisible: cartCount > 0,
            label: Text('$cartCount', style: const TextStyle(fontSize: 10)),
            backgroundColor: _blue,
            child: const Icon(Icons.shopping_bag_outlined),
          ),
          label: 'Sacola',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Perfil'),
      ],
    );
  }
}
