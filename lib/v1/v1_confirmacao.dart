// ═══════════════════════════════════════════════════════════
// V1 — Confirmação de Pedido (Order Confirmation / Success)
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_data.dart';
import '../providers/providers.dart';
import '../utils/currency_format.dart';
import 'v1_colors.dart';

class V1Confirmacao extends ConsumerWidget {
  final String paymentMethod;
  final int installments;

  const V1Confirmacao({
    super.key,
    required this.paymentMethod,
    this.installments = 1,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ref.watch(cartTotalProvider);
    final isCarne = paymentMethod == 'carneDigital';
    final installmentOptions = MockData.calculateInstallments(total);
    final selectedOpt =
        installmentOptions.where((o) => o.count == installments).toList();
    final installmentValue =
        selectedOpt.isNotEmpty ? selectedOpt.first.perInstallment : total;
    final user = MockData.user;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: V1Colors.green.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: V1Colors.green, size: 40),
              ),
              const SizedBox(height: 16),
              const Text('Pedido realizado!',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: V1Colors.text)),
              const SizedBox(height: 6),
              const Text('Seu pedido foi confirmado com sucesso.',
                  style: TextStyle(fontSize: 13, color: V1Colors.textSec),
                  textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text(
                'Pedido #${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
                style: const TextStyle(
                    fontSize: 11, color: V1Colors.textSec),
              ),

              // Carnê activation card
              if (isCarne) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: V1Colors.orange.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: V1Colors.orange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.receipt_long,
                                color: V1Colors.orange, size: 18),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Limite Magalu ativado',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: V1Colors.text)),
                                Text('Seu crédito parcelado foi confirmado',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: V1Colors.textSec)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: V1Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Ativo',
                                style: TextStyle(
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
                              const Text('Parcelas',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: V1Colors.textSec)),
                              Text(
                                '$installments x de ${CurrencyFormat.format(installmentValue)}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: V1Colors.orange),
                              ),
                            ],
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Próximo vencimento',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: V1Colors.textSec)),
                              Text(
                                '17/03/2026',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: V1Colors.text),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Limite restante',
                              style: TextStyle(
                                  fontSize: 10, color: V1Colors.textSec)),
                          Text(
                            CurrencyFormat.format(
                                user.carneDigitalAvailable - total),
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: V1Colors.text),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(cartProvider.notifier).clear();
                    ref.read(paymentProvider.notifier).reset();
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: V1Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Voltar ao início',
                      style: TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
