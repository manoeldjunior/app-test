import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/variant_config.dart';
import '../config/naming_variables.dart';

/// Credit badge displayed on product cards (Phase A — Discovery).
/// Shows eligibility indicator with the naming variable text.
/// Example: "Pix Parcelado até 12x" or "Limite Magalu disponível"
class CreditBadge extends StatelessWidget {
  final VariantConfig config;
  final int maxInstallments;
  final bool eligible;

  const CreditBadge({
    super.key,
    required this.config,
    required this.maxInstallments,
    this.eligible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!eligible) return const SizedBox.shrink();

    final copy = NamingVariables.getCopy(config.naming);
    final color = config.theme.creditAccent;
    final isDark = config.theme.isDark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.credit_card, color: color, size: 12),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '${copy.badgeText} até ${maxInstallments}x',
              style: GoogleFonts.inter(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
