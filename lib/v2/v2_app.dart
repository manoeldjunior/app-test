// ═══════════════════════════════════════════════════════════
// V2 — Mercado Livre (ML Marketplace + Mercado Pago Credit)
// ═══════════════════════════════════════════════════════════
// ML-inspired: yellow header, 2-column dense grid, seller
// info, green "Compra Garantida" badges, step checkout,
// MercadoPago branding with credit line indicators at
// top of funnel (Home + Product Detail).
// ═══════════════════════════════════════════════════════════

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/models.dart';
import '../data/mock_data.dart';
import '../providers/providers.dart';
import '../utils/currency_format.dart';

// ─── Colors ──────────────────────────────────────────────
class _C {
  static const yellow = Color(0xFFFFE600);
  static const blue = Color(0xFF3483FA);
  static const green = Color(0xFF00A650);
  static const greenLight = Color(0xFFE6F7ED);
  static const bg = Color(0xFFEBEBEB);
  static const card = Colors.white;
  static const text = Color(0xFF333333);
  static const textSec = Color(0xFF999999);
  static const lightBlue = Color(0xFFE8F4FD);
  static const mpBlue = Color(0xFF009EE3);
  static const mpLightBlue = Color(0xFFE7F6FD);
  static const orange = Color(0xFFFF7733);
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(
                fontSize: 14,
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

// ═════════════════════════════════════════════════════════
// HOME — Top of funnel with credit line indicators
// ═════════════════════════════════════════════════════════
class _Home extends ConsumerWidget {
  const _Home();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartItemCountProvider);
    final user = MockData.user;

    return Scaffold(
      body: Column(
        children: [
          // Yellow header
          Container(
            color: _C.yellow,
            padding: const EdgeInsets.fromLTRB(12, 40, 12, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: _SearchBar()),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const _Cart())),
                      child: Stack(
                        children: [
                          const Icon(Icons.shopping_cart_outlined,
                              color: _C.text, size: 24),
                          if (cartCount > 0)
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text('$cartCount',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 8)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: _C.text),
                    const SizedBox(width: 4),
                    const Text('Enviar para CEP 01310-100',
                        style: TextStyle(fontSize: 11, color: _C.text)),
                    const SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down,
                        size: 14, color: _C.text.withOpacity(0.6)),
                  ],
                ),
              ],
            ),
          ),
          // Category pills
          Container(
            color: _C.card,
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              children: const [
                _CatPill('Ofertas do dia', true),
                _CatPill('Celulares', false),
                _CatPill('Informática', false),
                _CatPill('TVs', false),
                _CatPill('Games', false),
                _CatPill('Moda', false),
              ],
            ),
          ),
          // ╔══════════════════════════════════════════════════╗
          // ║ TOP-OF-FUNNEL: Mercado Pago Credit Banner       ║
          // ╚══════════════════════════════════════════════════╝
          Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF009EE3), Color(0xFF2D3277)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('MP',
                          style: TextStyle(
                              color: _C.mpBlue,
                              fontSize: 10,
                              fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Linha de Crédito Mercado Pago',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          Text('Dinheiro disponível na hora',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white70),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.account_balance_wallet,
                                color: Colors.white, size: 14),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Crédito: ${CurrencyFormat.format(user.creditLineAvailable)}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.monetization_on,
                              color: Colors.white, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'Até ${user.creditLineMaxInstallments}x',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ╔══════════════════════════════════════════════════╗
          // ║ TOP-OF-FUNNEL: Mercado Pago Balance             ║
          // ╚══════════════════════════════════════════════════╝
          Container(
            margin: const EdgeInsets.fromLTRB(8, 6, 8, 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _C.card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFDDDDDD)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _C.mpLightBlue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.account_balance,
                      size: 16, color: _C.mpBlue),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Saldo Mercado Pago',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _C.text)),
                      Text(
                        CurrencyFormat.format(user.mercadoPagoBalance),
                        style: const TextStyle(
                            fontSize: 11, color: _C.textSec),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _C.mpLightBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.monetization_on,
                          size: 12, color: _C.orange),
                      const SizedBox(width: 4),
                      Text(
                        '${user.meliDolarBalance.toStringAsFixed(2)} Meli Dólar',
                        style: const TextStyle(
                            fontSize: 10,
                            color: _C.orange,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Products grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 0.52,
              ),
              itemCount: MockData.products.length,
              itemBuilder: (context, i) =>
                  _ProductCard(product: MockData.products[i]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _C.blue,
        unselectedItemColor: _C.textSec,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 22), label: 'Início'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border, size: 22),
              label: 'Favoritos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined, size: 22),
              label: 'Ofertas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history, size: 22), label: 'Histórico'),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz, size: 22), label: 'Mais'),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: const Row(
        children: [
          Icon(Icons.search, color: _C.textSec, size: 18),
          SizedBox(width: 8),
          Text('Buscar em Mercado Livre',
              style: TextStyle(color: _C.textSec, fontSize: 13)),
        ],
      ),
    );
  }
}

