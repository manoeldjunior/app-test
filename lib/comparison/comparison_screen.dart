// ═══════════════════════════════════════════════════════════
// Comparison Screen — Side-by-Side Variant View
// ═══════════════════════════════════════════════════════════
// Shows app variants in phone-frame mockups on a dark bg.
// Original group: V1-V3. Competitors removed per directive.
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'phone_frame.dart';
import '../v1/v1_app.dart';
import '../v2/v2_app.dart';
import '../v3/v3_app.dart';
import '../v1/v1_widgets.dart';
import '../hybrids/v_agent_final.dart';
import '../hybrids/v_final_input.dart';

class ComparisonScreen extends StatelessWidget {
  const ComparisonScreen({super.key});

  static const _bgDark = Color(0xFF0D1117);
  static const _bgGrad1 = Color(0xFF0D1117);
  static const _bgGrad2 = Color(0xFF161B22);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: _bgDark,
      ),
      home: const _ComparisonPage(),
    );
  }
}

class _ComparisonPage extends StatelessWidget {
  const _ComparisonPage();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ComparisonScreen._bgGrad1, ComparisonScreen._bgGrad2],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ─── Header ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0086FF).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('MAGALU',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF0086FF),
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2,
                              )),
                        ),
                        const SizedBox(width: 8),
                        Text('Comparativo de Experiências',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: isWide ? 18 : 14,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Toque nas telas para navegar. V1 (Magalu) • V2 (ML) • V3 (Nubank) • V_Agent • Final',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // ─── Phone Frames ────────────────────────────
              Expanded(
                child: isWide ? _buildWide() : _buildNarrow(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWide() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 320,
            child: ProviderScope(
              child: PhoneFrame(
                label: 'Magalu Atual',
                subtitle: 'Experiência utilitarian',
                headerWidget: const CdcStateToggle(),
                child: const V1App(),
              ),
            ),
          ),
          SizedBox(
            width: 320,
            child: PhoneFrame(
              label: 'Magalu × ML',
              subtitle: 'Padrões Mercado Livre',
              child: const V2App(),
            ),
          ),
          SizedBox(
            width: 320,
            child: PhoneFrame(
              label: 'Magalu × Nubank',
              subtitle: 'Elegância e fluidez premium',
              child: const V3App(),
            ),
          ),
          SizedBox(
            width: 320,
            child: PhoneFrame(
              label: '★ V_Agent_Final',
              subtitle: 'Nubank Shell × ML Engine × Magalu',
              child: const VAgentFinalApp(),
            ),
          ),
          SizedBox(
            width: 320,
            child: PhoneFrame(
              label: '★ Final',
              subtitle: 'Nubank UX × ML Grid × MagaluPay CDC',
              child: const VFinalInputApp(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrow() {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        SizedBox(
          width: 300,
          child: ProviderScope(
            child: PhoneFrame(
              label: 'Magalu Atual',
              subtitle: 'Experiência utilitarian',
              headerWidget: const CdcStateToggle(),
              child: const V1App(),
            ),
          ),
        ),
        SizedBox(
          width: 300,
          child: PhoneFrame(
            label: 'Magalu × ML',
            subtitle: 'Padrões Mercado Livre',
            child: const V2App(),
          ),
        ),
        SizedBox(
          width: 300,
          child: PhoneFrame(
            label: 'Magalu × Nubank',
            subtitle: 'Elegância e fluidez premium',
            child: const V3App(),
          ),
        ),
        SizedBox(
          width: 300,
          child: PhoneFrame(
            label: '★ V_Agent_Final',
            subtitle: 'Nubank Shell × ML Engine × Magalu',
            child: const VAgentFinalApp(),
          ),
        ),
        SizedBox(
          width: 300,
          child: PhoneFrame(
            label: '★ Final',
            subtitle: 'Nubank UX × ML Grid × MagaluPay CDC',
            child: const VFinalInputApp(),
          ),
        ),
      ],
    );
  }
}

