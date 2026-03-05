import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../core/theme/app_theme.dart';
import '../models/lead_model.dart';
import '../providers/lead_provider.dart';
import '../widgets/lead_card.dart';

class LeadsScreen extends HookConsumerWidget {
  const LeadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadsAsync = ref.watch(allLeadsProvider);
    final selectedStatus = useState<LeadStatus?>(null);

    final filters = [
      null,
      LeadStatus.newLead,
      LeadStatus.contacted,
      LeadStatus.done,
      LeadStatus.cancelled,
    ];

    final filterLabels = ['All', 'New', 'Contacted', 'Done', 'Cancelled'];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text(
                  'All Leads 📋',
                  style: GoogleFonts.poppins(
                    color: AppTheme.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Filter Chips ──
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filters.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final isSelected = selectedStatus.value == filters[i];
                    return GestureDetector(
                      onTap: () => selectedStatus.value = filters[i],
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? AppTheme.primaryGradient
                              : null,
                          color: isSelected ? null : AppTheme.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : AppTheme.border,
                          ),
                        ),
                        child: Text(
                          filterLabels[i],
                          style: GoogleFonts.poppins(
                            color: isSelected
                                ? Colors.white
                                : AppTheme.textSecondary,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // ── Leads List ──
              Expanded(
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
                  data: (allLeads) {
                    final leads = selectedStatus.value == null
                        ? allLeads
                        : allLeads
                              .where((l) => l.status == selectedStatus.value)
                              .toList();

                    if (leads.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Iconsax.people,
                              color: AppTheme.textHint,
                              size: 56,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No leads found',
                              style: GoogleFonts.poppins(
                                color: AppTheme.textSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: leads.length,
                      itemBuilder: (_, i) => LeadCard(
                        lead: leads[i],
                        onTap: () =>
                            context.push('/lead-detail', extra: leads[i]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
