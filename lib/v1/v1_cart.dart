// ═══════════════════════════════════════════════════════════
// V1 — Sacola (Cart) with CDC awareness
// ═══════════════════════════════════════════════════════════
// Per funnel_logic.md Phase C: Reinforce the credit decision
// in the cart. Show savings pill when using Limite Magalu.
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/models.dart';
import '../data/mock_data.dart';
import '../providers/providers.dart';
import '../utils/currency_format.dart';
import 'v1_colors.dart';

import 'v1_formas_pagamento.dart';

class V1Cart extends ConsumerWidget {
  const V1Cart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);
    final user = MockData.user;
    final cdcState = ref.watch(cdcUserStateProvider);
    final canUseCDC = cdcState != CdcUserState.naoLogado &&
        total <= user.carneDigitalAvailable;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        backgroundColor: V1Colors.blue,
        foregroundColor: Colors.white,
        title: Text('Sacola (${items.length})', style: const TextStyle(fontSize: 16)),
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
                      size: 48, color: V1Colors.textSec),
                  SizedBox(height: 8),
                  Text('Sacola vazia',
                      style: TextStyle(color: V1Colors.textSec, fontSize: 14)),
                ],
              ),
            )
          : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          // CDC status banner
                          if (canUseCDC) _buildCdcBanner(cdcState, user, total),

                          // Não logado prompt
                          if (cdcState == CdcUserState.naoLogado)
                            Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: V1Colors.blue.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: V1Colors.blue.withOpacity(0.2)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      size: 16, color: V1Colors.blue),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Faça login para parcelar com seu Limite Magalu',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: V1Colors.blue,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Cart items
                          ...items.map((item) => _CartItemTile(
                                item: item,
                                onRemove: () => ref
                                    .read(cartProvider.notifier)
                                    .removeItem(item.product.id),
                                onQty: (q) => ref
                                    .read(cartProvider.notifier)
                                    .updateQuantity(item.product.id, q),
                              )),

                          // Shipping info
                          Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: V1Colors.card,
                              border: Border.all(color: V1Colors.border),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.local_shipping,
                                    size: 16, color: V1Colors.green),
                                SizedBox(width: 6),
                                Text('Frete Grátis — até 22 de fev',
                                    style: TextStyle(
                                        fontSize: 12, color: V1Colors.green)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                    // Bottom total bar
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: V1Colors.card,
                        border: Border(top: BorderSide(color: V1Colors.border)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(CurrencyFormat.format(total),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          if (canUseCDC)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'ou 12x de ${CurrencyFormat.format(total / 12)} no Limite Magalu',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: V1Colors.green,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const V1FormasPagamento()),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: V1Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('Continuar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildCdcBanner(
      CdcUserState state, UserProfile user, double cartTotal) {
    final isAtivo = state == CdcUserState.ativo;
    final remaining = user.carneDigitalAvailable - cartTotal;

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isAtivo
            ? const Color(0xFFE8F5E9)
            : V1Colors.orangeLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: (isAtivo ? V1Colors.green : V1Colors.orange)
                .withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle,
                  size: 16,
                  color: isAtivo ? V1Colors.green : V1Colors.orange),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isAtivo
                      ? 'Parcele com seu Limite Magalu ativo!'
                      : 'Você pode parcelar no Limite Magalu!',
                  style: TextStyle(
                      fontSize: 11,
                      color: isAtivo ? V1Colors.green : V1Colors.orange,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Limite restante após compra: ${CurrencyFormat.format(remaining)}',
            style: TextStyle(
                fontSize: 10,
                color: isAtivo ? V1Colors.green : V1Colors.orange),
          ),
        ],
      ),
    );
  }
}

// ─── Cart Item Tile ─────────────────────────────────────
class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final ValueChanged<int> onQty;
  const _CartItemTile(
      {required this.item, required this.onRemove, required this.onQty});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: V1Colors.card,
        border: Border.all(color: V1Colors.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              imageUrl: item.product.imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
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
                    border: Border.all(color: V1Colors.border),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    item.quantity > 1 ? Icons.remove : Icons.delete_outline,
                    size: 14,
                    color: item.quantity > 1 ? V1Colors.text : Colors.red,
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
                    border: Border.all(color: V1Colors.border),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.add, size: 14, color: V1Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
