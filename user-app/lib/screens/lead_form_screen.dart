import 'package:autolead_ai/widgets/custom_multi_select_dropdown.dart';
import 'package:autolead_ai/widgets/custom_text_field.dart';
import 'package:autolead_ai/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/validators.dart';
import '../models/lead_model.dart';
import '../providers/lead_provider.dart';

class LeadFormScreen extends HookConsumerWidget {
  const LeadFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final nameCtrl = useTextEditingController();
    final phoneCtrl = useTextEditingController();
    final emailCtrl = useTextEditingController();
    final messageCtrl = useTextEditingController();
    final selectedServices = useState<List<String>>([]);
    final serviceError = useState<String?>(null);

    final leadState = ref.watch(leadProvider);
    final isLoading = leadState.status == LeadStatus.loading;

    Future<void> submit() async {
      final isServiceValid = selectedServices.value.isNotEmpty;
      serviceError.value = isServiceValid
          ? null
          : 'Please select at least one service';

      if (!formKey.currentState!.validate() || !isServiceValid) return;
      FocusScope.of(context).unfocus();

      final lead = LeadModel(
        name: nameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        service: selectedServices.value,
        message: messageCtrl.text.trim(),
      );

      await ref.read(leadProvider.notifier).submitLead(lead);

      final state = ref.read(leadProvider);
      if (!context.mounted) return;

      if (state.status == LeadStatus.success) {
        context.go('/success');
      } else if (state.status == LeadStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.errorMessage ?? 'Server error. Try again.',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // ── Top Bar ──
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Iconsax.autobrightness,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'AutoLeadAI',
                        style: GoogleFonts.poppins(
                          color: AppTheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),

                  const SizedBox(height: 28),

                  Text(
                    'Get In Touch 👋',
                    style: GoogleFonts.poppins(
                      color: AppTheme.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.3),

                  const SizedBox(height: 8),

                  Text(
                    "Fill the form and we'll contact you on WhatsApp!",
                    style: GoogleFonts.poppins(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3),

                  const SizedBox(height: 28),

                  // ── Form Card ──
                  Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            CustomTextField(
                                  label: 'Full Name',
                                  hint: 'Enter your full name',
                                  icon: Iconsax.user,
                                  controller: nameCtrl,
                                  validator: Validators.validateName,
                                  textCapitalization: TextCapitalization.words,
                                )
                                .animate(delay: 300.ms)
                                .fadeIn()
                                .slideX(begin: -0.1),

                            const SizedBox(height: 16),

                            CustomTextField(
                                  label: 'Phone Number',
                                  hint: 'e.g. 0300-1234567',
                                  icon: Iconsax.call,
                                  controller: phoneCtrl,
                                  validator: Validators.validatePhone,
                                  keyboardType: TextInputType.phone,
                                )
                                .animate(delay: 350.ms)
                                .fadeIn()
                                .slideX(begin: -0.1),

                            const SizedBox(height: 16),

                            CustomTextField(
                                  label: 'Email Address',
                                  hint: 'Enter your email',
                                  icon: Iconsax.sms,
                                  controller: emailCtrl,
                                  validator: Validators.validateEmail,
                                  keyboardType: TextInputType.emailAddress,
                                )
                                .animate(delay: 400.ms)
                                .fadeIn()
                                .slideX(begin: -0.1),

                            const SizedBox(height: 16),

                            CustomMultiSelectDropdown(
                                  selectedServices: selectedServices.value,
                                  onChanged: (newList) {
                                    selectedServices.value = List<String>.from(
                                      newList,
                                    );
                                    if (newList.isNotEmpty) {
                                      serviceError.value = null;
                                    }
                                  },
                                  errorText: serviceError.value,
                                )
                                .animate(delay: 450.ms)
                                .fadeIn()
                                .slideX(begin: -0.1),

                            const SizedBox(height: 16),

                            CustomTextField(
                                  label: 'Message',
                                  hint: 'Tell us more about your needs...',
                                  icon: Iconsax.message,
                                  controller: messageCtrl,
                                  validator: Validators.validateMessage,
                                  maxLines: 3,
                                )
                                .animate(delay: 500.ms)
                                .fadeIn()
                                .slideX(begin: -0.1),
                          ],
                        ),
                      )
                      .animate(delay: 250.ms)
                      .fadeIn()
                      .scale(begin: const Offset(0.95, 0.95)),

                  const SizedBox(height: 24),

                  SubmitButton(
                    isLoading: isLoading,
                    onPressed: submit,
                  ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.3),

                  const SizedBox(height: 16),

                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Iconsax.lock,
                          color: AppTheme.textHint,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Your data is secure and private',
                          style: GoogleFonts.poppins(
                            color: AppTheme.textHint,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: 700.ms).fadeIn(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
