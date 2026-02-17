// ═══════════════════════════════════════════════════════════
// V1 — Resumo de Pagamento (Payment Summary / Order Review)
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/mock_data.dart';
import '../providers/providers.dart';
import '../utils/currency_format.dart';
import 'v1_colors.dart';
import 'v1_widgets.dart';
import 'v1_confirmacao.dart';

class V1ResumoPagamento extends ConsumerWidget {
  final String paymentMethod;
  final int installments;

  const V1ResumoPagamento({
    super.key,
    required this.paymentMethod,
    this.installments = 1,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);
    final isCarne = paymentMethod == 'carneDigital';
    final installmentOptions = MockData.calculateInstallments(total);
    final selectedOpt = installmentOptions
        .where((o) => o.count == installments)
        .toList();
    final installmentValue =
        selectedOpt.isNotEmpty ? selectedOpt.first.perInstallment : total;
    final installmentTotal =
        selectedOpt.isNotEmpty ? selectedOpt.first.total : total;
    final interest = installmentTotal - total;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        backgroundColor: V1Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Resumo do pedido', style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
            children: [
              const V1StepHeader(current: 2, total: 2, label: 'Etapa 2 de 2'),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 8),

                    // Delivery section
                    Container(
                      color: V1Colors.card,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.local_shipping,
                                  size: 16, color: V1Colors.green),
                              SizedBox(width: 6),
                              Text('Entrega',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text('São Paulo, SP — CEP 04105-062',
                              style: TextStyle(
                                  fontSize: 12, color: V1Colors.text)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('Grátis',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: V1Colors.green,
                                        fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 6),
                              const Text('Chegará até 22 de fev',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: V1Colors.textSec)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 1),

                    // Items section
                    Container(
                      color: V1Colors.card,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Itens (${items.fold<int>(0, (s, i) => s + i.quantity)})',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 8),
                          ...items.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: CachedNetworkImage(
                                        imageUrl: item.product.imageUrl,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.product.name,
                                            style: const TextStyle(
                                                fontSize: 11),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${item.quantity}x ${CurrencyFormat.format(item.product.price)}',
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: V1Colors.textSec),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(CurrencyFormat.format(item.total),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 1),

                    // Payment method recap
                    Container(
                      color: V1Colors.card,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Pagamento',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isCarne
                                  ? V1Colors.orangeLight
                                  : V1Colors.bg,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isCarne
                                    ? V1Colors.orange.withOpacity(0.3)
                                    : V1Colors.border,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _paymentIcon(paymentMethod),
                                  size: 20,
                                  color: isCarne
                                      ? V1Colors.orange
                                      : V1Colors.blue,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_paymentLabel(paymentMethod),
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: isCarne
                                                  ? V1Colors.orange
                                                  : V1Colors.text)),
                                      if (isCarne)
                                        Text(
                                          '${installments}x de ${CurrencyFormat.format(installmentValue)}',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: V1Colors.textSec),
                                        )
                                      else
                                        Text(
                                          _paymentSubtitle(paymentMethod),
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: V1Colors.textSec),
                                        ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Alterar',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: V1Colors.blue)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 1),

                    // Summary totals
                    Container(
                      color: V1Colors.card,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          V1SumRow(
                              'Subtotal', CurrencyFormat.format(total)),
                          const V1SumRow('Frete', 'Grátis',
                              color: V1Colors.green),
                          if (isCarne && interest > 0)
                            V1SumRow('Juros',
                                '+ ${CurrencyFormat.format(interest)}',
                                color: V1Colors.textSec),
                          const Divider(height: 12),
                          V1SumRow(
                            'Total',
                            CurrencyFormat.format(
                                isCarne ? installmentTotal : total),
                            bold: true,
                          ),
                          if (isCarne && installments > 1)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: V1Colors.orangeLight,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.receipt_long,
                                        size: 14, color: V1Colors.orange),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Limite Magalu: ${installments}x de ${CurrencyFormat.format(installmentValue)}',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: V1Colors.orange,
                                            fontWeight: FontWeight.w600),
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
              ),
            ],
          ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: V1Colors.card,
          border: Border(top: BorderSide(color: V1Colors.border)),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => V1Confirmacao(
                  paymentMethod: paymentMethod,
                  installments: installments,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: V1Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Confirmar pedido',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  IconData _paymentIcon(String method) => switch (method) {
        'carneDigital' => Icons.receipt_long,
        'magaluPay' => Icons.account_balance_wallet,
        'creditCard' => Icons.credit_card,
        'pix' => Icons.pix,
        'boleto' => Icons.description,
        _ => Icons.payment,
      };

  String _paymentLabel(String method) => switch (method) {
        'carneDigital' => 'Limite Magalu',
        'magaluPay' => 'Saldo MagaluPay',
        'creditCard' => 'Cartão de Crédito',
        'pix' => 'Pix',
        'boleto' => 'Boleto Bancário',
        _ => 'Pagamento',
      };

  String _paymentSubtitle(String method) => switch (method) {
        'magaluPay' => 'Pagamento com saldo',
        'creditCard' => 'Visa •••• 4321',
        'pix' => 'Aprovação imediata',
        'boleto' => 'Vence em 3 dias úteis',
        _ => '',
      };
}
