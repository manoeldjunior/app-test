import 'package:flutter/material.dart';
import '../config/variant_config.dart';

/// Base shell for Home Screen. Provides configurable header, content area,
/// and bottom navigation. Competitor prototypes inject their specific widgets
/// into the named slots.
class BaseHomeShell extends StatelessWidget {
  final VariantConfig config;
  final Widget header;
  final Widget? creditBanner;
  final Widget? balanceCard;
  final Widget productList;
  final Widget? bottomNav;
  final List<Widget>? categoryPills;

  const BaseHomeShell({
    super.key,
    required this.config,
    required this.header,
    this.creditBanner,
    this.balanceCard,
    required this.productList,
    this.bottomNav,
    this.categoryPills,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.theme.background,
      body: Column(
        children: [
          header,
          if (categoryPills != null)
            Container(
              color: config.theme.surface,
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                children: categoryPills!,
              ),
            ),
          if (creditBanner != null) creditBanner!,
          if (balanceCard != null) balanceCard!,
          Expanded(child: productList),
        ],
      ),
      bottomNavigationBar: bottomNav,
    );
  }
}

/// Base shell for Product Detail Page. Provides image area, info section,
/// credit injection point, and bottom CTA bar.
class BasePdpShell extends StatelessWidget {
  final VariantConfig config;
  final Widget appBar;
  final Widget imageSection;
  final Widget productInfo;
  final Widget? creditSection; // Credit limit pill + simulator trigger
  final Widget? shippingSection;
  final Widget? sellerSection;
  final Widget? extraSections;
  final Widget bottomBar;

  const BasePdpShell({
    super.key,
    required this.config,
    required this.appBar,
    required this.imageSection,
    required this.productInfo,
    this.creditSection,
    this.shippingSection,
    this.sellerSection,
    this.extraSections,
    required this.bottomBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.theme.background,
      body: Column(
        children: [
          appBar,
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                imageSection,
                productInfo,
                SizedBox(height: config.sectionSpacing),
                // Credit section placement per CtaPlacement
                if (creditSection != null && config.ctaPlacement != CtaPlacement.stickyBottom)
                  creditSection!,
                if (shippingSection != null) ...[
                  SizedBox(height: config.sectionSpacing),
                  shippingSection!,
                ],
                if (sellerSection != null) ...[
                  SizedBox(height: config.sectionSpacing),
                  sellerSection!,
                ],
                if (extraSections != null) extraSections!,
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: bottomBar,
    );
  }
}

/// Base shell for Cart Screen.
class BaseCartShell extends StatelessWidget {
  final VariantConfig config;
  final Widget appBar;
  final Widget itemsList;
  final Widget? creditCallout; // Savings callout injection point
  final Widget? summarySection;
  final Widget? bottomBar;
  final Widget emptyState;
  final bool isEmpty;

  const BaseCartShell({
    super.key,
    required this.config,
    required this.appBar,
    required this.itemsList,
    this.creditCallout,
    this.summarySection,
    this.bottomBar,
    required this.emptyState,
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.theme.background,
      body: Column(
        children: [
          appBar,
          Expanded(
            child: isEmpty
                ? emptyState
                : ListView(
                    padding: const EdgeInsets.only(top: 8),
                    children: [
                      itemsList,
                      if (creditCallout != null) creditCallout!,
                      if (summarySection != null) summarySection!,
                      const SizedBox(height: 60),
                    ],
                  ),
          ),
          if (!isEmpty && bottomBar != null) bottomBar!,
        ],
      ),
    );
  }
}

/// Base shell for Checkout Screen.
class BaseCheckoutShell extends StatelessWidget {
  final VariantConfig config;
  final Widget appBar;
  final Widget content;
  final Widget bottomBar;

  const BaseCheckoutShell({
    super.key,
    required this.config,
    required this.appBar,
    required this.content,
    required this.bottomBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.theme.background,
      body: Column(
        children: [
          appBar,
          Expanded(child: content),
          bottomBar,
        ],
      ),
    );
  }
}

/// Base shell for Success Screen.
class BaseSuccessShell extends StatelessWidget {
  final VariantConfig config;
  final Widget content;
  final Widget? bottomAction;

  const BaseSuccessShell({
    super.key,
    required this.config,
    required this.content,
    this.bottomAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.theme.isDark
          ? config.theme.background
          : config.theme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: content),
            if (bottomAction != null)
              Padding(
                padding: const EdgeInsets.all(20),
                child: bottomAction!,
              ),
          ],
        ),
      ),
    );
  }
}
