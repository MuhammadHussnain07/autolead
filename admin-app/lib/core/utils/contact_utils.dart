import 'package:url_launcher/url_launcher.dart';

class ContactUtils {
  static Future<void> openWhatsApp({
    required String phone,
    required String name,
    required String service,
  }) async {
    // Remove spaces and dashes
    String cleaned = phone.replaceAll(RegExp(r'[\s-]'), '');

    // Convert local format (03xx) to international (923xx)
    if (cleaned.startsWith('0')) {
      cleaned = '92${cleaned.substring(1)}';
    }

    // Better message formatting with spaces
    final messageText =
        'Hi $name!\n'
        'This is AutoLeadAI Admin.\n'
        'We received your inquiry about $service.\n'
        'When are you available?';

    final url = Uri.parse(
      'https://wa.me/$cleaned?text=${Uri.encodeComponent(messageText)}',
    );

    print('Launching WhatsApp URL: $url');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('WhatsApp launch error: $e');
      throw Exception('Could not launch WhatsApp: $e');
    }
  }
}
