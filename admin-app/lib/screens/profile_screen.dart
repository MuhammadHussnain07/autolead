import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/lead_provider.dart';
import '../models/lead_model.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).user;
    final leadsAsync = ref.watch(allLeadsProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),

                // ── Avatar ──
                Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Iconsax.user,
                        color: Colors.white,
                        size: 40,
                      ),
                    )
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      duration: 500.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(),

                const SizedBox(height: 16),

                Text(
                  'Admin',
                  style: GoogleFonts.poppins(
                    color: AppTheme.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.3),

                const SizedBox(height: 4),

                Text(
                  user?.email ?? 'admin@autolead.com',
                  style: GoogleFonts.poppins(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ).animate(delay: 150.ms).fadeIn(),

                const SizedBox(height: 28),

                // ── Stats Row ──
                leadsAsync.when(
                  loading: () => const SizedBox(),
                  error: (_, _) => const SizedBox(),
                  data: (leads) {
                    return Row(
                      children: [
                        _MiniStat(
                          label: 'Total',
                          count: leads.length.toString(),
                          color: AppTheme.primary,
                        ),
                        _MiniStat(
                          label: 'New',
                          count: leads
                              .where((l) => l.status == LeadStatus.newLead)
                              .length
                              .toString(),
                          color: AppTheme.statusNew,
                        ),
                        _MiniStat(
                          label: 'Done',
                          count: leads
                              .where((l) => l.status == LeadStatus.done)
                              .length
                              .toString(),
                          color: AppTheme.statusDone,
                        ),
                      ],
                    ).animate(delay: 200.ms).fadeIn();
                  },
                ),

                const SizedBox(height: 28),

                // ── Menu Items ──
                _MenuItem(
                  icon: Iconsax.people,
                  label: 'All Leads',
                  subtitle: 'View and manage leads',
                  onTap: () => context.go('/leads'),
                ).animate(delay: 250.ms).fadeIn().slideX(begin: -0.1),

                const SizedBox(height: 10),

                _MenuItem(
                  icon: Iconsax.chart_square,
                  label: 'Dashboard',
                  subtitle: 'View analytics overview',
                  onTap: () => context.go('/dashboard'),
                ).animate(delay: 300.ms).fadeIn().slideX(begin: -0.1),

                const SizedBox(height: 10),

                // ── Logout ──
                GestureDetector(
                  onTap: () async {
                    await ref.read(authServiceProvider).signOut();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppTheme.error.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Iconsax.logout,
                          color: AppTheme.error,
                          size: 22,
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Sign Out',
                          style: GoogleFonts.poppins(
                            color: AppTheme.error,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Iconsax.arrow_right_3,
                          color: AppTheme.error,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ).animate(delay: 350.ms).fadeIn().slideX(begin: -0.1),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: GoogleFonts.poppins(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: AppTheme.textSecondary,
                fontSize: 12,
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
  final String subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: AppTheme.textHint,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Iconsax.arrow_right_3,
              color: AppTheme.textHint,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
