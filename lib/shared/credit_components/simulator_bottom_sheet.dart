import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/variant_config.dart';
import '../config/naming_variables.dart';
import '../../utils/currency_format.dart';

/// Installment simulator bottom sheet (Phase B — Consideration).
/// Opens without leaving the PDP per funnel_logic.md Phase B:
/// "Interaction: Tap opens a bottom sheet with a quick simulation,
///  without leaving the page."
class SimulatorBottomSheet extends StatefulWidget {
  final VariantConfig config;
  final double productPrice;
  final double availableLimit;
  final int maxInstallments;

  const SimulatorBottomSheet({
    super.key,
    required this.config,
    required this.productPrice,
    required this.availableLimit,
    required this.maxInstallments,
  });

  /// Show the simulator as a modal bottom sheet
  static Future<void> show(
    BuildContext context, {
    required VariantConfig config,
    required double productPrice,
    required double availableLimit,
    required int maxInstallments,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SimulatorBottomSheet(
        config: config,
        productPrice: productPrice,
        availableLimit: availableLimit,
        maxInstallments: maxInstallments,
      ),
    );
  }

  @override
  State<SimulatorBottomSheet> createState() => _SimulatorBottomSheetState();
}

class _SimulatorBottomSheetState extends State<SimulatorBottomSheet> {
  int _selectedInstallments = 1;

  @override
  Widget build(BuildContext context) {
    final copy = NamingVariables.getCopy(widget.config.naming);
    final color = widget.config.theme.creditAccent;
    final isDark = widget.config.theme.isDark;
    final bgColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecColor = isDark ? const Color(0xFFAAAAAA) : const Color(0xFF757575);

    // Build installment options with simple interest calculation
    final options = <int, _InstallmentInfo>{};
    for (int i = 1; i <= widget.maxInstallments; i++) {
      if (i == 1 || i == 2 || i == 3 || i == 6 || i == 10 || i == 12 || i == 18 || i == 24) {
        double rate = 0;
        if (i > 3 && i <= 6) rate = 0.0199;
        if (i > 6 && i <= 12) rate = 0.0249;
        if (i > 12) rate = 0.0299;
        final total = widget.productPrice * (1 + rate * i);
        options[i] = _InstallmentInfo(
          count: i,
          perInstallment: total / i,
          total: total,
          hasInterest: i > 3,
        );
      }
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: textSecColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Icon(Icons.calculate, color: color, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Simular ${copy.productName}',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      Text(
                        '${CurrencyFormat.format(widget.availableLimit)} de limite disponível',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: textSecColor,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: textSecColor, size: 22),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Installment grid
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Escolha o número de parcelas',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: options.length,
                    itemBuilder: (context, i) {
                      final entry = options.entries.elementAt(i);
                      final info = entry.value;
                      final selected = _selectedInstallments == info.count;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedInstallments = info.count),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: selected ? color : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5)),
                            borderRadius: BorderRadius.circular(12),
                            border: selected ? Border.all(color: color, width: 2) : null,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${info.count}x',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: selected ? Colors.white : textColor,
                                ),
                              ),
                              Text(
                                CurrencyFormat.format(info.perInstallment),
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: selected ? Colors.white70 : textSecColor,
                                ),
                              ),
                              if (info.hasInterest)
                                Text(
                                  'c/ juros',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    color: selected ? Colors.white54 : textSecColor.withValues(alpha: 0.7),
                                  ),
                                )
                              else
                                Text(
                                  'sem juros',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: selected ? Colors.white : const Color(0xFF00A650),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // Summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: isDark ? 0.15 : 0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Valor da parcela', style: GoogleFonts.inter(fontSize: 13, color: textSecColor)),
                            Text(
                              CurrencyFormat.format(options[_selectedInstallments]?.perInstallment ?? widget.productPrice),
                              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: textColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total', style: GoogleFonts.inter(fontSize: 12, color: textSecColor)),
                            Text(
                              CurrencyFormat.format(options[_selectedInstallments]?.total ?? widget.productPrice),
                              style: GoogleFonts.inter(fontSize: 13, color: textSecColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      child: Text(copy.pdpCtaText),
                    ),
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

class _InstallmentInfo {
  final int count;
  final double perInstallment;
  final double total;
  final bool hasInterest;

  const _InstallmentInfo({
    required this.count,
    required this.perInstallment,
    required this.total,
    required this.hasInterest,
  });
}
