import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class DrawerMenu extends StatelessWidget {
  final String userName;
  final VoidCallback? onClose;

  const DrawerMenu({
    super.key,
    required this.userName,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.divider),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá, $userName',
                          style: AppTextStyles.headlineSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Ver perfil',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Menu Items
            _MenuItem(
              icon: Icons.receipt_outlined,
              label: 'Meus Pedidos',
              onTap: () => Navigator.pop(context),
            ),
            _MenuItem(
              icon: Icons.account_balance_wallet_outlined,
              label: 'MagaluPay',
              onTap: () => Navigator.pop(context),
            ),
            _MenuItem(
              icon: Icons.pix,
              label: 'Pix',
              onTap: () => Navigator.pop(context),
            ),
            _MenuItem(
              icon: Icons.favorite_border,
              label: 'Favoritos',
              onTap: () => Navigator.pop(context),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Divider(),
            ),
            _MenuItem(
              icon: Icons.help_outline,
              label: 'Ajuda',
              onTap: () => Navigator.pop(context),
            ),
            _MenuItem(
              icon: Icons.security,
              label: 'Segurança',
              onTap: () => Navigator.pop(context),
            ),
            _MenuItem(
              icon: Icons.settings_outlined,
              label: 'Configurações',
              onTap: () => Navigator.pop(context),
            ),
            const Spacer(),
            // Footer
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Magalu v1.0.0',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary, size: 24),
      title: Text(
        label,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: AppColors.primary.withOpacity(0.05),
    );
  }
}