class _CatPill extends StatelessWidget {
  final String label;
  final bool active;
  const _CatPill(this.label, this.active);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: active ? _C.lightBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: active ? _C.blue : const Color(0xFFDDDDDD)),
      ),
      alignment: Alignment.center,
      child: Text(label,
          style: TextStyle(
              color: active ? _C.blue : _C.textSec,
              fontSize: 11,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
    );
  }
}

// ─── Product Card (with credit indicator) ────────────────
class _ProductCard extends ConsumerWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = MockData.user;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => _ProductDetail(product: product)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(6)),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(color: Colors.grey[100]),
                  errorWidget: (_, __, ___) =>
                      Container(color: Colors.grey[100]),
                ),
              ),
            ),
            // Info
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.originalPrice != null)
                      Text(CurrencyFormat.format(product.originalPrice!),
                          style: const TextStyle(
                              fontSize: 10,
                              decoration: TextDecoration.lineThrough,
                              color: _C.textSec)),
                    Text(CurrencyFormat.format(product.price),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400)),
                    if (product.maxInstallments > 1)
                      Text(
                          'em ${product.maxInstallments}x ${CurrencyFormat.format(product.installmentPrice)}',
                          style: const TextStyle(
                              fontSize: 10, color: _C.textSec)),
                    const SizedBox(height: 3),
                    if (product.freeShipping)
                      const Text('Frete grátis',
                          style: TextStyle(
                              fontSize: 10,
                              color: _C.green,
                              fontWeight: FontWeight.w600)),
                    // Credit line indicator on product cards
                    if (user.creditLineAvailable >= product.price)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: _C.mpBlue,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: const Text('MP',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 6,
                                      fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(width: 3),
                            const Flexible(
                              child: Text('Linha de Crédito',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: _C.mpBlue,
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),
                    // Rating
                    Row(
                      children: [
                        ...List.generate(
                            5,
                            (i) => Icon(
                                  Icons.star,
                                  size: 10,
                                  color: i < product.rating.floor()
                                      ? _C.blue
                                      : const Color(0xFFDDDDDD),
                                )),
                        const SizedBox(width: 3),
                        Text('${product.reviewCount}',
                            style: const TextStyle(
                                fontSize: 9, color: _C.textSec)),
                      ],
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

// ═════════════════════════════════════════════════════════
// PRODUCT DETAIL — with credit line pre-approval
// ═════════════════════════════════════════════════════════
class _ProductDetail extends ConsumerWidget {
  final Product product;
  const _ProductDetail({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = MockData.user;
    return Scaffold(
      body: Column(
        children: [
          // Yellow header bar
          Container(
            color: _C.yellow,
            padding: const EdgeInsets.fromLTRB(4, 36, 12, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 22),
                  onPressed: () => Navigator.pop(context),
                  color: _C.text,
                ),
                const Expanded(child: _SearchBar()),
                const SizedBox(width: 8),
                const Icon(Icons.favorite_border,
                    size: 22, color: _C.text),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Image
                Container(
                  color: _C.card,
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    placeholder: (_, __) =>
                        Container(color: Colors.grey[50], height: 220),
                  ),
                ),
                // Product info
                Container(
                  color: _C.card,
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Novo  |  +${product.reviewCount} vendidos',
                        style: const TextStyle(
                            fontSize: 11, color: _C.textSec),
                      ),
                      const SizedBox(height: 4),
                      Text(product.name,
                          style: const TextStyle(
                              fontSize: 14,
                              color: _C.text,
                              height: 1.3)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (i) => Icon(
                              Icons.star,
                              size: 12,
                              color: i < product.rating.floor()
                                  ? _C.blue
                                  : const Color(0xFFDDDDDD),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                              '${product.rating} (${product.reviewCount})',
                              style: const TextStyle(
                                  fontSize: 11, color: _C.textSec)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (product.originalPrice != null)
                        Text(
                            CurrencyFormat.format(
                                product.originalPrice!),
                            style: const TextStyle(
                                fontSize: 13,
                                decoration:
                                    TextDecoration.lineThrough,
                                color: _C.textSec)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(CurrencyFormat.format(product.price),
                              style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w300)),
                          if (product.discountPercent > 0) ...[
                            const SizedBox(width: 6),
                            Text(
                                '${product.discountPercent}% OFF',
                                style: const TextStyle(
                                    color: _C.green,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ],
                      ),
                      if (product.maxInstallments > 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              'em até ${product.maxInstallments}x ${CurrencyFormat.format(product.installmentPrice)} sem juros',
                              style: const TextStyle(
                                  fontSize: 12, color: _C.textSec)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                // ╔════════════════════════════════════════════╗
                // ║ CREDIT LINE — Product Detail indicator     ║
                // ╚════════════════════════════════════════════╝
                if (user.creditLineAvailable >= product.price)
                  Container(
                    color: _C.card,
                    padding: const EdgeInsets.all(14),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _C.mpLightBlue,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: _C.mpBlue.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: _C.mpBlue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('MP',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                    'Compre com Linha de Crédito',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: _C.mpBlue)),
                                Text(
                                  '${CurrencyFormat.format(user.creditLineAvailable)} disponível \u2022 Até ${user.creditLineMaxInstallments}x',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: _C.textSec),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right,
                              size: 18, color: _C.mpBlue),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
                // Shipping card
                Container(
                  color: _C.card,
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.freeShipping)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _C.greenLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_shipping,
                                  size: 14, color: _C.green),
                              const SizedBox(width: 4),
                              Text(
                                  'Frete grátis — chegará ${product.deliveryDate ?? "em breve"}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: _C.green,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Icon(Icons.store,
                              size: 14, color: _C.textSec),
                          SizedBox(width: 6),
                          Text('Vendido por ',
                              style: TextStyle(
                                  fontSize: 12, color: _C.textSec)),
                          Text('Magalu',
                              style: TextStyle(
                                  fontSize: 12, color: _C.blue)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Reputation bar
                      Row(
                        children: [
                          const Text('Reputação: ',
                              style: TextStyle(
                                  fontSize: 11, color: _C.textSec)),
                          ...List.generate(
                            5,
                            (i) => Container(
                              width: 20,
                              height: 6,
                              margin:
                                  const EdgeInsets.only(right: 2),
                              decoration: BoxDecoration(
                                color: i < 4
                                    ? _C.green
                                    : const Color(0xFFDDDDDD),
                                borderRadius:
                                    BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Ótima',
                              style: TextStyle(
                                  fontSize: 11, color: _C.green)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                // Compra Garantida
                Container(
                  color: _C.card,
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _C.lightBlue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.verified_user,
                            size: 18, color: _C.blue),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text('Compra Garantida',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _C.blue)),
                            Text(
                                'Receba o produto ou devolvemos seu dinheiro',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: _C.textSec)),
                          ],
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
      bottomSheet: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        color: _C.card,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).addItem(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          const Text('Agregado ao carrinho'),
                      backgroundColor: _C.blue,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: _C.blue,
                  side: const BorderSide(color: _C.blue),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Adicionar',
                    style: TextStyle(fontSize: 13)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(cartProvider.notifier)
                      .addItem(product);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const _Cart()));
                },
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
      body: Column(
        children: [
          Container(
            color: _C.yellow,
            padding: const EdgeInsets.fromLTRB(4, 36, 12, 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      size: 22, color: _C.text),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text('Carrinho',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _C.text)),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 48, color: _C.textSec),
                        SizedBox(height: 8),
                        Text('Seu carrinho está vazio',
                            style: TextStyle(
                                fontSize: 14, color: _C.textSec)),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.only(top: 8),
                    children: [
                      ...items.map((item) => _CartItemCard(
                            item: item,
                            onRemove: () => ref
                                .read(cartProvider.notifier)
                                .removeItem(item.product.id),
                            onQty: (q) => ref
                                .read(cartProvider.notifier)
                                .updateQuantity(
                                    item.product.id, q),
                          )),
                      Container(
                        color: _C.card,
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            _SumRow('Produtos',
                                CurrencyFormat.format(total)),
                            const _SumRow('Frete', 'Grátis',
                                color: _C.green),
                            const Divider(height: 16),
                            _SumRow('Total',
                                CurrencyFormat.format(total),
                                bold: true),
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
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const _Checkout())),
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
  const _CartItemCard(
      {required this.item,
      required this.onRemove,
      required this.onQty});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _C.card,
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: item.product.imageUrl,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
                color: Colors.grey[100], width: 64, height: 64),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(CurrencyFormat.format(item.product.price),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _QtyBtn(Icons.remove, () =>
                        item.quantity > 1
                            ? onQty(item.quantity - 1)
                            : onRemove()),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10),
                      child: Text('${item.quantity}',
                          style: const TextStyle(fontSize: 14)),
                    ),
                    _QtyBtn(Icons.add,
                        () => onQty(item.quantity + 1)),
                    const Spacer(),
                    GestureDetector(
                      onTap: onRemove,
                      child: const Text('Excluir',
                          style: TextStyle(
                              color: _C.blue, fontSize: 12)),
                    ),
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
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: _C.blue),
        ),
        child: Icon(icon, size: 14, color: _C.blue),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════
// CHECKOUT (with step indicator + MercadoPago credit)
// ═════════════════════════════════════════════════════════
class _Checkout extends ConsumerStatefulWidget {
  const _Checkout();
  @override
  ConsumerState<_Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends ConsumerState<_Checkout> {
  int _step = 0; // 0=address, 1=payment, 2=confirm
  String _paymentMethod = 'creditLine';

  @override
  Widget build(BuildContext context) {
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
                  icon: const Icon(Icons.arrow_back,
                      size: 22, color: _C.text),
                  onPressed: () => _step > 0
                      ? setState(() => _step--)
                      : Navigator.pop(context),
                ),
                const Text('Checkout',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _C.text)),
              ],
            ),
          ),
          // Step indicator
          Container(
            color: _C.card,
            padding: const EdgeInsets.symmetric(
                vertical: 12, horizontal: 24),
            child: Row(
              children: [
                _StepDot(0, _step, 'Endereço'),
                Expanded(
                    child: Container(
                        height: 2,
                        color: _step > 0
                            ? _C.blue
                            : const Color(0xFFDDDDDD))),
                _StepDot(1, _step, 'Pagamento'),
                Expanded(
                    child: Container(
                        height: 2,
                        color: _step > 1
                            ? _C.blue
                            : const Color(0xFFDDDDDD))),
                _StepDot(2, _step, 'Confirmação'),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8),
              children: [
                if (_step == 0) _buildAddressStep(),
                if (_step == 1)
                  _buildPaymentStep(total),
                if (_step == 2)
                  _buildConfirmStep(items, total),
                const SizedBox(height: 60),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            color: _C.card,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_step < 2) {
                    setState(() => _step++);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const _Success()));
                  }
                },
                child:
                    Text(_step == 2 ? 'Pagar' : 'Continuar'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressStep() {
    return Container(
      color: _C.card,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Endereço de entrega',
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: _C.blue),
              borderRadius: BorderRadius.circular(6),
              color: _C.lightBlue,
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle,
                    color: _C.blue, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text('Manoel - CEP 01310-100',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                      Text(
                          'Av. Paulista, 1000 — São Paulo, SP',
                          style: TextStyle(
                              fontSize: 11,
                              color: _C.textSec)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.local_shipping,
                  size: 14, color: _C.green),
              const SizedBox(width: 4),
              Text(
                  'Chegará grátis ${MockData.products.first.deliveryDate ?? "em breve"}',
                  style: const TextStyle(
                      fontSize: 12,
                      color: _C.green,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStep(double total) {
    final user = MockData.user;
    return Container(
      color: _C.card,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MercadoPago branding
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: _C.mpBlue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('MP',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 6),
              const Text('Pagar com Mercado Pago',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
            ],
          ),
          const SizedBox(height: 14),
          // Credit Line (featured)
          _PayOption(
            icon: Icons.account_balance_wallet,
            label: 'Linha de Crédito',
            subtitle:
                '${CurrencyFormat.format(user.creditLineAvailable)} \u2022 até ${user.creditLineMaxInstallments}x',
            value: 'creditLine',
            selected: _paymentMethod,
            onTap: () =>
                setState(() => _paymentMethod = 'creditLine'),
            featured: true,
          ),
          // MercadoPago Balance
          _PayOption(
            icon: Icons.account_balance,
            label: 'Saldo Mercado Pago',
            subtitle: CurrencyFormat.format(
                user.mercadoPagoBalance),
            value: 'mpBalance',
            selected: _paymentMethod,
            onTap: () =>
                setState(() => _paymentMethod = 'mpBalance'),
          ),
          _PayOption(
            icon: Icons.credit_card,
            label: 'Cartão de crédito',
            subtitle: 'até 12x sem juros',
            value: 'creditCard',
            selected: _paymentMethod,
            onTap: () =>
                setState(() => _paymentMethod = 'creditCard'),
          ),
          _PayOption(
            icon: Icons.pix,
            label: 'Pix',
            subtitle: 'Aprovação imediata',
            value: 'pix',
            selected: _paymentMethod,
            onTap: () =>
                setState(() => _paymentMethod = 'pix'),
          ),
          _PayOption(
            icon: Icons.receipt_long,
            label: 'Boleto',
            subtitle: 'Vence em 3 dias',
            value: 'boleto',
            selected: _paymentMethod,
            onTap: () =>
                setState(() => _paymentMethod = 'boleto'),
          ),
          // Meli Dólar
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on,
                    size: 16, color: _C.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Você tem ${user.meliDolarBalance.toStringAsFixed(2)} Meli Dólares para usar nessa compra',
                    style: const TextStyle(
                        fontSize: 11, color: _C.orange),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmStep(
      List<CartItem> items, double total) {
    return Column(
      children: [
        Container(
          color: _C.card,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Resumo da compra',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
              const SizedBox(height: 10),
              ...items.map((item) => Padding(
                    padding:
                        const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: item.product.imageUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                              '${item.quantity}x ${item.product.name}',
                              style: const TextStyle(
                                  fontSize: 12),
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis),
                        ),
                        Text(
                            CurrencyFormat.format(
                                item.total),
                            style: const TextStyle(
                                fontSize: 12)),
                      ],
                    ),
                  )),
              const Divider(height: 16),
              _SumRow(
                  'Total', CurrencyFormat.format(total),
                  bold: true),
              const SizedBox(height: 8),
              // Show selected payment method
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _C.lightBlue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle,
                        size: 16, color: _C.blue),
                    const SizedBox(width: 8),
                    Text(
                      _payMethodLabel(),
                      style: const TextStyle(
                          fontSize: 12,
                          color: _C.blue,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _payMethodLabel() {
    switch (_paymentMethod) {
      case 'creditLine':
        return 'Linha de Crédito Mercado Pago';
      case 'mpBalance':
        return 'Saldo Mercado Pago';
      case 'creditCard':
        return 'Cartão de crédito';
      case 'pix':
        return 'Pix';
      case 'boleto':
        return 'Boleto';
      default:
        return _paymentMethod;
    }
  }
}

class _StepDot extends StatelessWidget {
  final int step;
  final int current;
  final String label;
  const _StepDot(this.step, this.current, this.label);
  @override
  Widget build(BuildContext context) {
    final active = step <= current;
    return Column(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color:
                active ? _C.blue : const Color(0xFFDDDDDD),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: active && step < current
                ? const Icon(Icons.check,
                    size: 12, color: Colors.white)
                : Text('${step + 1}',
                    style: TextStyle(
                        color: active
                            ? Colors.white
                            : _C.textSec,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 3),
        Text(label,
            style: TextStyle(
                fontSize: 9,
                color: active ? _C.blue : _C.textSec,
                fontWeight: active
                    ? FontWeight.w600
                    : FontWeight.normal)),
      ],
    );
  }
}

class _PayOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final String value;
  final String selected;
  final VoidCallback onTap;
  final bool featured;
  const _PayOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.selected,
    required this.onTap,
    this.featured = false,
  });
  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected
                  ? _C.blue
                  : featured
                      ? _C.mpBlue.withOpacity(0.5)
                      : const Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(6),
          color: isSelected
              ? _C.lightBlue
              : featured
                  ? _C.mpLightBlue
                  : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 20,
                color: isSelected
                    ? _C.blue
                    : featured
                        ? _C.mpBlue
                        : _C.textSec),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(label,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: featured
                                  ? FontWeight.w600
                                  : FontWeight.normal)),
                      if (featured) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 1),
                          decoration: BoxDecoration(
                            color: _C.mpBlue,
                            borderRadius:
                                BorderRadius.circular(3),
                          ),
                          child: const Text('Novo',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight:
                                      FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 11,
                          color: _C.textSec)),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              size: 18,
              color: isSelected ? _C.blue : _C.textSec,
            ),
          ],
        ),
      ),
    );
  }
}

