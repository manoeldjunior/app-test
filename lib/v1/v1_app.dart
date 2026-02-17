// ═══════════════════════════════════════════════════════════
// V1 — Magalu Atual (with Carnê Digital / CDC Credit Funnel)
// ═══════════════════════════════════════════════════════════
// Blue Magalu experience with pre-approved credit/CDC
// indicators at the top of funnel (Home + Product Detail).
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/models.dart';
import '../data/mock_data.dart';
import '../providers/providers.dart';
import '../utils/currency_format.dart';

// ─── Colors ──────────────────────────────────────────────
class _C {
  static const blue = Color(0xFF0086FF);
  static const bg = Color(0xFFF0F0F0);
  static const card = Colors.white;
  static const border = Color(0xFFDDDDDD);
  static const green = Color(0xFF00A650);
  static const orange = Color(0xFFFF6F00);
  static const orangeLight = Color(0xFFFFF3E0);
  static const text = Color(0xFF333333);
  static const textSec = Color(0xFF777777);
}

// ─── Entry Point ─────────────────────────────────────────
class V1App extends StatelessWidget {
  const V1App({super.key});

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
            backgroundColor: _C.blue,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ),
        home: const _Home(),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════
// HOME SCREEN — Top of Funnel with Credit Indicators
// ═════════════════════════════════════════════════════════
class _Home extends ConsumerWidget {
  const _Home();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartItemCountProvider);
    final user = MockData.user;
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
                  MaterialPageRoute(builder: (_) => const _Cart()),
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
            color: _C.blue,
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
                  Icon(Icons.search, color: _C.textSec, size: 18),
                  SizedBox(width: 8),
                  Text('Busca no Magalu',
                      style: TextStyle(color: _C.textSec, fontSize: 13)),
                ],
              ),
            ),
          ),

          // ╔══════════════════════════════════════════════
          // ║ TOP-OF-FUNNEL: Pre-Approved Credit Banner
          // ╚══════════════════════════════════════════════
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0086FF), Color(0xFF0060CC)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.verified, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Crédito pré-aprovado',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          Text('Carnê Digital MagaluPay',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white70),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.account_balance_wallet, color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Limite disponível: ${CurrencyFormat.format(user.carneDigitalAvailable)}',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // MagaluPay Balance Mini Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _C.card,
              border: Border.all(color: _C.border),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _C.orangeLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.account_balance_wallet, color: _C.orange, size: 16),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Saldo MagaluPay',
                        style: TextStyle(fontSize: 11, color: _C.textSec)),
                    Text(CurrencyFormat.format(user.magaluPayBalance),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    _MiniAction(Icons.pix, 'Pix'),
                    const SizedBox(width: 12),
                    _MiniAction(Icons.receipt_long, 'Carnê'),
                    const SizedBox(width: 12),
                    _MiniAction(Icons.swap_horiz, 'Transferir'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Category chips
          Container(
            color: _C.card,
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              children: ['Ofertas', 'Celulares', 'Informática', 'TVs', 'Áudio', 'Games', 'Eletro']
                  .map((c) => _Chip(c))
                  .toList(),
            ),
          ),
          const Divider(height: 1, color: _C.border),
          // Offers banner
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _C.blue,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              children: [
                Icon(Icons.local_fire_department, color: Colors.white, size: 18),
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
        selectedItemColor: _C.blue,
        unselectedItemColor: _C.textSec,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 22), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.search, size: 22), label: 'Buscar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart, size: 22), label: 'Carrinho'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet, size: 22), label: 'MagaluPay'),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 22), label: 'Conta'),
        ],
      ),
    );
  }
}

class _MiniAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MiniAction(this.icon, this.label);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: _C.blue),
        Text(label, style: const TextStyle(fontSize: 8, color: _C.textSec)),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: _C.blue),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(label,
          style: const TextStyle(color: _C.blue, fontSize: 11)),
    );
  }
}

