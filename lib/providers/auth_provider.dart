import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../repositories/mock_repository.dart';

/// Holds the authentication and user state
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserModel? user;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserModel? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  /// Simulate checking auth state on app launch
  Future<void> checkAuthState() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 2));
    // Start as unauthenticated; user must log in
    state = state.copyWith(isLoading: false, isAuthenticated: false);
  }

  /// Simulate registration
  Future<bool> register({
    required String email,
    required String password,
    required String userType,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(seconds: 1));
    // In mock mode, always succeed
    state = state.copyWith(isLoading: false);
    return true;
  }

  /// Simulate OTP verification
  Future<bool> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 800));
    if (otp == '123456') {
      state = state.copyWith(isLoading: false);
      return true;
    }
    state = state.copyWith(
      isLoading: false,
      error: 'Invalid OTP. Use 123456 for demo.',
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
    await Future.delayed(const Duration(seconds: 1));

    final user = userType == 'student'
        ? MockRepository.mockStudent
        : MockRepository.mockManager;

    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      user: user,
    );
    return true;
  }

  /// Complete onboarding and update user
  void completeOnboarding(UserModel updatedUser) {
    state = state.copyWith(
      user: updatedUser.copyWith(onboardingComplete: true),
      isAuthenticated: true,
    );
  }

  /// Set user type during registration flow
  void setUserType(String userType) {
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
  return AuthNotifier();
});
