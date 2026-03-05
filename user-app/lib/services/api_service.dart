import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_urls.dart';
import '../models/lead_model.dart';

class ApiService {
  Future<bool> submitLead(LeadModel lead) async {
    try {
      final response = await http
          .post(
            Uri.parse(AppUrls.webhookUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(lead.toJson()),
          )
          .timeout(const Duration(seconds: 30));
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to submit: $e');
    }
  }
}
