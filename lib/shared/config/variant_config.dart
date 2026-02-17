import 'package:flutter/material.dart';

/// Enumerates the approved A/B naming variables for credit product labeling.
/// RULE: Never use "Carnê Digital" in new files.
enum NamingVariable {
  pixParcelado,   // VAR_A — Focus: Speed
  limiteMagalu,   // VAR_B — Focus: Exclusivity
  creditoRapido,  // Senior Product Engineer rule
  pagueLepois,    // VAR_C — Focus: BNPL
}

/// Controls the visual density of the layout.
enum LayoutDensity {
  compact,  // Higher information density, smaller spacing
  spacious, // More whitespace, larger cards
}

/// Controls where the credit CTA appears on the PDP.
enum CtaPlacement {
  aboveFold, // Credit info displayed in the main content area above scroll
  stickyBottom, // Sticky bottom bar with credit CTA
  inline, // Inline within the price/product info section
}

/// Controls which credit information is shown first.
enum InfoHierarchy {
  installmentFirst, // Show "12x de R$49,90" before limit
  limitFirst,       // Show "R$5.438 disponível" before installments
}

/// Complete configuration object for a variant. Drives all parameterized
/// shared components and layout shells.
class VariantConfig {
  final String id;
  final String label;
  final NamingVariable naming;
  final LayoutDensity density;
  final CtaPlacement ctaPlacement;
  final InfoHierarchy infoHierarchy;
  final CompetitorTheme theme;

  const VariantConfig({
    required this.id,
    required this.label,
    required this.naming,
    this.density = LayoutDensity.spacious,
    this.ctaPlacement = CtaPlacement.aboveFold,
    this.infoHierarchy = InfoHierarchy.installmentFirst,
    required this.theme,
  });

  /// Spacing values driven by density
  double get cardPadding => density == LayoutDensity.compact ? 8.0 : 14.0;
  double get sectionSpacing => density == LayoutDensity.compact ? 6.0 : 12.0;
  double get gridAspectRatio => density == LayoutDensity.compact ? 0.52 : 0.62;
  int get gridCrossAxisCount => density == LayoutDensity.compact ? 2 : 2;
  double get gridSpacing => density == LayoutDensity.compact ? 6.0 : 10.0;
  double get cardRadius => density == LayoutDensity.compact ? 8.0 : 14.0;
}

/// Competitor-specific theme overrides. These define the visual identity
/// of a raw competitor prototype or serve as the "source" for hybrid extraction.
class CompetitorTheme {
  final String name;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color creditAccent;
  final double cardRadius;
  final bool isDark;
  final bool useMaterial3;

  const CompetitorTheme({
    required this.name,
    required this.primary,
    required this.secondary,
    required this.accent,
    this.background = Colors.white,
    this.surface = Colors.white,
    this.textPrimary = const Color(0xFF1A1A1A),
    this.textSecondary = const Color(0xFF757575),
    required this.creditAccent,
    this.cardRadius = 12.0,
    this.isDark = false,
    this.useMaterial3 = true,
  });
}

/// Pre-defined competitor themes for raw vn prototypes
class CompetitorThemes {
  CompetitorThemes._();

  static const magalu = CompetitorTheme(
    name: 'Magalu',
    primary: Color(0xFF0086FF),
    secondary: Color(0xFF00A650),
    accent: Color(0xFFFF6F00),
    creditAccent: Color(0xFFFF6F00),
    cardRadius: 12.0,
  );

  static const mercadoLivre = CompetitorTheme(
    name: 'Mercado Livre',
    primary: Color(0xFF3483FA),
    secondary: Color(0xFFFFE600),
    accent: Color(0xFF00A650),
    background: Color(0xFFEBEBEB),
    creditAccent: Color(0xFF009EE3),
    cardRadius: 6.0,
    useMaterial3: false,
  );

  static const nubank = CompetitorTheme(
    name: 'Nubank',
    primary: Color(0xFF820AD1),
    secondary: Color(0xFF6B07AE),
    accent: Color(0xFF9B3FDB),
    background: Color(0xFF111111),
    surface: Color(0xFF1A1A1A),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFAAAAAA),
    creditAccent: Color(0xFF820AD1),
    cardRadius: 16.0,
    isDark: true,
  );

  static const casasBahia = CompetitorTheme(
    name: 'Casas Bahia',
    primary: Color(0xFF0033A0),
    secondary: Color(0xFFE91E63),
    accent: Color(0xFFE91E63),
    creditAccent: Color(0xFFE91E63),
    cardRadius: 10.0,
    useMaterial3: false,
  );

  static const banqi = CompetitorTheme(
    name: 'BanQi',
    primary: Color(0xFFFFD600),
    secondary: Color(0xFFFFC107),
    accent: Color(0xFFFF9800),
    background: Color(0xFFFFFDE7),
    textPrimary: Color(0xFF212121),
    textSecondary: Color(0xFF616161),
    creditAccent: Color(0xFFFFD600),
    cardRadius: 12.0,
  );

  static const ameShoptime = CompetitorTheme(
    name: 'Ame / Shoptime',
    primary: Color(0xFF0033CC),
    secondary: Color(0xFFFF0066),
    accent: Color(0xFFFF0066),
    creditAccent: Color(0xFFFF0066),
    cardRadius: 8.0,
    useMaterial3: false,
  );

  static const recargaPay = CompetitorTheme(
    name: 'RecargaPay',
    primary: Color(0xFF7C4DFF),
    secondary: Color(0xFF1A237E),
    accent: Color(0xFF7C4DFF),
    background: Color(0xFF1A1A2E),
    surface: Color(0xFF16213E),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFB0BEC5),
    creditAccent: Color(0xFF7C4DFF),
    cardRadius: 14.0,
    isDark: true,
  );

  static const bancoDoBrasil = CompetitorTheme(
    name: 'Banco do Brasil',
    primary: Color(0xFF003882),
    secondary: Color(0xFFFFCC00),
    accent: Color(0xFFFFCC00),
    creditAccent: Color(0xFF003882),
    cardRadius: 10.0,
  );
}
