import 'variant_config.dart';

/// Constants and copy for the 4 approved A/B naming variables.
/// RULE: "Carnê Digital" is FORBIDDEN in all new files.
/// Source: funnel_logic.md + Senior Product Engineer instructions
class NamingVariables {
  NamingVariables._();

  /// Get the display configuration for a naming variable
  static NamingCopy getCopy(NamingVariable variable) {
    switch (variable) {
      case NamingVariable.pixParcelado:
        return _pixParcelado;
      case NamingVariable.limiteMagalu:
        return _limiteMagalu;
      case NamingVariable.creditoRapido:
        return _creditoRapido;
      case NamingVariable.pagueLepois:
        return _pagueLepois;
    }
  }

  // ─── VAR_A: Pix Parcelado ─────────────────────────────
  // Focus: Speed
  static const _pixParcelado = NamingCopy(
    variable: NamingVariable.pixParcelado,
    productName: 'Pix Parcelado',
    badgeText: 'Pix Parcelado',
    homeBannerTitle: 'Pix Parcelado disponível!',
    homeBannerSubtitle: 'Parcele em até 24x sem cartão de crédito',
    pdpPillText: 'Pix Parcelado disponível',
    pdpCtaText: 'Comprar com Pix Parcelado',
    pdpInstallmentPrefix: 'Parcele no Pix em até',
    cartSavingsPrefix: 'Você economiza usando seu Pix Parcelado',
    checkoutLabel: 'Pix Parcelado',
    checkoutSubtitle: 'Parcele sem cartão de crédito',
    checkoutRecommendedBadge: 'Mais rápido',
    successMethodLabel: 'Pix Parcelado',
  );

  // ─── VAR_B: Limite Magalu ─────────────────────────────
  // Focus: Exclusivity
  static const _limiteMagalu = NamingCopy(
    variable: NamingVariable.limiteMagalu,
    productName: 'Limite Magalu',
    badgeText: 'Limite Magalu',
    homeBannerTitle: 'Seu Limite Magalu está ativo!',
    homeBannerSubtitle: 'Limite exclusivo pré-aprovado para você',
    pdpPillText: 'Limite Magalu disponível',
    pdpCtaText: 'Comprar com Limite Magalu',
    pdpInstallmentPrefix: 'Parcele com Limite Magalu em até',
    cartSavingsPrefix: 'Você economiza usando seu Limite Magalu',
    checkoutLabel: 'Limite Magalu',
    checkoutSubtitle: 'Limite exclusivo pré-aprovado',
    checkoutRecommendedBadge: 'Recomendado',
    successMethodLabel: 'Limite Magalu',
  );

  // ─── VAR (Senior PE Rule): Crédito Rápido ─────────────
  // Focus: Speed + Trust
  static const _creditoRapido = NamingCopy(
    variable: NamingVariable.creditoRapido,
    productName: 'Crédito Rápido',
    badgeText: 'Crédito Rápido',
    homeBannerTitle: 'Crédito Rápido pré-aprovado!',
    homeBannerSubtitle: 'Parcele sem burocracia, aprovação na hora',
    pdpPillText: 'Crédito Rápido disponível',
    pdpCtaText: 'Comprar com Crédito Rápido',
    pdpInstallmentPrefix: 'Parcele com Crédito Rápido em até',
    cartSavingsPrefix: 'Você economiza usando Crédito Rápido',
    checkoutLabel: 'Crédito Rápido',
    checkoutSubtitle: 'Aprovação instantânea sem cartão',
    checkoutRecommendedBadge: 'Rápido',
    successMethodLabel: 'Crédito Rápido',
  );

  // ─── VAR_C: Pague Depois ──────────────────────────────
  // Focus: BNPL
  static const _pagueLepois = NamingCopy(
    variable: NamingVariable.pagueLepois,
    productName: 'Pague Depois',
    badgeText: 'Pague Depois',
    homeBannerTitle: 'Compre agora, Pague Depois!',
    homeBannerSubtitle: 'Parcele em até 24x com aprovação imediata',
    pdpPillText: 'Pague Depois disponível',
    pdpCtaText: 'Comprar e Pagar Depois',
    pdpInstallmentPrefix: 'Pague Depois em até',
    cartSavingsPrefix: 'Você economiza usando Pague Depois',
    checkoutLabel: 'Pague Depois',
    checkoutSubtitle: 'Compre agora, pague em até 24x',
    checkoutRecommendedBadge: 'BNPL',
    successMethodLabel: 'Pague Depois',
  );
}

/// All UI copy strings for a single naming variable.
/// Used by shared credit components to render variant-specific text.
class NamingCopy {
  final NamingVariable variable;
  final String productName;
  final String badgeText;
  final String homeBannerTitle;
  final String homeBannerSubtitle;
  final String pdpPillText;
  final String pdpCtaText;
  final String pdpInstallmentPrefix;
  final String cartSavingsPrefix;
  final String checkoutLabel;
  final String checkoutSubtitle;
  final String checkoutRecommendedBadge;
  final String successMethodLabel;

  const NamingCopy({
    required this.variable,
    required this.productName,
    required this.badgeText,
    required this.homeBannerTitle,
    required this.homeBannerSubtitle,
    required this.pdpPillText,
    required this.pdpCtaText,
    required this.pdpInstallmentPrefix,
    required this.cartSavingsPrefix,
    required this.checkoutLabel,
    required this.checkoutSubtitle,
    required this.checkoutRecommendedBadge,
    required this.successMethodLabel,
  });
}
