import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/variant_config.dart';
import '../config/naming_variables.dart';
import '../../utils/currency_format.dart';

/// "Available Limit" pill for PDP (Phase B — Consideration).
/// Displays next to the price tag per funnel_logic.md.
/// Responds to [InfoHierarchy] to show installment-first or limit-first.
class CreditLimitPill extends StatelessWidget {
  final VariantConfig config;
  final double availableLimit;
  final int maxInstallments;
  final double installmentValue;

  const CreditLimitPill({
    super.key,
    required this.config,
    required this.availableLimit,
    required this.maxInstallments,
    required this.installmentValue,
  });

  @override
  Widget build(BuildContext context) {
    final copy = NamingVariables.getCopy(config.naming);
    final color = config.theme.creditAccent;
    final isDark = config.theme.isDark;

    final limitText = CurrencyFormat.format(availableLimit);
    final installmentText = '${maxInstallments}x de ${CurrencyFormat.format(installmentValue)}';

    final primaryText = config.infoHierarchy == InfoHierarchy.installmentFirst
        ? installmentText
        : '$limitText disponível';
    final secondaryText = config.infoHierarchy == InfoHierarchy.installmentFirst
        ? '$limitText disponível'
        : installmentText;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(config.cardRadius),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        children: [
          Icon(Icons.credit_card, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  copy.pdpPillText,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$primaryText • $secondaryText',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isDark
                        ? config.theme.textSecondary
                        : const Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Até ${maxInstallments}x',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