class _SumRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool bold;
  const _SumRow(this.label, this.value,
      {this.color, this.bold = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: bold ? 15 : 13,
                  fontWeight: bold
                      ? FontWeight.bold
                      : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontSize: bold ? 16 : 13,
                  fontWeight: bold
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: color)),
        ],
      ),
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
    final orderNum =
        (Random().nextInt(900000) + 100000).toString();

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
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: _C.greenLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle,
                      color: _C.green, size: 48),
                ),
                const SizedBox(height: 16),
                const Text('Pronto!',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: _C.text)),
                const SizedBox(height: 4),
                const Text('Compra aprovada',
                    style: TextStyle(
                        fontSize: 14, color: _C.textSec)),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _C.bg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      _InfoRow('Pedido #', orderNum),
                      const SizedBox(height: 6),
                      _InfoRow(
                          'Total',
                          CurrencyFormat.format(total)),
                      const SizedBox(height: 6),
                      const _InfoRow(
                          'Entrega', '20-22 de fev'),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // Compra Garantida badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _C.lightBlue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_user,
                          size: 16, color: _C.blue),
                      SizedBox(width: 6),
                      Text('Compra Garantida',
                          style: TextStyle(
                              color: _C.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref
                          .read(cartProvider.notifier)
                          .clear();
                      Navigator.of(context)
                          .popUntil((r) => r.isFirst);
                    },
                    child: const Text('Voltar ao início'),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                      'Acompanhar pedido',
                      style: TextStyle(
                          color: _C.blue, fontSize: 13)),
                ),
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
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: _C.textSec)),
        Text(value,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}
