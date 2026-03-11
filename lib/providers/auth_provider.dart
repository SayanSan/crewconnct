import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../repositories/mock_repository.dart';
import '../repositories/base_repository.dart';
import 'repository_provider.dart';

/// Holds the authentication and user state
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserModel? user;
  final String? error;
  final String? verificationId;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.error,
    this.verificationId,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserModel? user,
    String? error,
    String? verificationId,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error ?? this.error,
      verificationId: verificationId ?? this.verificationId,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState());

  /// Simulate checking auth state on app launch
  Future<void> checkAuthState() async {
    state = state.copyWith(isLoading: true);
    await _repository.checkAuthState();
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: _repository.currentUser != null,
      user: _repository.currentUser,
    );
  }

  /// Simulate registration
  Future<bool> register({
    required String email,
    required String password,
    required String userType,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final success = await _repository.register(
      email: email,
      password: password,
      userType: userType,
    );
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: success,
      user: _repository.currentUser,
    );
    return success;
  }

  /// Send OTP to phone number
  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null);
    await _repository.sendOtp(
      phoneNumber,
      onCodeSent: (verificationId) {
        state = state.copyWith(
          isLoading: false,
          verificationId: verificationId,
        );
      },
      onVerificationFailed: (error) {
        state = state.copyWith(
          isLoading: false,
          error: error,
        );
      },
    );
  }

  /// Verify OTP
  Future<bool> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    final success = await _repository.verifyOtp(
      otp,
      verificationId: state.verificationId,
    );
    if (success) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: _repository.currentUser != null,
        user: _repository.currentUser,
      );
      return true;
    }
    state = state.copyWith(
      isLoading: false,
      error: 'Invalid OTP. Please try again.',
    );
    return false;
  }

  /// Simulate login
  Future<bool> login({
    required String email,
    required String password,
    required String userType,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final success = await _repository.login(
      email: email,
      password: password,
      userType: userType,
    );

    state = state.copyWith(
      isLoading: false,
      isAuthenticated: success,
      user: _repository.currentUser,
    );
    return success;
  }

  /// Complete onboarding and update user
  void completeOnboarding(UserModel updatedUser) {
    state = state.copyWith(
      user: updatedUser.copyWith(onboardingComplete: true),
      isAuthenticated: true,
    );
  }

  /// Set user type during registration flow (Helper for UI)
  void setUserType(String userType) {
    // This is still a bit mock-ish for UI flow, but we use the repository's logic if possible
    final user = userType == 'student' 
        ? MockRepository.mockStudent.copyWith(onboardingComplete: false)
        : MockRepository.mockManager.copyWith(onboardingComplete: false);
    state = state.copyWith(user: user);
  }

  /// Logout
  void logout() {
    state = const AuthState();
  }

  /// Update user profile
  void updateUser(UserModel user) {
    state = state.copyWith(user: user);
  }
}

// ── Providers ────────────────────────────────────────────────────────────
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
