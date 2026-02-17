// ═══════════════════════════════════════════════════════════
// V2 — Mercado Livre (Pixel-Perfect from Screenshots)
// ═══════════════════════════════════════════════════════════
// Screens matched to real ML screenshots:
//   1. Home: Yellow header + search + bell, address bar,
//      category TABS, promo banner, meli+ bar, quick actions,
//      horizontal product sections (Visto recentemente, etc.)
//   2. PDP: Image + dots, price + "Crédito disponível" badge,
//      "36x R$ XX com Linha de Crédito", FULL shipping, stock.
//   3. Payment: "Como você prefere pagar?" list
//   4. Installments: "Em quantas vezes?" vertical list
//   5. Confirmation: White, regulatory text, address section
// ═══════════════════════════════════════════════════════════

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/models.dart';
import '../data/mock_data.dart';
import '../providers/providers.dart';
import '../utils/currency_format.dart';

// ─── Colors (from ML screenshots) ───────────────────────
class _C {
  static const yellow = Color(0xFFFFE600);
  static const blue = Color(0xFF3483FA);
  static const green = Color(0xFF00A650);
  static const greenLight = Color(0xFFE6F7ED);
  static const greenDark = Color(0xFF00662D);
  static const bg = Color(0xFFEEEEEE);
  static const card = Colors.white;
  static const text = Color(0xFF333333);
  static const textSec = Color(0xFF999999);
  static const lightBlue = Color(0xFFE8F4FD);
  static const mpBlue = Color(0xFF009EE3);
}

