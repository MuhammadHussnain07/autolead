import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../models/lead_model.dart';
import '../services/lead_service.dart';

final leadServiceProvider = Provider<LeadService>((ref) => LeadService());

final allLeadsProvider = StreamProvider<List<LeadModel>>((ref) {
  return ref.watch(leadServiceProvider).getAllLeads();
});

final selectedStatusProvider = StateProvider<LeadStatus?>((ref) => null);
