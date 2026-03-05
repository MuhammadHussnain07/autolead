import 'package:autoleadadmin/models/lead_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeadService {
  // ✅ Change 'leads' to whatever collection n8n uses
  // Check in Firebase Console → Firestore → what collection name n8n created
  final _col = FirebaseFirestore.instance.collection('leads');

  Stream<List<LeadModel>> getAllLeads() {
    return _col
        .orderBy('Date', descending: true) // ✅ n8n uses 'Date' not 'createdAt'
        .snapshots()
        .map(
          (s) => s.docs.map((d) => LeadModel.fromMap(d.data(), d.id)).toList(),
        );
  }

  Future<void> updateStatus(String leadId, LeadStatus status) async {
    await _col.doc(leadId).update({'Status': status.displayName});
  }
}