// ─── Entry Point ─────────────────────────────────────────
class V2App extends StatelessWidget {
  const V2App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          primaryColor: _C.blue,
          scaffoldBackgroundColor: _C.bg,
          appBarTheme: const AppBarTheme(
            backgroundColor: _C.yellow,
            foregroundColor: _C.text,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        home: const _Home(),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════
// HOME — Exact ML Home layout from screenshot
// ═════════════════════════════════════════════════════════
class _Home extends ConsumerWidget {
  const _Home();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartItemCountProvider);
    final products = MockData.products;

    return Scaffold(
      backgroundColor: _C.bg,
      body: Column(
        children: [
          // ── Yellow header zone ──
          Container(
            color: _C.yellow,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Search bar + notification bell
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Row(
                      children: [
                        // Search bar
                        Expanded(
                          child: Container(
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(19),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: const Row(
                              children: [
                                Icon(Icons.search, color: _C.textSec, size: 20),
                                SizedBox(width: 8),
                                Text('Buscar no Mercado Livre',
                                    style: TextStyle(color: _C.textSec, fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Notification bell with badge
                        Stack(
                          children: [
                            Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: _C.text.withOpacity(0.3)),
                              ),
                              child: const Icon(Icons.notifications_outlined, size: 20, color: _C.text),
                            ),
                            Positioned(
                              right: 0, top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                child: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Address bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: _C.text),
                        const SizedBox(width: 4),
                        const Text('Avenida Agami 347',
                            style: TextStyle(fontSize: 13, color: _C.text, fontWeight: FontWeight.w400)),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right, size: 16, color: _C.text),
                      ],
                    ),
                  ),
                  // Category tabs
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: const [
                        _CatTab('Tudo', true),
                        _CatTab('Moda', false),
                        _CatTab('Beleza', false),
                        _CatTab('Celulares', false),
                        _CatTab('Lar', false),
                        _CatTab('Computação', false),
                        _CatTab('Tecnologia', false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ── Scrollable content ──
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Promo banner
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  height: 140,
                  decoration: BoxDecoration(
                    color: _C.yellow,
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFE600), Color(0xFFFFC400)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFFE600), Color(0xFFFFA000)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('BLOQUINHO DE OFERTAS',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _C.text, letterSpacing: 0.5)),
                            const SizedBox(height: 2),
                            const Text('ATÉ 70% OFF',
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: _C.text)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: _C.green, borderRadius: BorderRadius.circular(4)),
                              child: const Text('CUPOM* ATÉ 30% OFF',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Meli+ bar
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: _C.card,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: _C.yellow, borderRadius: BorderRadius.circular(4)),
                        child: const Text('meli+', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _C.text)),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text('Confira seus benefícios exclusivos',
                            style: TextStyle(fontSize: 13, color: _C.text)),
                      ),
                      const Icon(Icons.chevron_right, size: 18, color: _C.textSec),
                    ],
                  ),
                ),
                // Quick action icons row
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 10, 0, 8),
                  height: 80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      _QuickIcon(Icons.local_offer, 'Ofertas', null),
                      _QuickIcon(Icons.attach_money, 'Afiliados', 'GANHE \$'),
                      _QuickIcon(Icons.movie, 'Mercado Play', 'GRÁTIS'),
                      _QuickIcon(Icons.confirmation_number, 'Cupons', null),
                      _QuickIcon(Icons.shopping_cart, 'Mercado', null),
                      _QuickIcon(Icons.flight, 'Internacional', null),
                    ],
                  ),
                ),
                // Featured product banner (ad)
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('FEITO PARA VOCÊ',
                                style: TextStyle(fontSize: 9, color: Colors.white60, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                            const SizedBox(height: 2),
                            const Text('OUÇA SEU SOM\nCOM QUALIDADE',
                                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w700, height: 1.2)),
                            const SizedBox(height: 4),
                            const Text('Adquira já', style: TextStyle(fontSize: 11, color: Colors.white60)),
                          ],
                        ),
                      ),
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.headphones, color: Colors.white30, size: 36),
                      ),
                    ],
                  ),
                ),
                // ── Product sections (horizontal scroll) ──
                _ProductSection(
                  title: 'Visto recentemente',
                  products: products.take(3).toList(),
                ),
                _ProductSection(
                  title: 'O que você quer',
                  products: products.skip(1).take(3).toList(),
                ),
                _ProductSection(
                  title: 'Também te interessa',
                  products: products.reversed.take(3).toList(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
      // Bottom nav — per screenshot: Início, Categorias, Carrinho (raised), Clips, Mais
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _C.card,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(Icons.home, 'Início', true),
                _NavItem(Icons.grid_view_rounded, 'Categorias', false),
                // Raised cart button
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _Cart())),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44, height: 44,
                        margin: const EdgeInsets.only(bottom: 2),
                        decoration: BoxDecoration(
                          color: _C.card,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFDDDDDD)),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(Icons.shopping_cart_outlined, size: 22, color: _C.textSec),
                            if (cartCount > 0)
                              Positioned(
                                right: 4, top: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                  child: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 7)),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Text('Carrinho', style: TextStyle(fontSize: 9, color: _C.textSec)),
                    ],
                  ),
                ),
                _NavItem(Icons.play_circle_outline, 'Clips', false),
                _NavItem(Icons.menu, 'Mais', false),
              ],
            ),
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
        Icon(icon, size: 22, color: active ? _C.blue : _C.textSec),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 9, color: active ? _C.blue : _C.textSec, fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
      ],
    );
  }
}

