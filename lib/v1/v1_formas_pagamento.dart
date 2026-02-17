// ═══════════════════════════════════════════════════════════
// V1 — Formas de Pagamento (Payment Method Selection)
// ═══════════════════════════════════════════════════════════
// Per funnel_logic.md Phase D: Carnê is SELECTED by default
// when pre-approved, highlighted as RECOMMENDED.
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../data/mock_data.dart';
import '../providers/providers.dart';
import '../utils/currency_format.dart';
import 'v1_colors.dart';
import 'v1_widgets.dart';
import 'v1_resumo_pagamento.dart';

class V1FormasPagamento extends ConsumerStatefulWidget {
  const V1FormasPagamento({super.key});
  @override
  ConsumerState<V1FormasPagamento> createState() => _V1FormasPagamentoState();
}

class _V1FormasPagamentoState extends ConsumerState<V1FormasPagamento> {
  late String _paymentMethod;
  int _selectedInstallments = 1;

  @override
  void initState() {
    super.initState();
    // Phase D: pre-select carnê if pre-approved
    final cdcState = ref.read(cdcUserStateProvider);
    _paymentMethod = (cdcState != CdcUserState.naoLogado)
        ? 'carneDigital'
        : 'pix';
  }

  @override
  Widget build(BuildContext context) {
    final total = ref.watch(cartTotalProvider);
    final user = MockData.user;
    final cdcState = ref.watch(cdcUserStateProvider);
    final canUseCDC = cdcState != CdcUserState.naoLogado &&
        total <= user.carneDigitalAvailable;
    final installments = MockData.calculateInstallments(total);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        backgroundColor: V1Colors.blue,
        foregroundColor: Colors.white,
        title:
            const Text('Formas de pagamento', style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
            children: [
              // Step progress
              const V1StepHeader(current: 1, total: 2, label: 'Etapa 1 de 2'),

              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      color: V1Colors.card,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Escolha como pagar',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(
                            'Total: ${CurrencyFormat.format(total)}',
                            style: const TextStyle(
                                fontSize: 12, color: V1Colors.textSec),
                          ),
                          const SizedBox(height: 12),

                          // Limite Magalu (promoted at top)
                          V1PayRadio(
                            label: 'Limite Magalu',
                            subtitle: canUseCDC
                                ? 'Limite: ${CurrencyFormat.format(user.carneDigitalAvailable)} — até 12x'
                                : cdcState == CdcUserState.naoLogado
                                    ? 'Faça login para usar seu limite'
                                    : 'Limite insuficiente',
                            value: 'carneDigital',
                            groupValue: _paymentMethod,
                            onChanged: (v) =>
                                setState(() => _paymentMethod = v),
                            highlight: canUseCDC,
                            disabled: !canUseCDC,
                            badge: canUseCDC ? 'Recomendado' : null,
                          ),

                          // Installment selector (when carnê selected)
                          if (_paymentMethod == 'carneDigital' && canUseCDC)
                            _buildInstallmentGrid(installments),

                          const Divider(height: 16),

                          V1PayRadio(
                            label: 'Saldo MagaluPay',
                            subtitle:
                                'Disponível: ${CurrencyFormat.format(user.magaluPayBalance)}',
                            value: 'magaluPay',
                            groupValue: _paymentMethod,
                            onChanged: (v) =>
                                setState(() => _paymentMethod = v),
                            disabled:
                                user.magaluPayBalance < total,
                          ),
                          V1PayRadio(
                            label: 'Cartão de Crédito',
                            subtitle: 'Visa •••• 4321',
                            value: 'creditCard',
                            groupValue: _paymentMethod,
                            onChanged: (v) =>
                                setState(() => _paymentMethod = v),
                          ),
                          V1PayRadio(
                            label: 'Pix',
                            subtitle: 'Aprovação imediata',
                            value: 'pix',
                            groupValue: _paymentMethod,
                            onChanged: (v) =>
                                setState(() => _paymentMethod = v),
                          ),
                          V1PayRadio(
                            label: 'Boleto Bancário',
                            subtitle: 'Vence em 3 dias úteis',
                            value: 'boleto',
                            groupValue: _paymentMethod,
                            onChanged: (v) =>
                                setState(() => _paymentMethod = v),
                          ),
                        ],
                      ),
                    ),

                    // Selected method summary
                    if (_paymentMethod == 'carneDigital' && canUseCDC)
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: V1Colors.orangeLight,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: V1Colors.orange.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.receipt_long,
                                size: 14, color: V1Colors.orange),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_selectedInstallments}x de ${CurrencyFormat.format(_getInstallmentValue(installments))}',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: V1Colors.orange,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  if (_selectedInstallments > 1)
                                    Text(
                                      'Total: ${CurrencyFormat.format(_getInstallmentTotal(installments))}',
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: V1Colors.textSec),
                                    ),
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
                builder: (_) => V1ResumoPagamento(
                  paymentMethod: _paymentMethod,
                  installments: _paymentMethod == 'carneDigital'
                      ? _selectedInstallments
                      : 1,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: V1Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Continuar', style: TextStyle(fontSize: 14)),
          ),
        ),
      ),
    );
  }

  Widget _buildInstallmentGrid(List<InstallmentOption> installments) {
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 32),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: installments.map((opt) {
          final isSelected = _selectedInstallments == opt.count;
          return GestureDetector(
            onTap: () => setState(() => _selectedInstallments = opt.count),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? V1Colors.orange
                    : V1Colors.orangeLight,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected
                      ? V1Colors.orange
                      : V1Colors.orange.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '${opt.count}x',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : V1Colors.orange,
                    ),
                  ),
                  Text(
                    CurrencyFormat.format(opt.perInstallment),
                    style: TextStyle(
                      fontSize: 9,
                      color: isSelected
                          ? Colors.white.withOpacity(0.8)
                          : V1Colors.textSec,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  double _getInstallmentValue(List<InstallmentOption> installments) {
    final match = installments.where((o) => o.count == _selectedInstallments);
    return match.isNotEmpty ? match.first.perInstallment : 0;
  }

  double _getInstallmentTotal(List<InstallmentOption> installments) {
    final match = installments.where((o) => o.count == _selectedInstallments);
    return match.isNotEmpty ? match.first.total : 0;
  }
}
