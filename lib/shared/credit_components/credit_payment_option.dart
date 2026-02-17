import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/variant_config.dart';
import '../config/naming_variables.dart';
import '../../utils/currency_format.dart';

/// Credit payment option tile for Checkout (Phase D — Conversion).
/// Per funnel_logic.md Phase D:
///   If credit is pre-approved, this option should be SELECTED by default
///   or highlighted as RECOMMENDED.
///   Remove "Upload Document" steps if user is already KYC verified.
class CreditPaymentOption extends StatelessWidget {
  final VariantConfig config;
  final double availableLimit;
  final int maxInstallments;
  final bool isSelected;
  final bool isPreApproved;
  final bool isKycVerified;
  final VoidCallback? onTap;

  const CreditPaymentOption({
    super.key,
    required this.config,
    required this.availableLimit,
    required this.maxInstallments,
    this.isSelected = false,
    this.isPreApproved = true,
    this.isKycVerified = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final copy = NamingVariables.getCopy(config.naming);
    final color = config.theme.creditAccent;
    final isDark = config.theme.isDark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: isDark ? 0.2 : 0.08)
              : (isDark ? const Color(0xFF222222) : Colors.white),
          borderRadius: BorderRadius.circular(config.cardRadius),
          border: Border.all(
            color: isSelected ? color : (isDark ? const Color(0xFF333333) : const Color(0xFFDDDDDD)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.credit_score,
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        copy.checkoutLabel,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                        ),
                      ),
                      if (isPreApproved) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            copy.checkoutRecommendedBadge,
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${CurrencyFormat.format(availableLimit)} disponível • Até ${maxInstallments}x',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark ? const Color(0xFFAAAAAA) : const Color(0xFF757575),
                    ),
                  ),
                  if (!isKycVerified)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 12, color: Colors.orange.shade700),
                          const SizedBox(width: 4),
                          Text(
                            'Verificação necessária',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            // Radio
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 22,
              color: isSelected ? color : (isDark ? const Color(0xFF777777) : const Color(0xFFBDBDBD)),
            ),
          ],
        ),
      ),
    );
  }
}
