import 'package:flutter/material.dart';

/// A realistic phone-shaped bezel that wraps any variant app.
/// Shows Dynamic Island notch, side buttons, and home indicator.
class PhoneFrame extends StatelessWidget {
  final Widget child;
  final String label;
  final String? subtitle;
  final Widget? headerWidget;

  const PhoneFrame({
    super.key,
    required this.child,
    required this.label,
    this.subtitle,
    this.headerWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        children: [
          // ─── Label ──────────────────────────────────────
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 3),
            Text(
              subtitle!,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (headerWidget != null) ...[
            const SizedBox(height: 6),
            headerWidget!,
          ],
          const SizedBox(height: 10),
          // ─── Phone Body ─────────────────────────────────
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 375 / 812,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(44),
                    border: Border.all(
                      color: const Color(0xFF2A2A2A),
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.03),
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Stack(
                      children: [
                        // App content
                        Positioned.fill(
                          child: MediaQuery(
                            data: const MediaQueryData(
                              padding: EdgeInsets.only(top: 54, bottom: 20),
                              size: Size(375, 812),
                            ),
                            child: child,
                          ),
                        ),
                        // Dynamic Island
                        Positioned(
                          top: 10,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 105,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        // Home Indicator
                        Positioned(
                          bottom: 6,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 110,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
