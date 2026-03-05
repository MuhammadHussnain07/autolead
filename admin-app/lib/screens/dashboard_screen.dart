import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../core/theme/app_theme.dart';
import '../models/lead_model.dart';
import '../providers/lead_provider.dart';
import '../widgets/lead_card.dart';
import '../widgets/stat_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadsAsync = ref.watch(allLeadsProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: leadsAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            ),
            error: (err, _) => Center(
              child: Text(
                'Error: $err',
                style: GoogleFonts.poppins(color: AppTheme.error),
              ),
            ),
            data: (leads) {
              final totalLeads = leads.length;
              final newLeads = leads
                  .where((l) => l.status == LeadStatus.newLead)
                  .length;
              final contactedLeads = leads
                  .where((l) => l.status == LeadStatus.contacted)
                  .length;
              final doneLeads = leads
                  .where((l) => l.status == LeadStatus.done)
                  .length;
              final recentLeads = leads.take(5).toList();

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dashboard 📊',
                              style: GoogleFonts.poppins(
                                color: AppTheme.textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Welcome back, Admin!',
                              style: GoogleFonts.poppins(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Iconsax.chart_square,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

                    const SizedBox(height: 24),

                    // ── Stats Grid ──
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                      children: [
                        StatCard(
                              title: 'Total Leads',
                              count: totalLeads.toString(),
                              icon: Iconsax.people,
                              color: AppTheme.primary,
                            )
                            .animate(delay: 100.ms)
                            .fadeIn()
                            .scale(begin: const Offset(0.9, 0.9)),
                        StatCard(
                              title: 'New Leads',
                              count: newLeads.toString(),
                              icon: Iconsax.clock,
                              color: AppTheme.statusNew,
                            )
                            .animate(delay: 150.ms)
                            .fadeIn()
                            .scale(begin: const Offset(0.9, 0.9)),
                        StatCard(
                              title: 'Contacted',
                              count: contactedLeads.toString(),
                              icon: Iconsax.call,
                              color: AppTheme.statusContacted,
                            )
                            .animate(delay: 200.ms)
                            .fadeIn()
                            .scale(begin: const Offset(0.9, 0.9)),
                        StatCard(
                              title: 'Completed',
                              count: doneLeads.toString(),
                              icon: Iconsax.tick_circle,
                              color: AppTheme.statusDone,
                            )
                            .animate(delay: 250.ms)
                            .fadeIn()
                            .scale(begin: const Offset(0.9, 0.9)),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ── Recent Leads ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Leads',
                          style: GoogleFonts.poppins(
                            color: AppTheme.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/leads'),
                          child: Text(
                            'See All',
                            style: GoogleFonts.poppins(
                              color: AppTheme.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ).animate(delay: 300.ms).fadeIn(),

                    const SizedBox(height: 12),

                    if (recentLeads.isEmpty)
                      _EmptyState()
                    else
                      ...recentLeads.asMap().entries.map(
                        (e) =>
                            LeadCard(
                                  lead: e.value,
                                  onTap: () => context.push(
                                    '/lead-detail',
                                    extra: e.value,
                                  ),
                                )
                                .animate(delay: (350 + e.key * 50).ms)
                                .fadeIn()
                                .slideX(begin: 0.1),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          const Icon(Iconsax.people, color: AppTheme.textHint, size: 48),
          const SizedBox(height: 12),
          Text(
            'No leads yet',
            style: GoogleFonts.poppins(
              color: AppTheme.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Leads from your Flutter user app will appear here',
            style: GoogleFonts.poppins(color: AppTheme.textHint, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