class _CatTab extends StatelessWidget {
  final String label;
  final bool active;
  const _CatTab(this.label, this.active);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: _C.text,
              )),
          const SizedBox(height: 4),
          Container(
            height: 3,
            width: label.length * 7.0,
            decoration: BoxDecoration(
              color: active ? _C.text : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  const _QuickIcon(this.icon, this.label, this.badge);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: _C.card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 22, color: _C.text),
              ),
              if (badge != null)
                Positioned(
                  bottom: -3, left: 2, right: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                    decoration: BoxDecoration(
                      color: _C.green,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(badge!, style: const TextStyle(fontSize: 7, color: Colors.white, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 56,
            child: Text(label, style: const TextStyle(fontSize: 9, color: _C.text), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

// ─── Product Section (horizontal scroll cards) ───────────
class _ProductSection extends StatelessWidget {
  final String title;
  final List<Product> products;
  const _ProductSection({required this.title, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: products.length,
            itemBuilder: (context, i) {
              final p = products[i];
              return _HomeProductCard(product: p, sectionTitle: i == 0 ? title : null);
            },
          ),
        ),
      ],
    );
  }
}

class _HomeProductCard extends ConsumerWidget {
  final Product product;
  final String? sectionTitle;
  const _HomeProductCard({required this.product, this.sectionTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _ProductDetail(product: product))),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title inside card (per screenshot)
            if (sectionTitle != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                child: Text(sectionTitle!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _C.text)),
              ),
            // Image
            Expanded(
              child: ClipRRect(
                borderRadius: sectionTitle != null
                    ? BorderRadius.zero
                    : const BorderRadius.vertical(top: Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  placeholder: (_, __) => Container(color: Colors.grey[50]),
                  errorWidget: (_, __, ___) => Container(color: Colors.grey[50]),
                ),
              ),
            ),
            // Price info
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.originalPrice != null)
                    Text(CurrencyFormat.format(product.originalPrice!),
                        style: const TextStyle(fontSize: 10, decoration: TextDecoration.lineThrough, color: _C.textSec)),
                  Row(
                    children: [
                      Flexible(
                        child: Text(CurrencyFormat.format(product.price),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _C.text)),
                      ),
                      if (product.discountPercent > 0) ...[
                        const SizedBox(width: 4),
                        Text('${product.discountPercent}% OFF',
                            style: const TextStyle(fontSize: 10, color: _C.green, fontWeight: FontWeight.w600)),
                      ],
                    ],
                  ),
                  if (product.freeShipping)
                    Row(
                      children: [
                        const Text('Frete grátis', style: TextStyle(fontSize: 10, color: _C.green, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(color: _C.greenLight, borderRadius: BorderRadius.circular(2)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.bolt, size: 8, color: _C.green),
                              const Text('FULL', style: TextStyle(fontSize: 7, color: _C.green, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      ],
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
// PRODUCT DETAIL — ML PDP with "Crédito disponível" badge
// Per screenshot: image + dots, price, discount badge,
// "Crédito disponível" dark pill, "36x R$ XX com Linha de
// Crédito", "Ver os meios de pagamento", shipping, stock
// ═════════════════════════════════════════════════════════
class _ProductDetail extends ConsumerWidget {
  final Product product;
  const _ProductDetail({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = MockData.user;
    final creditInstallments = 36;
    final creditPerMonth = product.price * 1.35 / creditInstallments; // ~35% total interest over 36x

    return Scaffold(
      backgroundColor: _C.card,
      body: Column(
        children: [
          // Yellow header
          Container(
            color: _C.yellow,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 12, 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, size: 22, color: _C.text),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Container(
                            height: 34,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17)),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: const Row(
                              children: [
                                Icon(Icons.search, color: _C.textSec, size: 18),
                                SizedBox(width: 8),
                                Text('Buscar no Mercado Livre', style: TextStyle(color: _C.textSec, fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Stack(
                          children: [
                            Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: _C.text.withOpacity(0.3))),
                              child: const Icon(Icons.notifications_outlined, size: 18, color: _C.text),
                            ),
                            Positioned(
                              right: 0, top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                child: const Text('2', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Address bar
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 13, color: _C.text),
                          const SizedBox(width: 4),
                          const Text('Avenida Agami 347', style: TextStyle(fontSize: 12, color: _C.text)),
                          const Icon(Icons.chevron_right, size: 14, color: _C.text),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Scrollable content
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Product image with dot indicators
                Container(
                  color: _C.card,
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        placeholder: (_, __) => Container(color: Colors.grey[50], height: 240),
                      ),
                      // "GANHE DINHEIRO" share button (per screenshot)
                      Positioned(
                        right: 12, bottom: 20,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _C.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.share, color: Colors.white, size: 16),
                              Text('GANHE\nDINHEIRO', style: TextStyle(fontSize: 6, color: Colors.white, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Dot indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (i) => Container(
                    width: 8, height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == 0 ? _C.blue : const Color(0xFFDDDDDD),
                    ),
                  )),
                ),
                // ── Price section ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Original price (struck)
                      if (product.originalPrice != null)
                        Text(CurrencyFormat.format(product.originalPrice!),
                            style: const TextStyle(fontSize: 13, decoration: TextDecoration.lineThrough, color: _C.textSec)),
                      const SizedBox(height: 2),
                      // Current price + discount badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(CurrencyFormat.format(product.price),
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w300, color: _C.text)),
                          if (product.discountPercent > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(color: _C.greenLight, borderRadius: BorderRadius.circular(4)),
                              child: Text('${product.discountPercent}% OFF',
                                  style: const TextStyle(fontSize: 12, color: _C.green, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      // ╔════════════════════════════════════════════╗
                      // ║ "Crédito disponível" badge (per screenshot)║
                      // ╚════════════════════════════════════════════╝
                      if (user.creditLineAvailable >= product.price)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF333333),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Crédito disponível ',
                                  style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
                              const Icon(Icons.monetization_on, size: 14, color: _C.yellow),
                            ],
                          ),
                        ),
                      const SizedBox(height: 6),
                      // "36x R$ XX,XX com Linha de Crédito" (per screenshot)
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 15, color: _C.text),
                          children: [
                            TextSpan(text: '${creditInstallments}x '),
                            TextSpan(
                              text: CurrencyFormat.format(creditPerMonth),
                              style: const TextStyle(fontWeight: FontWeight.w400),
                            ),
                            const TextSpan(text: ' com Linha de Crédito'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      // "Ver os meios de pagamento" link
                      GestureDetector(
                        onTap: () {},
                        child: const Text('Ver os meios de pagamento',
                            style: TextStyle(fontSize: 13, color: _C.blue)),
                      ),
                      const SizedBox(height: 14),
                      // ── Shipping section ──
                      // "FRETE GRÁTIS ACIMA DE R$ 19" badge
                      if (product.freeShipping)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: _C.greenLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('FRETE GRÁTIS ACIMA DE R\$ 19',
                              style: TextStyle(fontSize: 11, color: _C.greenDark, fontWeight: FontWeight.w700)),
                        ),
                      // Free delivery text
                      if (product.freeShipping) ...[
                        Text('Chegará grátis entre amanhã e quinta-feira',
                            style: TextStyle(fontSize: 14, color: _C.green, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        GestureDetector(
                          onTap: () {},
                          child: const Text('Mais detalhes e formas de entrega',
                              style: TextStyle(fontSize: 13, color: _C.blue)),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 13, color: _C.text),
                            children: [
                              TextSpan(text: 'Retire grátis ', style: TextStyle(color: _C.green, fontWeight: FontWeight.w500)),
                              TextSpan(text: 'entre sexta-feira e segunda-feira em uma agência Mercado Livre'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        GestureDetector(
                          onTap: () {},
                          child: const Text('Ver no mapa', style: TextStyle(fontSize: 13, color: _C.blue)),
                        ),
                      ],
                      const SizedBox(height: 14),
                      // Stock info
                      const Text('Estoque disponível',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _C.text)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text('Armazenado e enviado pelo ', style: TextStyle(fontSize: 13, color: _C.textSec)),
                          Icon(Icons.bolt, size: 14, color: _C.green),
                          const Text('FULL', style: TextStyle(fontSize: 12, color: _C.green, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Quantity selector
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFDDDDDD)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Text('Quantidade: ', style: TextStyle(fontSize: 14, color: _C.textSec)),
                            const Text('1', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _C.text)),
                            const Text(' (+50 disponíveis)', style: TextStyle(fontSize: 14, color: _C.textSec)),
                            const Spacer(),
                            const Icon(Icons.chevron_right, size: 18, color: _C.textSec),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      // CTA buttons
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ref.read(cartProvider.notifier).addItem(product);
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const _Cart()));
                          },
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                          child: const Text('Comprar agora'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            ref.read(cartProvider.notifier).addItem(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Agregado ao carrinho'),
                                backgroundColor: _C.blue,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _C.blue,
                            side: const BorderSide(color: _C.blue, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Adicionar ao carrinho', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Bottom nav same as Home
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _C.card,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(Icons.home, 'Início', false),
                _NavItem(Icons.grid_view_rounded, 'Categorias', false),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _Cart())),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44, height: 44,
                        margin: const EdgeInsets.only(bottom: 2),
                        decoration: BoxDecoration(color: _C.card, shape: BoxShape.circle, border: Border.all(color: const Color(0xFFDDDDDD))),
                        child: const Icon(Icons.shopping_cart_outlined, size: 22, color: _C.textSec),
                      ),
                      const Text('Carrinho', style: TextStyle(fontSize: 9, color: _C.textSec)),
                    ],
                  ),
                ),
                _NavItem(Icons.play_circle_outline, 'Clips', false),
                _NavItem(Icons.menu, 'Mais', false),
              ],
            ),
          ),
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
      body: Column(
        children: [
          Container(
            color: _C.yellow,
            padding: const EdgeInsets.fromLTRB(4, 36, 12, 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 22, color: _C.text),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text('Carrinho',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _C.text)),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 48, color: _C.textSec),
                        SizedBox(height: 8),
                        Text('Seu carrinho está vazio', style: TextStyle(fontSize: 14, color: _C.textSec)),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.only(top: 8),
                    children: [
                      ...items.map((item) => _CartItemCard(
                            item: item,
                            onRemove: () => ref.read(cartProvider.notifier).removeItem(item.product.id),
                            onQty: (q) => ref.read(cartProvider.notifier).updateQuantity(item.product.id, q),
                          )),
                      Container(
                        color: _C.card,
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            _SumRow('Produtos', CurrencyFormat.format(total)),
                            const _SumRow('Frete', 'Grátis', color: _C.green),
                            const Divider(height: 16),
                            _SumRow('Total', CurrencyFormat.format(total), bold: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
          ),
          if (items.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              color: _C.card,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _PaymentMethod())),
                  child: const Text('Continuar a compra'),
                ),
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
    return Container(
      color: _C.card,
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: item.product.imageUrl, width: 64, height: 64, fit: BoxFit.cover,
            placeholder: (_, __) => Container(color: Colors.grey[100], width: 64, height: 64),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(CurrencyFormat.format(item.product.price), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _QtyBtn(Icons.remove, () => item.quantity > 1 ? onQty(item.quantity - 1) : onRemove()),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('${item.quantity}', style: const TextStyle(fontSize: 14))),
                    _QtyBtn(Icons.add, () => onQty(item.quantity + 1)),
                    const Spacer(),
                    GestureDetector(onTap: onRemove, child: const Text('Excluir', style: TextStyle(color: _C.blue, fontSize: 12))),
                  ],
                ),
              ],
            ),
          ),
        ],
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
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: _C.blue)),
        child: Icon(icon, size: 14, color: _C.blue),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════
