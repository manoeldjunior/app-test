import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/variant_config.dart';
import '../config/naming_variables.dart';
import '../../utils/currency_format.dart';

/// Pre-approved credit banner for Home screen (Phase A — Discovery).
/// Displays credit limit and max installments prominently at top of funnel.
/// Per funnel_logic.md Phase A:
///   IF user_has_preapproved_credit == TRUE:
///     Display "Credit Badge" on product cards.
///     Copy: "Parcele em até 24x sem cartão."
class CreditBannerHome extends StatelessWidget {
  final VariantConfig config;
  final double availableLimit;
  final int maxInstallments;
  final VoidCallback? onTap;

  const CreditBannerHome({
    super.key,
    required this.config,
    required this.availableLimit,
    required this.maxInstallments,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final copy = NamingVariables.getCopy(config.naming);
    final color = config.theme.creditAccent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(config.cardPadding),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color,
              color.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(config.cardRadius),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.credit_score, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    copy.homeBannerTitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    copy.homeBannerSubtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.account_balance_wallet, color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              CurrencyFormat.format(availableLimit),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Até ${maxInstallments}x',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}
