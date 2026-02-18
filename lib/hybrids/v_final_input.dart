/// V_Final_Input — User's Ideal Variant
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Home:     ML-style dense product grid, Nubank clean chrome — NO credit limit shown
/// PDP:      Small banner under price: "Crédito Digital MagaluPay — 10% off no Pix"
///           Only appears when price <= creditLimit (5000). Hidden otherwise.
/// Checkout: Magalu CDC-first payment selection in Nubank's elegant card format.
///           Installment summary after selecting CDC (Nubank style).
///           Interest rate disclaimer at the bottom (scroll to see), ML pattern.
///
/// "Carnê Digital" is FORBIDDEN in user-facing strings.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/models.dart';
import '../data/mock_data.dart';
import '../utils/currency_format.dart';

// ─── BRAND TOKENS ────────────────────────────────────────
const _blue = Color(0xFF0086FF);
const _green = Color(0xFF00A650);
const _bg = Color(0xFFF7F8FA);
const _surface = Colors.white;
const _text1 = Color(0xFF1A1A1A);
const _text2 = Color(0xFF757575);
const _text3 = Color(0xFFAAAAAA);
const _radius = 16.0;
const _creditLimit = 2000.0; // User's MagaluPay credit limit

// ─── ENTRY ───────────────────────────────────────────────
class VFinalInputApp extends StatelessWidget {
  const VFinalInputApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magalu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: _blue,
        useMaterial3: true,
        scaffoldBackgroundColor: _bg,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const _Shell(),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// SHELL — Nubank-clean navigation
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _Shell extends StatefulWidget {
  const _Shell();
  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  final _cart = <CartItem>[];
  int _tab = 0;

  void _addToCart(Product p) {
    setState(() {
      final i = _cart.indexWhere((c) => c.product.id == p.id);
      if (i >= 0) {
        _cart[i] = _cart[i].copyWith(quantity: _cart[i].quantity + 1);
      } else {
        _cart.add(CartItem(product: p));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${p.name.split(' ').take(3).join(' ')} adicionado'),
      duration: const Duration(milliseconds: 900),
      backgroundColor: _blue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  void _removeFromCart(String id) => setState(() => _cart.removeWhere((c) => c.product.id == id));
  void _updateQty(String id, int q) => setState(() {
        if (q <= 0) {
          _cart.removeWhere((c) => c.product.id == id);
        } else {
          final i = _cart.indexWhere((c) => c.product.id == id);
          if (i >= 0) _cart[i] = _cart[i].copyWith(quantity: q);
        }
      });
  int get _cartCount => _cart.fold(0, (s, c) => s + c.quantity);

  void _push(Widget w) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: IndexedStack(index: _tab, children: [
        _HomeTab(onAddToCart: _addToCart, onPush: _push),
        _CartTab(cart: _cart, onRemove: _removeFromCart, onUpdateQty: _updateQty, onPush: _push),
      ]),
      bottomNavigationBar: NavigationBar(
        height: 64,
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        backgroundColor: _surface,
        indicatorColor: _blue.withValues(alpha: 0.08),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Início'),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: _cartCount > 0,
              label: Text('$_cartCount', style: const TextStyle(fontSize: 10)),
              backgroundColor: _blue,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            label: 'Sacola',
          ),
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// HOME — ML-style dense grid, Nubank clean chrome, NO credit limit
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _HomeTab extends StatelessWidget {
  final ValueChanged<Product> onAddToCart;
  final void Function(Widget) onPush;
  const _HomeTab({required this.onAddToCart, required this.onPush});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── Header (Nubank: white, clean, minimal) ──
        SliverToBoxAdapter(
          child: Container(
            color: _surface,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, bottom: 14),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Text('magalu',
                      style: GoogleFonts.inter(
                          fontSize: 26, fontWeight: FontWeight.w800, color: _blue, letterSpacing: -0.5)),
                  const Spacer(),
                  _CircleBtn(Icons.notifications_none_rounded),
                ]),
              ),
              const SizedBox(height: 14),
              // ML-style search bar (compact, rounded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(22)),
                  child: Row(children: [
                    const SizedBox(width: 16),
                    Icon(Icons.search_rounded, color: _text2, size: 20),
                    const SizedBox(width: 10),
                    Text('Buscar produtos', style: GoogleFonts.inter(fontSize: 14, color: _text2)),
                  ]),
                ),
              ),
            ]),
          ),
        ),

        // ── Quick categories (ML-style horizontal chips) ──
        SliverToBoxAdapter(
          child: Container(
            height: 48,
            margin: const EdgeInsets.only(top: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _CategoryChip('Ofertas', true),
                _CategoryChip('Celulares', false),
                _CategoryChip('Informática', false),
                _CategoryChip('Eletrônicos', false),
                _CategoryChip('Eletro', false),
              ],
            ),
          ),
        ),

        // ── Section label ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
            child: Row(children: [
              Text('Para você', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: _text1)),
              const Spacer(),
              Text('Ver tudo', style: GoogleFonts.inter(fontSize: 13, color: _blue, fontWeight: FontWeight.w600)),
            ]),
          ),
        ),

        // ── Product grid (ML-style 2-column, compact) ──
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.56,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, i) {
                final p = MockData.products[i];
                return _ProductCard(
                  product: p,
                  onTap: () => onPush(_PDP(product: p, onAddToCart: onAddToCart)),
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

// ─── PRODUCT CARD (ML compact, no credit shown) ──────────
class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Image
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF5F5F5),
                padding: const EdgeInsets.all(10),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 40, color: Color(0xFFCCCCCC)),
                ),
              ),
            ),
          ),
          // Info
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 12, color: _text1, height: 1.3)),
                const Spacer(),
                if (product.originalPrice != null)
                  Text(CurrencyFormat.format(product.originalPrice!),
                      style: GoogleFonts.inter(fontSize: 10, color: _text2, decoration: TextDecoration.lineThrough)),
                const SizedBox(height: 2),
                Row(children: [
                  Flexible(
                    child: Text(CurrencyFormat.format(product.price),
                        style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w800, color: _text1)),
                  ),
                  if (product.discountPercent > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(color: _green, borderRadius: BorderRadius.circular(5)),
                      child: Text('-${product.discountPercent}%',
                          style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ],
                ]),
                const SizedBox(height: 3),
                Text(
                  'até ${product.maxInstallments}x de ${CurrencyFormat.format(product.installmentPrice)}',
                  style: GoogleFonts.inter(fontSize: 10, color: _text2),
                ),
                if (product.freeShipping)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(children: [
                      Icon(Icons.local_shipping_rounded, color: _green, size: 12),
                      const SizedBox(width: 3),
                      Text('Frete grátis', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: _green)),
                    ]),
                  ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PDP — Nubank clean + conditional MagaluPay banner
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _PDP extends StatelessWidget {
  final Product product;
  final ValueChanged<Product> onAddToCart;
  const _PDP({required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final pixPrice = product.price * 0.90; // 10% off
    final eligible = product.price <= _creditLimit;

    return Scaffold(
      backgroundColor: _bg,
      body: Column(children: [
        // Nubank-style white top bar
        Container(
          color: _surface,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: SizedBox(
            height: 52,
            child: Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => Navigator.pop(context)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.share_outlined, size: 20), onPressed: () {}),
              IconButton(icon: const Icon(Icons.favorite_border_rounded, size: 20), onPressed: () {}),
            ]),
          ),
        ),
        Expanded(
          child: ListView(padding: EdgeInsets.zero, children: [
            // Image (generous white bg)
            Container(
              color: _surface,
              padding: const EdgeInsets.all(20),
              height: 300,
              child: Image.network(product.imageUrl, fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image, size: 56, color: Color(0xFFCCCCCC)))),
            ),
            const SizedBox(height: 12),

            // ── Price section ──
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(_radius)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(product.brand, style: GoogleFonts.inter(fontSize: 12, color: _text2)),
                const SizedBox(height: 4),
                Text(product.name, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: _text1, height: 1.4)),
                const SizedBox(height: 6),
                Row(children: [
                  Icon(Icons.star_rounded, color: Colors.amber.shade700, size: 15),
                  const SizedBox(width: 3),
                  Text('${product.rating}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                  Text(' (${product.reviewCount})', style: GoogleFonts.inter(fontSize: 13, color: _text2)),
                ]),
                const SizedBox(height: 14),
                if (product.originalPrice != null) ...[
                  Row(children: [
                    Text(CurrencyFormat.format(product.originalPrice!),
                        style: GoogleFonts.inter(fontSize: 13, color: _text2, decoration: TextDecoration.lineThrough)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(color: _green, borderRadius: BorderRadius.circular(6)),
                      child: Text('-${product.discountPercent}%',
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ]),
                  const SizedBox(height: 4),
                ],
                Text(CurrencyFormat.format(product.price),
                    style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: _text1, letterSpacing: -0.5)),
                const SizedBox(height: 4),
                Text('até ${product.maxInstallments}x de ${CurrencyFormat.format(product.installmentPrice)} sem juros',
                    style: GoogleFonts.inter(fontSize: 13, color: _text2)),
              ]),
            ),

            // ── MagaluPay Banner (ONLY when price <= 5000) ──
            if (eligible)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_blue.withValues(alpha: 0.07), _blue.withValues(alpha: 0.03)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _blue.withValues(alpha: 0.15)),
                ),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: _blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.credit_card_rounded, color: _blue, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: 'Crédito Digital MagaluPay',
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: _blue),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${CurrencyFormat.format(pixPrice)} no Pix — 10% off',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: _green),
                      ),
                    ]),
                  ),
                  Icon(Icons.chevron_right_rounded, color: _blue.withValues(alpha: 0.5), size: 22),
                ]),
              ),

            const SizedBox(height: 10),

            // Shipping card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(_radius)),
              child: Row(children: [
                Icon(product.freeShipping ? Icons.local_shipping_rounded : Icons.local_shipping_outlined,
                    color: product.freeShipping ? _green : _text2, size: 20),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(product.freeShipping ? 'Frete grátis' : 'Frete: ${CurrencyFormat.format(product.shippingCost ?? 0)}',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600,
                          color: product.freeShipping ? _green : _text1)),
                  if (product.deliveryDate != null)
                    Text('Previsão: ${product.deliveryDate}', style: GoogleFonts.inter(fontSize: 12, color: _text2)),
                ]),
              ]),
            ),

            // Description
            Container(
              margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(_radius)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Descrição', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(product.description, style: GoogleFonts.inter(fontSize: 13, color: _text2, height: 1.5)),
              ]),
            ),

            const SizedBox(height: 90),
          ]),
        ),
      ]),
      // Floating buy bar
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: _surface,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10, offset: const Offset(0, -3))],
        ),
        padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
        child: Row(children: [
          Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(CurrencyFormat.format(product.price),
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: _text1)),
            if (eligible)
              Text('ou ${CurrencyFormat.format(product.price * 0.9)} no Pix',
                  style: GoogleFonts.inter(fontSize: 11, color: _green, fontWeight: FontWeight.w600)),
          ]),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              onAddToCart(product);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: Text('Comprar', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ]),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// CART
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
          child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: _text2.withValues(alpha: 0.3)),
            const SizedBox(height: 14),
            Text('Sacola vazia', style: GoogleFonts.inter(fontSize: 18, color: _text2)),
          ])),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Sacola (${cart.length})',
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: _text1)),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              children: [
                ...cart.map((item) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(14)),
                      child: Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(item.product.imageUrl, width: 66, height: 66, fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Container(width: 66, height: 66, color: const Color(0xFFF0F0F0),
                                  child: const Icon(Icons.image, size: 24, color: Color(0xFFCCCCCC)))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(item.product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(fontSize: 12, color: _text1)),
                          const SizedBox(height: 5),
                          Text(CurrencyFormat.format(item.total),
                              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                        ])),
                        Column(children: [
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            _QtyBtn(Icons.remove, () => onUpdateQty(item.product.id, item.quantity - 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text('${item.quantity}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                            ),
                            _QtyBtn(Icons.add, () => onUpdateQty(item.product.id, item.quantity + 1)),
                          ]),
                          const SizedBox(height: 4),
                          GestureDetector(onTap: () => onRemove(item.product.id),
                              child: Text('Remover', style: GoogleFonts.inter(fontSize: 10, color: Colors.red))),
                        ]),
                      ]),
                    )),

                // Summary
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(14)),
                  child: Column(children: [
                    _Row('Subtotal', CurrencyFormat.format(_total)),
                    const SizedBox(height: 6),
                    _Row('Frete', 'Grátis', valueColor: _green),
                    const Divider(height: 18),
                    _Row('Total', CurrencyFormat.format(_total), isBold: true),
                  ]),
                ),
              ],
            ),
          ),
        ]),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: _surface,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, -2))],
        ),
        padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => onPush(_Checkout(cart: cart, total: _total)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: Text('Continuar • ${CurrencyFormat.format(_total)}',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// CHECKOUT — Magalu CDC-first × Nubank elegant format
// ML-style interest disclaimer at the bottom (scroll)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _Checkout extends StatefulWidget {
  final List<CartItem> cart;
  final double total;
  const _Checkout({required this.cart, required this.total});
  @override
  State<_Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<_Checkout> {
  int _selectedPayment = 0; // CDC first
  int _selectedInstallment = 12;

  // Installment options with rates (matching MockData pattern)
  List<_InstOption> get _installments {
    const entries = [
      (1, 0.0),
      (2, 0.0),
      (3, 0.0),
      (6, 0.0199),
      (10, 0.0249),
      (12, 0.0299),
      (18, 0.0349),
      (24, 0.0399),
    ];
    return entries.map((e) {
      final (n, rate) = e;
      final total = widget.total * (1 + rate * n);
      return _InstOption(count: n, perMonth: total / n, total: total, rate: rate, hasInterest: rate > 0);
    }).toList();
  }

  _InstOption get _currentInst => _installments.firstWhere((o) => o.count == _selectedInstallment,
      orElse: () => _installments.last);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(children: [
        // Nubank clean header
        Container(
          color: _surface,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: SizedBox(height: 52, child: Row(children: [
            IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => Navigator.pop(context)),
            Text('Pagamento', style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700)),
            const Spacer(),
          ])),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Order summary ──
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(_radius)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Resumo', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  ...widget.cart.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(children: [
                          Expanded(
                            child: Text('${item.quantity}x ${item.product.name.split(' ').take(4).join(' ')}',
                                style: GoogleFonts.inter(fontSize: 13, color: _text2), overflow: TextOverflow.ellipsis),
                          ),
                          Text(CurrencyFormat.format(item.total),
                              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                        ]),
                      )),
                  const Divider(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Total', style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700)),
                    Text(CurrencyFormat.format(widget.total),
                        style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700)),
                  ]),
                ]),
              ),

              const SizedBox(height: 18),
              Text('Forma de pagamento', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),

              // ── CDC FIRST (Magalu's checkout, Nubank card style) ──
              _PaymentOption(
                icon: Icons.credit_score_rounded,
                label: 'Crédito Digital MagaluPay',
                subtitle: 'Até 24x • Aprovação imediata',
                color: _blue,
                isSelected: _selectedPayment == 0,
                onTap: () => setState(() => _selectedPayment = 0),
              ),

              // ── CDC INSTALLMENT SUMMARY (Nubank style, shown when CDC selected) ──
              if (_selectedPayment == 0)
                _buildInstallmentSummary(),

              _PaymentOption(
                icon: Icons.pix_rounded,
                label: 'Pix',
                subtitle: '10% off • ${CurrencyFormat.format(widget.total * 0.9)}',
                color: const Color(0xFF00BDAE),
                isSelected: _selectedPayment == 1,
                onTap: () => setState(() => _selectedPayment = 1),
              ),

              _PaymentOption(
                icon: Icons.credit_card_rounded,
                label: 'Cartão de crédito',
                subtitle: 'Até 12x sem juros',
                color: const Color(0xFF444444),
                isSelected: _selectedPayment == 2,
                onTap: () => setState(() => _selectedPayment = 2),
              ),

              _PaymentOption(
                icon: Icons.receipt_long_rounded,
                label: 'Boleto bancário',
                subtitle: 'Até 3 dias úteis',
                color: const Color(0xFF444444),
                isSelected: _selectedPayment == 3,
                onTap: () => setState(() => _selectedPayment = 3),
              ),

              const SizedBox(height: 20),

              // ── INTEREST RATE DISCLAIMER (ML-style, you need to scroll to see) ──
              if (_selectedPayment == 0)
                _buildInterestDisclaimer(),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ]),

      // CTA
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: _surface,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, -2))],
        ),
        padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).padding.bottom + 12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          if (_selectedPayment == 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${_currentInst.count}x de ${CurrencyFormat.format(_currentInst.perMonth)}',
                style: GoogleFonts.inter(fontSize: 14, color: _blue, fontWeight: FontWeight.w600),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const _Success())),
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text('Finalizar compra', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      ),
    );
  }

  // ── Nubank-style installment summary card ──
  Widget _buildInstallmentSummary() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _blue.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _blue.withValues(alpha: 0.1)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Parcelas', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: _text1)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _installments.map((opt) {
              final isSel = opt.count == _selectedInstallment;
              return GestureDetector(
                onTap: () => setState(() => _selectedInstallment = opt.count),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSel ? _blue : _surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isSel ? _blue : const Color(0xFFDDDDDD)),
                  ),
                  child: Text(
                    '${opt.count}x',
                    style: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: isSel ? Colors.white : _text1,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          // Nubank-style summary line
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${_currentInst.count}x de',
                    style: GoogleFonts.inter(fontSize: 12, color: _text2)),
                Text(CurrencyFormat.format(_currentInst.perMonth),
                    style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: _text1)),
              ]),
              const Spacer(),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('Total', style: GoogleFonts.inter(fontSize: 12, color: _text2)),
                Text(CurrencyFormat.format(_currentInst.total),
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: _text1)),
              ]),
            ]),
          ),
          if (_currentInst.hasInterest) ...[
            const SizedBox(height: 8),
            Row(children: [
              Icon(Icons.info_outline_rounded, size: 13, color: _text3),
              const SizedBox(width: 4),
              Text(
                'Taxa de ${(_currentInst.rate * 100).toStringAsFixed(2)}% a.m.',
                style: GoogleFonts.inter(fontSize: 11, color: _text3),
              ),
            ]),
          ] else ...[
            const SizedBox(height: 8),
            Row(children: [
              Icon(Icons.check_circle_outline_rounded, size: 13, color: _green),
              const SizedBox(width: 4),
              Text('Sem juros', style: GoogleFonts.inter(fontSize: 11, color: _green, fontWeight: FontWeight.w600)),
            ]),
          ],
        ]),
      ),
    );
  }

  // ── ML-style interest rate disclaimer (need to scroll) ──
  Widget _buildInterestDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.info_outline_rounded, size: 16, color: _text2),
          const SizedBox(width: 8),
          Text('Informações sobre juros', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: _text2)),
        ]),
        const SizedBox(height: 10),
        Text(
          'O Crédito Digital MagaluPay é oferecido pela MagaluPay S.A. '
          'As taxas de juros variam conforme o prazo escolhido:',
          style: GoogleFonts.inter(fontSize: 11, color: _text2, height: 1.5),
        ),
        const SizedBox(height: 8),
        _disclaimerLine('1x a 3x', 'Sem juros (0,00% a.m.)'),
        _disclaimerLine('6x', '1,99% a.m. — CET: 26,8% a.a.'),
        _disclaimerLine('10x', '2,49% a.m. — CET: 34,4% a.a.'),
        _disclaimerLine('12x', '2,99% a.m. — CET: 42,5% a.a.'),
        _disclaimerLine('18x', '3,49% a.m. — CET: 51,1% a.a.'),
        _disclaimerLine('24x', '3,99% a.m. — CET: 60,0% a.a.'),
        const SizedBox(height: 8),
        Text(
          'O Custo Efetivo Total (CET) varia conforme o valor financiado e as condições vigentes na data da contratação. '
          'Consulte as condições completas antes de contratar. Sujeito à análise de crédito.',
          style: GoogleFonts.inter(fontSize: 10, color: _text3, height: 1.5),
        ),
      ]),
    );
  }

  Widget _disclaimerLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        SizedBox(width: 60, child: Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: _text2))),
        Expanded(child: Text(value, style: GoogleFonts.inter(fontSize: 11, color: _text2))),
      ]),
    );
  }
}

