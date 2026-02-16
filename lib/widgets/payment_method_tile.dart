import 'package:flutter/material.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'pressable_scale.dart';

class PaymentMethodTile extends StatelessWidget {
  final PaymentOption option;
  final bool isSelected;
  final VoidCallback? onTap;

  const PaymentMethodTile({
    super.key,
    required this.option,
    this.isSelected = false,
    this.onTap,
  });

  IconData _getIcon() {
    switch (option.method) {
      case PaymentMethod.magaluPay:
        return Icons.account_balance_wallet;
      case PaymentMethod.creditCard:
        return Icons.credit_card;
      case PaymentMethod.pix:
        return Icons.pix;
      case PaymentMethod.carneDigital:
        return Icons.receipt_long;
      case PaymentMethod.boleto:
        return Icons.description;
    }
  }

  Color _getIconColor() {
    switch (option.method) {
      case PaymentMethod.magaluPay:
        return AppColors.magaluPay;
      case PaymentMethod.creditCard:
        return AppColors.primary;
      case PaymentMethod.pix:
        return AppColors.pixGreen;
      case PaymentMethod.carneDigital:
        return AppColors.magaluPay;
      case PaymentMethod.boleto:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _getIconColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_getIcon(), color: _getIconColor(), size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (option.subtitle != null)
                    Text(
                      option.subtitle!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            // Radio indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.textTertiary,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
