// ═══════════════════════════════════════════════════════════
// V1 — Magalu Atual (Entry Point + Home Screen)
// ═══════════════════════════════════════════════════════════
// Blue Magalu experience with CDC credit funnel awareness.
// All sub-screens are now in separate files.
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/models.dart';
import '../data/mock_data.dart';
import '../providers/providers.dart';
import '../utils/currency_format.dart';
import 'v1_colors.dart';
import 'v1_widgets.dart';
import 'v1_product_detail.dart';
import 'v1_cart.dart';

// ─── Entry Point ─────────────────────────────────────────
class V1App extends StatelessWidget {
  const V1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          primaryColor: V1Colors.blue,
          scaffoldBackgroundColor: V1Colors.bg,
          appBarTheme: const AppBarTheme(
            backgroundColor: V1Colors.blue,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: V1Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ),
        home: const _Home(),
      );
  }
}

// ═════════════════════════════════════════════════════════
// HOME SCREEN — Phase A: Discovery / Top of Funnel
// ═════════════════════════════════════════════════════════
class _Home extends ConsumerWidget {
  const _Home();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartItemCountProvider);
    final user = MockData.user;
    final cdcState = ref.watch(cdcUserStateProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48,
        leading: const Icon(Icons.menu, size: 22),
        title: const Text('Magalu',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 22),
            onPressed: () {},
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, size: 22),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const V1Cart()),
                ),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: Text('$cartCount',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 9)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Search bar
              Container(
                color: V1Colors.blue,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: V1Colors.textSec, size: 18),
                      SizedBox(width: 8),
                      Text('Busca no Magalu',
                          style: TextStyle(color: V1Colors.textSec, fontSize: 13)),
                    ],
                  ),
                ),
              ),

              // ╔══════════════════════════════════════════════
              // ║ TOP-OF-FUNNEL: CDC Credit Banner (state-aware)
              // ╚══════════════════════════════════════════════
              V1CreditBanner(
                userState: cdcState,
                availableLimit: user.carneDigitalAvailable,
                usedLimit: user.carneDigitalUsed,
                totalLimit: user.carneDigitalLimit,
              ),

              // MagaluPay Balance Mini Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: V1Colors.card,
                  border: Border.all(color: V1Colors.border),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: V1Colors.orangeLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.account_balance_wallet,
                          color: V1Colors.orange, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Saldo MagaluPay',
                            style:
                                TextStyle(fontSize: 11, color: V1Colors.textSec)),
                        Text(CurrencyFormat.format(user.magaluPayBalance),
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Spacer(),
                    const Row(
                      children: [
                        V1MiniAction(Icons.pix, 'Pix'),
                        SizedBox(width: 12),
                        V1MiniAction(Icons.receipt_long, 'Crédito'),
                        SizedBox(width: 12),
                        V1MiniAction(Icons.swap_horiz, 'Transferir'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // Category chips
              Container(
                color: V1Colors.card,
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  children: [
                    'Ofertas', 'Celulares', 'Informática', 'TVs', 'Áudio',
                    'Games', 'Eletro'
                  ].map((c) => V1Chip(c)).toList(),
                ),
              ),
              const Divider(height: 1, color: V1Colors.border),

              // Offers banner
              Container(
                margin: const EdgeInsets.all(8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: V1Colors.blue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text('Ofertas do dia — até 50% OFF',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ),
                  ],
                ),
              ),

              // Product list
              ...MockData.products.map((p) => _ProductTile(product: p)),
              const SizedBox(height: 60),
            ],
          ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: V1Colors.blue,
        unselectedItemColor: V1Colors.textSec,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 22), label: 'Início'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 22), label: 'Buscar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart, size: 22), label: 'Carrinho'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet, size: 22),
              label: 'MagaluPay'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 22), label: 'Conta'),
        ],
      ),
    );
  }
}

// ─── Product Tile (Home listing) ────────────────────────
class _ProductTile extends ConsumerWidget {
  final Product product;
  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = MockData.user;
    final cdcState = ref.watch(cdcUserStateProvider);
    final canShowCDC = cdcState != CdcUserState.naoLogado &&
        product.price <= user.carneDigitalAvailable;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => V1ProductDetail(product: product)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: V1Colors.card,
          border: Border.all(color: V1Colors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: product.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(color: Colors.grey[200], width: 72, height: 72),
              errorWidget: (_, __, ___) =>
                  Container(color: Colors.grey[200], width: 72, height: 72),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style:
                          const TextStyle(fontSize: 12, color: V1Colors.text),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  if (product.originalPrice != null)
                    Text(CurrencyFormat.format(product.originalPrice!),
                        style: const TextStyle(
                            fontSize: 10,
                            decoration: TextDecoration.lineThrough,
                            color: V1Colors.textSec)),
                  Text(CurrencyFormat.format(product.price),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  if (product.maxInstallments > 1)
                    Text(
                        '${product.maxInstallments}x de ${CurrencyFormat.format(product.installmentPrice)}',
                        style: const TextStyle(
                            fontSize: 10, color: V1Colors.textSec)),
                  // CDC credit indicator on product tiles
                  if (canShowCDC)
                    Container(
                      margin: const EdgeInsets.only(top: 3),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: V1Colors.orangeLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.receipt_long,
                              size: 10, color: V1Colors.orange),
                          const SizedBox(width: 3),
                          Text(
                            'Limite Magalu até ${product.maxInstallments}x',
                            style: const TextStyle(
                                fontSize: 9,
                                color: V1Colors.orange,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  if (product.freeShipping)
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text('Frete grátis',
                          style: TextStyle(
                              fontSize: 10, color: V1Colors.green)),
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
