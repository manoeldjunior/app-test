import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../providers/providers.dart';
import '../../utils/currency_format.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);
    final shippingMethod = ref.watch(shippingMethodProvider);

    const shippingCost = 0.0; // Free shipping

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'Resumo do pedido',
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
            // ─── Items ─────────────────────────────────────
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Itens do pedido',
                    style: AppTextStyles.headlineSmall,
                  ),
                  const SizedBox(height: 14),
                  ...cartItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: item.product.imageUrl,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(
                                  width: 56,
                                  height: 56,
                                  color: AppColors.shimmerBase,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: AppTextStyles.bodyMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Qtd: ${item.quantity}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              CurrencyFormat.format(item.total),
                              style: AppTextStyles.titleMedium,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ─── Shipping Method ────────────────────────────
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Entrega',
                    style: AppTextStyles.headlineSmall,
                  ),
                  const SizedBox(height: 14),
                  _ShippingOption(
                    icon: Icons.home,
                    title: 'Receber em casa',
                    subtitle: 'Chegará até 22 de fev',
                    isSelected: shippingMethod == 'delivery',
                    onTap: () => ref
                        .read(shippingMethodProvider.notifier)
                        .state = 'delivery',
                  ),
                  const SizedBox(height: 8),
                  _ShippingOption(
                    icon: Icons.store,
                    title: 'Retirar na loja',
                    subtitle: 'Disponível em 1 dia útil',
                    isSelected: shippingMethod == 'pickup',
                    onTap: () => ref
                        .read(shippingMethodProvider.notifier)
                        .state = 'pickup',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ─── Summary ────────────────────────────────────
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _SummaryRow(
                    label: 'Subtotal',
                    value: CurrencyFormat.format(total),
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: 'Frete',
                    value: shippingCost == 0 ? 'Grátis' : CurrencyFormat.format(shippingCost),
                    valueColor: AppColors.accentGreen,
                  ),
                  const Divider(height: 24),
                  _SummaryRow(
                    label: 'Total',
                    value: CurrencyFormat.format(total + shippingCost),
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      // ─── CTA ──────────────────────────────────────────
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
            onPressed: () => context.push('/payment'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Escolher pagamento'),
          ),
        ),
      ),
    );
  }
}

class _ShippingOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ShippingOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.scaffoldBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleMedium),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.textTertiary,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTextStyles.headlineSmall
              : AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: isBold
              ? AppTextStyles.priceTotal
              : AppTextStyles.titleMedium.copyWith(
                  color: valueColor ?? AppColors.textPrimary),
        ),
      ],
    );
  }
}
