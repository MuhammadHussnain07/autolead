import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../models/lead_model.dart';
import '../services/api_service.dart';

enum LeadStatus { initial, loading, success, error }

class LeadState {
  final LeadStatus status;
  final String? errorMessage;

  const LeadState({this.status = LeadStatus.initial, this.errorMessage});

  LeadState copyWith({LeadStatus? status, String? errorMessage}) {
    return LeadState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class LeadNotifier extends StateNotifier<LeadState> {
  final ApiService _apiService;
  LeadNotifier(this._apiService) : super(const LeadState());

  Future<void> submitLead(LeadModel lead) async {
    state = state.copyWith(status: LeadStatus.loading);
    try {
      final success = await _apiService.submitLead(lead);
      state = state.copyWith(
        status: success ? LeadStatus.success : LeadStatus.error,
        errorMessage: success ? null : 'Server error. Please try again.',
      );
    } catch (e) {
      state = state.copyWith(
        status: LeadStatus.error,
        errorMessage: 'Connection failed. Check your internet.',
      );
    }
  }

  void reset() => state = const LeadState();
}

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final leadProvider = StateNotifierProvider<LeadNotifier, LeadState>(
  (ref) => LeadNotifier(ref.read(apiServiceProvider)),
);
