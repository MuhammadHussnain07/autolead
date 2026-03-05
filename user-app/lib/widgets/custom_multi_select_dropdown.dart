import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../core/theme/app_theme.dart';

const List<String> kServices = [
  'Haircut',
  'Hair Color',
  'Beard Trim',
  'Hair Treatment',
  'Consultation',
  'Other',
];

class CustomMultiSelectDropdown extends StatelessWidget {
  final List<String> selectedServices;
  final Function(List<String>) onChanged;
  final String? errorText;

  const CustomMultiSelectDropdown({
    super.key,
    required this.selectedServices,
    required this.onChanged,
    this.errorText,
  });

  void _showMultiSelect(BuildContext context) {
    List<String> localSelections = List<String>.from(selectedServices);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Services',
                        style: GoogleFonts.poppins(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: kServices.length,
                      separatorBuilder: (_, _) => Divider(
                        color: AppTheme.border.withValues(alpha: 0.5),
                      ),
                      itemBuilder: (context, index) {
                        final service = kServices[index];
                        final isSelected = localSelections.contains(service);
                        return ListTile(
                          onTap: () {
                            setModalState(() {
                              if (isSelected) {
                                localSelections.remove(service);
                              } else {
                                localSelections.add(service);
                              }
                            });

                            onChanged(localSelections);
                          },
                          leading: Icon(
                            isSelected
                                ? Icons.check_box_rounded
                                : Icons.check_box_outline_blank_rounded,
                            color: isSelected
                                ? AppTheme.primary
                                : AppTheme.textHint,
                          ),
                          title: Text(
                            service,
                            style: GoogleFonts.poppins(
                              color: isSelected
                                  ? AppTheme.textPrimary
                                  : AppTheme.textSecondary,
                              fontSize: 15,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Done (${localSelections.length} selected)',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services Needed',
          style: GoogleFonts.poppins(
            color: AppTheme.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showMultiSelect(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: errorText != null ? AppTheme.error : AppTheme.border,
              ),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.brush_1, color: AppTheme.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedServices.isEmpty
                        ? 'Select services'
                        : selectedServices.join(', '),
                    style: GoogleFonts.poppins(
                      color: selectedServices.isEmpty
                          ? AppTheme.textHint
                          : AppTheme.textPrimary,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.primary,
                ),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: GoogleFonts.poppins(color: AppTheme.error, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}