class _InstOption {
  final int count;
  final double perMonth;
  final double total;
  final double rate;
  final bool hasInterest;
  const _InstOption({required this.count, required this.perMonth, required this.total, required this.rate, required this.hasInterest});
}

// ─── PAYMENT OPTION (Nubank card style) ──────────────────
class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.05) : _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? color : const Color(0xFFEEEEEE), width: isSelected ? 2 : 1),
        ),
        child: Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: _text2)),
          ])),
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: isSelected ? color : const Color(0xFFCCCCCC), size: 22,
          ),
        ]),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// SUCCESS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _Success extends StatelessWidget {
  const _Success();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 88, height: 88,
                decoration: BoxDecoration(color: _green.withValues(alpha: 0.12), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, color: _green, size: 52),
              ),
              const SizedBox(height: 24),
              Text('Pedido confirmado!',
                  style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: _text1, letterSpacing: -0.5)),
              const SizedBox(height: 10),
              Text('Você receberá um e-mail com os\ndetalhes da sua compra.',
                  textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 14, color: _text2, height: 1.5)),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _blue, foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text('Voltar ao início', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// SHARED ATOMS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
class _CircleBtn extends StatelessWidget {
  final IconData icon;
  const _CircleBtn(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38, height: 38,
      decoration: BoxDecoration(color: _bg, shape: BoxShape.circle),
      child: Icon(icon, color: _text2, size: 20),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool active;
  const _CategoryChip(this.label, this.active);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? _blue : _surface,
        borderRadius: BorderRadius.circular(20),
        border: active ? null : Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Center(
        child: Text(label,
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: active ? Colors.white : _text1)),
      ),
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
        width: 28, height: 28,
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFDDDDDD)), borderRadius: BorderRadius.circular(7)),
        child: Icon(icon, size: 14, color: _text2),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;
  const _Row(this.label, this.value, {this.isBold = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: GoogleFonts.inter(
          fontSize: isBold ? 15 : 13, fontWeight: isBold ? FontWeight.w700 : FontWeight.w400, color: _text1)),
      Text(value, style: GoogleFonts.inter(
          fontSize: isBold ? 15 : 13, fontWeight: isBold ? FontWeight.w700 : FontWeight.w500, color: valueColor ?? _text1)),
    ]);
  }
}
