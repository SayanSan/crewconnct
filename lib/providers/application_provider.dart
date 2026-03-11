import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/application_model.dart';
import '../repositories/mock_repository.dart';

class ApplicationState {
  final bool isLoading;
  final List<ApplicationModel> applications;
  final String? error;

  const ApplicationState({
    this.isLoading = false,
    this.applications = const [],
    this.error,
  });

  ApplicationState copyWith({
    bool? isLoading,
    List<ApplicationModel>? applications,
    String? error,
  }) {
    return ApplicationState(
      isLoading: isLoading ?? this.isLoading,
      applications: applications ?? this.applications,
      error: error ?? this.error,
    );
  }
}

class ApplicationNotifier extends StateNotifier<ApplicationState> {
  final IApplicationRepository _repository;

  ApplicationNotifier(this._repository) : super(const ApplicationState());

  Future<void> loadApplications() async {
    state = state.copyWith(isLoading: true);
    try {
      final apps = await _repository.fetchApplications();
      state = state.copyWith(
        isLoading: false,
        applications: apps,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> applyToGig({
    required String gigId,
    required String gigTitle,
    required String studentId,
    required String studentName,
    required String managerId,
    String? coverNote,
  }) async {
    state = state.copyWith(isLoading: true);
    final success = await _repository.applyToGig(
      gigId: gigId,
      gigTitle: gigTitle,
      studentId: studentId,
      studentName: studentName,
      managerId: managerId,
      coverNote: coverNote,
    );
    if (success) {
      // In a real app we might re-fetch or the API might return the new app
      // For now we simulate the local addition if successful
      final newApp = ApplicationModel(
        id: 'app-${DateTime.now().millisecondsSinceEpoch}',
        gigId: gigId,
        gigTitle: gigTitle,
        studentId: studentId,
        studentName: studentName,
        managerId: managerId,
        status: 'applied',
        coverNote: coverNote,
        appliedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      state = state.copyWith(
        isLoading: false,
        applications: [...state.applications, newApp],
      );
    } else {
      state = state.copyWith(isLoading: false, error: 'Failed to apply');
    }
    return success;
  }

  Future<bool> updateStatus(String applicationId, String newStatus) async {
    state = state.copyWith(isLoading: true);
    final success = await _repository.updateApplicationStatus(applicationId, newStatus);
    if (success) {
      final updated = state.applications.map((a) {
        if (a.id == applicationId) {
          return a.copyWith(status: newStatus, updatedAt: DateTime.now());
        }
        return a;
      }).toList();
      state = state.copyWith(isLoading: false, applications: updated);
    } else {
      state = state.copyWith(isLoading: false, error: 'Failed to update status');
    }
    return success;
  }

  bool hasApplied(String gigId, String studentId) {
    return state.applications.any(
      (a) => a.gigId == gigId && a.studentId == studentId,
    );
  }
}

final applicationProvider =
    StateNotifierProvider<ApplicationNotifier, ApplicationState>((ref) {
  final repository = ref.watch(applicationRepositoryProvider);
  return ApplicationNotifier(repository);
});