class _ProductTile extends ConsumerWidget {
  final Product product;
  const _ProductTile({required this.product});

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
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _C.card,
          border: Border.all(color: _C.border),
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
                      style: const TextStyle(fontSize: 12, color: _C.text),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  if (product.originalPrice != null)
                    Text(CurrencyFormat.format(product.originalPrice!),
                        style: const TextStyle(
                            fontSize: 10,
                            decoration: TextDecoration.lineThrough,
                            color: _C.textSec)),
                  Text(CurrencyFormat.format(product.price),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  if (product.maxInstallments > 1)
                    Text(
                        '${product.maxInstallments}x de ${CurrencyFormat.format(product.installmentPrice)}',
                        style:
                            const TextStyle(fontSize: 10, color: _C.textSec)),
                  // CDC credit indicator on product tiles
                  if (product.price <= user.carneDigitalAvailable)
                    Container(
                      margin: const EdgeInsets.only(top: 3),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _C.orangeLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.receipt_long, size: 10, color: _C.orange),
                          const SizedBox(width: 3),
                          Text(
                            'Carnê Digital até ${product.maxInstallments}x',
                            style: const TextStyle(fontSize: 9, color: _C.orange, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  if (product.freeShipping)
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text('Frete grátis',
                          style: TextStyle(fontSize: 10, color: _C.green)),
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
// PRODUCT DETAIL — Credit indicators at Top of Funnel
// ═════════════════════════════════════════════════════════
class _ProductDetail extends ConsumerWidget {
  final Product product;
  const _ProductDetail({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = MockData.user;
    final canUseCDC = product.price <= user.carneDigitalAvailable;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        title: Text(product.brand,
            style: const TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Product image
          CachedNetworkImage(
            imageUrl: product.imageUrl,
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (_, __) =>
                Container(color: Colors.grey[200], height: 220),
          ),
          Container(
            color: _C.card,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.isNew)
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _C.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('NOVO',
                        style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                Text(product.name,
                    style: const TextStyle(
                        fontSize: 14, color: _C.text, height: 1.3)),
                const SizedBox(height: 4),
                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 2),
                    Text('${product.rating}',
                        style: const TextStyle(fontSize: 12)),
                    Text(' (${product.reviewCount})',
                        style:
                            const TextStyle(fontSize: 11, color: _C.textSec)),
                  ],
                ),
                const Divider(height: 16),
                // Price
                if (product.originalPrice != null)
                  Text('De ${CurrencyFormat.format(product.originalPrice!)}',
                      style: const TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          color: _C.textSec)),
                Row(
                  children: [
                    Text(CurrencyFormat.format(product.price),
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    if (product.discountPercent > 0) ...[
                      const SizedBox(width: 8),
                      Text('${product.discountPercent}% OFF',
                          style: const TextStyle(
                              color: _C.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ],
                  ],
                ),
                if (product.maxInstallments > 1)
                  Text(
                      'em até ${product.maxInstallments}x de ${CurrencyFormat.format(product.installmentPrice)} sem juros',
                      style:
                          const TextStyle(fontSize: 12, color: _C.textSec)),
              ],
            ),
          ),

          // ╔══════════════════════════════════════════════
          // ║ CDC / CARNÊ DIGITAL Credit Card (Product Detail)
          // ╚══════════════════════════════════════════════
          if (canUseCDC)
            Container(
              margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
              color: _C.card,
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _C.orange.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: _C.orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.receipt_long, color: _C.orange, size: 16),
                        ),
                        const SizedBox(width: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Carnê Digital MagaluPay',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: _C.text)),
                            Text('Crédito pré-aprovado',
                                style: TextStyle(fontSize: 10, color: _C.textSec)),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _C.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('Aprovado',
                              style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Limite disponível',
                                style: TextStyle(fontSize: 10, color: _C.textSec)),
                            Text(CurrencyFormat.format(user.carneDigitalAvailable),
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _C.orange)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Parcele em até',
                                style: TextStyle(fontSize: 10, color: _C.textSec)),
                            Text('${product.maxInstallments}x de ${CurrencyFormat.format(product.installmentPrice)}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _C.text)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          Container(
            color: _C.card,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.freeShipping)
                  Row(
                    children: [
                      const Icon(Icons.local_shipping,
                          size: 14, color: _C.green),
                      const SizedBox(width: 4),
                      Text(
                          'Frete grátis — chegará ${product.deliveryDate ?? "em breve"}',
                          style:
                              const TextStyle(fontSize: 12, color: _C.green)),
                    ],
                  ),
                const Divider(height: 20),
                const Text('Descrição',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: _C.text)),
                const SizedBox(height: 4),
                Text(product.description,
                    style: const TextStyle(
                        fontSize: 12, color: _C.textSec, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _C.card,
          border: const Border(top: BorderSide(color: _C.border)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Carnê CTA at bottom
            if (canUseCDC)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long, size: 12, color: _C.orange),
                    const SizedBox(width: 4),
                    Text(
                      'Parcele no Carnê Digital em até ${product.maxInstallments}x',
                      style: const TextStyle(fontSize: 10, color: _C.orange, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(cartProvider.notifier).addItem(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Adicionado ao carrinho')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _C.blue,
                      side: const BorderSide(color: _C.blue),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Adicionar', style: TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(cartProvider.notifier).addItem(product);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const _Cart()),
                      );
                    },
                    child:
                        const Text('Comprar agora', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
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
    final user = MockData.user;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        title: const Text('Carrinho', style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: items.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 48, color: _C.textSec),
                  SizedBox(height: 8),
                  Text('Carrinho vazio',
                      style: TextStyle(color: _C.textSec, fontSize: 14)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      // CDC status banner in cart
                      if (total <= user.carneDigitalAvailable)
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _C.orangeLight,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: _C.orange.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, size: 16, color: _C.orange),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Você pode parcelar no Carnê Digital! Limite: ${CurrencyFormat.format(user.carneDigitalAvailable)}',
                                  style: const TextStyle(fontSize: 11, color: _C.orange, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ...items
                          .map((item) => _CartItemW(
                                item: item,
                                onRemove: () => ref
                                    .read(cartProvider.notifier)
                                    .removeItem(item.product.id),
                                onQty: (q) => ref
                                    .read(cartProvider.notifier)
                                    .updateQuantity(item.product.id, q),
                              ))
                          .toList(),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _C.card,
                    border: const Border(top: BorderSide(color: _C.border)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(CurrencyFormat.format(total),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const _Checkout()),
                          ),
                          child: const Text('Finalizar compra'),
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

class _CartItemW extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final ValueChanged<int> onQty;
  const _CartItemW(
      {required this.item, required this.onRemove, required this.onQty});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _C.card,
        border: Border.all(color: _C.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: item.product.imageUrl,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(CurrencyFormat.format(item.product.price),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () =>
                    item.quantity > 1 ? onQty(item.quantity - 1) : onRemove(),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    border: Border.all(color: _C.border),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    item.quantity > 1 ? Icons.remove : Icons.delete_outline,
                    size: 14,
                    color: item.quantity > 1 ? _C.text : Colors.red,
                  ),
                ),
              ),
              SizedBox(
                width: 28,
                child: Text('${item.quantity}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13)),
              ),
              InkWell(
                onTap: () => onQty(item.quantity + 1),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    border: Border.all(color: _C.border),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child:
                      const Icon(Icons.add, size: 14, color: _C.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════
// CHECKOUT — with CDC / Carnê Digital payment option
// ═════════════════════════════════════════════════════════
class _Checkout extends ConsumerStatefulWidget {
  const _Checkout();
  @override
  ConsumerState<_Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends ConsumerState<_Checkout> {
  String _paymentMethod = 'carneDigital';

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);
    final user = MockData.user;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        title: const Text('Finalizar compra', style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Items summary
          Container(
            color: _C.card,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Itens do pedido',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                ...items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantity}x ${item.product.name}',
                              style: const TextStyle(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(CurrencyFormat.format(item.total),
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 1),
          // Shipping
          Container(
            color: _C.card,
            padding: const EdgeInsets.all(12),
            child: const Row(
              children: [
                Icon(Icons.local_shipping, size: 16, color: _C.green),
                SizedBox(width: 6),
                Text('Frete Grátis — até 22 de fev',
                    style: TextStyle(fontSize: 12, color: _C.green)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Payment
          Container(
            color: _C.card,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Forma de pagamento',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                // Carnê Digital first (promoted)
                _PayRadio(
                  label: 'Carnê Digital MagaluPay',
                  subtitle: 'Limite: ${CurrencyFormat.format(user.carneDigitalAvailable)} — até 12x',
                  value: 'carneDigital',
                  groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v),
                  highlight: true,
                ),
                _PayRadio(
                  label: 'Saldo MagaluPay',
                  subtitle: 'Disponível: ${CurrencyFormat.format(user.magaluPayBalance)}',
                  value: 'magaluPay',
                  groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v),
                ),
                _PayRadio(
                  label: 'Cartão de Crédito',
                  subtitle: 'Visa •••• 4321',
                  value: 'creditCard',
                  groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v),
                ),
                _PayRadio(
                  label: 'Pix',
                  subtitle: 'Aprovação imediata',
                  value: 'pix',
                  groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v),
                ),
                _PayRadio(
                  label: 'Boleto Bancário',
                  subtitle: 'Vence em 3 dias úteis',
                  value: 'boleto',
                  groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Total
          Container(
            color: _C.card,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _SumRow('Subtotal', CurrencyFormat.format(total)),
                const _SumRow('Frete', 'Grátis', color: _C.green),
                const Divider(height: 12),
                _SumRow('Total', CurrencyFormat.format(total), bold: true),
                if (_paymentMethod == 'carneDigital')
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _C.orangeLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.receipt_long, size: 14, color: _C.orange),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Carnê Digital: 12x de ${CurrencyFormat.format(total / 12)}',
                              style: const TextStyle(fontSize: 11, color: _C.orange, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _C.card,
          border: const Border(top: BorderSide(color: _C.border)),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _Success()),
            ),
            child:
                const Text('Confirmar pedido', style: TextStyle(fontSize: 14)),
          ),
        ),
      ),
    );
  }
}

class _PayRadio extends StatelessWidget {
  final String label;
  final String subtitle;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final bool highlight;
  const _PayRadio({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.highlight = false,
  });
  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: highlight
            ? BoxDecoration(
                color: isSelected ? _C.orangeLight : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: isSelected ? _C.orange : Colors.transparent),
              )
            : null,
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: (v) => onChanged(v!),
              activeColor: highlight ? _C.orange : _C.blue,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: highlight ? FontWeight.w600 : FontWeight.normal)),
                  Text(subtitle,
                      style:
                          const TextStyle(fontSize: 11, color: _C.textSec)),
                ],
              ),
            ),
            if (highlight && isSelected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _C.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Recomendado',
                    style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
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
  const _SumRow(this.label, this.value, {this.color, this.bold = false});
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
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                  color: _C.text)),
          Text(value,
              style: TextStyle(
                  fontSize: bold ? 16 : 13,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                  color: color ?? _C.text)),
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
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _C.green.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: _C.green, size: 36),
              ),
              const SizedBox(height: 16),
              const Text('Pedido realizado!',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _C.text)),
              const SizedBox(height: 6),
              const Text('Seu pedido foi confirmado com sucesso.',
                  style: TextStyle(fontSize: 13, color: _C.textSec),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(cartProvider.notifier).clear();
                    ref.read(paymentProvider.notifier).reset();
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  child:
                      const Text('Voltar ao início', style: TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
