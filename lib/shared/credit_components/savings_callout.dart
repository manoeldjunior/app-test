import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/variant_config.dart';
import '../config/naming_variables.dart';
import '../../utils/currency_format.dart';

/// Cart savings callout (Phase C — Intent).
/// Per funnel_logic.md Phase C:
///   Display: "Você economiza R$ XX.XX usando seu Limite Magalu."
class SavingsCallout extends StatelessWidget {
  final VariantConfig config;
  final double savingsAmount;

  const SavingsCallout({
    super.key,
    required this.config,
    required this.savingsAmount,
  });

  @override
  Widget build(BuildContext context) {
    if (savingsAmount <= 0) return const SizedBox.shrink();

    final copy = NamingVariables.getCopy(config.naming);
    final color = config.theme.creditAccent;
    final isDark = config.theme.isDark;
    final bgColor = color.withValues(alpha: isDark ? 0.15 : 0.08);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: config.cardPadding, vertical: config.sectionSpacing / 2),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(config.cardRadius),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.savings, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(fontSize: 13, color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
                children: [
                  TextSpan(
                    text: 'Você economiza ',
                  ),
                  TextSpan(
                    text: CurrencyFormat.format(savingsAmount),
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: color),
                  ),
                  TextSpan(
                    text: ' usando seu ${copy.productName}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
