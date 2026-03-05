import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_theme.dart';
import '../models/lead_model.dart';

Color statusColor(LeadStatus s) {
  switch (s) {
    case LeadStatus.newLead:
      return AppTheme.statusNew;
    case LeadStatus.contacted:
      return AppTheme.statusContacted;
    case LeadStatus.done:
      return AppTheme.statusDone;
    case LeadStatus.cancelled:
      return AppTheme.statusCancelled;
  }
}

IconData statusIcon(LeadStatus s) {
  switch (s) {
    case LeadStatus.newLead:
      return Iconsax.clock;
    case LeadStatus.contacted:
      return Iconsax.call;
    case LeadStatus.done:
      return Iconsax.tick_circle;
    case LeadStatus.cancelled:
      return Iconsax.close_circle;
  }
}

class LeadCard extends StatelessWidget {
  final LeadModel lead;
  final VoidCallback onTap;

  const LeadCard({super.key, required this.lead, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = statusColor(lead.status);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  lead.name.isNotEmpty ? lead.name[0].toUpperCase() : 'A',
                  style: GoogleFonts.poppins(
                    color: AppTheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lead.name,
                    style: GoogleFonts.poppins(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lead.service,
                    style: GoogleFonts.poppins(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, yyyy • h:mm a').format(lead.createdAt),
                    style: GoogleFonts.poppins(
                      color: AppTheme.textHint,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon(lead.status), color: color, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    lead.status.displayName,
                    style: GoogleFonts.poppins(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
