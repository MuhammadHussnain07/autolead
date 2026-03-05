import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/contact_utils.dart';
import '../models/lead_model.dart';
import '../providers/lead_provider.dart';
import '../widgets/lead_card.dart';

class LeadDetailScreen extends ConsumerWidget {
  final LeadModel lead;
  const LeadDetailScreen({super.key, required this.lead});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // ── App Bar ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.card,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: const Icon(
                          Iconsax.arrow_left,
                          color: AppTheme.textPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Lead Details',
                      style: GoogleFonts.poppins(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      // ── Avatar & Name ──
                      Column(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                lead.name.isNotEmpty
                                    ? lead.name[0].toUpperCase()
                                    : 'A',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ).animate().scale(
                            duration: 400.ms,
                            curve: Curves.elasticOut,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            lead.name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppTheme.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor(lead.status).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              lead.status.displayName,
                              style: GoogleFonts.poppins(
                                color: statusColor(lead.status),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(),

                      const SizedBox(height: 16),

                      // ── Info Card (Flexible) ──
                      Flexible(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _InfoRow(
                                icon: Iconsax.call,
                                label: 'Phone',
                                value: lead.phone,
                              ),
                              const Divider(color: AppTheme.border, height: 16),
                              _InfoRow(
                                icon: Iconsax.sms,
                                label: 'Email',
                                value: lead.email,
                              ),
                              const Divider(color: AppTheme.border, height: 16),
                              _InfoRow(
                                icon: Iconsax.brush_1,
                                label: 'Service',
                                value: lead.service,
                              ),
                              const Divider(color: AppTheme.border, height: 16),
                              _InfoRow(
                                icon: Iconsax.calendar,
                                label: 'Date',
                                value: DateFormat(
                                  'MMM d, yyyy • h:mm a',
                                ).format(lead.createdAt),
                              ),
                            ],
                          ),
                        ),
                      ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),

                      const SizedBox(height: 12),

                      // ── Message Card (Flexible + Internal Scroll) ──
                      Flexible(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Iconsax.message,
                                    color: AppTheme.primary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Message',
                                    style: GoogleFonts.poppins(
                                      color: AppTheme.textSecondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Text(
                                    lead.message,
                                    style: GoogleFonts.poppins(
                                      color: AppTheme.textPrimary,
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),

                      const SizedBox(height: 12),

                      // ── WhatsApp Button ──
                      GestureDetector(
                        onTap: () async {
                          try {
                            await ContactUtils.openWhatsApp(
                              phone: lead.phone,
                              name: lead.name,
                              service: lead.service,
                            );
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('WhatsApp not available'),
                                  backgroundColor: AppTheme.error,
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF25D366).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF25D366).withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Iconsax.message,
                                color: Color(0xFF25D366),
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Contact on WhatsApp',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF25D366),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate(delay: 300.ms).fadeIn(),

                      const SizedBox(height: 16),

                      // ── Update Status Grid ──
                      Text(
                        'Update Status',
                        style: GoogleFonts.poppins(
                          color: AppTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ).animate(delay: 350.ms).fadeIn(),

                      const SizedBox(height: 8),

                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 3.2,
                        children: LeadStatus.values.map((status) {
                          final isSelected = lead.status == status;
                          final color = statusColor(status);
                          return GestureDetector(
                            onTap: () async {
                              await ref
                                  .read(leadServiceProvider)
                                  .updateStatus(lead.id, status);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Status → ${status.displayName}',
                                    ),
                                    backgroundColor: color,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                                context.pop();
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? color.withOpacity(0.15)
                                    : AppTheme.card,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? color : AppTheme.border,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    statusIcon(status),
                                    color: isSelected
                                        ? color
                                        : AppTheme.textHint,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    status.displayName,
                                    style: GoogleFonts.poppins(
                                      color: isSelected
                                          ? color
                                          : AppTheme.textSecondary,
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ).animate(delay: 400.ms).fadeIn(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primary, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: AppTheme.textHint,
                  fontSize: 11,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
