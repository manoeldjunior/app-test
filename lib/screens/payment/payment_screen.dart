import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../providers/providers.dart';
import '../../utils/currency_format.dart';
import '../../widgets/payment_method_tile.dart';
import '../../widgets/installment_selector.dart';

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'Pagamento',
          style: AppTextStyles.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // ─── Total Display ──────────────────────────────
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total a pagar',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    CurrencyFormat.format(total),
                    style: AppTextStyles.priceTotal,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ─── Payment Methods ────────────────────────────
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Forma de pagamento',
                      style: AppTextStyles.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...MockData.paymentOptions.map((option) {
                    return PaymentMethodTile(
                      option: option,
                      isSelected:
                          paymentState.selectedMethod == option.method,
                      onTap: () => ref
                          .read(paymentProvider.notifier)
                          .selectMethod(option.method),
                    );
                  }),
                ],
              ),
            ),

            // ─── Installments (for credit card) ─────────────
            if (paymentState.selectedMethod == PaymentMethod.creditCard ||
                paymentState.selectedMethod == PaymentMethod.carneDigital)
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  color: AppColors.surface,
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InstallmentSelector(
                    totalPrice: total,
                    selectedInstallments: paymentState.installments,
                    maxInstallments: paymentState.selectedMethod ==
                            PaymentMethod.carneDigital
                        ? 24
                        : 12,
                    onSelect: (count) => ref
                        .read(paymentProvider.notifier)
                        .selectInstallments(count),
                  ),
                ),
              ),

            // ─── Pix info ───────────────────────────────────
            if (paymentState.selectedMethod == PaymentMethod.pix)
              Container(
                color: AppColors.surface,
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.pixGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.pix,
                          color: AppColors.pixGreen, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pagamento via Pix',
                            style: AppTextStyles.titleMedium,
                          ),
                          Text(
                            'Aprovação imediata. Código válido por 30 minutos.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 120),
          ],
        ),
      ),
      // ─── Confirm Button ───────────────────────────────
      bottomSheet: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          16 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowMedium,
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: paymentState.selectedMethod != null
                ? () => context.push('/success')
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              disabledBackgroundColor: AppColors.divider,
            ),
            child: Text(
              paymentState.selectedMethod != null
                  ? 'Confirmar pagamento'
                  : 'Selecione uma forma de pagamento',
            ),
          ),
        ),
      ),
    );
  }
}