// PAYMENT METHOD — "Como você prefere pagar?" (Screenshot)
// Order: Saldo MP, Mastercard x2, Pix (NOVO), Novo cartão,
// Mercado Crédito (LAST). Then Boleto.
// ═════════════════════════════════════════════════════════
class _PaymentMethod extends ConsumerStatefulWidget {
  const _PaymentMethod();
  @override
  ConsumerState<_PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends ConsumerState<_PaymentMethod> {
  String _selected = 'saldoMp';

  @override
  Widget build(BuildContext context) {
    final user = MockData.user;
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: _C.card,
      body: Column(
        children: [
          Container(
            color: _C.card,
            padding: const EdgeInsets.fromLTRB(4, 36, 12, 10),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back, size: 22, color: _C.text), onPressed: () => Navigator.pop(context)),
                const Text('Como você prefere pagar?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _C.text)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // "Com Mercado Pago" header
                Row(
                  children: [
                    const Text('Com Mercado Pago', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _C.text)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: _C.lightBlue, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.account_balance_wallet, size: 14, color: _C.mpBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _PayTile(icon: Icons.account_balance_wallet, iconColor: _C.mpBlue, label: 'Saldo no Mercado Pago',
                    subtitle: 'Saldo: ${CurrencyFormat.format(user.mercadoPagoBalance)}', value: 'saldoMp', selected: _selected,
                    onTap: () => setState(() => _selected = 'saldoMp')),
                _PayTile(icon: Icons.credit_card, iconColor: Colors.red, label: 'Mastercard **** 9303',
                    value: 'mc1', selected: _selected, onTap: () => setState(() => _selected = 'mc1')),
                _PayTile(icon: Icons.credit_card, iconColor: Colors.red.shade700, label: 'Mastercard **** 7326',
                    value: 'mc2', selected: _selected, onTap: () => setState(() => _selected = 'mc2')),
                _PayTile(icon: Icons.pix, iconColor: const Color(0xFF00BDAE), label: 'Pix',
                    subtitle: 'Aprovação imediata', value: 'pix', selected: _selected,
                    onTap: () => setState(() => _selected = 'pix'), badge: 'NOVO'),
                _PayTile(icon: Icons.add_card, iconColor: _C.textSec, label: 'Novo cartão de crédito',
                    value: 'newCard', selected: _selected, onTap: () => setState(() => _selected = 'newCard')),
                _PayTile(icon: Icons.account_balance_wallet, iconColor: _C.mpBlue, label: 'Mercado Crédito',
                    subtitle: 'Boleto parcelado em até 12x', value: 'mercadoCredito', selected: _selected,
                    onTap: () => setState(() => _selected = 'mercadoCredito')),
                const SizedBox(height: 20),
                const Text('Com outros meios de pagamento', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _C.text)),
                const SizedBox(height: 12),
                _PayTile(icon: Icons.receipt_long, iconColor: _C.text, label: 'Boleto',
                    value: 'boleto', selected: _selected, onTap: () => setState(() => _selected = 'boleto')),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(Icons.confirmation_number_outlined, size: 18, color: _C.blue),
                      const SizedBox(width: 8),
                      const Text('Inserir código do cupom', style: TextStyle(color: _C.blue, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: _C.card, border: Border(top: BorderSide(color: Colors.grey.shade200))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Você pagará', style: TextStyle(fontSize: 13, color: _C.textSec)),
                Text(CurrencyFormat.format(total), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _C.text)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            color: _C.card,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selected == 'mercadoCredito') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => _InstallmentSelection(total: total)));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => _Confirmation(total: total, paymentLabel: _payLabel())));
                  }
                },
                child: const Text('Continuar'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _payLabel() {
    switch (_selected) {
      case 'saldoMp': return 'Saldo Mercado Pago';
      case 'mc1': return 'Mastercard **** 9303';
      case 'mc2': return 'Mastercard **** 7326';
      case 'pix': return 'Pix';
      case 'newCard': return 'Novo cartão de crédito';
      case 'mercadoCredito': return 'Mercado Crédito';
      case 'boleto': return 'Boleto';
      default: return _selected;
    }
  }
}

class _PayTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String? subtitle;
  final String value;
  final String selected;
  final VoidCallback onTap;
  final String? badge;
  const _PayTile({required this.icon, required this.iconColor, required this.label, this.subtitle,
      required this.value, required this.selected, required this.onTap, this.badge});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(child: Text(label, style: const TextStyle(fontSize: 14, color: _C.text))),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: _C.green, borderRadius: BorderRadius.circular(4)),
                          child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                  if (subtitle != null) Text(subtitle!, style: const TextStyle(fontSize: 11, color: _C.textSec)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: _C.textSec),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════
