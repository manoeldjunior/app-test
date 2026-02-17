// ═══════════════════════════════════════════════════════════
// V1 Shared Widgets — Reusable components for all V1 screens
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../providers/providers.dart';
import 'v1_colors.dart';
import '../utils/currency_format.dart';

// ─── CDC State Toggle (for comparison screen header) ────
// Normal widget (not Positioned) for placing outside the phone frame.
class CdcStateToggle extends ConsumerWidget {
  const CdcStateToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cdcUserStateProvider);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2430),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A3040)),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: CdcUserState.values.map((s) {
          final isActive = s == state;
          return GestureDetector(
            onTap: () => ref.read(cdcUserStateProvider.notifier).state = s,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? _stateColor(s) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_stateIcon(s), size: 11,
                      color: isActive ? Colors.white : Colors.white54),
                  const SizedBox(width: 3),
                  Text(
                    _stateLabel(s),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static Color _stateColor(CdcUserState s) => switch (s) {
    CdcUserState.naoLogado  => V1Colors.textSec,
    CdcUserState.preAprovado => V1Colors.orange,
    CdcUserState.ativo       => V1Colors.green,
  };

  static IconData _stateIcon(CdcUserState s) => switch (s) {
    CdcUserState.naoLogado  => Icons.person_outline,
    CdcUserState.preAprovado => Icons.verified_outlined,
    CdcUserState.ativo       => Icons.check_circle,
  };

  static String _stateLabel(CdcUserState s) => switch (s) {
    CdcUserState.naoLogado  => 'Não logado',
    CdcUserState.preAprovado => 'Pré-aprov.',
    CdcUserState.ativo       => 'Ativo',
  };
}

// ─── Mini Action Button (Home quick actions) ────────────
class V1MiniAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const V1MiniAction(this.icon, this.label, {super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: V1Colors.blue),
        Text(label, style: const TextStyle(fontSize: 8, color: V1Colors.textSec)),
      ],
    );
  }
}

// ─── Category Chip ──────────────────────────────────────
class V1Chip extends StatelessWidget {
  final String label;
  const V1Chip(this.label, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: V1Colors.blue),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(label,
          style: const TextStyle(color: V1Colors.blue, fontSize: 11)),
    );
  }
}

// ─── Payment Radio Tile ─────────────────────────────────
class V1PayRadio extends StatelessWidget {
  final String label;
  final String subtitle;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final bool highlight;
  final bool disabled;
  final String? badge;

  const V1PayRadio({
    super.key,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.highlight = false,
    this.disabled = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: disabled ? null : () => onChanged(value),
      child: Opacity(
        opacity: disabled ? 0.45 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: highlight
              ? BoxDecoration(
                  color: isSelected ? V1Colors.orangeLight : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: isSelected ? V1Colors.orange : Colors.transparent),
                )
              : null,
          child: Row(
            children: [
              Radio<String>(
                value: value,
                groupValue: groupValue,
                onChanged: disabled ? null : (v) => onChanged(v!),
                activeColor: highlight ? V1Colors.orange : V1Colors.blue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
                            color: disabled ? V1Colors.textSec : V1Colors.text)),
                    Text(subtitle,
                        style: const TextStyle(fontSize: 11, color: V1Colors.textSec)),
                  ],
                ),
              ),
              if (badge != null && isSelected)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: V1Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(badge!,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Summary Row ────────────────────────────────────────
class V1SumRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool bold;
  const V1SumRow(this.label, this.value, {super.key, this.color, this.bold = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: bold ? 15 : 13,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                  color: V1Colors.text)),
          Text(value,
              style: TextStyle(
                  fontSize: bold ? 16 : 13,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                  color: color ?? V1Colors.text)),
        ],
      ),
    );
  }
}

// ─── Step Progress Header ───────────────────────────────
class V1StepHeader extends StatelessWidget {
  final int current; // 1-based
  final int total;
  final String label;
  const V1StepHeader({
    super.key,
    required this.current,
    required this.total,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: V1Colors.blue,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Row(
            children: List.generate(total, (i) {
              final isActive = i < current;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
                  height: 3,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─── CDC Credit Banner (reusable across PDP / Home) ─────
class V1CreditBanner extends StatelessWidget {
  final CdcUserState userState;
  final double availableLimit;
  final double? usedLimit;
  final double? totalLimit;
  final VoidCallback? onTap;

  const V1CreditBanner({
    super.key,
    required this.userState,
    required this.availableLimit,
    this.usedLimit,
    this.totalLimit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return switch (userState) {
      CdcUserState.naoLogado => _buildNaoLogado(),
      CdcUserState.preAprovado => _buildPreAprovado(),
      CdcUserState.ativo => _buildAtivo(),
    };
  }

  Widget _buildNaoLogado() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: V1Colors.card,
          border: Border.all(color: V1Colors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: V1Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.credit_score, color: V1Colors.blue, size: 18),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Conheça o Limite Magalu',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13, color: V1Colors.text)),
                  Text('Faça login para ver seu limite pré-aprovado',
                      style: TextStyle(fontSize: 11, color: V1Colors.textSec)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: V1Colors.textSec),
          ],
        ),
      ),
    );
  }

  Widget _buildPreAprovado() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [V1Colors.blue, V1Colors.blueDark],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.verified, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Crédito pré-aprovado',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                      Text('Limite Magalu',
                          style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white70),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_balance_wallet,
                      color: Colors.white, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'Limite disponível: ${CurrencyFormat.format(availableLimit)}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAtivo() {
    final used = usedLimit ?? 0;
    final total = totalLimit ?? availableLimit + used;
    final progress = total > 0 ? used / total : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00A650), Color(0xFF007A3D)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.check_circle, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Limite Magalu ativo',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                      Text('Seu crédito está em dia',
                          style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Ativo',
                      style: TextStyle(
                          color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Utilization bar
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation(Colors.white),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Usado: ${CurrencyFormat.format(used)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
                Text(
                  'Disponível: ${CurrencyFormat.format(availableLimit)}',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
