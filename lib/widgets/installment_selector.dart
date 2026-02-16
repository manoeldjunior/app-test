import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/currency_format.dart';
import 'pressable_scale.dart';

class InstallmentSelector extends StatelessWidget {
  final double totalPrice;
  final int selectedInstallments;
  final int maxInstallments;
  final ValueChanged<int>? onSelect;

  const InstallmentSelector({
    super.key,
    required this.totalPrice,
    required this.selectedInstallments,
    this.maxInstallments = 12,
    this.onSelect,
  });

  double _calculateInstallmentPrice(int count) {
    // Simple interest simulation: 1x = no interest, 2-6x = 1.5% p.m., 7-12x = 2.5% p.m.
    if (count == 1) return totalPrice;
    final rate = count <= 6 ? 0.015 : 0.025;
    final total = totalPrice * (1 + rate * count);
    return total / count;
  }

  bool _isInterestFree(int count) => count <= 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Parcelas',
            style: AppTextStyles.headlineSmall,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.6,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: maxInstallments,
          itemBuilder: (context, index) {
            final count = index + 1;
            final isSelected = count == selectedInstallments;
            final installmentPrice = _calculateInstallmentPrice(count);
            final interestFree = _isInterestFree(count);

            return PressableScale(
              onTap: () => onSelect?.call(count),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${count}x',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      CurrencyFormat.format(installmentPrice),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isSelected
                            ? Colors.white70
                            : AppColors.textSecondary,
                      ),
                    ),
                    if (interestFree)
                      Text(
                        'sem juros',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.accentGreen,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
