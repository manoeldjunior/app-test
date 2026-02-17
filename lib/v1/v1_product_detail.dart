// ═══════════════════════════════════════════════════════════
// V1 — Product Detail Page (PDP) with CDC User State Variants
// ═══════════════════════════════════════════════════════════
// Per funnel_logic.md Phase B: Credit simulator widget above
// the fold, "Available Limit" pill next to price.
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/models.dart';
import '../data/mock_data.dart';
import '../providers/providers.dart';
import '../utils/currency_format.dart';
import 'v1_colors.dart';

import 'v1_cart.dart';

class V1ProductDetail extends ConsumerWidget {
  final Product product;
  const V1ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cdcState = ref.watch(cdcUserStateProvider);
    final user = MockData.user;
    final canUseCDC = cdcState != CdcUserState.naoLogado &&
        product.price <= user.carneDigitalAvailable;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        backgroundColor: V1Colors.blue,
        foregroundColor: Colors.white,
        title: Text(product.brand, style: const TextStyle(fontSize: 16)),
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

              // Product info card
              Container(
                color: V1Colors.card,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.isNew)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: V1Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('NOVO',
                            style:
                                TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    Text(product.name,
                        style: const TextStyle(
                            fontSize: 14, color: V1Colors.text, height: 1.3)),
                    const SizedBox(height: 4),
                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text('${product.rating}',
                            style: const TextStyle(fontSize: 12)),
                        Text(' (${product.reviewCount})',
                            style: const TextStyle(
                                fontSize: 11, color: V1Colors.textSec)),
                      ],
                    ),
                    const Divider(height: 16),
                    // Price
                    if (product.originalPrice != null)
                      Text(
                          'De ${CurrencyFormat.format(product.originalPrice!)}',
                          style: const TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color: V1Colors.textSec)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(CurrencyFormat.format(product.price),
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        if (product.discountPercent > 0) ...[
                          const SizedBox(width: 8),
                          Text('${product.discountPercent}% OFF',
                              style: const TextStyle(
                                  color: V1Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                        // Phase B: "Available Limit" pill next to price
                        if (canUseCDC) ...[
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: V1Colors.orangeLight,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: V1Colors.orange.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.receipt_long,
                                    size: 10, color: V1Colors.orange),
                                const SizedBox(width: 3),
                                Text(
                                  cdcState == CdcUserState.ativo
                                      ? 'Ativo'
                                      : 'Pré-aprovado',
                                  style: const TextStyle(
                                      fontSize: 9,
                                      color: V1Colors.orange,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (product.maxInstallments > 1)
                      Text(
                          'em até ${product.maxInstallments}x de ${CurrencyFormat.format(product.installmentPrice)} sem juros',
                          style: const TextStyle(
                              fontSize: 12, color: V1Colors.textSec)),
                    // Phase B: CDC installment line (green, like ML benchmark)
                    if (canUseCDC)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'ou parcele sem cartão em até ${product.maxInstallments}x',
                          style: const TextStyle(
                              fontSize: 12,
                              color: V1Colors.green,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                  ],
                ),
              ),

              // ── CDC Credit Card Section ──
              if (canUseCDC) _buildCdcCard(cdcState, user),

              // Shipping & Description
              Container(
                color: V1Colors.card,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.freeShipping)
                      Row(
                        children: [
                          const Icon(Icons.local_shipping,
                              size: 14, color: V1Colors.green),
                          const SizedBox(width: 4),
                          Text(
                              'Frete grátis — chegará ${product.deliveryDate ?? "em breve"}',
                              style: const TextStyle(
                                  fontSize: 12, color: V1Colors.green)),
                        ],
                      ),
                    const Divider(height: 20),
                    const Text('Descrição',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: V1Colors.text)),
                    const SizedBox(height: 4),
                    Text(product.description,
                        style: const TextStyle(
                            fontSize: 12,
                            color: V1Colors.textSec,
                            height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(height: 90),
            ],
          ),
      bottomSheet: _buildBottomCta(context, ref, canUseCDC, cdcState),
    );
  }

  // ── CDC Credit Card ─────────────────────────────────────
  Widget _buildCdcCard(CdcUserState state, UserProfile user) {
    final isAtivo = state == CdcUserState.ativo;
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
      color: V1Colors.card,
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isAtivo
                ? [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)]
                : [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)],
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: (isAtivo ? V1Colors.green : V1Colors.orange).withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: (isAtivo ? V1Colors.green : V1Colors.orange)
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.receipt_long,
                      color: isAtivo ? V1Colors.green : V1Colors.orange,
                      size: 16),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Limite Magalu',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: V1Colors.text)),
                    Text(
                        isAtivo
                            ? 'Crédito ativo'
                            : 'Crédito pré-aprovado',
                        style: const TextStyle(
                            fontSize: 10, color: V1Colors.textSec)),
                  ],
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isAtivo ? V1Colors.green : V1Colors.orange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                      isAtivo ? 'Ativo' : 'Aprovado',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold)),
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
                        style:
                            TextStyle(fontSize: 10, color: V1Colors.textSec)),
                    Text(
                        CurrencyFormat.format(user.carneDigitalAvailable),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isAtivo
                                ? V1Colors.green
                                : V1Colors.orange)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Parcele em até',
                        style:
                            TextStyle(fontSize: 10, color: V1Colors.textSec)),
                    Text(
                        '${product.maxInstallments}x de ${CurrencyFormat.format(product.installmentPrice)}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: V1Colors.text)),
                  ],
                ),
              ],
            ),
            if (isAtivo) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: user.carneDigitalUsed / user.carneDigitalLimit,
                  minHeight: 4,
                  backgroundColor: V1Colors.green.withOpacity(0.2),
                  valueColor:
                      const AlwaysStoppedAnimation(V1Colors.green),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Usado: ${CurrencyFormat.format(user.carneDigitalUsed)} de ${CurrencyFormat.format(user.carneDigitalLimit)}',
                style: const TextStyle(fontSize: 9, color: V1Colors.textSec),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Bottom CTA Bar ──────────────────────────────────────
  Widget _buildBottomCta(
      BuildContext context, WidgetRef ref, bool canUseCDC, CdcUserState state) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: V1Colors.card,
        border: Border(top: BorderSide(color: V1Colors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canUseCDC)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long,
                      size: 12, color: V1Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    'Parcele no Limite Magalu em até ${product.maxInstallments}x',
                    style: const TextStyle(
                        fontSize: 10,
                        color: V1Colors.orange,
                        fontWeight: FontWeight.w600),
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
                      const SnackBar(
                          content: Text('Adicionado ao carrinho')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: V1Colors.blue,
                    side: const BorderSide(color: V1Colors.blue),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child:
                      const Text('Adicionar', style: TextStyle(fontSize: 13)),
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
                      MaterialPageRoute(
                          builder: (_) => const V1Cart()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: V1Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Comprar agora',
                      style: TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
