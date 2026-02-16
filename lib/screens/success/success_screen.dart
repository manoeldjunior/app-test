import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../providers/providers.dart';
import '../../utils/currency_format.dart';

class SuccessScreen extends ConsumerStatefulWidget {
  const SuccessScreen({super.key});

  @override
  ConsumerState<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends ConsumerState<SuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _scaleController;
  late AnimationController _confettiController;
  late Animation<double> _checkAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    // Sequence: scale → check → confetti
    _scaleController.forward().then((_) {
      _checkController.forward();
      _confettiController.forward();
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = ref.watch(cartTotalProvider);
    final payment = ref.watch(paymentProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // ─── Animated Check ───────────────────────
              Stack(
                alignment: Alignment.center,
                children: [
                  // Confetti particles
                  AnimatedBuilder(
                    listenable: _confettiController,
                    builder: (context, _) {
                      return CustomPaint(
                        size: const Size(200, 200),
                        painter: _ConfettiPainter(
                          progress: _confettiController.value,
                        ),
                      );
                    },
                  ),
                  // Circle + Check
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.accentGreen.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: AppColors.accentGreen,
                            shape: BoxShape.circle,
                          ),
                          child: ScaleTransition(
                            scale: _checkAnimation,
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // ─── Title ────────────────────────────────
              FadeTransition(
                opacity: _checkAnimation,
                child: Column(
                  children: [
                    Text(
                      'Compra realizada!',
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Seu pedido foi confirmado com sucesso.',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // ─── Order Summary Card ───────────────────
              FadeTransition(
                opacity: _checkAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _InfoRow(
                        label: 'Total',
                        value: CurrencyFormat.format(total),
                      ),
                      const SizedBox(height: 10),
                      _InfoRow(
                        label: 'Pagamento',
                        value: _getPaymentLabel(payment.selectedMethod),
                      ),
                      if (payment.installments > 1) ...[
                        const SizedBox(height: 10),
                        _InfoRow(
                          label: 'Parcelas',
                          value:
                              '${payment.installments}x de ${CurrencyFormat.format(total / payment.installments)}',
                        ),
                      ],
                      const SizedBox(height: 10),
                      _InfoRow(
                        label: 'Previsão',
                        value: '20-22 de fev',
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 2),
              // ─── Buttons ──────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(cartProvider.notifier).clear();
                    ref.read(paymentProvider.notifier).reset();
                    context.go('/');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Voltar ao início'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Acompanhar pedido',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _getPaymentLabel(PaymentMethod? method) {
    switch (method) {
      case PaymentMethod.magaluPay:
        return 'MagaluPay';
      case PaymentMethod.creditCard:
        return 'Cartão de Crédito';
      case PaymentMethod.pix:
        return 'Pix';
      case PaymentMethod.carneDigital:
        return 'Carnê Digital';
      case PaymentMethod.boleto:
        return 'Boleto';
      case null:
        return '-';
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(value, style: AppTextStyles.titleMedium),
      ],
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final _random = Random(42);

  _ConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final colors = [
      AppColors.primary,
      AppColors.magaluPay,
      AppColors.accentGreen,
      AppColors.ratingStar,
      AppColors.pixGreen,
    ];

    for (int i = 0; i < 20; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final distance = 40 + _random.nextDouble() * 80;
      final x = size.width / 2 + cos(angle) * distance * progress;
      final y = size.height / 2 +
          sin(angle) * distance * progress +
          20 * progress * progress; // gravity

      final paint = Paint()
        ..color = colors[i % colors.length].withOpacity(1 - progress)
        ..style = PaintingStyle.fill;

      final particleSize = 3 + _random.nextDouble() * 4;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, y),
            width: particleSize,
            height: particleSize * 1.5,
          ),
          const Radius.circular(1),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;

  const AnimatedBuilder({
    super.key,
    required Listenable listenable,
    required this.builder,
  }) : super(listenable: listenable);

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}