// INSTALLMENT SELECTION — "Em quantas vezes?" (Screenshot)
// ═════════════════════════════════════════════════════════
class _InstallmentSelection extends StatefulWidget {
  final double total;
  const _InstallmentSelection({required this.total});
  @override
  State<_InstallmentSelection> createState() => _InstallmentSelectionState();
}

class _InstallmentSelectionState extends State<_InstallmentSelection> {
  @override
  Widget build(BuildContext context) {
    final options = <int, _InstOpt>{
      1: _InstOpt(widget.total, widget.total),
      2: _InstOpt(widget.total * 1.03 / 2, widget.total * 1.03),
      3: _InstOpt(widget.total * 1.05 / 3, widget.total * 1.05),
      4: _InstOpt(widget.total * 1.07 / 4, widget.total * 1.07),
      5: _InstOpt(widget.total * 1.09 / 5, widget.total * 1.09),
      6: _InstOpt(widget.total * 1.12 / 6, widget.total * 1.12),
      10: _InstOpt(widget.total * 1.18 / 10, widget.total * 1.18),
      12: _InstOpt(widget.total * 1.22 / 12, widget.total * 1.22),
    };

    return Scaffold(
      backgroundColor: _C.card,
      body: Column(
        children: [
          Container(
            color: _C.card,
            padding: const EdgeInsets.fromLTRB(4, 36, 12, 10),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back, size: 22, color: _C.text), onPressed: () => Navigator.pop(context)),
                const Text('Em quantas vezes?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _C.text)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: options.entries.map((e) {
                final count = e.key;
                final opt = e.value;
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => _Confirmation(
                      total: opt.totalWithInterest,
                      paymentLabel: 'Mercado Crédito — ${count}x de ${CurrencyFormat.format(opt.perInstallment)}',
                    ),
                  )),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))),
                    child: Row(
                      children: [
                        Text('${count}x', style: const TextStyle(fontSize: 14, color: _C.text)),
                        const SizedBox(width: 8),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 14, color: _C.text),
                            children: [
                              const TextSpan(text: 'R\$ '),
                              TextSpan(text: opt.perInstallment.toStringAsFixed(2).split('.')[0]),
                              TextSpan(text: opt.perInstallment.toStringAsFixed(2).split('.')[1], style: const TextStyle(fontSize: 10)),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(CurrencyFormat.format(opt.totalWithInterest), style: const TextStyle(fontSize: 13, color: _C.textSec)),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, size: 16, color: _C.textSec),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: _C.card, border: Border(top: BorderSide(color: Colors.grey.shade200))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Você pagará', style: TextStyle(fontSize: 13, color: _C.textSec)),
                Text(CurrencyFormat.format(widget.total), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _C.text)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InstOpt {
  final double perInstallment;
  final double totalWithInterest;
  const _InstOpt(this.perInstallment, this.totalWithInterest);
}

// ═════════════════════════════════════════════════════════
// CONFIRMATION — "Confirme a sua compra" (Screenshot)
// ═════════════════════════════════════════════════════════
class _Confirmation extends ConsumerWidget {
  final double total;
  final String paymentLabel;
  const _Confirmation({required this.total, required this.paymentLabel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    const shipping = 5.22;
    final grandTotal = total + shipping;

    return Scaffold(
      backgroundColor: _C.card,
      body: Column(
        children: [
          Container(
            color: _C.card,
            padding: const EdgeInsets.fromLTRB(4, 36, 12, 10),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back, size: 22, color: _C.text), onPressed: () => Navigator.pop(context)),
                const Text('Confirme a sua compra', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _C.text)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _ConfRow('Produtos (${items.length})', CurrencyFormat.format(total)),
                const SizedBox(height: 6),
                _ConfRow('Frete', CurrencyFormat.format(shipping)),
                const SizedBox(height: 6),
                _ConfRow('Subtotal', CurrencyFormat.format(total + shipping)),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Você pagará', style: TextStyle(fontSize: 14, color: _C.text)),
                    Text('1x  ${CurrencyFormat.format(grandTotal)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _C.text)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text('Total  ${CurrencyFormat.format(grandTotal)}', style: const TextStyle(fontSize: 12, color: _C.textSec))],
                ),
                const Divider(height: 24),
                // Terms
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(fontSize: 11, color: _C.textSec, height: 1.4),
                    children: [
                      TextSpan(text: 'Ao confirmar, você aceita os '),
                      TextSpan(text: 'termos e condições gerais', style: TextStyle(color: _C.blue)),
                      TextSpan(text: '  e declaro assinada a '),
                      TextSpan(text: 'Cédula de Crédito Bancário', style: TextStyle(color: _C.blue)),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _Success())),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text('Confirmar compra'),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'O Mercado Pago atua apenas e tão somente na qualidade de correspondente bancário de Instituições Financeiras Parceiras. A oferta e o valor da oferta poderão ser alterados, a qualquer momento, a critério das Instituições Financeiras.',
                  style: TextStyle(fontSize: 10, color: _C.textSec, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Address
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(border: Border.all(color: const Color(0xFFEEEEEE)), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 28, color: _C.blue),
                      const SizedBox(height: 8),
                      const Text('Rua José Muniz dos Santos 60',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _C.text), textAlign: TextAlign.center),
                      const SizedBox(height: 4),
                      const Text(
                        'CEP 04571914 — Cidade Monções — São Paulo, São Paulo\nLucas Fidelis Monteiro Gonçalves — 11993652956',
                        style: TextStyle(fontSize: 11, color: _C.textSec), textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      GestureDetector(onTap: () {}, child: const Text('Editar ou escolher outro', style: TextStyle(color: _C.blue, fontSize: 13))),
                    ],
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

class _ConfRow extends StatelessWidget {
  final String label;
  final String value;
  const _ConfRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: _C.text)),
        Text(value, style: const TextStyle(fontSize: 13, color: _C.text)),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════
// SUCCESS
// ═════════════════════════════════════════════════════════
class _Success extends ConsumerWidget {
  const _Success();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ref.watch(cartTotalProvider);
    final orderNum = (Random().nextInt(900000) + 100000).toString();

    return Scaffold(
      backgroundColor: _C.card,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72, height: 72,
                  decoration: const BoxDecoration(color: _C.greenLight, shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle, color: _C.green, size: 48),
                ),
                const SizedBox(height: 16),
                const Text('Pronto!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: _C.text)),
                const SizedBox(height: 4),
                const Text('Compra aprovada', style: TextStyle(fontSize: 14, color: _C.textSec)),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: _C.bg, borderRadius: BorderRadius.circular(6)),
                  child: Column(
                    children: [
                      _InfoRow('Pedido #', orderNum),
                      const SizedBox(height: 6),
                      _InfoRow('Total', CurrencyFormat.format(total)),
                      const SizedBox(height: 6),
                      const _InfoRow('Entrega', '20-22 de fev'),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: _C.lightBlue, borderRadius: BorderRadius.circular(6)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_user, size: 16, color: _C.blue),
                      SizedBox(width: 6),
                      Text('Compra Garantida', style: TextStyle(color: _C.blue, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(cartProvider.notifier).clear();
                      Navigator.of(context).popUntil((r) => r.isFirst);
                    },
                    child: const Text('Voltar ao início'),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(onPressed: () {}, child: const Text('Acompanhar pedido', style: TextStyle(color: _C.blue, fontSize: 13))),
              ],
            ),
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
        Text(label, style: const TextStyle(fontSize: 12, color: _C.textSec)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _SumRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool bold;
  const _SumRow(this.label, this.value, {this.color, this.bold = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: bold ? 15 : 13, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: bold ? 16 : 13, fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: color)),
        ],
      ),
    );
  }
}
