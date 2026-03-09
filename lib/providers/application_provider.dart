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
      error: error,
    );
  }
}

class ApplicationNotifier extends StateNotifier<ApplicationState> {
  ApplicationNotifier() : super(const ApplicationState());

  Future<void> loadApplications() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      isLoading: false,
      applications: MockRepository.mockApplications,
    );
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
    await Future.delayed(const Duration(milliseconds: 500));
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
    return true;
  }

  Future<bool> updateStatus(String applicationId, String newStatus) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 300));
    final updated = state.applications.map((a) {
      if (a.id == applicationId) {
        return a.copyWith(status: newStatus, updatedAt: DateTime.now());
      }
      return a;
    }).toList();
    state = state.copyWith(isLoading: false, applications: updated);
    return true;
  }

  bool hasApplied(String gigId, String studentId) {
    return state.applications.any(
      (a) => a.gigId == gigId && a.studentId == studentId,
    );
  }
}

final applicationProvider =
    StateNotifierProvider<ApplicationNotifier, ApplicationState>((ref) {
  return ApplicationNotifier();
});
